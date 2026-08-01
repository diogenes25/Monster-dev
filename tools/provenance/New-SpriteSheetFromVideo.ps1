<#
.SYNOPSIS
    Builds a transparent sprite sheet from a video of a walking character.

.DESCRIPTION
    This is the pipeline that produced the sheets in monsters/. It works for cartoon
    footage where the character carries a closed, clearly dark outline — no green
    screen required, the outline itself is the cut-out boundary.

    Steps:
      1. Extract every frame with ffmpeg.
      2. Cut the character out: mark dark pixels as a barrier, flood fill the
         non-dark pixels inwards from the image border, and keep the largest
         region the fill could not reach. Enclosed areas such as eyes survive
         because the fill never gets in there.
      3. Optionally grow into the dark teal fill used for tails and hind limbs,
         which is too close to the outline colour to be caught by step 2.
      4. Measure the gait period by comparing the leg region across every
         possible frame offset, then pick the offset that loops most cleanly.
         Both comparisons are made in the anchored frame — relative to each
         frame's own body axis and ground line, the way the cells are composed —
         so the character's travel across the shot does not count as mismatch.
      5. Align each frame on a shared ground line and body axis, scale, and
         compose the sheet.

    Requires ffmpeg on PATH.

    Source footage advertised as a seamless loop frequently is not one. The report
    states the loop closure as a multiple of the agreement between two genuinely
    consecutive frames, which is the bar an invisible seam has to clear: below
    about 1.0x the walk hitches on every repeat and the period is wrong. Pin it
    with -Period / -StartFrame once you have established it independently.

.PARAMETER VideoPath
    Source video.

.PARAMETER OutputPath
    Destination PNG for the finished sheet.

.PARAMETER DarkThreshold
    Luminance below which a pixel counts as outline. 55 suits a black keyline on
    bright artwork. Raise it if the outline is washed out, lower it if dark
    background elements are being pulled into the silhouette.

.PARAMETER CellHeight
    Height of one cell in the finished sheet. The width follows from the
    character's proportions.

.PARAMETER NoTealFill
    Disables step 3. Use this when the character has no body parts filled in a
    colour close to the outline — the grow can only cost you time then, and on
    a character with genuinely teal surroundings it could leak.

.PARAMETER TailFadePx
    Width of the alpha ramp at the right cell edge. Only relevant when the
    character leaves the frame (a tail running out of shot); the ramp turns a
    hard vertical cut into a soft one. Set to 0 to disable.

.PARAMETER TopTrimMinWidth
    Rows at the top of the silhouette narrower than this are dropped. Removes
    thin scene elements — an overhanging branch, a wire — that touch the head
    and would otherwise be welded to the character.

.PARAMETER Period
    Overrides the measured gait period, in source frames. Use it when you have
    established the period independently and the automatic pick disagrees.

.PARAMETER StartFrame
    Overrides the first frame of the cycle (1-based, as numbered in the report).
    Only the period search is skipped when -Period is given; the cut point is
    still searched unless you pin it here too.

.PARAMETER Slug
    Catalog key for this sheet, e.g. green-fuzz-strolling. Required with
    -CatalogPath.

.PARAMETER CatalogPath
    A monsters catalog JSON to add or replace this sheet's entry in. The entry
    records the measured geometry so no number has to be retyped by hand.

.PARAMETER Faces
    Which way the artwork faces, 'left' or 'right'. Not measurable — state it.
    Required with -CatalogPath.

.PARAMETER Look
    One-line description of this sheet for the catalog, e.g. "full curled tail".

.PARAMETER Character
    Which creature this sheet shows. Two sheets of the same creature share it.

.EXAMPLE
    .\New-SpriteSheetFromVideo.ps1 -VideoPath walk.mp4 -OutputPath ..\..\monsters\green-fuzz-strolling.png

.EXAMPLE
    # Period established independently; record the result in the catalog.
    .\New-SpriteSheetFromVideo.ps1 -VideoPath walk.mp4 `
        -OutputPath ..\..\monsters\green-fuzz-strolling.png `
        -Period 16 -StartFrame 7 `
        -CatalogPath ..\..\monsters\catalog.json -Slug green-fuzz-strolling `
        -Faces left -Character 'green fuzzy monster' -Look 'full curled tail'
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$VideoPath,
    [Parameter(Mandatory)][string]$OutputPath,
    [int]$DarkThreshold  = 55,
    [int]$CellHeight     = 300,
    [switch]$NoTealFill,
    [int]$TailFadePx     = 22,
    [int]$TopTrimMinWidth = 30,
    [int]$MinPeriod      = 6,
    [int]$MaxPeriod      = 40,
    [int]$Period         = 0,
    [int]$StartFrame     = 0,
    [string]$Slug,
    [string]$CatalogPath,
    [ValidateSet('left','right')][string]$Faces,
    [string]$Look,
    [string]$Character,
    [string]$WorkDir,
    [switch]$KeepWork
)

