<#
.SYNOPSIS
Creates the run folder a hire works in, prepares it, and refuses to hand back one that is not isolated.

.DESCRIPTION
This used to be three commands pasted out of the skill: Copy-Item, git init, git commit. That is the
same shape that failed for the <dist> mirror — "a mirror assembled from a pasted command is a mirror
nobody verified" — and it acquired a fourth step the moment fixtures stopped being plain files.

A fixture with a build (`ng new`, `dotnet new`) cannot ship its dependencies: this repo is not going
to track node_modules. Somebody has to run `npm ci` or `dotnet restore`, and **it must not be the
hire**. Installing is environment preparation, not the job — done inside the session it lands in
`num_turns` and `total_cost_usd`, which are two of the three numbers the gates in CLAUDE.md are
stated in, and a run that dies on an npm error dies for a reason that has nothing to do with the
playbook.

So the setup recipes live here, in `process/tools/setup/<fixture>.ps1`, and never inside the fixture
folder. A recipe stored beside the fixture would be copied into the target with everything else, and
would then show up in `git status` — the exact diff surface §9 is scored on. A fixture with no recipe
is the normal case and needs none.

Order matters: copy, then set up, then exactly one commit. The commit lands after installation so
that whatever the project's own .gitignore excludes stays excluded, the way it would in a real
checkout.

Like build-dist.ps1, this deletes what it built rather than return something unusable — a run folder
that fails the isolation check is worse than no run folder, because it looks ready.

.PARAMETER RunId
Identifies the run. The folder is created at ..\monster-dev-testruns\<RunId>.

.PARAMETER Fixture
A directory name under process\fixtures\.

.PARAMETER Force
Replace an existing run folder of the same name instead of refusing.

.EXAMPLE
.\process\tools\new-run.ps1 -RunId 2026-08-02-alt-a -Fixture static-site

.EXAMPLE
.\process\tools\new-run.ps1 -RunId 2026-08-02-gsap-a -Fixture gsap-site
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$RunId,
    [Parameter(Mandatory)][string]$Fixture,
    [switch]$Force
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path 'START.md')) {
    throw "Run this from the repository root — START.md is not here."
}

$source = Join-Path 'process\fixtures' $Fixture
if (-not (Test-Path $source)) {
    $known = (Get-ChildItem 'process\fixtures' -Directory | ForEach-Object Name) -join ', '
    throw "No fixture '$Fixture'. Known fixtures: $known"
}

$target = Join-Path (Resolve-Path '..').Path "monster-dev-testruns\$RunId"
if (Test-Path $target) {
    if (-not $Force) { throw "$target already exists. Pass -Force to replace it." }
    Remove-Item -Recurse -Force $target
}

New-Item -ItemType Directory -Force (Split-Path $target) | Out-Null
Copy-Item -Recurse $source $target

# The recipe runs with the run folder as its working directory and is never copied into it.
$recipe = Join-Path $PSScriptRoot "setup\$Fixture.ps1"
$setup = 'none'
if (Test-Path $recipe) {
    $setup = Split-Path $recipe -Leaf
    # Cleared first: a stale code left by any earlier native command would otherwise read as a
    # failed recipe and delete a perfectly good run folder.
    $global:LASTEXITCODE = 0
    Push-Location $target
    try { & $recipe }
    finally { Pop-Location }
    if ($LASTEXITCODE) {
        Remove-Item -Recurse -Force $target
        throw "Setup recipe '$setup' failed with exit code $LASTEXITCODE. Run folder deleted so it cannot be hired against."
    }
}

git -C $target init -q
git -C $target add -A
git -C $target commit -qm 'Initial project'

# The same check the hire procedure runs, done here so a broken folder never reaches it.
try {
    & (Join-Path $PSScriptRoot 'check-isolation.ps1') -Target $target | Out-Null
} catch {
    Remove-Item -Recurse -Force $target
    throw "$_`nRun folder deleted so it cannot be used by accident."
}

# An empty status is what makes "the hire changed exactly this" readable afterwards. A non-empty one
# means the fixture or the recipe left something untracked and unignored, and every §9 measurement in
# this run would be scored against that noise.
$dirty = @(git -C $target status --porcelain -uall)
if ($dirty) {
    Remove-Item -Recurse -Force $target
    throw ("Run folder is not clean after its first commit:`n" + ($dirty -join "`n") +
           "`nA fixture or setup recipe left files that are neither committed nor ignored, which would " +
           "contaminate the §9 diff surface. Run folder deleted.")
}

[pscustomobject]@{
    RunId    = $RunId
    Fixture  = $Fixture
    Target   = $target
    Setup    = $setup
    Commits  = 1
    Clean    = $true
}
