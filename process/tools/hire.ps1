<#
.SYNOPSIS
Hires Monster-Dev for one turn and keeps the evidence that the prose reports used to throw away.

.DESCRIPTION
`claude -p --output-format json` already prints total_cost_usd, num_turns, session_id,
is_error and permission_denials. Every run so far discarded them and retyped the numbers into
a report by hand — which is a problem, because two of the three proof gates in CLAUDE.md are
stated in exactly those numbers. This script runs the hire and keeps the envelope.

It also snapshots `git status --porcelain -uall` in the target immediately before and after
each turn. That second snapshot is the point: K7a ("asked before building") is the criterion
this project has misattributed three times, and its evidence has always been a hand-typed
sentence. An empty worktree after turn 1 is the same claim as a machine fact.

Turn 1 needs -Brief (or -BriefFile) and -Dist. Every later turn needs only -Answer; the
session id is read back out of the stored envelope. Everything is written under process/runs/ —
never into the target, because an artefact inside the target would violate the §9 cleanup
rule the run is there to measure.

Run it from the repository root.

.PARAMETER RunId
Identifies the run. Evidence is appended to process/runs/<RunId>.hire.json.

.PARAMETER Target
The run folder the hire works in. Must be outside this repository.

.PARAMETER Dist
The mirror from build-dist.ps1, handed over with --add-dir. Turn 1 only.

.PARAMETER Brief
The customer brief from the scenario. Turn 1 only; mutually exclusive with -BriefFile.

.PARAMETER BriefFile
A file holding the customer brief, so a long or multi-line brief stays out of the shell.

.PARAMETER Answer
A customer answer, taken verbatim from the scenario's answer script. Turn 2 onward.

.PARAMETER Model
Passed to claude --model. Recorded as hire.modelFlag, which is authoritative: what the
envelope reports has changed across CLI versions.

.PARAMETER AllowedTools
Passed to claude --allowedTools. A fence that is too tight shows up as a product failure when
it was really the harness, so it is recorded rather than assumed.

.EXAMPLE
.\process\tools\hire.ps1 -RunId 2026-08-02-plan-sonnet -Target ..\monster-dev-testruns\2026-08-02-plan-sonnet -Dist ..\monster-dev-testruns\2026-08-02-plan-sonnet.dist -Model sonnet -BriefFile .\process\scenarios\alt-a-left-to-right.brief.txt

.EXAMPLE
.\process\tools\hire.ps1 -RunId 2026-08-02-plan-sonnet -Target ..\monster-dev-testruns\2026-08-02-plan-sonnet -Answer 'keine Präferenz, nimm deinen Standard'
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$RunId,
    [Parameter(Mandatory)][string]$Target,
    [string]$Dist,
    [string]$Brief,
    [string]$BriefFile,
    [string]$Answer,
    [string]$Model,
    [string]$AllowedTools = 'Read,Write,Edit,Glob,Grep,Bash,WebFetch'
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path 'START.md')) {
    throw "Run this from the repository root — START.md is not here."
}

$repoRoot   = (Resolve-Path '.').Path
$targetPath = (Resolve-Path $Target).Path
$runDir     = Join-Path $repoRoot "process\runs\$RunId"
$recordPath = Join-Path $runDir 'hire.json'
New-Item -ItemType Directory -Force $runDir | Out-Null

# The whole isolation story depends on the run folder not sitting under this repo, where
# CLAUDE.md would reach the hire through the ancestor chain.
if ($targetPath.StartsWith($repoRoot, [StringComparison]::OrdinalIgnoreCase)) {
    throw "BROKEN: target $targetPath is inside this repository — CLAUDE.md would leak into the hire."
}

# Step 4 of Half B, re-run per turn rather than once per run. It is cheap, and a turn-2 hire
# is exactly as sensitive to a stray CLAUDE.md as a turn-1 hire.
& (Join-Path $repoRoot 'process\tools\check-isolation.ps1') -Target $targetPath | Out-Null

function Get-Worktree($path) {
    # -uall so an untracked *directory* is listed by its files; a collapsed "assets/" entry
    # would hide which file the hire actually added.
    @(git -C $path status --porcelain -uall) | Where-Object { $_ }
}

# --- assemble the turn ---------------------------------------------------------------------

