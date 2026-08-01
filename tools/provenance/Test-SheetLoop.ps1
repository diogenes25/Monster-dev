<#
.SYNOPSIS
    Measures whether a finished sprite sheet loops without a visible hitch.

.DESCRIPTION
    New-SpriteSheetFromVideo.ps1 judges candidate gait cycles while it works, on the source
    footage. This checks the opposite end: the artifact that actually ships.

    A sheet loops by jumping from its last cell back to its first, so that hand-over is the
    only seam a viewer ever sees. The bar it has to clear is the sheet's own mean step between
    adjacent cells — a wrap that differs no more than a normal step is a wrap nobody notices.
    Reported as a ratio, so the figure means the same thing for any sheet at any size.

    Cells are composited over white first: a sheet is transparent, and comparing raw RGB would
    ignore alpha differences, which are exactly where a badly cut limb shows up.

    This exists because the two checks can disagree, and when they do this one is right. The
    generator compares candidates in the *anchored* frame — sampled relative to each frame's own
    body axis and ground line, the way cells are later composed. Judging the same footage on raw
    video frames instead counts the character's travel across the shot as mismatch, and travel is
    precisely what composition removes; measured that way the wrong period wins by a wide margin.
    Here the question does not arise: the cells are already aligned, so there is nothing to
    normalise and nothing to get wrong.

    Windows-only (System.Drawing), offline, never part of the hiring flow.

.PARAMETER SheetPath
    A single sheet to check. Its frame count is looked up in the catalog by sheet dimensions
    unless -Frames says otherwise. Omit to check every entry in the catalog.

.PARAMETER Frames
    Cell count, when the sheet is not in the catalog or is being checked before being added.

.PARAMETER CatalogPath
    The catalog to resolve frame counts from. Defaults to monsters/catalog.json beside this repo.

.PARAMETER MaxRatio
    Wrap-to-adjacent ratio still counted as seamless. 1.05 allows a wrap a touch worse than an
    average step; by 1.3 the hitch is plainly visible.

.EXAMPLE
    .\Test-SheetLoop.ps1
    Checks every sheet in the catalog. This is the regression check after regenerating one.

.EXAMPLE
    .\Test-SheetLoop.ps1 -SheetPath ..\..\monsters\green-fuzz-strolling.png

.EXAMPLE
    .\Test-SheetLoop.ps1 -SheetPath .\candidate.png -Frames 16