$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.Drawing

if (-not (Get-Command ffmpeg -ErrorAction SilentlyContinue)) {
    throw "ffmpeg not found on PATH."
}
if ($CatalogPath) {
    if (-not $Slug)  { throw "-CatalogPath needs -Slug: the entry has to be keyed by something." }
    if (-not $Faces) { throw "-CatalogPath needs -Faces ('left' or 'right'): it cannot be measured from the footage." }
}
$VideoPath  = (Resolve-Path $VideoPath).Path
$OutputPath = [System.IO.Path]::GetFullPath($OutputPath)
if (-not $WorkDir) { $WorkDir = Join-Path ([System.IO.Path]::GetTempPath()) ("sheet-" + [System.IO.Path]::GetRandomFileName()) }
New-Item -ItemType Directory -Force $WorkDir | Out-Null
New-Item -ItemType Directory -Force (Join-Path $WorkDir "raw") | Out-Null
New-Item -ItemType Directory -Force (Join-Path $WorkDir "cut") | Out-Null
New-Item -ItemType Directory -Force (Join-Path $WorkDir "bled") | Out-Null

#region --- native pixel helpers -------------------------------------------------
$cs = @'
using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.Runtime.InteropServices;

public static class SheetPx
{
    static bool[] Dilate(bool[] m, int W, int H, int r)
    {
        bool[] a = (bool[])m.Clone();
        for (int s = 0; s < r; s++)
        {
            bool[] b = new bool[a.Length];
            for (int y = 0; y < H; y++)
                for (int x = 0; x < W; x++)
                {
                    int p = y*W+x;
                    if (a[p] || (x>0&&a[p-1]) || (x<W-1&&a[p+1]) || (y>0&&a[p-W]) || (y<H-1&&a[p+W])) b[p]=true;
                }
            a = b;
        }
        return a;
    }

    // Dark teal used for tail and hind limbs, around (45,130,110): the giveaway is
    // the very low red. Sky (160,205,230) passes the green and blue tests but never
    // the red one; grass and foliage fail the blue test.
    static bool IsTeal(int r, int g, int b)
    {
        return (g - r) > 40 && (b - r) > 15 && g >= b && r < 125 && g > 60 && g < 200;
    }

