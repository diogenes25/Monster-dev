<#
.SYNOPSIS
Assembles the blind evidence bundle a second, independent scoring of a run is done against.

.DESCRIPTION
A run is scored by the person who designed it, wrote the board item it came from, and knows which
criterion was supposed to flip. Four defects on the board say what that costs: #009 (the verifier
measured a proxy for visibility, twice, in two disguises), #010 (a stale server measured the
before-arm and reported it confidently), #007 (a fixture-inherent console error counted against
every hire), #015 (six hires held the answer and ten scoring passes did not notice). None of those
is a hard bug. Each is a verdict that looked right to a reader who expected it.

So the run is scored a second time, blind, and this script is what "blind" means in practice.

What goes in is the evidence. What stays out is everything that says what the answer should be:

  the board item that was the run's brief   — the sharpest anchor there is
  every earlier report                      — including this run's own first scoring
  the scenario's run-log table              — ten prior verdicts on the same criteria
  CLAUDE.md and the workshop skill          — the gates, the technique, what is measured

The bundle is built outside this repository and outside ../monster-dev-testruns/, because a
scoring session started under either would pick up CLAUDE.md from its ancestry (see
check-isolation.ps1) or the neighbouring run folders (see #019). The second scoring is then run as
a separate `claude -p` session with the bundle as its working directory — an in-process subagent
cannot be blind, because it can read this whole repository, and asking it not to is not a control.

Run it from the repository root.

.PARAMETER RunId
The run to assemble. Reads process/runs/<RunId>.* and the target recorded in its hire.json.

.PARAMETER Scenario
The scenario the run was scored against, repo-relative. Its run-log table is stripped.

.PARAMETER Target
The run folder, if there is no hire.json to read it from — true for six of the ten runs on record,
which predate the wrapper.

.PARAMETER TranscriptPath
The session transcript, if the sessionId cannot be resolved. Normally found by globbing
~/.claude/projects/*/<sessionId>.jsonl — the CLI owns the project-slug rule, so the slug is never
derived from the target path.

.PARAMETER OutRoot
Where bundles are built. Default ..\monster-dev-scoring.

.EXAMPLE
.\process\tools\score-bundle.ps1 -RunId 2026-08-01-plan-sonnet -Scenario process\scenarios\alt-a-left-to-right.md
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$RunId,
    [Parameter(Mandatory)][string]$Scenario,
    [string]$Target,
    [string]$TranscriptPath,
    [string]$OutRoot = '..\monster-dev-scoring'
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path 'START.md')) {
    throw "Run this from the repository root — START.md is not here."
}

$repoRoot = (Resolve-Path '.').Path
$runsDir  = Join-Path $repoRoot 'process\runs'

# --- where it goes ---------------------------------------------------------------------------

New-Item -ItemType Directory -Force $OutRoot | Out-Null
$bundle = Join-Path (Resolve-Path $OutRoot).Path $RunId
if (Test-Path $bundle) { Remove-Item -Recurse -Force $bundle }
New-Item -ItemType Directory -Force $bundle | Out-Null

if ($bundle.StartsWith($repoRoot, [StringComparison]::OrdinalIgnoreCase)) {
    Remove-Item -Recurse -Force $bundle
    throw "BROKEN: bundle $bundle is inside this repository — CLAUDE.md would reach the scorer."
}

# --- criteria, minus the verdicts of every run before this one -------------------------------

$scenarioPath = Join-Path $repoRoot $Scenario
if (-not (Test-Path $scenarioPath)) { throw "BROKEN: no scenario at $scenarioPath" }

$lines = Get-Content $scenarioPath
$cut   = ($lines | Select-String -Pattern '^##\s+Run log\s*$' | Select-Object -First 1).LineNumber

# Fail rather than pass the file through. A stripper that silently stops stripping is how the
# anchor comes back, and it comes back invisibly: the bundle still looks right.
if (-not $cut) {
    Remove-Item -Recurse -Force $bundle
    throw ("BROKEN: no '## Run log' heading in $Scenario, so nothing was stripped. " +
           "Either the scenario changed shape or the wrong file was passed. The bundle is not " +
           "blind without this cut, so it was deleted rather than handed back.")
}

$kept = $lines[0..($cut - 2)]
Set-Content (Join-Path $bundle 'criteria.md') $kept -Encoding utf8

# The run-log table is the bulk of the anchor, not all of it: scenario prose cites run ids too
# (alt-a-left-to-right.md explains its dialogue protocol by quoting what 2026-08-01-phase2 did).
# Reported rather than stripped — cutting prose by pattern would silently remove criteria.
$residue = @($kept | Select-String -Pattern '\b20\d\d-\d\d-\d\d-[a-z0-9-]+' -AllMatches |
             ForEach-Object { $_.Matches.Value } | Sort-Object -Unique)

# --- the envelope, the measurements, the git surface ------------------------------------------

$hireJson = Join-Path $runsDir "$RunId\hire.json"
$sessionId = $null
if (Test-Path $hireJson) {
    Copy-Item $hireJson (Join-Path $bundle 'hire.json')
    $record    = Get-Content $hireJson -Raw | ConvertFrom-Json
    $sessionId = $record.sessionId
    if (-not $Target) { $Target = $record.target }
}

$measurements = Join-Path $runsDir "$RunId\measurements.json"
if (Test-Path $measurements) { Copy-Item $measurements (Join-Path $bundle 'measurements.json') }

$shot = Join-Path $runsDir "$RunId\midwalk.png"
if (Test-Path $shot) { Copy-Item $shot (Join-Path $bundle 'midwalk.png') }

if (-not $Target) {
    Remove-Item -Recurse -Force $bundle
    throw "BROKEN: no target for $RunId — no hire.json to read it from, so pass -Target."
}
if (-not (Test-Path $Target)) {
    Remove-Item -Recurse -Force $bundle
    throw "BROKEN: target $Target does not exist. For an archived run, point -Target at the rescued copy."
}
$targetPath = (Resolve-Path $Target).Path

@(
    '=== git log --oneline ==='
    (git -C $targetPath log --oneline)
    ''
    '=== git status --porcelain -uall ==='
    (git -C $targetPath status --porcelain -uall)
    ''
    '=== git diff --stat ==='
    (git -C $targetPath diff --stat)
) | Set-Content (Join-Path $bundle 'git.txt') -Encoding utf8

# The project as it was handed back. Without .git, so the scorer reads the state rather than
# reconstructing the history — git.txt is the history, already reduced to what the criteria ask.
$work = Join-Path $bundle 'worktree'
Copy-Item -Recurse $targetPath $work
if (Test-Path (Join-Path $work '.git')) { Remove-Item -Recurse -Force (Join-Path $work '.git') }

# --- the transcript ---------------------------------------------------------------------------

$transcript = $null
if ($TranscriptPath) {
    $transcript = (Resolve-Path $TranscriptPath).Path
} elseif ($sessionId) {
    # Glob the CLI's own project folders. The slug rule is the CLI's, not ours, and deriving it
    # from the target path is how that breaks silently on the next CLI version.
    $hit = @(Get-ChildItem (Join-Path $HOME '.claude\projects') -Recurse -Filter "$sessionId.jsonl" -ErrorAction SilentlyContinue)
    if ($hit.Count -eq 1) { $transcript = $hit[0].FullName }
    elseif ($hit.Count -gt 1) { throw "BROKEN: $($hit.Count) transcripts match session $sessionId." }
}

if ($transcript) {
    Copy-Item $transcript (Join-Path $bundle 'transcript.jsonl')
} else {
    # Not fatal: the git surface, the worktree and the measurements still carry sections A, B and D.
    # Section E cannot be scored without it, and saying so beats a bundle that looks complete.
    Set-Content (Join-Path $bundle 'MISSING.md') @(
        '# Not in this bundle'
        ''
        'No transcript could be resolved for this run. Sections that are scored from the dialogue —'
        'criteria 6, 7, 14a, 15a, 15b and the whole of section E — cannot be scored from what is here.'
        'Record them as NOT SCORABLE rather than as failures.'
    ) -Encoding utf8
}

# --- nothing that names the answer may have arrived -------------------------------------------

$leaks = @()
foreach ($f in Get-ChildItem $bundle -Recurse -File -Include '*.md','*.json','*.txt') {
    if ($f.Name -eq 'criteria.md') { continue }
    if ($f.Name -eq 'transcript.jsonl') { continue }
    if (Select-String -Path $f.FullName -Pattern 'acceptance criteria|proof design|playbook gap|board' -Quiet) {
        $leaks += "LEAK: $($f.FullName) reads like harness material"
    }
}
if (Test-Path (Join-Path $bundle 'CLAUDE.md')) { $leaks += 'LEAK: CLAUDE.md reached the bundle' }
if ($leaks) {
    Remove-Item -Recurse -Force $bundle
    throw ($leaks -join "`n") + "`nBundle deleted rather than handed back."
}

& (Join-Path $repoRoot 'process\tools\check-isolation.ps1') -Target $bundle -AncestryOnly | Out-Null

[pscustomobject]@{
    RunId          = $RunId
    Bundle         = $bundle
    CriteriaLines  = $kept.Count
    StrippedAtLine = $cut
    Transcript     = if ($transcript) { Split-Path $transcript -Leaf } else { '(none — section E not scorable)' }
    RunIdsInProse  = if ($residue) { $residue -join ', ' } else { '(none)' }
}

if ($residue) {
    "`nNOTE: the stripped scenario still names $($residue.Count) run id(s) in its prose. That is a"
    "residual anchor this script does not remove, because cutting prose by pattern would take"
    "criteria with it. Read those passages before trusting a close verdict."
}
