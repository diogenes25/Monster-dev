<#
.SYNOPSIS
Checks that the working tree, the playbook's two indexes and the sprite catalog all agree.

.DESCRIPTION
`raw.githubusercontent.com` serves no directory listing, so §2 and §5 of the playbook are the
only indexes a hire can see. That makes the prose load-bearing in a way prose usually isn't:

  listed but absent   a dead pointer — the hire spends a turn on a 404, and num_turns is one of
                      the two numbers the tooling gate reads, so the confound lands straight in
                      the measurement
  present but unlisted unreachable, however complete the filesystem is

build-dist.ps1 already refuses a *mirror* where those disagree. This script checks the same
thing one step earlier, on the working tree, so the disagreement is caught while it is still an
edit rather than a build failure — and it goes further in three ways build-dist cannot:

  * catalog.json is compared against the §5 row, figure by figure. The catalog is the authority
    and §5 is its only published copy; a sheet regenerated with a new frame count leaves the two
    disagreeing, and a hire only ever sees the stale half.
  * Sprite sheets outside `monsters/` are reported. They reach the mirror, they are not in the
    §5 roster, and nothing in build-dist's index check looks there.
  * The orientation cap on stack notes (40 lines above the first `---`) is enforced. That cap is
    the entire price of orientation being exempt from the A/B gate; unchecked, it is a back door.

Exits non-zero if anything disagrees, so it can gate a commit. Run it from the repository root.

.PARAMETER Quiet
Report only failures. Without it, everything checked is listed, which is the point when the
answer is "nothing is wrong" — a silent pass and a script that did nothing look identical.

.EXAMPLE
.\process\tools\check-index.ps1

.EXAMPLE
.\process\tools\check-index.ps1 -Quiet
#>
[CmdletBinding()]
param([switch]$Quiet)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path 'START.md')) {
    throw "Run this from the repository root — START.md is not here."
}

. (Join-Path $PSScriptRoot 'lib\playbook-index.ps1')

$playbook = 'MONSTER-DEV.md'
$failures = @()
$notes    = @()

# --- §2 versus the stacks that exist -----------------------------------------------------------

$listedStacks = @(Get-PlaybookStacks -PlaybookPath $playbook)
$realStacks   = @(Get-ChildItem 'stacks' -Directory -ErrorAction SilentlyContinue |
    Where-Object { Test-Path (Join-Path $_.FullName 'README.md') } | ForEach-Object { $_.Name })

foreach ($s in $listedStacks | Where-Object { $_ -notin $realStacks }) {
    $failures += "DEAD POINTER: §2 lists stack '$s' but stacks/$s/README.md does not exist"
}
foreach ($s in $realStacks | Where-Object { $_ -notin $listedStacks }) {
    $failures += "UNREACHABLE: stacks/$s/README.md exists but §2 does not list it"
}
$notes += "§2 stacks: $($listedStacks -join ', ')"

# --- the orientation cap ------------------------------------------------------------------------
#
# Orientation is gate-free because there is no honest A/B arm that omits a stack's own definition.
# The cap is what stops that exemption from becoming a home for untested advice, so it is checked
# rather than trusted. Everything above the first `---` counts.

foreach ($s in $realStacks) {
    $path  = "stacks/$s/README.md"
    $lines = @(Get-Content $path)
    $rule  = ($lines | Select-String -Pattern '^---$' | Select-Object -First 1).LineNumber
    $orientation = if ($rule) { $rule - 1 } else { $lines.Count }

    if ($orientation -gt 40) {
        $failures += "OVER CAP: $path has $orientation lines of orientation above the '---' rule (max 40)"
    } else {
        $notes += "$path orientation: $orientation/40 lines"
    }
    if (-not $rule) {
        $notes += "$path has no '---' rule yet — the whole file counts as orientation"
    }
}

# --- §5 versus the sheets on disk versus the catalog --------------------------------------------

$rows        = @(Get-PlaybookSheetRows -PlaybookPath $playbook)
$listedSheets = @($rows | ForEach-Object { $_.Slug })
$realSheets  = @(Get-ChildItem 'monsters' -Filter '*.png' -ErrorAction SilentlyContinue |
    ForEach-Object { $_.BaseName })

$catalog     = Get-Content 'monsters/catalog.json' -Raw | ConvertFrom-Json
$catalogBySlug = @{}
foreach ($m in $catalog.monsters) { $catalogBySlug[$m.slug] = $m }

