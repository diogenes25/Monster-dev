# Where a run folder and a scoring bundle live. One definition, dot-sourced by every tool that
# needs one, because the arrangement it replaces was three scripts each deriving `..` on their own
# and a fourth quoting the result in its help text.
#
# --- what this file settles, and it is the mechanism rather than the location ------------------
#
# #041 measured that the run folder is three `cd ..` from the repository, and its cost section says
# the path convention is load-bearing in seven places. That is #003's shape exactly — *a list of
# sites is the list of sites somebody found* — and it is the part of #041 that is decidable without
# deciding anything about where runs should live. After this file there is one site. Moving the
# runs root later is a one-line edit here instead of a grep somebody has to get right.
#
# So: this file makes the location cheap to change. It does not change it.
#
# --- what it deliberately does not settle -----------------------------------------------------
#
# The default below is still a sibling of the working copy, and `ls ..\..\..` from a hire's own
# working directory still returns this:
#
#   MonsterLib                     CLAUDE.md, process/, and this run's own scenario file
#   monster-dev-scoring            a blind bundle, holding criteria.md verbatim
#   monster-dev-rescue-2026-08-02  rescue copies of nine implementations, with sprites
#   monster-dev-archive            twenty older run folders and mirrors (#040)
#
# That is unresolved and #041 stays open on it. Two reasons it is not resolved by relocating, and
# the first is CLAUDE.md's own:
#
#   1. CLAUDE.md already answers this for the structurally identical case. Of the run class that
#      fetches over real raw.githubusercontent.com URLs and never sees a mirror, it says: *"that is
#      not a hole to plug by hiding things — it is a validity condition of that run class, and the
#      way to hold it is to measure it."* A directory three levels up is the same case. The
#      detector — read the captured transcript for reaches above the run folder, and say in the
#      report that you did — is *stronger* evidence than a relocation, because it reports what the
#      hire touched instead of what we believe it could not reach.
#   2. #003, #036, #040 and #041 are four instances in two days of one failure: a fix that
#      relocates its own subject, after which nobody re-asks what the check points at. #041's log
#      records that whoever found #040's relocation defect committed the same one inside the hour.
#      A third relocation on the same day, with nothing measured in between, is the fifth instance.
#
# --- the rule a location has to satisfy, whenever one is chosen -------------------------------
#
# **No ancestor and no sibling of the run folder, up to and including the runs root, may have
# anything to do with the experiment.** Under the current layout:
#
#   <runs root>\<id>\target    the hire's working directory
#   <runs root>\<id>\dist      the mirror, the one sibling it is meant to reach
#   <runs root>\<id>           checked by check-isolation.ps1: target, dist, nothing else
#   <runs root>                checked by check-isolation.ps1: this run, nothing else
#   <runs root>'s parent       NOT checked and cannot be — it is a general source directory
#                              holding unrelated projects, and the repository is one of them
#
# The last line is the open part. Two levels hold; the third is a location problem, and no
# arrangement of sideways checks fixes a location.
#
# --- the scoring root, and why a habit was the wrong close ------------------------------------
#
# A blind-scoring bundle contains `criteria.md` in full, and the scoring root is a sibling of the
# runs root. Being buried among unrelated folders is obscurity, and CLAUDE.md says plainly that
# nothing here is hidden by obscurity and nothing should be built as though it were.
#
# A bundle is **transient**: it is built, a blind scorer reads it, and it has no reason to survive
# that. The obvious close is "delete it after scoring" — and that is a closing step, which is a
# step to forget. hire.ps1's own docstring makes this argument about itself, and this repository
# has already lost a run to a forgotten closing step.
#
# So it is enforced where it costs nothing to enforce: `check-isolation.ps1` runs before every
# turn of every hire, and it now refuses to let a hire start while any bundle exists. The window
# in which a stale bundle matters is exactly the window in which a hire is running, and that is
# the window the check owns. Forgetting is now loud instead of silent.

