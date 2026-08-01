<#
.SYNOPSIS
    Rebuilds a clean, transparent sprite sheet from an image that already shows
    several frames side by side.

.DESCRIPTION
    Image generators hand you a row of poses on a flat background, but never on a
    usable grid: the frames sit at uneven spacing, limbs of one frame reach into
    the next cell, and the figures drift horizontally. Cutting such a sheet on a
    fixed grid therefore always catches a piece of the neighbour.

    This script does it differently: it separates the frames by connected
    components, so each cell provably contains exactly one figure, and then
    aligns every frame on a shared ground line and body axis.

    Two background types are supported:

    Light  The background is bright and neutral (a white or light grey plate).
           Background pixels are found by flood filling inwards from the border,
           which keeps enclosed bright areas such as eyes. The drawn outline
           survives because it is dark.

    Dark   The background is black or near black. The character's own outline is
           then indistinguishable from it — both are black and connected, so the
           original outline cannot be recovered. Instead the coloured body is
           detected and a uniform outline of -OutlineRadius px is synthesised
           around it. 2 px suits typical cartoon artwork; too large a value turns
           the outline into a thick lump.

.PARAMETER FrameCount
    How many figures the source contains. The script takes the N largest blobs,
    so stray specks and caption text are ignored automatically — but N must match,
    otherwise a figure will be dropped or a speck promoted to a frame.

.PARAMETER CropBottom
    Ignore everything below this row. Use it when the source carries frame numbers
    or a caption underneath the figures.

.EXAMPLE
    .\New-SpriteSheetFromImage.ps1 -ImagePath sheet.png -OutputPath ..\walk.png `
        -Background Dark -FrameCount 11

.EXAMPLE
    .\New-SpriteSheetFromImage.ps1 -ImagePath sheet.jpg -OutputPath ..\walk.png `
        -Background Light -FrameCount 8 -CropBottom 620
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$ImagePath,
    [Parameter(Mandatory)][string]$OutputPath,
    [Parameter(Mandatory)][ValidateSet('Light','Dark')][string]$Background,
    [Parameter(Mandatory)][int]$FrameCount,
    [int]$CropBottom    = 0,     # 0 = full height
    [int]$InkThreshold  = 40,    # Dark mode: luminance above which a pixel is "body"
    [int]$OutlineRadius = 2,     # Dark mode: thickness of the synthesised outline
    [int]$BrightMin     = 203,   # Light mode: darkest pixel still counting as background
    [int]$NeutralMax    = 16     # Light mode: max channel spread for "neutral"
)

$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.Drawing
$ImagePath  = (Resolve-Path $ImagePath).Path
$OutputPath = [System.IO.Path]::GetFullPath($OutputPath)

$cs = @'
using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.Runtime.InteropServices;

public static class SheetFromImage
{
    // ---- background is bright and neutral -------------------------------------
    // Flood fill from the border over background-looking pixels. Enclosed bright
    // areas (eyes, teeth) are never reached and therefore stay opaque.
    static byte[] AlphaLight(byte[] px, int W, int H, int stride, int brightMin, int neutralMax)
    {
        int N = W*H;
        bool[] cand = new bool[N];
        for (int y=0;y<H;y++){ int off=y*stride;
          for (int x=0;x<W;x++){ int i=off+x*3;
            int b=px[i], g=px[i+1], r=px[i+2];
            int mx=Math.Max(r,Math.Max(g,b)), mn=Math.Min(r,Math.Min(g,b));
            if (mx-mn < neutralMax && mn > brightMin) cand[y*W+x]=true; } }

        bool[] bg = new bool[N]; int[] q = new int[N]; int qh=0,qt=0;
        for (int x=0;x<W;x++){
          int a=x, k=(H-1)*W+x;
          if(cand[a]&&!bg[a]){bg[a]=true;q[qt++]=a;}
          if(cand[k]&&!bg[k]){bg[k]=true;q[qt++]=k;} }
        for (int y=0;y<H;y++){
          int a=y*W, b2=y*W+W-1;
          if(cand[a]&&!bg[a]){bg[a]=true;q[qt++]=a;}
          if(cand[b2]&&!bg[b2]){bg[b2]=true;q[qt++]=b2;} }
        while(qh<qt){ int p=q[qh++]; int y=p/W,x=p-y*W;
          for(int dy=-1;dy<=1;dy++) for(int dx=-1;dx<=1;dx++){
            int nx=x+dx, ny=y+dy;
            if(nx<0||ny<0||nx>=W||ny>=H) continue;
            int n=ny*W+nx;
            if(cand[n]&&!bg[n]){bg[n]=true;q[qt++]=n;} } }

        byte[] alpha = new byte[N];
        for (int i=0;i<N;i++) alpha[i]=(byte)(bg[i]?0:255);

        // Feather the compression halo along the edge.
        byte[] soft=(byte[])alpha.Clone();
        for (int y=1;y<H-1;y++) for (int x=1;x<W-1;x++){
          int p=y*W+x; if(alpha[p]==0) continue;
          bool touches=false;
          for(int dy=-1;dy<=1&&!touches;dy++) for(int dx=-1;dx<=1;dx++)
            if(alpha[(y+dy)*W+(x+dx)]==0){touches=true;break;}
          if(!touches) continue;
          int i3=y*stride+x*3;
          int lum=(px[i3+2]*30+px[i3+1]*59+px[i3]*11)/100;
          if(lum>200){
            int a=(int)Math.Round(255.0*(238-lum)/38.0);
            soft[p]=(byte)Math.Max(0,Math.Min(255,a)); } }
        return soft;
    }

