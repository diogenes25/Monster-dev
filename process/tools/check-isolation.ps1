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

The second leak is sideways, and it went unlooked-at for ten runs. Ancestry is about what a
parent injects into context *automatically*; a sibling injects nothing and simply sits there,
one `ls ..` away. When every run folder and every mirror was a direct child of
..\monster-dev-testruns\, that listing was ten finished, already-scored implementations of the
identical brief — and one hire ran it. So this check now looks sideways as well: the run
folder's parent may hold this run's own directories and nothing else.

Run it after creating the run folder, before hiring. Any hit invalidates the run before it
starts, so treat a failure as a stop, not a warning.

.PARAMETER AncestryOnly
Checks the CLAUDE.md ancestry and skips the single-commit test *and the sibling test*. For a
folder that must be free of this repository's context but is not a run folder — the blind scoring
bundle from score-bundle.ps1 is one, and it is deliberately not a git repo, nor is its parent
reserved for it. The CLAUDE.md half is the half that matters for any session started somewhere;
the other two only mean anything where §8 and §9 are being scored.

.PARAMETER Sibling
Directory names that are allowed to sit beside the run folder, in addition to the run folder
itself. `dist` is the default because build-dist.ps1 writes it there by design — it is the one
directory the hire is *supposed* to be able to reach.

.EXAMPLE
.\process\tools\check-isolation.ps1 -Target ..\monster-dev-testruns\2026-08-02-alt-a\target

.EXAMPLE
.\process\tools\check-isolation.ps1 -Target ..\monster-dev-scoring\2026-08-02-alt-a -AncestryOnly
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$Target,
    [switch]$AncestryOnly,
    [string[]]$Sibling = @('dist')
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

# The sideways look. `ls ..` from the hire's working directory must show this run and nothing
# else — no earlier run folder, no earlier mirror. The check names no run id and no date pattern:
# anything that is not this run's own target or an allowed sibling fails, whatever it is called,
# because the next thing to land in there will not be called what the last one was.
#
# Files are ignored on purpose. The exposure is a *directory* holding a finished implementation;
# a stray note or a .zip beside the run folder is untidy, and failing on it would make the check
# noisy enough to be switched off.
if (-not $AncestryOnly) {
    $self   = (Resolve-Path $Target).Path
    $parent = Split-Path $self -Parent
    $allowed = @([System.IO.Path]::GetFileName($self)) + $Sibling

    foreach ($d in @(Get-ChildItem $parent -Directory -ErrorAction SilentlyContinue)) {
        if ($d.Name -notin $allowed) {
            $failures += "LEAK: $($d.FullName) sits beside the run folder — one ``ls ..`` shows it to the hire"
        }
    }
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

if ($AncestryOnly) {
    "isolation OK (ancestry only) — $Target"
} else {
    # The sibling count is named rather than implied: a parent that happened to be empty and a
    # sideways check that never ran produce the same silence otherwise.
    $beside = @(Get-ChildItem (Split-Path (Resolve-Path $Target).Path -Parent) -Directory |
        Where-Object { $_.Name -ne [System.IO.Path]::GetFileName((Resolve-Path $Target).Path) })
    "isolation OK — $Target (parent holds $($beside.Count) other director$(if ($beside.Count -eq 1) {'y'} else {'ies'})$(if ($beside) { ': ' + (($beside | ForEach-Object Name) -join ', ') }))"
}