    /// Cuts the character out of one frame. Returns
    /// "pixelCount|minX|maxX|minY|maxY|anchorX" (invariant decimals).
    public static string Cut(string src, string dstCut, int darkT, bool fillTeal, int topTrimMinWidth)
    {
        Bitmap bmp = new Bitmap(src);
        int W = bmp.Width, H = bmp.Height, N = W*H;
        BitmapData bd = bmp.LockBits(new Rectangle(0,0,W,H), ImageLockMode.ReadOnly, PixelFormat.Format24bppRgb);
        int stride = bd.Stride; byte[] px = new byte[stride*H];
        Marshal.Copy(bd.Scan0, px, 0, px.Length); bmp.UnlockBits(bd); bmp.Dispose();

        bool[] best = null; int bestCnt = 0;
        // A gap in the outline lets the fill flood the body. Growing the barrier
        // seals small gaps; the growth is undone afterwards. Try progressively
        // stronger sealing until the silhouette looks plausible.
        int[] radii = new int[] { 0, 2, 4, 7 };

        foreach (int closeR in radii)
        {
            bool[] dark = new bool[N];
            for (int y=0;y<H;y++){ int off=y*stride;
              for (int x=0;x<W;x++){ int i=off+x*3;
                int lum=(px[i+2]*30+px[i+1]*59+px[i]*11)/100;
                if (lum<darkT) dark[y*W+x]=true; } }
            bool[] barrier = closeR>0 ? Dilate(dark,W,H,closeR) : dark;

            bool[] outside=new bool[N]; int[] q=new int[N]; int qh=0,qt=0;
            for(int x=0;x<W;x++){int a=x,b2=(H-1)*W+x;
              if(!barrier[a]&&!outside[a]){outside[a]=true;q[qt++]=a;}
              if(!barrier[b2]&&!outside[b2]){outside[b2]=true;q[qt++]=b2;}}
            for(int y=0;y<H;y++){int a=y*W,b2=y*W+W-1;
              if(!barrier[a]&&!outside[a]){outside[a]=true;q[qt++]=a;}
              if(!barrier[b2]&&!outside[b2]){outside[b2]=true;q[qt++]=b2;}}
            while(qh<qt){int p=q[qh++];int y=p/W,x=p-y*W;
              if(x>0){int n=p-1;if(!barrier[n]&&!outside[n]){outside[n]=true;q[qt++]=n;}}
              if(x<W-1){int n=p+1;if(!barrier[n]&&!outside[n]){outside[n]=true;q[qt++]=n;}}
              if(y>0){int n=p-W;if(!barrier[n]&&!outside[n]){outside[n]=true;q[qt++]=n;}}
              if(y<H-1){int n=p+W;if(!barrier[n]&&!outside[n]){outside[n]=true;q[qt++]=n;}}}

            bool[] cand=new bool[N]; for(int i=0;i<N;i++) cand[i]=!outside[i];
            int[] label=new int[N]; for(int i=0;i<N;i++) label[i]=-1;
            int[] sizes=new int[400000]; int nl=0,bestLb=-1,bs=0;
            for(int p0=0;p0<N;p0++){
              if(!cand[p0]||label[p0]>=0) continue;
              int lb=nl++;int size=0;qh=0;qt=0;q[qt++]=p0;label[p0]=lb;
              while(qh<qt){int p=q[qh++];size++;int y=p/W,x=p-y*W;
                if(x>0){int n=p-1;if(cand[n]&&label[n]<0){label[n]=lb;q[qt++]=n;}}
                if(x<W-1){int n=p+1;if(cand[n]&&label[n]<0){label[n]=lb;q[qt++]=n;}}
                if(y>0){int n=p-W;if(cand[n]&&label[n]<0){label[n]=lb;q[qt++]=n;}}
                if(y<H-1){int n=p+W;if(cand[n]&&label[n]<0){label[n]=lb;q[qt++]=n;}}}
              sizes[lb]=size; if(size>bs){bs=size;bestLb=lb;}}

            bool[] core=new bool[N];
            for(int i=0;i<N;i++) core[i] = label[i]==bestLb;
            if (closeR>0) {
              bool[] inv=new bool[N]; for(int i=0;i<N;i++) inv[i]=!core[i];
              bool[] dd=Dilate(inv,W,H,closeR);
              for(int i=0;i<N;i++) core[i]=!dd[i];
            }

            int cnt=0; for(int i=0;i<N;i++) if(core[i]) cnt++;
            if (cnt > bestCnt) { bestCnt = cnt; best = core; }
            if (cnt > N/6) break;    // plausible silhouette, no need for heavier sealing
        }

        bool[] mask = best;

        if (fillTeal)
        {
            int[] q=new int[N]; int qh=0,qt=0;
            bool[] vis=(bool[])mask.Clone();
            for(int p=0;p<N;p++) if(mask[p]) q[qt++]=p;
            while(qh<qt){ int p=q[qh++]; int y=p/W,x=p-y*W;
              for(int k=0;k<4;k++){
                int nx=x+(k==0?-1:k==1?1:0), ny=y+(k==2?-1:k==3?1:0);
                if(nx<0||ny<0||nx>=W||ny>=H) continue;
                int n=ny*W+nx; if(vis[n]) continue;
                int i=ny*stride+nx*3;
                if(IsTeal(px[i+2],px[i+1],px[i])){ vis[n]=true; mask[n]=true; q[qt++]=n; } } }
        }

        // Drop thin appendages at the very top (overhanging scene elements).
        int minY=H, maxY=-1, minX=W, maxX=-1;
        for(int p=0;p<N;p++) if(mask[p]){int y=p/W,x=p-y*W;
          if(x<minX)minX=x; if(x>maxX)maxX=x; if(y<minY)minY=y; if(y>maxY)maxY=y;}
        int trimTo = minY;
        for(int y=minY; y<=maxY; y++){
          int wRow=0; for(int x=0;x<W;x++) if(mask[y*W+x]) wRow++;
          if(wRow >= topTrimMinWidth){ trimTo=y; break; } }
        for(int y=minY;y<trimTo;y++) for(int x=0;x<W;x++) mask[y*W+x]=false;
        minY = trimTo;

        minX=W; maxX=-1; maxY=-1; int cnt2=0;
        for(int p=0;p<N;p++) if(mask[p]){int y=p/W,x=p-y*W;cnt2++;
          if(x<minX)minX=x; if(x>maxX)maxX=x; if(y>maxY)maxY=y;}

        // Anchor = horizontal centroid of the upper 40%. Head and shoulders barely
        // move during a walk, so this is far steadier than the bounding box centre,
        // which swings with the limbs.
        int headBand = minY + (int)((maxY-minY)*0.40);
        double sum=0; long c=0;
        for(int y=minY;y<=headBand;y++) for(int x=0;x<W;x++) if(mask[y*W+x]){sum+=x;c++;}
        double anchor = c>0 ? sum/c : (minX+maxX)/2.0;

        Bitmap cut=new Bitmap(W,H,PixelFormat.Format32bppArgb);
        BitmapData cd=cut.LockBits(new Rectangle(0,0,W,H),ImageLockMode.WriteOnly,PixelFormat.Format32bppArgb);
        byte[] co=new byte[cd.Stride*H];
        for(int y=0;y<H;y++) for(int x=0;x<W;x++){
          int p=y*W+x; if(!mask[p]) continue;
          int ci=y*cd.Stride+x*4, si=y*stride+x*3;
          co[ci]=px[si];co[ci+1]=px[si+1];co[ci+2]=px[si+2];co[ci+3]=255; }
        Marshal.Copy(co,0,cd.Scan0,co.Length); cut.UnlockBits(cd);
        cut.Save(dstCut, ImageFormat.Png); cut.Dispose();

        return string.Format(System.Globalization.CultureInfo.InvariantCulture,
            "{0}|{1}|{2}|{3}|{4}|{5:F1}", cnt2, minX, maxX, minY, maxY, anchor);
    }