if (Test-Path $recordPath) {
    $record = Get-Content $recordPath -Raw | ConvertFrom-Json
    if ($Brief -or $BriefFile) {
        throw "BROKEN: $RunId already has turn 1 recorded. Use -Answer to continue the session."
    }
    if (-not $Answer) { throw "BROKEN: -Answer is required to continue an existing run." }

    $sessionId = $record.sessionId
    if (-not $sessionId) { throw "BROKEN: no session id stored in $recordPath — cannot resume." }

    $prompt   = $Answer
    $kind     = 'answer'
    $claudeArgs = @('-p', $prompt, '--resume', $sessionId, '--output-format', 'json')
} else {
    if ($Answer)   { throw "BROKEN: $RunId has no turn 1 yet. Start it with -Brief or -BriefFile." }
    if (-not $Dist) { throw "BROKEN: -Dist is required for turn 1 — the hire has no entry point without the mirror." }
    if ($Brief -and $BriefFile) { throw "BROKEN: pass either -Brief or -BriefFile, not both." }

    $prompt = if ($BriefFile) { Get-Content $BriefFile -Raw } else { $Brief }
    if (-not $prompt) { throw "BROKEN: turn 1 needs -Brief or -BriefFile." }

    $distPath = (Resolve-Path $Dist).Path
    $kind     = 'brief'
    $claudeArgs = @('-p', $prompt, '--output-format', 'json', '--add-dir', $distPath)

    $record = [pscustomobject]@{
        runId        = $RunId
        target       = $targetPath
        dist         = $distPath
        modelFlag    = $Model
        allowedTools = $AllowedTools
        cliVersion   = (claude --version)
        sessionId    = $null
        turns        = @()
        totals       = $null
    }
}

$claudeArgs += @('--allowedTools', $AllowedTools)
if ($Model) { $claudeArgs += @('--model', $Model) }

# --- run it --------------------------------------------------------------------------------

$before = Get-Worktree $targetPath

Push-Location $targetPath
try {
    $raw = & claude @claudeArgs
    $exit = $LASTEXITCODE
} finally {
    Pop-Location
}

$after = Get-Worktree $targetPath

if ($exit -ne 0) {
    throw "BROKEN: claude exited $exit. Nothing recorded — widen the fence or fix the invocation and rerun this turn."
}

$envelope = ($raw -join "`n") | ConvertFrom-Json

# --- record it -----------------------------------------------------------------------------

$turn = [pscustomobject]@{
    index          = $record.turns.Count + 1
    kind           = $kind
    invokedAt      = (Get-Date).ToUniversalTime().ToString('o')
    prompt         = $prompt
    worktreeBefore = @($before)
    worktreeAfter  = @($after)
    envelope       = $envelope
}

$record.turns = @($record.turns) + $turn
if (-not $record.sessionId) { $record.sessionId = $envelope.session_id }

# num_turns is the model-turn count the prose reports called "33 model turns"; cliTurns is the
# number of claude -p invocations they called "2 turns". Both were conflated in the reports.
# firstEditAfterCliTurn is the direct input to criterion 19: it must be > 1, or the hire
# started editing before the customer had answered anything.
$firstEdit = $null
foreach ($t in $record.turns) {
    if (-not $firstEdit -and $t.worktreeAfter.Count -gt 0) { $firstEdit = $t.index }
}

$record.totals = [pscustomobject]@{
    total_cost_usd        = [math]::Round(( $record.turns | Measure-Object -Property { $_.envelope.total_cost_usd } -Sum ).Sum, 4)
    num_turns             = ( $record.turns | Measure-Object -Property { $_.envelope.num_turns } -Sum ).Sum
    cliTurns              = $record.turns.Count
    duration_ms           = ( $record.turns | Measure-Object -Property { $_.envelope.duration_ms } -Sum ).Sum
    anyError              = [bool](@($record.turns | Where-Object { $_.envelope.is_error }).Count)
    permissionDenials     = ( $record.turns | Measure-Object -Property { [int]$_.envelope.permission_denials } -Sum ).Sum
    firstEditAfterCliTurn = $firstEdit
}

New-Item -ItemType Directory -Force (Split-Path $recordPath) | Out-Null
$record | ConvertTo-Json -Depth 20 | Set-Content $recordPath -Encoding utf8

# --- the harness must leave no trace in the target -------------------------------------------

$strays = @($after | Where-Object { $_ -match '\.(hire|run|judgement)\.json|\.log$' })
if ($strays) {
    throw "LEAK: harness artefacts reached the target:`n" + ($strays -join "`n")
}

[pscustomobject]@{
    Turn        = $turn.index
    Kind        = $kind
    Session     = $record.sessionId
    Cost        = $record.totals.total_cost_usd
    ModelTurns  = $record.totals.num_turns
    CliTurns    = $record.totals.cliTurns
    Worktree    = if ($after) { $after -join '; ' } else { '(clean)' }
    Record      = $recordPath
}

"`n--- hire said ---`n"
$envelope.result
