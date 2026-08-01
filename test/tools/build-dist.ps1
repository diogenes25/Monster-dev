<#
.SYNOPSIS
Builds the <dist> mirror a test hire is allowed to see, and refuses to hand it over if anything leaked in.

.DESCRIPTION
<dist> is meant to be exactly the surface a push to GitHub would make public, minus the
two things that would invalidate the run:

  test/     the scenarios, answer scripts and acceptance criteria — an agent that reads
            them passes by knowing the answers, and every future run is worthless
  .claude/  the monster-dev-workshop skill, which describes the harness and what is measured

Both used to drop out on their own because they were untracked or gitignored. They are
tracked now, so the exclusion has to be deliberate — and verified, not assumed. That is why
building and checking live in one script: a mirror built by hand is a mirror nobody checked.

Run it from the repository root.

.PARAMETER RunId
Identifies the run; the mirror is created at ..\monster-dev-testruns\<RunId>.dist.

.PARAMETER Without
Paths (repo-relative, wildcards allowed) to additionally leave out. This is what makes an
A/B arm: build one mirror complete, one without the file under test, change nothing else.

.EXAMPLE
.\test\tools\build-dist.ps1 -RunId 2026-08-02-alt-a

.EXAMPLE
.\test\tools\build-dist.ps1 -RunId 2026-08-02-alt-a-armA -Without 'stacks/dom-css/*'
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
# CLAUDE.md is listed even though it is currently untracked and would drop out anyway. That is
# precisely the trap test/ and .claude/ already fell into once: an exclusion that works by
# accident stops working the day someone commits the file, and this one summarises the playbook,
# the sprite geometry and the §8 rule. Listed here it is excluded on purpose; the check below
# stays as the backstop.
$excluded = @('test/*', '.claude/*', 'CLAUDE.md') + $Without

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
foreach ($forbidden in 'test', '.claude') {
    if (Test-Path (Join-Path $dist $forbidden)) { $failures += "LEAK: $forbidden reached the mirror" }
}
foreach ($stray in (Get-ChildItem -Recurse -File -Filter 'CLAUDE.md' $dist)) {
    $failures += "LEAK: $($stray.FullName)"
}
if (-not (Test-Path (Join-Path $dist 'START.md'))) {
    $failures += "BROKEN: START.md missing — a hire has no entry point"
}

if ($failures) {
    Remove-Item -Recurse -Force $dist
    throw ($failures -join "`n") + "`nMirror deleted so it cannot be used by accident."
}

[pscustomobject]@{
    Dist     = $dist
    Files    = $copied
    Excluded = $excluded -join ', '
    Stacks   = (Get-ChildItem (Join-Path $dist 'stacks') -Directory -ErrorAction SilentlyContinue).Name -join ', '
}