    /// Bleeds edge colour into the transparent ring. Without this, bicubic
    /// downscaling blends the sprite against transparent black and leaves a dark halo.
    public static void Bleed(string src, string dst, int iterations)
    {
        Bitmap b = new Bitmap(src);
        int W=b.Width, H=b.Height;
        BitmapData bd = b.LockBits(new Rectangle(0,0,W,H), ImageLockMode.ReadWrite, PixelFormat.Format32bppArgb);
        int st=bd.Stride; byte[] p=new byte[st*H];
        Marshal.Copy(bd.Scan0,p,0,p.Length);
        for (int it=0; it<iterations; it++)
        {
            byte[] q=(byte[])p.Clone();
            for (int y=1;y<H-1;y++)
              for (int x=1;x<W-1;x++)
              {
                int i=y*st+x*4;
                if (p[i+3]!=0) continue;
                int r=0,g=0,bl=0,n=0;
                for(int dy=-1;dy<=1;dy++)
                  for(int dx=-1;dx<=1;dx++){
                    int j=(y+dy)*st+(x+dx)*4;
                    if(p[j+3]==0) continue;
                    bl+=p[j]; g+=p[j+1]; r+=p[j+2]; n++; }
                if(n>0){ q[i]=(byte)(bl/n); q[i+1]=(byte)(g/n); q[i+2]=(byte)(r/n); }
              }
            p=q;
        }
        Marshal.Copy(p,0,bd.Scan0,p.Length);
        b.UnlockBits(bd);
        b.Save(dst, ImageFormat.Png);
        b.Dispose();
    }

