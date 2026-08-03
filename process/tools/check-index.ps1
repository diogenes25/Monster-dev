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

It also checks the record tree, which no other script looks at: OKF frontmatter under
`process/runs/`, the `Stack:` line under `process/stacks/`, tag *form* but never tag vocabulary,
and every `[[wikilink]]` resolving to a record that exists. The tag overview it prints is
rendered from the files each time rather than stored, for the reason board.ps1 gives: the index
*is* the folder, and there is no second place for it to drift.

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
    # Same guard, and for the same reason, as the citation loop below: ls-files lists the index,
    # not the working tree. A PNG deleted but not yet staged makes Resolve-Path throw, and the
    # check then fails for a reason that has nothing to do with what it checks.
    if (-not (Test-Path -LiteralPath $p -PathType Leaf)) { continue }
    $img = [System.Drawing.Image]::FromFile((Resolve-Path $p))
    try   { $ratio = $img.Width / $img.Height; $dims = "$($img.Width)x$($img.Height)" }
    finally { $img.Dispose() }

    if ($ratio -ge $SHEET_RATIO) {
        $failures += "STRAY SHEET: $p ($dims, ratio $([math]::Round($ratio,1))) is shaped like a sprite sheet, reaches the mirror, and is absent from §5"
    } else {
        $notes += "$p ($dims, ratio $([math]::Round($ratio,1))) — not sheet-shaped, ignored"
    }
}

# --- a run that is cited but has no folder ---------------------------------------------------------
#
# hire.ps1 captures every run into process/runs/<id>/ per turn, so under normal operation this can
# only fail if the capture failed silently. It is the second line, not the first.
#
# Keyed *inside* the repository on purpose. The first draft read the neighbouring
# ../monster-dev-testruns/ tree, which would have made the same commit pass on one machine and
# fail on another — and #019 is about to reshape that tree anyway, after which the pattern would
# have matched nothing and reported clean.
#
# What it cannot catch is stated rather than hidden: a run executed and then cited nowhere leaves
# no trace in here at all. The per-turn capture is what covers that case, by construction.

# A run id is date-prefixed and is not followed by a file extension. The negative lookahead is
# load-bearing and was added after the first run of this check reported six orphans, all of them
# old *filenames* quoted in prose — `2026-08-01-alt-a-midwalk.png` matched as a run called
# `2026-08-01-alt-a-midwalk`. A run id that is not date-prefixed escapes this scan entirely;
# `ph0-smoke` is the one such id on record and it predates the convention.
# The atomic group is load-bearing too: without it the engine backtracks the id shorter and
# shorter until the lookahead is satisfied, so `…-alt-a-midwalk.png` came back as a run called
# `2026-08-01-alt-a-` with a trailing dash. Atomic means the id is matched whole or not at all.
$RUN_ID = '\b(?>(20\d\d-\d\d-\d\d-[a-z0-9-]*[a-z0-9]))(?!\.[a-z0-9]{2,5}\b)'
$cited = @{}
foreach ($f in (git ls-files 'process/runs/*.md' 'process/scenarios/*.md' 'process/backlog/*.md')) {
    # ls-files lists the index, not the working tree. Without this guard, deleting a run folder
    # made this block throw "cannot find report.md" instead of reporting the orphan — the check
    # failing for the wrong reason, which is indistinguishable from the check being broken.
    if (-not (Test-Path -LiteralPath $f -PathType Leaf)) { continue }
    foreach ($m in [regex]::Matches((Get-Content $f -Raw), $RUN_ID)) {
        $id = $m.Groups[1].Value
        if (-not $cited.ContainsKey($id)) { $cited[$id] = @() }
        if ($cited[$id] -notcontains $f) { $cited[$id] += $f }
    }
}

$orphans = @($cited.Keys | Where-Object { -not (Test-Path (Join-Path 'process/runs' $_) -PathType Container) } | Sort-Object)
foreach ($id in $orphans) {
    $where = ($cited[$id] | Select-Object -First 3) -join ', '
    $failures += "NO RUN FOLDER: '$id' is cited in $where but process/runs/$id/ does not exist"
}
if (-not $orphans) { $notes += "$($cited.Count) cited run id(s), every one with a folder in process/runs/" }

# --- the record tree: frontmatter, tags, wikilinks -------------------------------------------------
#
# Two conventions live under process/, and the boundary between them is a directory name — which is
# at least the kind of boundary a script can check, and this is the script that checks it:
#
#   process/runs/*/knowledge.md    Open Knowledge Format. YAML frontmatter, required `type`.
#   process/stacks/**/knowledge.md plain Markdown, first line `Stack: <published stack name>`.
#
# The second is not an oversight. CLAUDE.md and process/stacks/README.md both require that
# `Stack:` line and call it "the whole of the mapping" between the two trees — OKF makes the first
# line `---` and has no field for a published stack, since `resource` is spent on the run id. A
# metadata convention is not a good enough reason to move a line the two-tree design rests on.

$OKF_TYPES = 'run', 'implementation', 'surface', 'observation'
$TAG_FORM  = '^[a-z0-9]+(-[a-z0-9]+)*$'
$tagUse    = @{}
$linkTargets = @{}
$recordFiles = @()

