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
  the scenario's run log and provenance     — prior verdicts, and how each criterion got its wording
  CLAUDE.md and the workshop skill          — the gates, the technique, what is measured

Both of those last two live below one heading, `## Run log`, and everything from it down is cut.
A scenario's `## Provenance` section sits after it deliberately: a criterion's *history* — what an
audit found, what an earlier run scored, why a row was reworded — is not an instrument, and handing
it to the second reader hands over the map with the criterion at risk already circled (#056). The
cut is enforced twice over: no run id may appear above it, and this script refuses rather than
strips, because cutting prose by pattern would take criteria with it.

The bundle is built outside this repository and outside the runs root, because a scoring session
started under either would pick up CLAUDE.md from its ancestry (see check-isolation.ps1) or the
neighbouring run folders (see #019). Both roots come from lib\run-root.ps1 rather than from a
literal in this file. The second scoring is then run as a separate `claude -p` session with the
bundle as its working directory — an in-process subagent cannot be blind, because it can read this
whole repository, and asking it not to is not a control.

**A bundle is transient, and leaving one behind is now a blocked hire rather than a private
untidiness.** It contains `criteria.md` in full, and the scoring root sits beside the runs root
where a hire that walks up can reach it. Being buried among unrelated folders is obscurity, and
CLAUDE.md says nothing here is hidden by obscurity. So `check-isolation.ps1` — which hire.ps1 runs
before every turn — refuses to start a hire while any bundle exists. Delete it with -Remove when
the second scoring is written up; if you forget, the next run tells you instead of the hire finding
it. That placement is deliberate: a closing step is a step to forget, and this repository has
already lost a run that way.

Run it from the repository root.

.PARAMETER RunId
The run to assemble. Reads process/runs/<RunId>.* and the target recorded in its hire.json.

.PARAMETER Scenario
The scenario the run was scored against, repo-relative. Everything from its `## Run log` heading
down is cut, its `## Provenance` section included.

.PARAMETER Target
The run folder, if there is no hire.json to read it from — true for six of the ten runs on record,
which predate the wrapper.

.PARAMETER TranscriptPath
The session transcript, if the sessionId cannot be resolved. Normally found by globbing
~/.claude/projects/*/<sessionId>.jsonl — the CLI owns the project-slug rule, so the slug is never
derived from the target path.

.PARAMETER OutRoot
Where bundles are built. Defaults to lib\run-root.ps1's scoring root, which is overridable by
MONSTER_DEV_SCORING_ROOT and refuses to resolve inside this repository.

.PARAMETER NoVerifier
Say, in MISSING.md, that this run produced no verifier output *by design* rather than lost it —
because no criterion in the scenario names that instrument, which is a property of the scenario and
not of what the hire did. A note that reads as damage invites a blind scorer to hedge marks that
were never measured that way. Set by whoever builds the bundle; deriving it from the scenario text
would be guessing (#038).

The note deliberately does **not** say why there was nothing to measure. It used to say "there was
no page for a headless browser to drive", which is a claim about the hire, and `2026-08-03-r16`
falsified it: a decline scenario whose hire built an HTML page anyway. A blind bundle must not
assert a fact its own evidence contradicts.

.PARAMETER Remove
Deletes this run's bundle and reports what is left in the scoring root. Run it once the second
scoring is written up — until then the bundle is what the blind scorer reads, and afterwards it is
a copy of the criteria sitting where a hire can walk to it.

.EXAMPLE
.\process\tools\score-bundle.ps1 -RunId 2026-08-01-plan-sonnet -Scenario process\scenarios\alt-a-left-to-right.md

.EXAMPLE
.\process\tools\score-bundle.ps1 -RunId 2026-08-01-plan-sonnet -Remove
#>
[CmdletBinding(DefaultParameterSetName = 'Build')]
param(
    [Parameter(Mandatory)][string]$RunId,
    [Parameter(Mandatory, ParameterSetName = 'Build')][string]$Scenario,
    [Parameter(ParameterSetName = 'Build')][string]$Target,
    [Parameter(ParameterSetName = 'Build')][string]$TranscriptPath,
    [Parameter(ParameterSetName = 'Build')][switch]$NoVerifier,
    [string]$OutRoot,
    [Parameter(Mandatory, ParameterSetName = 'Remove')][switch]$Remove
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path 'START.md')) {
    throw "Run this from the repository root — START.md is not here."
}

$repoRoot = (Resolve-Path '.').Path
$runsDir  = Join-Path $repoRoot 'process\runs'

# --- where it goes ---------------------------------------------------------------------------
#
# Resolved here rather than as a param default, because a param default binds before the script
# body runs and so cannot call anything this file dot-sources.
. (Join-Path $PSScriptRoot 'lib\run-root.ps1')
if (-not $OutRoot) { $OutRoot = Get-MonsterDevScoringRoot }

# --- -Remove: the explicit close ---------------------------------------------------------------
#
# Reports the rest of the root rather than emptying it. A bundle belonging to another run is
# somebody else's evidence mid-scoring, and deleting it unasked is not this switch's business —
# but it will block the next hire, so saying so is.
if ($Remove) {
    $doomed = Join-Path $OutRoot $RunId
    $existed = Test-Path $doomed
    if ($existed) { Remove-Item -Recurse -Force $doomed }

    $left = @(Get-ChildItem $OutRoot -Directory -ErrorAction SilentlyContinue | ForEach-Object Name)
    [pscustomobject]@{
        RunId   = $RunId
        Removed = if ($existed) { $doomed } else { '(nothing there)' }
        Left    = if ($left) { $left -join ', ' } else { '(empty)' }
    }
    if ($left) {
        "`nNOTE: $($left.Count) bundle(s) still in $OutRoot. check-isolation.ps1 will refuse the next"
        "hire while any of them is there, because each holds a copy of some run's criteria.md a"
        "hire could walk up to. Remove them with -Remove once their scoring is written up."
    }
    return
}

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

# --- the run being scored may never name itself -------------------------------------------------
#
# #047. This run's id above the cut tells the blind reader which run it is holding, and on
# 2026-08-03-r12 the passage went further and named the criterion the pre-run audit had been worried
# about. A second reader that knows where to look is not the reader the second pass was designed to
# be.
#
# It runs before the general check below and is not redundant with it. Two reasons, in order of
# how much they matter: this message names the one thing that has to move, and the general check
# keys on a *dated* id, so a run called `ph0-smoke` is caught here and nowhere else.
#
# -SimpleMatch with ONE escaped pattern, deliberately. `-Pattern 'a|b' -SimpleMatch` searches for
# the pipe literally and can never match; that broke a 13b check on 2026-08-03 and returned the
# expected answer while measuring nothing.
$selfNamed = @($kept | Select-String -Pattern $RunId -SimpleMatch)
if ($selfNamed) {
    $where = ($selfNamed | ForEach-Object { "  line $($_.LineNumber): $($_.Line.Trim())" }) -join "`n"
    Remove-Item -Recurse -Force $bundle
    throw ("BROKEN: $Scenario names the run being scored, '$RunId', in the prose the scorer reads:`n" +
           "$where`n" +
           "That tells a blind reader which run it is holding, and a passage about a pre-run " +
           "correction also tells it which criterion was thought to be at risk. Move the passage to " +
           "the scenario's '## Provenance' section, which sits below this cut, or to " +
           "process\fixtures\<name>.md, and leave the scenario the current wording of its answer " +
           "script. Do not stop recording what the audit found. " +
           "Bundle deleted rather than handed back. (#047)")
}

# --- and no *other* run may be named above the cut either ---------------------------------------
#
# The run-log table is the bulk of the anchor, not all of it: scenario prose used to cite run ids
# too, and this was a NOTE for exactly one reason — cutting prose by pattern would silently remove
# criteria, so stripping was never an option. Refusing is a different move and was available all
# along: it hands the passage back to a human instead of guessing which words to keep.
#
# #056 is why it escalated. The residual anchors were not neutral trivia. alt-a-left-to-right.md's
# boundary sections named criteria *and* their pass counts — "`13b` had failed 12 of 12", "`r15`
# and `r14` both passed all three marks of `10`" — and nowhere-to-walk.md said which criterion a
# pre-run audit had been worried about. A blind scorer read all of it. The NOTE said "read those
# passages before trusting a close verdict", which is advice to the wrong person: by the time
# anybody reads the NOTE the disclosure is already in the bundle, and the scoring may be done.
#
# So both scenarios now keep their history in a `## Provenance` section placed *after* `## Run log`,
# below this same cut. No second hardcoded heading was needed and none was added: a section below
# the one cut that already hard-fails when absent cannot be forgotten into a leak.
#
# What this enforces is narrower than the rule that matters — a passage can give a verdict away
# without naming a run, and "its ten passes were assent" is exactly such a passage — so
# `## Provenance` stays a discipline applied by hand. What this catches is the anchor that makes a
# disclosure attributable to a run.
$residue = @($kept | Select-String -Pattern '\b20\d\d-\d\d-\d\d-[a-z0-9-]+' -AllMatches |
             ForEach-Object { $_.Matches.Value } | Sort-Object -Unique)
if ($residue) {
    $lineNos = @($kept | Select-String -Pattern '\b20\d\d-\d\d-\d\d-[a-z0-9-]+' |
                 ForEach-Object { "  line $($_.LineNumber): $($_.Line.Trim())" }) -join "`n"
    Remove-Item -Recurse -Force $bundle
    throw ("BROKEN: $Scenario names $($residue.Count) run id(s) above the '## Run log' cut, in the " +
           "prose the scorer reads — $($residue -join ', ')`n$lineNos`n" +
           "A run id above the cut is what makes a disclosure attributable, and a passage that " +
           "carries one is usually a criterion's history rather than its wording. Move it to the " +
           "scenario's '## Provenance' section, which sits below this cut, and leave the criteria " +
           "the wording that governs. Do not stop recording what an audit or an earlier run found. " +
           "Bundle deleted rather than handed back. (#056)")
}

# --- the envelope, the measurements, the git surface ------------------------------------------

$hireJson = Join-Path $runsDir "$RunId\hire.json"
$sessionId = $null
if (Test-Path $hireJson) {
    Copy-Item $hireJson (Join-Path $bundle 'hire.json')
    $record    = Get-Content $hireJson -Raw | ConvertFrom-Json
    $sessionId = $record.sessionId
    if (-not $Target) { $Target = $record.target }
}

# Every optional copy below records its own absence. The scorer is blind by construction — it sees
# this bundle and nothing else — so a file it was never told to expect is indistinguishable from a
# file that was never produced, and it scores the criteria off whatever is left without hedging.
# That is exactly what #035 was: the screenshot was copied under a name nothing wrote, the copy
# found nothing, and the bundle came out looking complete. The name agreement is what breaks again
# on the next rename; this list is the part that survives it.
#
# What these notes may not do is name criteria. Section letters and criterion numbers are
# scenario-local, and until #038 these strings spelled out alt-a-left-to-right.md's — which was
# harmless while one scenario existed and became a fabrication the moment a second one had a
# section D of its own. A criterion names its instrument (#027); so an absent instrument does not
# have to name its criteria. Say what is gone and what class of question went with it, and let the
# scorer map that onto criteria.md, which run-scorer.md has it read in full first anyway.
$missing = @()

$measurements = Join-Path $runsDir "$RunId\measurements.json"
if (Test-Path $measurements) {
    Copy-Item $measurements (Join-Path $bundle 'measurements.json')
} elseif ($NoVerifier) {
    # Says that the verifier was not part of this scenario's design, and stops there. It used to
    # say *why* — "there was no page for a headless browser to drive" — which is a claim about what
    # the hire did, not about the scenario, and 2026-08-03-r16 falsified it: a decline scenario
    # whose hire built an HTML page anyway. A note in a blind bundle that asserts a fact the
    # evidence contradicts is worse than a terse one, because the scorer has no way to check it.
    $missing += 'No `measurements.json`, and **this run produced none by design.** No criterion in this'
    $missing += "scenario names that instrument, so the verifier was never meant to run: its absence is not"
    $missing += 'damage and not a gap in the evidence. Score every criterion off the instrument it names.'
    $missing += ''
} else {
    $missing += 'No `measurements.json`. Nothing a headless browser would have measured is in this bundle —'
    $missing += 'position over time, rendered sprite geometry, computed style, page console output. Any'
    $missing += 'criterion naming that instrument is NOT SCORABLE, not a failure. `criteria.md` says which.'
    $missing += ''
}

$shot = Join-Path $runsDir "$RunId\midwalk.png"
if (Test-Path $shot) {
    Copy-Item $shot (Join-Path $bundle 'midwalk.png')
} elseif ($NoVerifier) {
    $missing += 'No `midwalk.png`, and **this run produced none by design** — no criterion here is settled by'
    $missing += 'looking at a rendered page. Not damage and not a gap.'
    $missing += ''
} else {
    $missing += 'No `midwalk.png`. Nothing in this bundle can be settled by looking at the rendered page. A'
    $missing += 'criterion whose only instrument is the screenshot is NOT SCORABLE; where it names a second'
    $missing += 'one, score it from that and say in the verdict that you did.'
    $missing += ''
}

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
    ''
    # The §8 trailer rule is scored off the message *body*, and --oneline is the subject only.
    # nowhere-to-walk's criterion 11 names `git log --format=%B` as one of its two instruments and
    # this file shipped the other one alone, so the blind scorer passed 11 on the inference that a
    # hire which never invoked git cannot have written a trailer — sound, and not the named
    # instrument (#044). An instrument a criterion names is an instrument the bundle ships.
    '=== git log --format=%B ==='
    (git -C $targetPath log --format='%B%n---')
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
    # Not fatal: the git surface, the worktree and whatever the verifier produced are still here.
    # Saying what went with the transcript beats a bundle that looks complete.
    $missing += 'No transcript could be resolved for this run. Nothing the hire *said* is in this bundle, and'
    $missing += 'nothing about the order it did things in: no turn text, no questions asked, no tool calls, no'
    $missing += 'record of what it read. Any criterion whose instrument is the transcript or the cli-turn text'
    $missing += 'is NOT SCORABLE rather than a failure. `hire.json` still carries the cost and turn figures.'
    $missing += ''
}

# One MISSING.md for all of them. It used to be written by the transcript branch alone with
# Set-Content, so a second absence would have overwritten the first rather than joined it.
if ($missing) {
    Set-Content (Join-Path $bundle 'MISSING.md') (@('# Not in this bundle', '') + $missing) -Encoding utf8
}

# --- nothing that names the answer may have arrived -------------------------------------------

$leaks = @()
foreach ($f in Get-ChildItem $bundle -Recurse -File -Include '*.md','*.json','*.txt') {
    if ($f.Name -eq 'criteria.md') { continue }
    if ($f.Name -eq 'transcript.jsonl') { continue }
    # `board` is word-bounded. Unanchored it matches inside **keyboard**, and the brief this
    # bundle is built around is a keyboard shortcut — so a hire writing "the keyboard handler"
    # anywhere in `worktree/**` or `hire.json` deleted the whole bundle. The other three terms
    # are multi-word and cannot collide this way.
    if (Select-String -Path $f.FullName -Pattern 'acceptance criteria|proof design|playbook gap|\bboard\b' -Quiet) {
        $leaks += "LEAK: $($f.FullName) reads like harness material"
    }
}
if (Test-Path (Join-Path $bundle 'CLAUDE.md')) { $leaks += 'LEAK: CLAUDE.md reached the bundle' }
if ($leaks) {
    Remove-Item -Recurse -Force $bundle
    throw ($leaks -join "`n") + "`nBundle deleted rather than handed back."
}

# Every failure path above deletes the bundle; this one was the exception, and it is the worst one
# to leave behind. A bundle that fails isolation is left looking complete at exactly the path the
# procedure tells the operator to `cd` into — and the blind scoring is the control on the first
# scoring, so a control run against a bundle this script refused is worse than no second pass.
# The check throws rather than returning a value, so catching is the only way to reach that.
# The reason is captured before the delete and carried into the throw: deleting on failure
# destroys the evidence of the failure, and the message is all the operator gets to look at.
try {
    & (Join-Path $repoRoot 'process\tools\check-isolation.ps1') -Target $bundle -AncestryOnly | Out-Null
} catch {
    $reason = "$_"
    Remove-Item -Recurse -Force $bundle
    throw "$reason`nBundle deleted rather than handed back."
}

[pscustomobject]@{
    RunId          = $RunId
    Bundle         = $bundle
    CriteriaLines  = $kept.Count
    StrippedAtLine = $cut
    Transcript     = if ($transcript) { Split-Path $transcript -Leaf } else { '(none — section E not scorable)' }
    # Always '(none)' now that a run id above the cut is a refusal. Reported anyway, because a
    # field that is always the same is still the field somebody looks at to confirm it was checked
    # — and because the day it says anything else, the refusal above has stopped firing.
    RunIdsInProse  = if ($residue) { $residue -join ', ' } else { '(none)' }
}

"`nThis bundle holds criteria.md in full and now blocks the next hire — check-isolation.ps1 refuses"
"to start one while any bundle exists. Delete it once the second scoring is written up:"
"    .\process\tools\score-bundle.ps1 -RunId $RunId -Remove"