    /// Keeps only the largest blob per cell (removes specks picked up from the scene),
    /// fades the right edge, and reports the head-top row per cell so the vertical
    /// bob can be verified. Rewrites the file in place.
    public static string Finish(string path, int cellW, int nf, int fadePx)
    {
        Bitmap b = new Bitmap(path);
        int W=b.Width, H=b.Height;
        BitmapData bd = b.LockBits(new Rectangle(0,0,W,H), ImageLockMode.ReadOnly, PixelFormat.Format32bppArgb);
        int st=bd.Stride; byte[] p=new byte[st*H];
        Marshal.Copy(bd.Scan0,p,0,p.Length); b.UnlockBits(bd); b.Dispose();

        string log="";
        int[] q=new int[cellW*H];
        for(int f=0; f<nf; f++)
        {
            int x0=f*cellW, x1=x0+cellW;
            int[] label=new int[cellW*H]; for(int i=0;i<label.Length;i++) label[i]=-1;
            int nl=0,bestLb=-1,bestSz=0; int[] sz=new int[200000];
            for(int y=0;y<H;y++) for(int x=x0;x<x1;x++)
            {
                int lx=x-x0, li=y*cellW+lx;
                if(p[y*st+x*4+3]<=24 || label[li]>=0) continue;
                int lb=nl++,size=0,qh=0,qt=0; q[qt++]=li; label[li]=lb;
                while(qh<qt){ int c=q[qh++]; size++; int cy=c/cellW, cx=c-cy*cellW;
                  for(int k=0;k<4;k++){
                    int nx=cx+(k==0?-1:k==1?1:0), ny=cy+(k==2?-1:k==3?1:0);
                    if(nx<0||ny<0||nx>=cellW||ny>=H) continue;
                    int n=ny*cellW+nx;
                    if(label[n]<0 && p[ny*st+(nx+x0)*4+3]>24){ label[n]=lb; q[qt++]=n; } } }
                sz[lb]=size; if(size>bestSz){bestSz=size;bestLb=lb;}
            }
            int top=H, bot=-1;
            for(int y=0;y<H;y++) for(int x=x0;x<x1;x++)
            {
                int li=y*cellW+(x-x0);
                if(label[li]!=bestLb){ p[y*st+x*4+3]=0; }
                else { if(y<top) top=y; if(y>bot) bot=y; }
            }
            log += string.Format("  cell {0,2}: head top y={1,3}  ground y={2,3}\n", f+1, top, bot);
        }

        for(int f=0; f<nf; f++)
          for(int k=0;k<fadePx;k++){
            int x=(f+1)*cellW-1-k;
            if(x<0||x>=W) continue;
            double factor=(double)k/fadePx;
            for(int y=0;y<H;y++){ int i=y*st+x*4; p[i+3]=(byte)(p[i+3]*factor); } }

        Bitmap o=new Bitmap(W,H,PixelFormat.Format32bppArgb);
        BitmapData od=o.LockBits(new Rectangle(0,0,W,H),ImageLockMode.WriteOnly,PixelFormat.Format32bppArgb);
        for(int y=0;y<H;y++) Marshal.Copy(p, y*st, IntPtr.Add(od.Scan0, y*od.Stride), W*4);
        o.UnlockBits(od); o.Save(path, ImageFormat.Png); o.Dispose();
        return log;
    }
}
'@
$refs = @([System.Drawing.Bitmap].Assembly.Location,
          [System.Drawing.Rectangle].Assembly.Location,
          [System.Runtime.InteropServices.Marshal].Assembly.Location) | Sort-Object -Unique
Add-Type -TypeDefinition $cs -ReferencedAssemblies $refs
#endregion

# --- 1. extract -----------------------------------------------------------------
Write-Host "Extracting frames..." -ForegroundColor Cyan
& ffmpeg -v error -y -i $VideoPath (Join-Path $WorkDir "raw\f_%04d.png")
if ($LASTEXITCODE -ne 0) { throw "ffmpeg failed with exit code $LASTEXITCODE" }
$rawFiles = Get-ChildItem (Join-Path $WorkDir "raw\f_*.png") | Sort-Object Name
if ($Period -gt 0) {
    # Period pinned: one cycle plus the frame that closes it is all that is needed.
    $needed = [math]::Max($StartFrame, 1) + $Period
    if ($rawFiles.Count -lt $needed) {
        throw "Only $($rawFiles.Count) frames — a cycle of $Period starting at $StartFrame needs $needed."
    }
} else {
    if ($rawFiles.Count -lt ($MinPeriod + 2)) {
        throw "Only $($rawFiles.Count) frames — too few to find a gait cycle."
    }
    # A short clip is the normal case, not an error: search as far as it allows.
    if ($MaxPeriod -gt ($rawFiles.Count - 2)) {
        $MaxPeriod = $rawFiles.Count - 2
        Write-Host "  clip is short — capping the period search at $MaxPeriod frames"
    }
}

$probe = New-Object System.Drawing.Bitmap($rawFiles[0].FullName)
$srcW = $probe.Width; $srcH = $probe.Height; $probe.Dispose()
$fps = [double](& ffprobe -v error -select_streams v:0 -show_entries stream=r_frame_rate -of csv=p=0 $VideoPath).Split('/')[0] /
       [double](& ffprobe -v error -select_streams v:0 -show_entries stream=r_frame_rate -of csv=p=0 $VideoPath).Split('/')[1]
