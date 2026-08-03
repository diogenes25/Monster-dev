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

The sideways look is **two levels deep**, and the second level is here because the first fix
created the gap it closes. #019 moved the run from ..\monster-dev-testruns\<id> to
..\monster-dev-testruns\<id>\target and added the sibling test — but the test follows the run
folder, so it inspects the *new* parent, which by construction holds only target and dist. The
listing that had the ten implementations in it moved to `..\..` and stopped being looked at.
Measured on 2026-08-03 while assembling a run: the check reported `isolation OK — parent holds
1 other directory: dist` while `..\..` held ten run folders and nine superseded mirrors, nine
of those mirrors still carrying the root README.md that #018 is about. A check that relocates
an exposure and then reports clean is worse than the exposure, which is the whole reason this
file exists.

So the run root's own parent — the testruns root — must hold this run and nothing else. Both
levels are named in the failure, because "something is beside you" and "something is beside
your parent" call for different clean-ups.

What the sideways look **cannot** reach is one level higher still: the runs root is a sibling of
this working copy, so `ls ..\..\..` returns the repository itself. That is #041, it is a location
problem rather than a check problem, and it is not closed here. What is done about it instead is
measured rather than assumed — see check-reach.ps1, which reads a finished run's transcript for
what the hire actually walked to.

The third leak is a **blind-scoring bundle left lying around**. It holds `criteria.md` in full and
lives in a root beside the runs root, so it is reachable by the same walk. Deleting it after
scoring is the obvious fix and is a closing step, which is a step to forget — so it is enforced
here instead, because this check already runs before every turn of every hire. A bundle blocks the
next run, loudly, at the only moment it could do harm.

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
    # TrimEnd before GetFileName: `Resolve-Path` *preserves* a trailing separator, and
    # `GetFileName('C:\a\b\')` is the empty string — so a `-Target` that ends in a backslash,
    # which is exactly what tab-completion produces, would leave the run folder's own name out
    # of $allowed and make the check report the folder as a leaking sibling of itself.
    $self   = (Resolve-Path $Target).Path.TrimEnd([System.IO.Path]::DirectorySeparatorChar,
                                                  [System.IO.Path]::AltDirectorySeparatorChar)
    $parent = Split-Path $self -Parent
    $allowed = @([System.IO.Path]::GetFileName($self)) + $Sibling

    foreach ($d in @(Get-ChildItem $parent -Directory -ErrorAction SilentlyContinue)) {
        if ($d.Name -notin $allowed) {
            $failures += "LEAK: $($d.FullName) sits beside the run folder — one ``ls ..`` shows it to the hire"
        }
    }

    # One level further up, because #019's own fix moved the dangerous listing here. The testruns
    # root may hold this run's folder and nothing else: `ls ..\..` is no harder for a hire to type
    # than `ls ..`, and what it used to list was ten scored implementations of the identical brief
    # plus nine superseded mirrors carrying the README that tells a hire it is being tested.
    $runRoot     = $parent
    $testrunRoot = Split-Path $runRoot -Parent
    if ($testrunRoot) {
        $runRootName = [System.IO.Path]::GetFileName($runRoot)
        foreach ($d in @(Get-ChildItem $testrunRoot -Directory -ErrorAction SilentlyContinue)) {
            if ($d.Name -ne $runRootName) {
                $failures += "LEAK: $($d.FullName) sits beside this run's own folder — one ``ls ..\..`` shows it to the hire"
            }
        }
    }

    # No blind-scoring bundle may exist while a hire runs. Each one holds criteria.md verbatim, and
    # the scoring root is a sibling of the runs root — the same walk that reaches one reaches the
    # other. For a re-run of a scenario already scored, that file *is* the answer sheet.
    #
    # This is the enforcement half of a rule score-bundle.ps1 states and cannot keep: it prints the
    # -Remove line, and printing is not enforcing. Placed here because this check is the one thing
    # that runs before every turn of every hire, so the rule is checked exactly when it matters and
    # nowhere else. A bundle sitting there between two scorings harms nothing and is not policed.
    #
    # It fires whatever the bundle is called and whether or not it belongs to this run: a bundle for
    # *this* run existing before the hire means an earlier attempt was scored, which makes it the
    # sharpest leak of the lot rather than an exemption.
    . (Join-Path $PSScriptRoot 'lib\run-root.ps1')
    $scoringRoot = Get-MonsterDevScoringRoot
    foreach ($b in @(Get-ChildItem $scoringRoot -Directory -ErrorAction SilentlyContinue)) {
        $failures += ("LEAK: $($b.FullName) is a blind-scoring bundle and holds criteria.md in full. " +
                      "Delete it before hiring: .\process\tools\score-bundle.ps1 -RunId $($b.Name) -Remove")
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
    #
    # $self and $parent come from the check above rather than being derived a second time. The
    # duplicate derivation that used to be here re-ran GetFileName on the *untrimmed* path, so a
    # `-Target` ending in a separator listed the run folder among its own neighbours — the same
    # defect as the check, surviving in the line that reports the check passed.
    $beside = @(Get-ChildItem $parent -Directory | Where-Object { $_.Name -ne [System.IO.Path]::GetFileName($self) })
    "isolation OK — $Target (parent holds $($beside.Count) other director$(if ($beside.Count -eq 1) {'y'} else {'ies'})$(if ($beside) { ': ' + (($beside | ForEach-Object Name) -join ', ') }))"
}