# `process/runs/**/*.md` misses `process/runs/plan-retro.md`, and `process/stacks/**/*.md` misses
# `process/stacks/README.md` — git's `**` wants at least one directory level. Those two are the
# overview documents, which is where a cross-reference is most likely to be written, so the glob
# is a directory and the extension is filtered here.
foreach ($f in (git ls-files 'process/runs/*' 'process/stacks/*' | Where-Object { $_ -like '*.md' })) {
    if (-not (Test-Path -LiteralPath $f -PathType Leaf)) { continue }
    # Nothing writes into a frozen copy. step-1-fixture/ and step-4-result/ are byte copies of what
    # a job started from and handed back, and a copy that has been edited is not a copy — #014 needs
    # step-4-result/ byte-identical for a published demo to be the thing that was really delivered.
    # They are skipped rather than exempted: an exemption invites the next convention to argue.
    if ($f -match '/step-[14]-') { continue }
    $recordFiles += $f

    # A link target is the *name* of a record: a folder holding a knowledge.md, or the stem of any
    # .md in the tree. [[name|label]] is supported and only the name half is resolved.
    $leaf = [System.IO.Path]::GetFileNameWithoutExtension($f)
    $dir  = Split-Path $f -Parent | Split-Path -Leaf
    foreach ($k in @($leaf, $dir)) { if ($k) { $linkTargets[$k.ToLower()] = $true } }
}

foreach ($f in $recordFiles) {
    $lines = @(Get-Content -LiteralPath $f)
    $isRun = $f -match '^process/runs/[^/]+/knowledge\.md$'

    if ($isRun) {
        if ($lines[0] -ne '---') {
            $failures += "NO FRONTMATTER: $f is a run record and must open with an OKF '---' block"
        } else {
            $end = 0
            for ($i = 1; $i -lt $lines.Count; $i++) { if ($lines[$i] -eq '---') { $end = $i; break } }
            if (-not $end) {
                $failures += "UNCLOSED FRONTMATTER: $f opens with '---' and never closes it"
            } else {
                $fm = $lines[1..($end - 1)]
                $type = ($fm | Where-Object { $_ -match '^type:\s*(\S+)' } | Select-Object -First 1)
                if (-not $type) {
                    $failures += "NO TYPE: $f has frontmatter but no required 'type:' field"
                } elseif (($type -replace '^type:\s*', '').Trim() -notin $OKF_TYPES) {
                    $failures += "BAD TYPE: $f has type '$(($type -replace '^type:\s*','').Trim())'; OKF types here are $($OKF_TYPES -join ', ')"
                }
                # Tags are free-form on purpose — a controlled vocabulary is a second index that can
                # drift, and the board has already reasoned that out once. Only the *form* is
                # enforced, so `stride` and `schrittlaenge` end up side by side in the overview
                # below and somebody merges them. Made visible, not prevented.
                $tagLine = ($fm | Where-Object { $_ -match '^tags:\s*\[' } | Select-Object -First 1)
                if ($tagLine) {
                    foreach ($t in ($tagLine -replace '^tags:\s*\[', '' -replace '\]\s*$', '') -split ',') {
                        $t = $t.Trim().Trim("'", '"')
                        if (-not $t) { continue }
                        # -cnotmatch, not -notmatch. PowerShell's comparison operators are
                        # case-insensitive by default, so a lowercase-only rule written with
                        # -notmatch accepts `Stride` — which is the one thing it exists to reject.
                        # Found by the negative test; the check had reported clean.
                        if ($t -cnotmatch $TAG_FORM) { $failures += "BAD TAG: $f has tag '$t'; tags are lowercase-kebab" }
                        else {
                            if (-not $tagUse.ContainsKey($t)) { $tagUse[$t] = @() }
                            $tagUse[$t] += $f
                        }
                    }
                }
            }
        }
    } elseif ($f -match '^process/stacks/.*knowledge\.md$') {
        # The other half of the boundary, and the load-bearing one.
        if (-not (($lines | Select-Object -First 6) -match '^Stack:\s*`?[a-z0-9-]+`?\s*$')) {
            $failures += "NO STACK LINE: $f must name its published stack in a 'Stack: <name>' line near the top"
        }
    }

    # Wikilinks, in both trees, because they are body syntax and need no frontmatter.
    #
    # Code is stripped first, and that is load-bearing rather than fussy. Wave 1 hit the same shape
    # from the other side — a citation scan reported an orphan because a board item *quoted* a run
    # id — and there the only fix was to elide the quotation, since prose carries no marker saying
    # "this is an example". Here it does: `[[name|label]]` inside backticks is documentation of the
    # syntax, and process/stacks/README.md is full of it. A check that cannot be written about is a
    # check people route around.
    $inFence = $false
    $n = 0
    foreach ($line in $lines) {
        $n++
        if ($line -match '^\s*```') { $inFence = -not $inFence; continue }
        if ($inFence) { continue }

        foreach ($m in [regex]::Matches(($line -replace '`[^`]*`', ''), '\[\[([^\]\|]+)(\|[^\]]*)?\]\]')) {
            $target = $m.Groups[1].Value.Trim().ToLower()
            if (-not $linkTargets.ContainsKey($target)) {
                $failures += "DEAD WIKILINK: ${f}:${n} points at [[$($m.Groups[1].Value.Trim())]], which is not a record in this tree"
            }
        }
    }
}

if ($recordFiles) { $notes += "record tree: $($recordFiles.Count) file(s), $($linkTargets.Count) link target(s)" }

# Rendered, never written. board.ps1's doctrine applied unchanged: the index *is* the folder, and
# there is no second place for it to drift.
if ($tagUse.Count) {
    $notes += "tags in use: " + (($tagUse.Keys | Sort-Object | ForEach-Object { "$_ ($($tagUse[$_].Count))" }) -join ', ')
} elseif ($recordFiles) {
    $notes += "tags in use: none yet"
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
