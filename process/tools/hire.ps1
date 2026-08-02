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

After every turn it also brings the run home: the scrubbed transcript, the worktree without
.git, and a base.txt saying what the run started from. That rides on the per-turn write rather
than being a closing step, because a closing step is a step to forget — and this repository has
already lost one run that way, along with its only copy of the folder it ran in.

Run it from the repository root.

.PARAMETER RunId
Identifies the run. Everything it produces goes in process/runs/<RunId>/.

.PARAMETER Target
The run folder the hire works in — ..\monster-dev-testruns\<RunId>\target. Must be outside this
repository, and its parent must hold nothing but this run; check-isolation.ps1 enforces both.

.PARAMETER Dist
The mirror from build-dist.ps1 — ..\monster-dev-testruns\<RunId>\dist, the one directory beside
the run folder a hire is meant to reach. Handed over with --add-dir. Turn 1 only.

.PARAMETER Brief
The customer brief from the scenario. Turn 1 only; mutually exclusive with -BriefFile.

.PARAMETER BriefFile
A file holding the customer brief, so a long or multi-line brief stays out of the shell.

.PARAMETER Answer
A customer answer, taken verbatim from the scenario's answer script. Turn 2 onward.

.PARAMETER Model
Passed to claude --model. Recorded as hire.modelFlag, which is authoritative: what the
envelope reports has changed across CLI versions.

.PARAMETER Fixture
Which fixture the run folder was made from. Turn 1 only, and recorded rather than used —
nothing else in a captured run says it, and the base commit alone does not distinguish two
fixtures that both start with one commit called "Initial site".

.PARAMETER AllowedTools
Passed to claude --allowedTools. A fence that is too tight shows up as a product failure when
it was really the harness, so it is recorded rather than assumed.

.EXAMPLE
.\process\tools\hire.ps1 -RunId 2026-08-02-plan-sonnet -Target ..\monster-dev-testruns\2026-08-02-plan-sonnet\target -Dist ..\monster-dev-testruns\2026-08-02-plan-sonnet\dist -Model sonnet -BriefFile .\process\scenarios\alt-a-left-to-right.brief.txt

.EXAMPLE
.\process\tools\hire.ps1 -RunId 2026-08-02-plan-sonnet -Target ..\monster-dev-testruns\2026-08-02-plan-sonnet\target -Answer 'keine Präferenz, nimm deinen Standard'
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
    [string]$Fixture,
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
        fixture      = $Fixture
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

# --- bring the run home, every turn ----------------------------------------------------------
#
# The transcript is the only record of *how* a hire worked and the only artefact here that
# cannot be recreated; the worktree is the only record of what it built. Both used to live
# outside the repository, and `new-run.ps1 -Force` deletes a run folder before recreating it —
# which has already destroyed one set, `ph0-smoke`, of which nothing survives but a transcript.
#
# This rides on the per-turn write above rather than being a closing step in the procedure.
# A remembered step has been lost twice here: the `test/` → `process/` mirror exclusion, and
# `ph0-smoke` itself, which was run outside this wrapper and left nothing behind. There is no
# end of the run to miss, and a run abandoned after turn 1 still leaves an honest record.
#
# It runs *after* the envelope is on disk and it never throws: a bug in the capture must not
# cost a turn that has already been paid for. It fails loudly instead — CAPTURE-FAILED.txt in
# the run folder, and a line in the object this script returns.
$captureError = $null
try {
    Remove-Item -LiteralPath (Join-Path $runDir 'CAPTURE-FAILED.txt') -ErrorAction SilentlyContinue

    # Glob the CLI's own project folders. The slug rule is the CLI's, not ours, and deriving it
    # from the target path is how that breaks silently on the next CLI version.
    $hits = @(Get-ChildItem (Join-Path $HOME '.claude\projects') -Recurse -Filter "$($record.sessionId).jsonl" -ErrorAction SilentlyContinue)
    if ($hits.Count -ne 1) { throw "expected exactly 1 transcript for session $($record.sessionId), found $($hits.Count)" }

    # Scrubbed on the way in, because process/ is tracked and this repository is pushed. The
    # scrubber deletes nothing on failure and writes nothing on failure, so a transcript that
    # cannot be anonymised simply does not arrive — which is what CAPTURE-FAILED.txt then says.
    & (Join-Path $repoRoot 'process\tools\scrub-transcript.ps1') `
        -In $hits[0].FullName -Out (Join-Path $runDir 'transcript.jsonl') `
        -Run $targetPath -Dist $record.dist -RepoRoot $repoRoot | Out-Null

    $work = Join-Path $runDir 'worktree'
    if (Test-Path $work) { Remove-Item -Recurse -Force $work }
    Copy-Item -Recurse $targetPath $work
    if (Test-Path (Join-Path $work '.git')) { Remove-Item -Recurse -Force (Join-Path $work '.git') }

    @(
        "run:      $RunId"
        "fixture:  $(if ($record.fixture) { $record.fixture } else { '(not recorded — hire.ps1 was called without -Fixture)' })"
        "base:     $(git -C $targetPath log --format='%H %s' --max-parents=0 -1)"
        "captured: $((Get-Date).ToUniversalTime().ToString('o')) after cli turn $($turn.index)"
        ''
        'git status --porcelain -uall at capture time:'
    ) + @(if ($after) { $after } else { '(clean)' }) |
        Set-Content (Join-Path $runDir 'base.txt') -Encoding utf8

    # Created once and then left alone: it is the one file here a person writes, and a turn-2
    # capture must not overwrite a sentence somebody typed after turn 1.
    #
    # Open Knowledge Format (v0.1), which #024 settled for process/runs/ and only for
    # process/runs/ — process/stacks/ keeps its `Stack:` first line, because OKF has no field for a
    # published stack and that line is the whole mapping between the two trees. `type` is the one
    # required field; the four values allowed here are run / implementation / surface / observation.
    #
    # `tags` is written empty rather than guessed. Tags are free-form and check-index.ps1 enforces
    # only their form, so an automatically invented one would be a real tag nobody chose — and it
    # would show up in the rendered overview as though somebody had.
    $knowledge = Join-Path $runDir 'knowledge.md'
    if (-not (Test-Path $knowledge)) {
        @(
            '---'
            'type: run'
            "title: Run $RunId"
            'description:'
            "resource: $RunId"
            'tags: []'
            "timestamp: $((Get-Date).ToUniversalTime().ToString('yyyy-MM-dd'))"
            '---'
            ''
            "# Run ``$RunId``"
            ''
            '*What this run was for, and what it turned up. Written by hand after it is scored —'
            'the capture never fills this in, because an automatically written half-record reads'
            'exactly like a real one. Cross-reference other records with `[[wikilinks]]`;'
            '`check-index.ps1` fails on one with no target.*'
        ) | Set-Content $knowledge -Encoding utf8
    }
} catch {
    $captureError = $_.Exception.Message
    @(
        "The capture failed after cli turn $($turn.index). The envelope in hire.json is intact and",
        'the turn is not lost, but the transcript and/or the worktree are not in this folder.',
        '',
        $captureError
    ) | Set-Content (Join-Path $runDir 'CAPTURE-FAILED.txt') -Encoding utf8
}

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
    Capture     = if ($captureError) { "FAILED — $captureError" } else { $runDir }
}

"`n--- hire said ---`n"
$envelope.result
