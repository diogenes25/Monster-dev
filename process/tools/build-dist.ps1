<#
.SYNOPSIS
Builds the <dist> mirror a test hire is allowed to see, and refuses to hand it over if anything leaked in.

.DESCRIPTION
<dist> is meant to be exactly the surface a push to GitHub would make public, minus the
two things that would invalidate the run:

  process/  the scenarios, answer scripts and acceptance criteria, the board, and the
            implementation records — an agent that reads them passes by knowing the answers,
            and every future run is worthless
  .claude/  the monster-dev-workshop skill, which describes the harness and what is measured

Both used to drop out on their own because they were untracked or gitignored. They are
tracked now, so the exclusion has to be deliberate — and verified, not assumed. That is why
building and checking live in one script: a mirror built by hand is a mirror nobody checked.

The second check is that the mirror is internally consistent. §2 and §5 of the playbook are
the only indexes a hire has, since raw.githubusercontent.com serves no directory listing, so
the mirror is verified against the playbook's own prose: nothing listed may be missing, and
nothing present may be unlisted.

Run it from the repository root.

.PARAMETER RunId
Identifies the run; the mirror is created at ..\monster-dev-testruns\<RunId>.dist.

.PARAMETER Without
Paths (repo-relative, wildcards allowed) to additionally leave out.

Note that dropping a whole stack or sheet this way now **fails** the index check below, on
purpose: §2 and §5 would still tell the hire to fetch it, so the arm would differ from its
pair by the missing notes *plus* a turn burned on a 404 — and num_turns is one of the two
numbers the tooling gate reads. Removing content at file granularity is also the wrong size
for the question actually being asked, which is usually about one entry or one fragment
inside a file. Both are solved by the variant-overlay mechanism, not here.

.EXAMPLE
.\process\tools\build-dist.ps1 -RunId 2026-08-02-alt-a

.EXAMPLE
.\process\tools\build-dist.ps1 -RunId 2026-08-02-alt-a-armA -Without 'index.html'
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$RunId,
    [string[]]$Without = @()
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path 'START.md')) {
    throw "Run this from the repository root — START.md is not here."
}

$dist = Join-Path (Resolve-Path '..').Path "monster-dev-testruns\$RunId.dist"
if (Test-Path $dist) { Remove-Item -Recurse -Force $dist }
New-Item -ItemType Directory -Force $dist | Out-Null

# Never published to a hire. Keep this list and the verification below in step.
#
# CLAUDE.md is tracked, so this line is the only thing keeping it out of the mirror — it is not
# the belt-and-braces entry it once was. That is exactly the trap test/ (now process/) and .claude/
# already fell into: an exclusion that worked by accident stopped working the day the file was
# committed. CLAUDE.md summarises the playbook, the sprite geometry and the §8 rule, so the check
# below stays as the backstop.
#
# The backstop only helps if it is kept in step. It hard-codes the same folder name as the line
# below, which means a rename breaks *both* at once and in the same direction — the filter stops
# matching, and the check hunts a folder that is no longer there and reports clean. That happened
# on 2026-08-02 (test/ -> process/). Change one, change the other, then build a mirror and look
# inside it: this script passing is not on its own evidence that anything was excluded.
$excluded = @('process/*', '.claude/*', 'CLAUDE.md') + $Without

$copied = 0
foreach ($file in (git ls-files)) {
    if ($excluded | Where-Object { $file -like $_ }) { continue }
    $target = Join-Path $dist $file
    New-Item -ItemType Directory -Force (Split-Path $target) | Out-Null
    Copy-Item $file $target
    $copied++
}

# --- verification: a mirror that fails here must not be used ---
$failures = @()
foreach ($forbidden in 'process', '.claude') {
    if (Test-Path (Join-Path $dist $forbidden)) { $failures += "LEAK: $forbidden reached the mirror" }
}
foreach ($stray in (Get-ChildItem -Recurse -File -Filter 'CLAUDE.md' $dist)) {
    $failures += "LEAK: $($stray.FullName)"
}
if (-not (Test-Path (Join-Path $dist 'START.md'))) {
    $failures += "BROKEN: START.md missing — a hire has no entry point"
}

# The playbook's prose is the only index a hire has, so the mirror has to be checked against it
# rather than against the working tree. A listed-but-absent stack costs a hire a turn on a 404 —
# and num_turns is one of the two numbers the tooling gate reads, so the confound lands directly
# in the measurement. An absent-but-unlisted one is simply unreachable.
$playbook = Join-Path $dist 'MONSTER-DEV.md'
if (-not (Test-Path $playbook)) {
    $failures += "BROKEN: MONSTER-DEV.md missing — a hire has no method and no index"
} else {
    . (Join-Path $PSScriptRoot 'lib\playbook-index.ps1')

    $listedStacks = @(Get-PlaybookStacks -PlaybookPath $playbook)
    $mirrorStacks = @(Get-ChildItem (Join-Path $dist 'stacks') -Directory -ErrorAction SilentlyContinue |
        Where-Object { Test-Path (Join-Path $_.FullName 'README.md') } | ForEach-Object { $_.Name })

    foreach ($s in $listedStacks | Where-Object { $_ -notin $mirrorStacks }) {
        $failures += "DEAD POINTER: §2 lists stack '$s' but stacks/$s/README.md is not in the mirror"
    }
    foreach ($s in $mirrorStacks | Where-Object { $_ -notin $listedStacks }) {
        $failures += "UNREACHABLE: stacks/$s/README.md is in the mirror but §2 does not list it"
    }

    $listedSheets = @(Get-PlaybookSheets -PlaybookPath $playbook)
    $mirrorSheets = @(Get-ChildItem (Join-Path $dist 'monsters') -Filter '*.png' -ErrorAction SilentlyContinue |
        ForEach-Object { $_.BaseName })

    foreach ($m in $listedSheets | Where-Object { $_ -notin $mirrorSheets }) {
        $failures += "DEAD POINTER: §5 lists sheet '$m' but monsters/$m.png is not in the mirror"
    }
    foreach ($m in $mirrorSheets | Where-Object { $_ -notin $listedSheets }) {
        $failures += "UNREACHABLE: monsters/$m.png is in the mirror but §5 does not list it"
    }
}

if ($failures) {
    Remove-Item -Recurse -Force $dist
    throw ($failures -join "`n") + "`nMirror deleted so it cannot be used by accident."
}

[pscustomobject]@{
    Dist     = $dist
    Files    = $copied
    Excluded = $excluded -join ', '
    Stacks   = $listedStacks -join ', '
    Sheets   = $listedSheets -join ', '
    IndexOk  = $true
}
