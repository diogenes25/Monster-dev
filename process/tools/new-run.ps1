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

The same rule was overdue for the fixture's own notes and cost ten runs. A fixture folder holds only
what the target project would hold; what the fixture is *for* goes in `process/fixtures/<name>.md`,
a sibling. This script enforces the half of that a string can see: if `Monster-Dev` or `MonsterLib`
appears anywhere in the copied target, the folder is deleted rather than handed back.

Order matters: copy, then set up, then exactly one commit. The commit lands after installation so
that whatever the project's own .gitignore excludes stays excluded, the way it would in a real
checkout.

Like build-dist.ps1, this deletes what it built rather than return something unusable — a run folder
that fails the isolation check is worse than no run folder, because it looks ready.

.PARAMETER RunId
Identifies the run. The folder is created at <runs root>\<RunId>\target, and its only sibling is
the <RunId>\dist mirror build-dist.ps1 writes. Where the runs root is, and how to move it, is
lib\run-root.ps1's business and no longer this script's — it used to derive `..` itself, as did
build-dist.ps1, with nothing making the two agree.

Both used to be direct children of the runs root, which made every previous run one `ls ..` away
from the hire — ten finished, already-scored implementations of the identical brief, in dated
folders with the model name in them. One hire listed exactly that. Nesting per run costs nothing
and puts every other run two levels away instead of one.

The run id itself is not checked by anything and is worth choosing carefully. One assembled on
2026-08-03 carried the scenario's own finding in its name, which would have put that word in the
hire's working directory and in the output of its first `pwd`. No check here looks at what an id
*means*.

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

. (Join-Path $PSScriptRoot 'lib\run-root.ps1')
$paths   = Get-MonsterDevRunPaths -RunId $RunId
$runRoot = $paths.Folder
$target  = $paths.Target
if (Test-Path $target) {
    if (-not $Force) { throw "$target already exists. Pass -Force to replace it." }
    Remove-Item -Recurse -Force $target
}

New-Item -ItemType Directory -Force $runRoot | Out-Null
Copy-Item -Recurse $source $target

# --- nothing in the target may name the product -------------------------------------------------
#
# A fixture folder contains only what the target project would contain. That rule was violated for
# ten runs by the fixtures' own README files, which described the expected behaviour to whoever
# read them — and the reader was the hire. Six of ten transcripts contain the string.
#
# Two product names and nothing wider. `monster` alone would fire the moment a fixture legitimately
# has one, and a check that has to be argued with is a check that gets switched off.
#
# Which reader this protects: the **hire's own working copy**, against being handed the expected
# answer. It is not build-dist.ps1's harness vocabulary, which protects the hire against learning
# it is measured at all, and it is not score-bundle.ps1's criteria terms, which protect the blind
# scorer. Three readers, three leaks, three lists on purpose.
#
# It runs before the setup recipe rather than after. What a recipe installs is upstream package
# content: walking it would be slow, and a match inside somebody else's dependency is not this
# project's leak. What the recipe itself writes is in scope and is not covered here — recorded as a
# boundary rather than claimed.
$PRODUCT_NAMES = 'Monster-Dev', 'MonsterLib'
$named = @()
foreach ($f in (Get-ChildItem $target -Recurse -File)) {
    $hits = @(Select-String -LiteralPath $f.FullName -Pattern $PRODUCT_NAMES -SimpleMatch -ErrorAction SilentlyContinue)
    foreach ($h in $hits) {
        $rel = $f.FullName.Substring($target.Length).TrimStart('\')
        $named += "  ${rel}:$($h.LineNumber): $($h.Line.Trim())"
    }
}
if ($named) {
    Remove-Item -Recurse -Force $target
    throw ("The fixture names the product inside the target project:`n" + ($named -join "`n") +
           "`nA hire reads its own working copy first. Move the note to process\fixtures\$Fixture.md, " +
           "which is a sibling of the fixture folder and is never copied. Run folder deleted.")
}

# The recipe runs with the run folder as its working directory and is never copied into it.
$recipe = Join-Path $PSScriptRoot "setup\$Fixture.ps1"
$setup = 'none'
if (Test-Path $recipe) {
    $setup = Split-Path $recipe -Leaf
    # Cleared first: a stale code left by any earlier native command would otherwise read as a
    # failed recipe and delete a perfectly good run folder.
    $global:LASTEXITCODE = 0
    $recipeError = $null
    Push-Location $target
    # The catch is not belt-and-braces for the exit-code branch below — it is its other half. A
    # recipe that *exits* non-zero is handled there; one that *raises a terminating error* — a
    # missing command, a failed download, anything at all under $ErrorActionPreference = 'Stop' —
    # went past both and left the run folder on disk. What happens next is somebody hires against
    # a folder whose dependencies were never installed, and that cost lands in num_turns, one of
    # the three numbers the tooling gate is stated in.
    #
    # The failure is recorded and re-thrown *after* Pop-Location rather than inside the catch:
    # $target is the working directory at that point, and Windows will not delete it.
    try { & $recipe }
    catch { $recipeError = $_ }
    finally { Pop-Location }
    if ($recipeError) {
        Remove-Item -Recurse -Force $target
        throw "Setup recipe '$setup' threw: $recipeError`nRun folder deleted so it cannot be hired against."
    }
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
    RunRoot  = $runRoot
    Target   = $target
    Setup    = $setup
    Commits  = 1
    Clean    = $true
}