Write-Host "  $($rawFiles.Count) frames, $srcW x $srcH, $fps fps"

# --- 2. cut out -----------------------------------------------------------------
Write-Host "Cutting out the character..." -ForegroundColor Cyan
$meta = @{}
$idx = 0
foreach ($f in $rawFiles) {
    $idx++
    $dst = Join-Path $WorkDir ("cut\c_{0:d4}.png" -f $idx)
    $r = [SheetPx]::Cut($f.FullName, $dst, $DarkThreshold, (-not $NoTealFill), $TopTrimMinWidth) -split '\|'
    $meta[$idx] = [pscustomobject]@{
        Index = $idx; File = $dst
        Pixel = [int]$r[0]; MinX = [int]$r[1]; MaxX = [int]$r[2]
        MinY  = [int]$r[3]; MaxY = [int]$r[4]; Anchor = [double]$r[5]
    }
}
$counts = $meta.Values.Pixel
$median = ($counts | Sort-Object)[[int]($counts.Count/2)]
$weak = $meta.Values | Where-Object { $_.Pixel -lt ($median * 0.75) }
Write-Host ("  silhouette size: median {0}, min {1}, max {2}" -f $median,
            ($counts | Measure-Object -Minimum).Minimum, ($counts | Measure-Object -Maximum).Maximum)
if ($weak) { Write-Warning ("Suspicious frames (silhouette collapsed): " + (($weak.Index) -join ', ')) }