# process\tools\lib -> process\tools -> process -> the repository root. Anchored to this file
# rather than to the working directory: every caller asserts it is at the repository root anyway,
# but a root that depends on the caller's CWD is a root that is one `cd` from being wrong.
$script:MonsterDevRepoRoot = [System.IO.Path]::GetFullPath(
    (Split-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) -Parent))

function Resolve-MonsterDevRoot {
    <#
    .SYNOPSIS
    Normalises a configured root to an absolute path and refuses one inside the repository.

    .DESCRIPTION
    The environment overrides below exist because a hard-coded path assumes one laptop's layout —
    the complaint #029 and #037 both already make. They also introduce a failure mode that did not
    exist while the path was a literal: a contributor can point a root *into* their working copy,
    and then CLAUDE.md reaches the hire through the ancestor chain, which is the one thing this
    whole arrangement exists to prevent.

    hire.ps1 and score-bundle.ps1 each check containment for their own path already, and both
    checks stay — they cover a -Target passed by hand, which this function never sees. This is the
    earlier of the two: it fails when the root is *configured*, naming the variable, rather than
    when a folder has already been built inside it.
    #>
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][string]$Source
    )

    # Relative roots resolve against the repository root, not the caller's CWD, and GetFullPath
    # collapses the `..` so downstream StartsWith comparisons see a normalised path.
    $full = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($script:MonsterDevRepoRoot, $Path))

    $repo = $script:MonsterDevRepoRoot.TrimEnd('\')
    if ($full.TrimEnd('\') -eq $repo -or $full.StartsWith($repo + '\', [StringComparison]::OrdinalIgnoreCase)) {
        throw ("BROKEN: $Source resolves to $full, which is inside this repository. " +
               "A run or a bundle under the working copy reaches CLAUDE.md, process/ and its own " +
               "acceptance criteria through its ancestor chain. Point it outside the repository.")
    }
    $full
}

function Get-MonsterDevRunRoot {
    <#
    .SYNOPSIS
    The directory that holds run folders, one per run, and nothing else.

    .DESCRIPTION
    Default: ..\monster-dev-testruns, a sibling of the working copy — unchanged, and still the open
    half of #041. Override with MONSTER_DEV_RUN_ROOT.
    #>
    if ($env:MONSTER_DEV_RUN_ROOT) {
        return Resolve-MonsterDevRoot -Path $env:MONSTER_DEV_RUN_ROOT -Source 'MONSTER_DEV_RUN_ROOT'
    }
    Resolve-MonsterDevRoot -Path '..\monster-dev-testruns' -Source 'the default runs root'
}

function Get-MonsterDevScoringRoot {
    <#
    .SYNOPSIS
    The directory that holds blind-scoring bundles. Never inside the runs root — that one must hold
    exactly one run, and check-isolation.ps1 enforces it.

    .DESCRIPTION
    Default: ..\monster-dev-scoring. Override with MONSTER_DEV_SCORING_ROOT. A bundle left here
    blocks the next hire; see the note above on why that is a check rather than a habit.
    #>
    if ($env:MONSTER_DEV_SCORING_ROOT) {
        return Resolve-MonsterDevRoot -Path $env:MONSTER_DEV_SCORING_ROOT -Source 'MONSTER_DEV_SCORING_ROOT'
    }
    Resolve-MonsterDevRoot -Path '..\monster-dev-scoring' -Source 'the default scoring root'
}

function Get-MonsterDevRunPaths {
    <#
    .SYNOPSIS
    Every path a run is made of, derived once from its id.

    .DESCRIPTION
    The `<id>\{target,dist}` nesting is #019's fix, and it was spelled out separately in
    new-run.ps1 and build-dist.ps1 — two scripts that have to agree about a layout, with nothing
    making them. They now read it from here. Returns absolute paths whether or not they exist yet,
    because both scripts create what they return.
    #>
    param([Parameter(Mandatory)][string]$RunId)

    $root   = Get-MonsterDevRunRoot
    $folder = Join-Path $root $RunId
    [pscustomobject]@{
        Root   = $root
        Folder = $folder
        Target = Join-Path $folder 'target'
        Dist   = Join-Path $folder 'dist'
    }
}