#>
[CmdletBinding()]
param(
    [string]$SheetPath,
    [int]$Frames = 0,
    [string]$CatalogPath,
    [double]$MaxRatio = 1.05
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

if (-not $CatalogPath) {
    $CatalogPath = Join-Path $PSScriptRoot '..\..\monsters\catalog.json'
}
$CatalogPath = [System.IO.Path]::GetFullPath($CatalogPath)

$cs = @'
using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.Runtime.InteropServices;

public static class SheetLoop
{
    /// Returns "meanAdjacentStep|wrapStep" (invariant decimals) for a sheet of nf cells.
    public static string Measure(string path, int nf)
    {
        Bitmap b = new Bitmap(path);
        int W = b.Width, H = b.Height, cw = W / nf;
        BitmapData bd = b.LockBits(new Rectangle(0,0,W,H), ImageLockMode.ReadOnly, PixelFormat.Format32bppArgb);
        int st = bd.Stride;
        byte[] p = new byte[st*H];
        Marshal.Copy(bd.Scan0, p, 0, p.Length);
        b.UnlockBits(bd); b.Dispose();

        // One cell, composited over white. Index 0 is blue, matching the 32bppArgb byte order.
        Func<int, byte[]> cell = (k) => {
            byte[] o = new byte[cw*H*3];
            for (int y = 0; y < H; y++)
                for (int x = 0; x < cw; x++)
                {
                    int i = y*st + (k*cw + x)*4, j = (y*cw + x)*3;
                    double a = p[i+3] / 255.0;
                    for (int c = 0; c < 3; c++)
                        o[j+c] = (byte)Math.Round(p[i+c]*a + 255*(1-a));
                }
            return o;
        };

        Func<byte[], byte[], double> mad = (u, v) => {
            long s = 0;
            for (int i = 0; i < u.Length; i++) { int d = u[i] - v[i]; s += d < 0 ? -d : d; }
            return (double)s / u.Length;
        };

        byte[] first = cell(0), prev = first, last = null;
        double sum = 0;
        for (int k = 1; k < nf; k++)
        {
            byte[] c = cell(k);
            sum += mad(prev, c);
            prev = c;
            if (k == nf-1) last = c;
        }
        double adjacent = sum / (nf - 1);
        double wrap = mad(last, first);

        return string.Format(System.Globalization.CultureInfo.InvariantCulture,
            "{0:F4}|{1:F4}", adjacent, wrap);
    }
}
'@
$refs = @([System.Drawing.Bitmap].Assembly.Location,
          [System.Drawing.Rectangle].Assembly.Location,
          [System.Runtime.InteropServices.Marshal].Assembly.Location) | Sort-Object -Unique
Add-Type -TypeDefinition $cs -ReferencedAssemblies $refs

# --- work out what to check -------------------------------------------------------
$catalog = if (Test-Path $CatalogPath) { Get-Content -Raw $CatalogPath | ConvertFrom-Json } else { $null }

$targets = @()
if ($SheetPath) {
    $SheetPath = (Resolve-Path $SheetPath).Path
    $nf = $Frames
    if ($nf -le 0) {
        if (-not $catalog) { throw "No catalog at $CatalogPath — pass -Frames." }
        $bmp = New-Object System.Drawing.Bitmap($SheetPath)
        $w = $bmp.Width; $h = $bmp.Height; $bmp.Dispose()
        $hit = $catalog.monsters | Where-Object { $_.sheet.width -eq $w -and $_.sheet.height -eq $h }
        if (-not $hit) { throw "$w x $h matches no catalog entry — pass -Frames." }
        $nf = $hit.frames
    }
    $targets += [pscustomobject]@{ Slug = [System.IO.Path]::GetFileNameWithoutExtension($SheetPath); Path = $SheetPath; Frames = $nf }
} else {
    if (-not $catalog) { throw "No catalog at $CatalogPath and no -SheetPath given." }
    $repoRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..\..'))
    foreach ($m in $catalog.monsters) {
        $p = Join-Path $repoRoot $m.file
        if (-not (Test-Path $p)) { throw "Catalog lists $($m.file) but it is not on disk." }
        $targets += [pscustomobject]@{ Slug = $m.slug; Path = $p; Frames = $m.frames }
    }
}

# --- measure ----------------------------------------------------------------------
$failed = $false
$targets | ForEach-Object {
    $r = [SheetLoop]::Measure($_.Path, $_.Frames) -split '\|'
    $adjacent = [double]::Parse($r[0], [System.Globalization.CultureInfo]::InvariantCulture)
    $wrap     = [double]::Parse($r[1], [System.Globalization.CultureInfo]::InvariantCulture)
    $ratio    = $wrap / $adjacent
    $ok       = $ratio -le $MaxRatio
    if (-not $ok) { $failed = $true }
    [pscustomobject]@{
        Sheet    = $_.Slug
        Cells    = $_.Frames
        AdjStep  = [math]::Round($adjacent, 2)
        Wrap     = [math]::Round($wrap, 2)
        Ratio    = "{0:F2}x" -f $ratio
        Verdict  = if ($ok) { 'seamless' } else { 'HITCHES' }
    }
} | Format-Table -AutoSize

if ($failed) {
    Write-Warning ("A sheet's wrap exceeds {0:F2}x its own adjacent step: the walk restarts with a " -f $MaxRatio +
                   "visible jump. The gait period is the usual cause — see monsters/README.md.")
    exit 1
}
