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
The run folder the hire works in — <runs root>\<RunId>\target, as new-run.ps1 printed it. Must be
outside this repository, and neither its parent nor the runs root may hold anything but this run;
check-isolation.ps1 enforces all three. Passed rather than derived on purpose: the paid turn is in
this script, and a path it computed for itself would be a path nobody looked at.

.PARAMETER Dist
The mirror from build-dist.ps1 — <runs root>\<RunId>\dist, the one directory beside the run folder
a hire is meant to reach. Handed over with --add-dir. Turn 1 only.

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
# Since #048 this folder normally already exists — new-run.ps1 creates it and writes assembly.md
# into it, so the record of a run starts when the run is assembled rather than when it is first
# paid for. The -Force stays anyway: it is idempotent on a directory, and a run folder built some
# other way must not make the wrapper throw before it has captured anything.
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

    # Closes the assembly record: an assembly.md with no `hire.ps1` entry is a setup that was
    # built and never hired, which is precisely the case #048 exists for.
    #
    # The entry-point path is written down here because #042 makes it part of the mirror surface.
    # `2026-08-01-alt-a` was handed a path running through a session scratchpad, and a scratchpad
    # segment is a CLI project slug — this repository's absolute path with the separators turned
    # into dashes. The hire decoded it and listed the repository root without ever walking up. That
    # is checkable before a turn is bought, and only if the path is on record.
    # Measured, not asserted. A line saying "no scratchpad segment" that nothing looked for is the
    # fourth instrument in this project to confirm an expectation while measuring nothing, and one of
    # those four was written the same day #042 was found. The check itself lives in the lib so it can
    # be exercised without paying for a turn.
    . (Join-Path $repoRoot 'process\tools\lib\assembly.ps1')
    $epMatch   = [regex]::Match($prompt, '\S*START\.md')
    $entry     = if ($epMatch.Success) { $epMatch.Value } else { '' }
    $decodable = Test-MonsterDevEntryPointLeak -Prompt $prompt -DistPath $distPath -RepoRoot $repoRoot

    # Precomputed, not interpolated inline: a nested double-quoted string carrying backtick escapes
    # inside $() inside a double-quoted string does not survive PowerShell's tokenizer.
    $noteFixture = if ($Fixture) { "``$Fixture``" } else { '(not passed)' }
    $noteEntry   = if ($entry) { "``$entry``" } else { 'no START.md path in the brief text' }
    $noteDecode  = if ($decodable) { 'FOUND — ' + ($decodable -join '; ') } else { 'none found' }

    Add-MonsterDevAssemblyNote -RunId $RunId -Step 'hire.ps1' -Detail @(
        "model: ``$Model`` · fixture: $noteFixture"
        "mirror handed over as: ``$distPath``"
        "entry point in the brief: $noteEntry"
        "#042 — decodable references to this repository in turn 1's prompt and mirror path: $noteDecode"
    ) | Out-Null

    # Reports, does not gate — the leak-auditor's rule, for the same reason: a judgement step that
    # blocks runs is worse than none, and this one matches strings. A hit is still a stop; it is the
    # person reading it who decides, before the turn is paid for rather than after.
    if ($decodable) {
        Write-Warning ("#042: turn 1 hands the hire " + ($decodable -join ' and ') +
                       ". The alt-a hire decoded exactly this and listed the repository root. " +
                       "Recorded in assembly.md — read it before continuing.")
    }

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
#
# The three artefacts are captured **independently**, each attempted whatever the others did.
# They used to be one sequence, and `scrub-transcript.ps1` is built to *throw* rather than write
# a transcript it could not fully anonymise — correct on its own, and it aborted the whole block,
# so the worktree copy and base.txt were not written either. Neither of those contains the
# account name the scrubber was worried about. A failure in the most protective component
# destroyed the two artefacts it was not protecting (#034), and it failed worst exactly when it
# mattered most: a transcript with an unanticipated shape is the one worth having a worktree of.
$captureErrors = [ordered]@{}
Remove-Item -LiteralPath (Join-Path $runDir 'CAPTURE-FAILED.txt') -ErrorAction SilentlyContinue

# 1/3 — the transcript. A transcript that fails to scrub is not written at all: not unscrubbed,
# and not to a `.unscrubbed` sidecar either, because process/ is tracked and pushed and a sidecar
# is a file somebody commits by accident. What is kept is the reason, below.
try {
    # Glob the CLI's own project folders. The slug rule is the CLI's, not ours, and deriving it
    # from the target path is how that breaks silently on the next CLI version.
    $hits = @(Get-ChildItem (Join-Path $HOME '.claude\projects') -Recurse -Filter "$($record.sessionId).jsonl" -ErrorAction SilentlyContinue)
    if ($hits.Count -ne 1) { throw "expected exactly 1 transcript for session $($record.sessionId), found $($hits.Count)" }

    & (Join-Path $repoRoot 'process\tools\scrub-transcript.ps1') `
        -In $hits[0].FullName -Out (Join-Path $runDir 'transcript.jsonl') `
        -Run $targetPath -Dist $record.dist -RepoRoot $repoRoot | Out-Null
} catch { $captureErrors['transcript.jsonl'] = "$_" }

# 2/3 — the worktree, which is what §9's diff surface and the 18-marks are read against.
try {
    $work = Join-Path $runDir 'worktree'
    if (Test-Path $work) { Remove-Item -Recurse -Force $work }
    Copy-Item -Recurse $targetPath $work
    if (Test-Path (Join-Path $work '.git')) { Remove-Item -Recurse -Force (Join-Path $work '.git') }
} catch { $captureErrors['worktree/'] = "$_" }

# 3/3 — base.txt and the record stub.
try {
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
} catch { $captureErrors['base.txt'] = "$_" }

# Named per artefact, because "the transcript and/or the worktree are not in this folder" was
# accurate only while the block was all-or-nothing. Now each can fail alone, and a reader has to
# be able to tell which of them did without going and looking.
#
# knowledge.md is deliberately *not* written to here, which departs from #034's proposal that the
# run record should say the transcript is missing. That file is created once and then left alone
# — it is the one file in the folder a person writes — and an automatically inserted line reads
# exactly like a written one, which is the same reason its `tags` are left empty rather than
# guessed. CAPTURE-FAILED.txt is rewritten every turn and is the honest place for a machine fact.
$captureError = $null
if ($captureErrors.Count) {
    $captureError = ($captureErrors.Keys | ForEach-Object { "${_}: $($captureErrors[$_])" }) -join '; '
    $all = @('transcript.jsonl', 'worktree/', 'base.txt')
    @(
        "The capture partly failed after cli turn $($turn.index). The envelope in hire.json is intact"
        'and the turn is not lost. Each artefact is captured independently, so the ones marked ok'
        'below are complete and usable.'
        ''
    ) + @($all | ForEach-Object {
        if ($captureErrors.Contains($_)) { "  FAILED  $_ — $($captureErrors[$_])" } else { "  ok      $_" }
    }) | Set-Content (Join-Path $runDir 'CAPTURE-FAILED.txt') -Encoding utf8
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