    // ---- background is black ---------------------------------------------------
    // The drawn outline is black too and merges with the background, so it cannot
    // be told apart. Detect the coloured body instead and synthesise a uniform
    // outline: a chamfer distance transform, solid out to the radius, then a short
    // feather.
    static byte[] AlphaDark(byte[] px, int W, int H, int stride, int inkThreshold, int radius)
    {
        int N=W*H;
        bool[] body=new bool[N];
        for(int y=0;y<H;y++){ int off=y*stride;
          for(int x=0;x<W;x++){ int i=off+x*3;
            int lum=(px[i+2]*30+px[i+1]*59+px[i]*11)/100;
            if(lum>inkThreshold) body[y*W+x]=true; } }

        const int INF=1<<20;
        int[] dist=new int[N];
        for(int i=0;i<N;i++) dist[i]= body[i]?0:INF;
        for(int y=0;y<H;y++) for(int x=0;x<W;x++){
          int p=y*W+x,d=dist[p];
          if(y>0){ if(x>0) d=Math.Min(d,dist[p-W-1]+4);
                   d=Math.Min(d,dist[p-W]+3);
                   if(x<W-1) d=Math.Min(d,dist[p-W+1]+4); }
          if(x>0) d=Math.Min(d,dist[p-1]+3);
          dist[p]=d; }
        for(int y=H-1;y>=0;y--) for(int x=W-1;x>=0;x--){
          int p=y*W+x,d=dist[p];
          if(y<H-1){ if(x<W-1) d=Math.Min(d,dist[p+W+1]+4);
                     d=Math.Min(d,dist[p+W]+3);
                     if(x>0) d=Math.Min(d,dist[p+W-1]+4); }
          if(x<W-1) d=Math.Min(d,dist[p+1]+3);
          dist[p]=d; }

        int solid=radius*3, fade=4;
        byte[] alpha=new byte[N];
        for(int i=0;i<N;i++){
          int d=dist[i];
          if(d<=solid) alpha[i]=255;
          else if(d<=solid+fade) alpha[i]=(byte)(255-255*(d-solid)/fade);
          else alpha[i]=0; }
        return alpha;
    }