# --- 3. gait period -------------------------------------------------------------
# Compare only the leg region: that is where the cycle lives. The torso is nearly
# constant and would wash the signal out.
Write-Host "Measuring the gait period..." -ForegroundColor Cyan
$BW = 60; $BH = 34
$SPANX = [int]($srcW * 0.21); $SPANY = [int]($srcH * 0.19)
$maps = @{}
foreach ($m in $meta.Values) {
    $bmp = New-Object System.Drawing.Bitmap($m.File)
    $bd = $bmp.LockBits((New-Object System.Drawing.Rectangle(0,0,$bmp.Width,$bmp.Height)),
          [System.Drawing.Imaging.ImageLockMode]::ReadOnly,[System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $st = $bd.Stride; $buf = New-Object byte[] ($st*$bmp.Height)
    [System.Runtime.InteropServices.Marshal]::Copy($bd.Scan0,$buf,0,$buf.Length); $bmp.UnlockBits($bd)
    $a = New-Object byte[] ($BW*$BH)
    for ($j=0; $j -lt $BH; $j++) {
        $sy = [int]($m.MaxY - $SPANY + ($j+0.5)*$SPANY/$BH)
        for ($i=0; $i -lt $BW; $i++) {
            $sx = [int]($m.Anchor - $SPANX + ($i+0.5)*2*$SPANX/$BW)
            if ($sx -ge 0 -and $sy -ge 0 -and $sx -lt $bmp.Width -and $sy -lt $bmp.Height) {
                if ($buf[$sy*$st+$sx*4+3] -gt 128) { $a[$j*$BW+$i] = 1 }
            }
        }
    }
    $maps[$m.Index] = $a
    $bmp.Dispose()
}
function Get-IoU($a, $b) {
    $i = 0; $u = 0
    for ($k=0; $k -lt ($BW*$BH); $k++) {
        $x = $a[$k]; $y = $b[$k]
        if ($x -bor $y) { $u++; if ($x -band $y) { $i++ } }
    }
    if ($u -eq 0) { 0 } else { $i/$u }
}
$total = $rawFiles.Count

# The bar the loop closure is judged against. Two consecutive frames are as alike
# as any pair in the clip ever gets, so a cut whose two ends match this well is a
# cut nobody sees. Reporting closure as a multiple of it makes the figure mean the
# same thing across clips of different resolution and tempo.
$adjSum = 0.0
for ($f = 1; $f -lt $total; $f++) { $adjSum += Get-IoU $maps[$f] $maps[($f+1)] }
$adjacent = $adjSum / ($total - 1)
Write-Host ("  adjacent-frame agreement {0:F3} — the bar a seam has to clear" -f $adjacent)

if ($Period -gt 0) {
    $bestPeriod = $Period
    Write-Host "  period pinned to $bestPeriod frames by -Period"
} else {
    $bestPeriod = 0; $bestScore = -1
    foreach ($lag in $MinPeriod..$MaxPeriod) {
        $sum = 0.0; $n = 0
        for ($f = 1; $f -le ($total - $lag); $f++) { $sum += Get-IoU $maps[$f] $maps[($f+$lag)]; $n++ }
        $v = $sum / $n
        if ($v -gt $bestScore) { $bestScore = $v; $bestPeriod = $lag }
    }
    Write-Host ("  period = {0} frames ({1:F2} s at {2} fps), agreement {3:F3}" -f $bestPeriod, ($bestPeriod/$fps), $fps, $bestScore)
}

# Among all possible starts, take the one whose first and last frame match best —
# that is the seam the viewer will see on every repeat. Note this comparison, like
# the maps above, happens in the anchored frame: sampling is relative to each
# frame's own body axis and ground line, which is exactly how the cells are later
# composed. Judging a candidate cycle on raw video frames instead would score the
# character's travel across the shot as mismatch, and that travel is precisely
# what composition removes.
if ($StartFrame -gt 0) {
    $bestStart = $StartFrame
    $bestLoop  = Get-IoU $maps[$bestStart] $maps[($bestStart + $bestPeriod)]
} else {
    $bestStart = 1; $bestLoop = -1
    for ($s = 1; $s -le ($total - $bestPeriod); $s++) {
        $v = Get-IoU $maps[$s] $maps[($s + $bestPeriod)]
        if ($v -gt $bestLoop) { $bestLoop = $v; $bestStart = $s }
    }
}
$ratio = $bestLoop / $adjacent
Write-Host ("  cycle = frames {0}..{1}, loop closure {2:F3} ({3:F2}x adjacent)" -f $bestStart, ($bestStart+$bestPeriod-1), $bestLoop, $ratio)
if ($ratio -lt 0.95) {
    Write-Warning ("Loop closure is {0:F2}x the adjacent-frame agreement — the walk will hitch on every " -f $ratio +
                   "repeat. Footage advertised as a seamless loop often is not one; try pinning -Period.")
}
$cycle = $bestStart..($bestStart + $bestPeriod - 1)

# --- 4. common cell geometry ----------------------------------------------------
$extL = 0.0; $extT = 0
$hitsRightEdge = $false
foreach ($f in $cycle) {
    $m = $meta[$f]
    $l = $m.Anchor - $m.MinX;   if ($l -gt $extL) { $extL = $l }
    $t = $m.MaxY - $m.MinY + 1; if ($t -gt $extT) { $extT = $t }
    if ($m.MaxX -ge ($srcW - 2)) { $hitsRightEdge = $true }
}
if ($hitsRightEdge) {
    # Character leaves the frame. Clip every cell at the same distance from the body
    # axis so the cut stays put instead of pumping back and forth.
    $extR = [double]::MaxValue
    foreach ($f in $cycle) { $rr = ($srcW - 1) - $meta[$f].Anchor; if ($rr -lt $extR) { $extR = $rr } }
    Write-Warning "Character touches the right frame edge — cells are clipped to a common width."
} else {
    $extR = 0.0
    foreach ($f in $cycle) { $rr = $meta[$f].MaxX - $meta[$f].Anchor; if ($rr -gt $extR) { $extR = $rr } }
    $TailFadePx = 0
}
$extL = [math]::Ceiling($extL) + 6
$extR = [math]::Floor($extR)
$extT = $extT + 8

$scale = $CellHeight / $extT
$cellW = [int][math]::Round(($extL + $extR) * $scale)
$cellH = [int][math]::Round($extT * $scale)
$nf    = $cycle.Count

# --- 5. compose -----------------------------------------------------------------
Write-Host "Composing the sheet..." -ForegroundColor Cyan
$sheet = New-Object System.Drawing.Bitmap(($cellW*$nf), $cellH, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [System.Drawing.Graphics]::FromImage($sheet)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.PixelOffsetMode   = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
$g.CompositingMode   = [System.Drawing.Drawing2D.CompositingMode]::SourceCopy
$k = 0
foreach ($f in $cycle) {
    $m = $meta[$f]
    $bled = Join-Path $WorkDir ("bled\b_{0:d4}.png" -f $f)
    [SheetPx]::Bleed($m.File, $bled, 4)
    $b = New-Object System.Drawing.Bitmap($bled)
    $dstRect = New-Object System.Drawing.Rectangle(($k*$cellW), 0, $cellW, $cellH)
    $g.DrawImage($b, $dstRect, [float]($m.Anchor - $extL), [float]($m.MaxY - $extT + 1),
                 [float]($extL + $extR), [float]$extT, [System.Drawing.GraphicsUnit]::Pixel)
    $b.Dispose(); $k++
}
$g.Dispose()
New-Item -ItemType Directory -Force (Split-Path $OutputPath) | Out-Null
$sheet.Save($OutputPath, [System.Drawing.Imaging.ImageFormat]::Png)
$sheet.Dispose()

$bobLog = [SheetPx]::Finish($OutputPath, $cellW, $nf, $TailFadePx)

if (-not $KeepWork) { Remove-Item -Recurse -Force $WorkDir } else { Write-Host "Work dir: $WorkDir" }

# --- 6. report ------------------------------------------------------------------
Write-Host ""
Write-Host "Done: $OutputPath" -ForegroundColor Green
Write-Host ("  sheet {0} x {1}, {2} cells of {3} x {4}" -f ($cellW*$nf), $cellH, $nf, $cellW, $cellH)
Write-Host ""
Write-Host "CSS:"
Write-Host ("  --frame-w: {0}px;" -f $cellW)
Write-Host ("  --frame-h: {0}px;" -f $cellH)
Write-Host ("  --sheet-w: calc(var(--frame-w) * {0});" -f $nf)
Write-Host ("  --cycle:   {0:F2}s;   /* {1} frames at {2} fps */" -f ($bestPeriod/$fps), $bestPeriod, $fps)
Write-Host ("  animation: walk-cycle var(--cycle) steps({0}) infinite;" -f $nf)
Write-Host ""
Write-Host "Head-top row per cell — this is the vertical bob. If it barely moves,"
Write-Host "the source has no bob and the walk will look like floating:"
Write-Host $bobLog

# --- 7. catalog entry -----------------------------------------------------------
# Written from the same variables the sheet was composed from, so the numbers a
# hire is offered cannot drift from the numbers in the PNG. Retyping them by hand
# is how a roster starts lying about its own assets.
if ($CatalogPath) {
    $CatalogPath = [System.IO.Path]::GetFullPath($CatalogPath)
    $catalog = if (Test-Path $CatalogPath) {
        Get-Content -Raw $CatalogPath | ConvertFrom-Json
    } else {
        [pscustomobject]@{ default = $Slug; monsters = @() }
    }

    $entry = [ordered]@{
        slug         = $Slug
        file         = "monsters/$Slug.png"
        character    = $Character
        look         = $Look
        frames       = $nf
        cell         = [ordered]@{ width = $cellW; height = $cellH }
        sheet        = [ordered]@{ width = ($cellW*$nf); height = $cellH }
        layout       = "single horizontal row, left to right, one complete gait cycle"
        sourceFps    = [math]::Round($fps, 3)
        cycleSeconds = [math]::Round($bestPeriod/$fps, 3)
        faces        = $Faces
        provenance   = [ordered]@{
            # Recorded relative to the working directory so the reference resolves for the next
            # person, not just names a file they have to go looking for. Footage outside the repo
            # would give a path that means nothing there, so that degrades to the bare filename.
            sourceVideo = $(
                $rel = (Resolve-Path -Relative $VideoPath) -replace '^\.[\\/]', '' -replace '\\', '/'
                if ($rel -like '../*') { [System.IO.Path]::GetFileName($VideoPath) } else { $rel }
            )
            cycleFrames = "$bestStart..$($bestStart+$bestPeriod-1) of $total"
            seamRatio   = [math]::Round($ratio, 3)
            tool        = "tools/provenance/New-SpriteSheetFromVideo.ps1"
        }
    }

    $keep = @($catalog.monsters | Where-Object { $_.slug -ne $Slug })
    $catalog.monsters = @($keep + [pscustomobject]$entry | Sort-Object slug)
    if (-not $catalog.default) { $catalog.default = $Slug }

    New-Item -ItemType Directory -Force (Split-Path $CatalogPath) | Out-Null
    $catalog | ConvertTo-Json -Depth 6 | Set-Content -Path $CatalogPath -Encoding utf8
    Write-Host ""
    Write-Host "Catalog entry '$Slug' written to $CatalogPath" -ForegroundColor Green
    Write-Host "Now copy the row into MONSTER-DEV.md §5 — that table is what a hire actually reads."
}
