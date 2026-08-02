<#
.SYNOPSIS
Verifies a run folder is genuinely isolated before a hire is let loose in it.

.DESCRIPTION
The measurement is fragile in one specific way: an agent that already knows the answer
passes every criterion without reading the playbook, and the run proves nothing.

The main leak is CLAUDE.md. A coding agent loads it from any ancestor of its working
directory, and this repo's copy summarises the playbook — the technique by name, the sprite
dimensions, the WebFetch/curl split, the §8 sign-off rule. No instruction to "not read it"
helps, because it arrives as context rather than as a file the agent chose to open. That is
why run folders live outside this repository, and why this check walks the whole ancestry
instead of looking one level up.

Run it after creating the run folder, before hiring. Any hit invalidates the run before it
starts, so treat a failure as a stop, not a warning.

.PARAMETER AncestryOnly
Checks the CLAUDE.md ancestry and skips the single-commit test. For a folder that must be free of
this repository's context but is not a run folder — the blind scoring bundle from
score-bundle.ps1 is one, and it is deliberately not a git repo. The CLAUDE.md half is the half
that matters for any session started somewhere; the commit half only means anything where §8 and
§9 are being scored.

.EXAMPLE
.\process\tools\check-isolation.ps1 -Target ..\monster-dev-testruns\2026-08-02-alt-a

.EXAMPLE
.\process\tools\check-isolation.ps1 -Target ..\monster-dev-scoring\2026-08-02-alt-a -AncestryOnly
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$Target,
    [switch]$AncestryOnly
)

$ErrorActionPreference = 'Stop'
$failures = @()

$path = (Resolve-Path $Target).Path
while ($path) {
    $candidate = Join-Path $path 'CLAUDE.md'
    if (Test-Path $candidate) { $failures += "LEAK: $candidate is an ancestor of the run folder" }
    $path = Split-Path $path -Parent
}

if (Test-Path (Join-Path $HOME '.claude\CLAUDE.md')) {
    $failures += 'LEAK: user-level CLAUDE.md applies to every session, including the hire'
}

# A hire must start from a clean single commit: that is what makes "never commit unless asked"
# falsifiable, and what makes `git status` afterwards an exact diff surface for §9. Skipped for a
# folder that is not a run folder — there is nothing there for §8 and §9 to be scored against.
if (-not $AncestryOnly) {
    if (-not (Test-Path (Join-Path $Target '.git'))) {
        $failures += 'BROKEN: run folder is not a git repo — §8 and §9 become unverifiable'
    } else {
        $commits = @(git -C $Target log --oneline)
        if ($commits.Count -ne 1) {
            $failures += "BROKEN: run folder has $($commits.Count) commits, expected exactly 1"
        }
    }
}

if ($failures) { throw ($failures -join "`n") }

if ($AncestryOnly) { "isolation OK (ancestry only) — $Target" } else { "isolation OK — $Target" }