    public static string Build(string src, string dst, string mode, int frameCount,
                               int cropBottom, int inkThreshold, int outlineRadius,
                               int brightMin, int neutralMax)
    {
        Bitmap bmp = new Bitmap(src);
        int W=bmp.Width, H=bmp.Height, N=W*H;
        BitmapData bd = bmp.LockBits(new Rectangle(0,0,W,H), ImageLockMode.ReadOnly, PixelFormat.Format24bppRgb);
        int stride=bd.Stride; byte[] px=new byte[stride*H];
        Marshal.Copy(bd.Scan0,px,0,px.Length); bmp.UnlockBits(bd); bmp.Dispose();

        byte[] alpha = mode == "Dark"
            ? AlphaDark(px, W, H, stride, inkThreshold, outlineRadius)
            : AlphaLight(px, W, H, stride, brightMin, neutralMax);

        int yLimit = cropBottom > 0 ? Math.Min(cropBottom, H) : H;

        // ---- separate the frames by connected components, never by a fixed grid:
        // the figures overlap their nominal cells, so a grid cut always catches a
        // piece of the neighbour.
        int[] label=new int[N]; for(int i=0;i<N;i++) label[i]=-1;
        const int MAXC=400000;
        int[] cSize=new int[MAXC], cMinX=new int[MAXC], cMaxX=new int[MAXC],
              cMinY=new int[MAXC], cMaxY=new int[MAXC];
        int[] q=new int[N]; int nl=0;
        for(int y=0;y<yLimit;y++) for(int x=0;x<W;x++){
          int p=y*W+x;
          if(alpha[p]<=8||label[p]>=0) continue;
          int lb=nl++, size=0, mnx=x, mxx=x, mny=y, mxy=y, qh=0, qt=0;
          q[qt++]=p; label[p]=lb;
          while(qh<qt){ int c=q[qh++]; size++;
            int cy=c/W, cx=c-cy*W;
            if(cx<mnx)mnx=cx; if(cx>mxx)mxx=cx; if(cy<mny)mny=cy; if(cy>mxy)mxy=cy;
            for(int dy=-1;dy<=1;dy++) for(int dx=-1;dx<=1;dx++){
              int nx=cx+dx, ny=cy+dy;
              if(nx<0||ny<0||nx>=W||ny>=yLimit) continue;
              int n=ny*W+nx;
              if(alpha[n]>8&&label[n]<0){ label[n]=lb; q[qt++]=n; } } }
          cSize[lb]=size; cMinX[lb]=mnx; cMaxX[lb]=mxx; cMinY[lb]=mny; cMaxY[lb]=mxy; }

        if (nl < frameCount)
            throw new Exception("Found only " + nl + " blobs but " + frameCount + " frames were requested.");

        string log = "blobs found: " + nl + "\n";
        int[] top=new int[frameCount]; bool[] taken=new bool[nl];
        for(int k=0;k<frameCount;k++){
          int best=-1;
          for(int l=0;l<nl;l++) if(!taken[l]&&(best<0||cSize[l]>cSize[best])) best=l;
          taken[best]=true; top[k]=best; }
        int spare=-1;
        for(int l=0;l<nl;l++) if(!taken[l]&&(spare<0||cSize[l]>cSize[spare])) spare=l;
        if(spare>=0)
          log += string.Format("largest discarded blob: {0} px (frames are {1}..{2} px) — "
               + "if that looks like a figure, -FrameCount is too low\n",
               cSize[spare], cSize[top[frameCount-1]], cSize[top[0]]);

        // order left to right
        for(int a=0;a<frameCount;a++) for(int b=a+1;b<frameCount;b++)
          if(cMinX[top[b]]+cMaxX[top[b]] < cMinX[top[a]]+cMaxX[top[a]]){
            int t=top[a]; top[a]=top[b]; top[b]=t; }

        int[] fx0=new int[frameCount], fx1=new int[frameCount],
              fy0=new int[frameCount], fy1=new int[frameCount], flb=new int[frameCount];
        double[] anchor=new double[frameCount];
        for(int f=0;f<frameCount;f++){
          int lb=top[f];
          fx0[f]=cMinX[lb]; fx1[f]=cMaxX[lb]; fy0[f]=cMinY[lb]; fy1[f]=cMaxY[lb]; flb[f]=lb;
          // Anchor = horizontal centroid of the upper 45%. Head and shoulders barely
          // move, so this is far steadier than the bounding box centre, which swings
          // with the limbs.
          int headBottom = fy0[f] + (int)((fy1[f]-fy0[f])*0.45);
          double sum=0; long c=0;
          for(int y=fy0[f];y<=headBottom;y++)
            for(int x=fx0[f];x<=fx1[f];x++){
              int p=y*W+x;
              if(label[p]==lb && alpha[p]>=128){ sum+=x; c++; } }
          anchor[f] = c>0 ? sum/c : (fx0[f]+fx1[f])/2.0;
          log += string.Format(System.Globalization.CultureInfo.InvariantCulture,
            "frame {0,2}: x {1}..{2} (w={3,3})  y {4}..{5} (h={6,3})  size={7,7}  anchor rel {8:F1}\n",
            f+1, fx0[f], fx1[f], fx1[f]-fx0[f]+1, fy0[f], fy1[f], fy1[f]-fy0[f]+1, cSize[lb], anchor[f]-fx0[f]); }

        // ---- one cell that fits every frame once aligned on (body axis, ground line)
        int leftMax=0, rightMax=0, tallest=0;
        for(int f=0;f<frameCount;f++){
          leftMax=Math.Max(leftMax,(int)Math.Ceiling(anchor[f]-fx0[f]));
          rightMax=Math.Max(rightMax,(int)Math.Ceiling(fx1[f]-anchor[f]));
          tallest=Math.Max(tallest, fy1[f]-fy0[f]); }
        int pad=4;
        int cellW=leftMax+rightMax+1+2*pad;
        int cellH=tallest+1+2*pad;
        int anchorInCell=leftMax+pad;
        int baseline=cellH-pad-1;

        Bitmap outBmp=new Bitmap(cellW*frameCount, cellH, PixelFormat.Format32bppArgb);
        BitmapData od=outBmp.LockBits(new Rectangle(0,0,cellW*frameCount,cellH),
                                      ImageLockMode.WriteOnly, PixelFormat.Format32bppArgb);
        int ostride=od.Stride; byte[] outPx=new byte[ostride*cellH];
        for(int f=0;f<frameCount;f++){
          int dxB=f*cellW+anchorInCell-(int)Math.Round(anchor[f]);
          int dyB=baseline-fy1[f];
          for(int y=fy0[f];y<=fy1[f];y++)
            for(int x=fx0[f];x<=fx1[f];x++){
              int sp=y*W+x;
              if(label[sp]!=flb[f]) continue;      // never copy a neighbour's limb
              byte a=alpha[sp]; if(a==0) continue;
              int tx=dxB+x, ty=dyB+y;
              if(tx<f*cellW||tx>=(f+1)*cellW||ty<0||ty>=cellH) continue;
              int si=y*stride+x*3, di=ty*ostride+tx*4;
              outPx[di]=px[si]; outPx[di+1]=px[si+1]; outPx[di+2]=px[si+2]; outPx[di+3]=a; } }
        Marshal.Copy(outPx,0,od.Scan0,outPx.Length);
        outBmp.UnlockBits(od);
        outBmp.Save(dst, ImageFormat.Png);
        outBmp.Dispose();

        log += string.Format("\nSHEET {0} x {1} | {2} cells of {3} x {4}\n",
                             cellW*frameCount, cellH, frameCount, cellW, cellH);
        log += string.Format("CELLW={0};CELLH={1};FRAMES={2}\n", cellW, cellH, frameCount);
        return log;
    }
}
'@
$refs = @([System.Drawing.Bitmap].Assembly.Location,
          [System.Drawing.Rectangle].Assembly.Location,
          [System.Runtime.InteropServices.Marshal].Assembly.Location) | Sort-Object -Unique
Add-Type -TypeDefinition $cs -ReferencedAssemblies $refs

New-Item -ItemType Directory -Force (Split-Path $OutputPath) | Out-Null
$log = [SheetFromImage]::Build($ImagePath, $OutputPath, $Background, $FrameCount,
                               $CropBottom, $InkThreshold, $OutlineRadius, $BrightMin, $NeutralMax)

$log -split "`n" | Where-Object { $_ -notmatch '^CELLW=' } | ForEach-Object { Write-Host $_ }
$vals = ($log -split "`n" | Where-Object { $_ -match '^CELLW=' }) -replace '[A-Z]+=','' -split ';'
$cellW = [int]$vals[0]; $cellH = [int]$vals[1]; $nf = [int]$vals[2]

Write-Host "Done: $OutputPath" -ForegroundColor Green
Write-Host ""
Write-Host "CSS:"
Write-Host ("  --frame-w: {0}px;" -f $cellW)
Write-Host ("  --frame-h: {0}px;" -f $cellH)
Write-Host ("  --sheet-w: calc(var(--frame-w) * {0});" -f $nf)
Write-Host ("  animation: walk-cycle var(--cycle) steps({0}) infinite;" -f $nf)