foreach ($m in $listedSheets | Where-Object { $_ -notin $realSheets }) {
    $failures += "DEAD POINTER: §5 lists sheet '$m' but monsters/$m.png does not exist"
}
foreach ($m in $realSheets | Where-Object { $_ -notin $listedSheets }) {
    $failures += "UNREACHABLE: monsters/$m.png exists but §5 does not list it — no hire can ask for it"
}
foreach ($m in $listedSheets | Where-Object { -not $catalogBySlug.ContainsKey($_) }) {
    $failures += "NO PROVENANCE: §5 lists '$m' but catalog.json has no entry — its geometry is unverifiable"
}
foreach ($slug in $catalogBySlug.Keys | Where-Object { $_ -notin $listedSheets }) {
    $failures += "UNPUBLISHED: catalog.json has '$slug' but §5 does not — writing a sheet is not publishing it"
}

if ($catalog.default -notin $listedSheets) {
    $failures += "BROKEN DEFAULT: catalog.json default is '$($catalog.default)' but §5 does not list it — a client with no preference gets nothing"
}

# --- §5's figures versus the catalog's ----------------------------------------------------------
#
# The catalog is written by the generator and is the authority; §5 is the only copy a hire reads.
# The cycle is compared at the precision §5 states it in, since the table deliberately rounds.

foreach ($row in $rows) {
    if (-not $catalogBySlug.ContainsKey($row.Slug)) { continue }
    $c = $catalogBySlug[$row.Slug]

    if (-not $row.Parsed) {
        $failures += "UNPARSEABLE: §5's row for '$($row.Slug)' does not match the expected frames / cell / cycle / faces columns"
        continue
    }

    $diffs = @()
    if ($row.Frames -ne $c.frames)      { $diffs += "frames §5=$($row.Frames) catalog=$($c.frames)" }
    if ($row.CellW  -ne $c.cell.width)  { $diffs += "cell width §5=$($row.CellW) catalog=$($c.cell.width)" }
    if ($row.CellH  -ne $c.cell.height) { $diffs += "cell height §5=$($row.CellH) catalog=$($c.cell.height)" }
    if ($row.Faces  -ne $c.faces)       { $diffs += "faces §5=$($row.Faces) catalog=$($c.faces)" }

    $decimals = ("$($row.Cycle)" -split '\.')[1]
    $places   = if ($decimals) { $decimals.Length } else { 0 }
    if ([math]::Round($c.cycleSeconds, $places) -ne $row.Cycle) {
        $diffs += "cycle §5=$($row.Cycle)s catalog=$($c.cycleSeconds)s (rounded to $places dp: $([math]::Round($c.cycleSeconds, $places)))"
    }

    if ($diffs) { $failures += "OUT OF SYNC: '$($row.Slug)' — " + ($diffs -join '; ') }
    else        { $notes    += "§5 '$($row.Slug)' matches catalog: $($row.Frames) frames, $($row.CellW)x$($row.CellH), $($row.Cycle)s, faces $($row.Faces)" }
}

# --- sheets a hire can reach but cannot be told about --------------------------------------------
#
# build-dist's index check only ever looks in monsters/, so a tracked sheet anywhere else lands in
# the mirror unlisted and unexplained. Not a leak — but a hire that found one would have a sheet
# outside the roster, and a run that used it compares to nothing.
#
# The test is geometry, not the folder. A first pass flagged every tracked PNG outside monsters/
# and caught `monster.png`, which is the README's banner — a false positive that would have had to
# be silenced by an exception, and an exception is how a check stops checking. A sprite sheet is a
# single horizontal row of cells, so it is extremely wide: the two real sheets sit at 21.2 and 16.9,
# the banner at 1.5. Nothing legitimate lands near 5.

Add-Type -AssemblyName System.Drawing
$SHEET_RATIO = 5

foreach ($p in (git ls-files '*.png' | Where-Object { $_ -notlike 'monsters/*' -and $_ -notlike 'process/*' })) {
    $img = [System.Drawing.Image]::FromFile((Resolve-Path $p))
    try   { $ratio = $img.Width / $img.Height; $dims = "$($img.Width)x$($img.Height)" }
    finally { $img.Dispose() }

    if ($ratio -ge $SHEET_RATIO) {
        $failures += "STRAY SHEET: $p ($dims, ratio $([math]::Round($ratio,1))) is shaped like a sprite sheet, reaches the mirror, and is absent from §5"
    } else {
        $notes += "$p ($dims, ratio $([math]::Round($ratio,1))) — not sheet-shaped, ignored"
    }
}

# --- report ---------------------------------------------------------------------------------------

if (-not $Quiet) { $notes | ForEach-Object { "  ok  $_" } }

if ($failures) {
    ''
    $failures | ForEach-Object { "FAIL  $_" }
    ''
    throw "$($failures.Count) index problem(s). A hire reads §2 and §5 and nothing else — fix these before building a mirror."
}

if (-not $Quiet) { '' }
"index OK — $($listedStacks.Count) stack(s), $($listedSheets.Count) sheet(s), catalog and §5 agree"
