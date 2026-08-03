<#
.SYNOPSIS
Reads a finished run's transcript and reports everything the hire reached outside its own run folder.

.DESCRIPTION
#041 measured that the runs root is a sibling of this working copy, so `ls ..\..\..` from a hire's
working directory returns the repository — CLAUDE.md, process/, and that run's own scenario file.
Two levels of sideways check hold (see check-isolation.ps1); the third is a location problem, and no
arrangement of sideways checks fixes a location.

The location has not been changed. This script is what was done instead, and CLAUDE.md already
argues for exactly this move about a structurally identical case — the run class that fetches over
real raw.githubusercontent.com URLs and never sees a mirror:

    "that is not a hole to plug by hiding things — it is a validity condition of that run class,
     and the way to hold it is to measure it: after a real-URL run, list every URL the hire fetched
     out of the captured transcript and check it against the playbook's own pointers. Say in the
     report that you did."

That paragraph describes a habit. This is the same instruction with a script behind it, widened from
URLs to the directory tree, because the tree is the reach #041 is about. Section D below is the URL
half, so the habit has a tool now too.

**A hit is a finding to write up, not automatically a void run.** What invalidates a run is a hire
that read the criteria; what this reports is a hire that looked somewhere it had no business looking,
which is evidence to weigh. It exits non-zero so it *can* gate, and so that a run whose report says
nothing about reach cannot have been checked.

.DESCRIPTION
How it classifies, and why it does not parse paths itself:

scrub-transcript.ps1 already rewrites every absolute path to <dist>, <run>, <repo> or <home>,
longest prefix first, in six written forms including the JSON-escaped and Git-Bash ones. That is a
classification of exactly the kind this script needs, done by the tool that owns the path forms. So
a scrubbed transcript containing `<repo>` is, by construction, a hire that touched this repository —
there is no path-parsing here to disagree with the scrubber and be wrong in a new way.

Two transcripts on record predate -Run/-Dist being passed to the scrubber, and in those a run-folder
path survives as `<home>\...\monster-dev-testruns\<id>\...`. So the allowed prefixes are also built
from hire.json's own `target` and `dist`, in both absolute and home-tokenised form. The same
construction makes the script work on a raw, unscrubbed transcript.

.DESCRIPTION
Four sections, and section C is the one that would have caught the leak #019 was filed for.

  A  tool calls whose paths resolve outside the run folder, the mirror and the scratch dir
  B  parent-directory traversal in a shell command — `ls ..`, `cd ..\..`, `find ..`
  C  what the calls flagged in A and B actually printed back

     A and B read what the hire asked for. C reads what it was shown, and the difference is the
     whole of #019: that hire ran `ls ..`, which names no path above the run folder at all. The
     command is caught by B; what made it a leak was the *output* — a listing of dated run folders.
     A listing prints leaf names, and a leaf name is not a path, so none of the scrubber's tokens
     cover it.

     C is therefore paired by `tool_use_id` rather than scanning every result in the transcript.
     The first draft did scan all of them for the repository's name and its loudest hit was the
     hire reasoning, correctly, that the project does not reference `MonsterLib` — a check whose
     top finding is the product working is a check that gets switched off. Paired, it answers the
     only question worth asking: the hire looked up, and *this* is what it saw.

     The names C looks for come from the disk as it is **today**, not as it was on the run's day.
     Say so when citing it.

  D  every URL fetched, for the real-URL validity condition quoted above

.DESCRIPTION
What is deliberately *not* a finding: the session scratch directory under the OS temp folder. It is
outside the run folder by design — MONSTER-DEV.md §7 tells a hire to build its scratch harness
outside the client's project, and the CLI hands it that directory. Sixteen of the seventeen section-A
hits on the first transcript this ran against were exactly that, which is the shape of a check about
to be ignored. Temp holds nothing belonging to this experiment, so it is allowed by name and the
allowance is stated here rather than left as a silent filter.

.PARAMETER RunId
Reads process/runs/<RunId>/transcript.jsonl and process/runs/<RunId>/hire.json.

.PARAMETER TranscriptPath
A transcript to read instead of the run's captured one — a raw session file, or an arm's copy.

.PARAMETER Target
The run folder, when there is no hire.json to read it from. Six runs on record predate the wrapper.

Pass the path the run **used**, not where those files sit today. This script matches strings inside a
transcript, so for a run whose folder has since been archived or moved, the current location matches
nothing and every path in the transcript is reported as a reach. An absolute path that no longer
exists is correct here and is accepted on purpose.

.PARAMETER Dist
The mirror, likewise.

.PARAMETER Quiet
Report only the sections that have hits.

.EXAMPLE
.\process\tools\check-reach.ps1 -RunId 2026-08-03-r12

.EXAMPLE
.\process\tools\check-reach.ps1 -RunId 2026-08-01-live -Quiet
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$RunId,
    [string]$TranscriptPath,
    [string]$Target,
    [string]$Dist,
    [switch]$Quiet
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path 'START.md')) {
    throw "Run this from the repository root — START.md is not here."
}

. (Join-Path $PSScriptRoot 'lib\run-root.ps1')

$repoRoot = (Resolve-Path '.').Path
$runDir   = Join-Path $repoRoot "process\runs\$RunId"

$transcript = if ($TranscriptPath) { $TranscriptPath } else { Join-Path $runDir 'transcript.jsonl' }
if (-not (Test-Path $transcript)) {
    throw ("BROKEN: no transcript at $transcript. A run with no captured transcript cannot be " +
           "checked for reach, and a report that omits this section should say that rather than " +
           "leave it out silently.")
}

$hireJson = Join-Path $runDir 'hire.json'
if (Test-Path $hireJson) {
    $record = Get-Content $hireJson -Raw | ConvertFrom-Json
    if (-not $Target) { $Target = $record.target }
    if (-not $Dist)   { $Dist   = $record.dist }
}
if (-not $Target) {
    throw "BROKEN: no target for $RunId — no hire.json to read it from, so pass -Target."
}

# --- what counts as inside ----------------------------------------------------------------------
#
# The scrubber's own tokens first, then the absolute paths, then those paths with the home prefix
# tokenised — which is the form the two pre-#019 transcripts carry. Compared case-insensitively and
# after normalising separators, so a forward-slash Bash path matches a backslash prefix.
function Normalize([string]$s) {
    ($s -replace '/', '\').TrimEnd('\').ToLowerInvariant()
}

$homeFull = (Resolve-Path $HOME).Path
$allowed  = [System.Collections.Generic.List[string]]::new()
foreach ($tok in '<run>', '<dist>') { $allowed.Add((Normalize $tok)) }
foreach ($p in $Target, $Dist) {
    if (-not $p) { continue }
    $full = if (Test-Path $p) { (Resolve-Path $p).Path } else { $p }
    $allowed.Add((Normalize $full))
    if ($full.StartsWith($homeFull, [StringComparison]::OrdinalIgnoreCase)) {
        $allowed.Add((Normalize ('<home>' + $full.Substring($homeFull.Length))))
    }
}

# The scratch directory, allowed on purpose — see the docstring. Both the real temp path and its
# home-tokenised form, because the scrubber rewrites the home prefix but the CLI writes temp paths
# in the 8.3 short form as well, which the scrubber also maps to <home>.
foreach ($tmp in @($env:TEMP, (Join-Path $homeFull 'AppData\Local\Temp')) | Where-Object { $_ }) {
    $full = if (Test-Path $tmp) { (Resolve-Path $tmp).Path } else { $tmp }
    $allowed.Add((Normalize $full))
    if ($full.StartsWith($homeFull, [StringComparison]::OrdinalIgnoreCase)) {
        $allowed.Add((Normalize ('<home>' + $full.Substring($homeFull.Length))))
    }
}
$allowed = @($allowed | Sort-Object -Unique)

# Section C's names. The repository's own leaf is the one that matters; the others are whatever sits
# beside the runs root, which is where #040's archive and the scoring root live. Derived from the
# disk now, not from the run's day — the docstring says so and a citation should repeat it.
$runsRoot     = Get-MonsterDevRunRoot
$runsRootLeaf = Split-Path $runsRoot -Leaf
$neighbourhood = Split-Path $runsRoot -Parent
$siblingNames = @(Split-Path $repoRoot -Leaf)
foreach ($d in @(Get-ChildItem $neighbourhood -Directory -ErrorAction SilentlyContinue)) {
    if ($d.Name -eq $runsRootLeaf) { continue }
    if ($d.Name -eq (Split-Path $repoRoot -Leaf)) { continue }
    if ($d.Name -like 'monster*') { $siblingNames += $d.Name }
}
$siblingNames = @($siblingNames | Sort-Object -Unique)

# --- the scan -----------------------------------------------------------------------------------

$outside   = @()   # A
$traversal = @()   # B
$shown     = @()   # C
$urls      = @()   # D

# The two patterns are named RX_* and not after their sections, because PowerShell variable names
# are **case-insensitive**: a `$TRAVERSAL` holding the pattern and a `$traversal` holding the hits
# are one variable. The first draft had exactly that. The array overwrote the pattern, Matches() was
# handed an empty string and matched at every offset, and `+=` concatenated onto a string — so the
# report printed `B — 1` with every field blank. It looked like a finding. A check that can report a
# hit it did not find is worse than no check, which is this repository's own standing rule about
# green scripts, arriving through a language feature.
#
# The drive-letter alternative carries a lookbehind because without one it matches the tail of any
# word ending in a letter followed by `:\`. `file://…` in a Write's content becomes `file:\\…` once
# separators are unified, out of which a bare `[a-z]:\\` carves `e:\\` and reports it as a reach.
$RX_PATH = '(?i)(?:<repo>|<home>|<run>|<dist>|(?<![a-z0-9_.])[a-z]:\\)[^"'',;\s\]\)}]*'
# A traversal is the `..` segment itself, not a command name: the list of commands that can list a
# directory is open-ended (ls, dir, find, cat, Get-ChildItem, tree, robocopy /l, …) and a list of
# them is a list of the ones somebody thought of. A `..` inside a shell command is the signal.
$RX_TRAVERSAL = '(?<![.\w])\.\.[\\/]'
$RX_URL       = '(?i)https?://[^"''\s\\,;\]\)}]+'

# tool_use_id -> why it was flagged. Section C reads results only for these.
$flagged = @{}

$lineNo = 0
foreach ($line in [System.IO.File]::ReadLines((Resolve-Path $transcript).Path)) {
    $lineNo++
    if (-not $line.Trim()) { continue }
    try { $rec = $line | ConvertFrom-Json } catch { continue }
    if (-not $rec.message.content) { continue }

    foreach ($c in @($rec.message.content)) {

        # --- what the hire asked for: A, B, D ---
        if ($c.type -eq 'tool_use') {
            $raw = $c.input | ConvertTo-Json -Depth 8 -Compress

            # URLs come out first and are then *removed* from the text. Rewriting separators for the
            # path scan turns `http://localhost:${port}` into `http:\\localhost:${port}`, out of
            # which the path pattern happily carves `p:\\localhost:${port` and reports it as a reach
            # outside the run folder. Two of those were in the first run of this script.
            $urlsHere = @()
            foreach ($m in [regex]::Matches($raw, $RX_URL)) {
                $urlsHere += $m.Value
                $urls += [pscustomobject]@{ Line = $lineNo; Tool = $c.name; Url = $m.Value }
            }
            $stripped = $raw
            foreach ($u in $urlsHere) { $stripped = $stripped.Replace($u, '<url>') }

            # Collapse JSON and doubly-escaped backslashes, then unify separators, so one prefix
            # comparison covers every form the scrubber knows how to write.
            $norm = $stripped -replace '\\{2,4}', '\'
            $norm = $norm -replace '/', '\'

            foreach ($m in [regex]::Matches($norm, $RX_PATH)) {
                $tok = Normalize $m.Value
                if (-not $tok) { continue }
                $inside = $false
                foreach ($a in $allowed) {
                    if ($tok -eq $a -or $tok.StartsWith($a + '\')) { $inside = $true; break }
                }
                if ($inside) { continue }
                $outside += [pscustomobject]@{
                    Line = $lineNo
                    Tool = $c.name
                    Path = $m.Value
                    What = if ($m.Value -match '(?i)^<repo>') { 'THIS REPOSITORY' } else { 'outside run, mirror and scratch' }
                }
                if ($c.id) { $flagged[$c.id] = 'reached outside' }
            }

            foreach ($m in [regex]::Matches($norm, $RX_TRAVERSAL)) {
                $from = [math]::Max(0, $m.Index - 40)
                $traversal += [pscustomobject]@{
                    Line    = $lineNo
                    Tool    = $c.name
                    Context = $norm.Substring($from, [math]::Min(110, $norm.Length - $from))
                }
                if ($c.id) { $flagged[$c.id] = 'walked up with ..' }
            }
        }

        # --- what those calls printed back: C ---
        #
        # Only results belonging to a call already flagged by A or B. tool_result content is a string
        # on some records and an array of blocks on others, so it is flattened rather than assumed.
        if ($c.type -eq 'tool_result' -and $c.tool_use_id -and $flagged.ContainsKey($c.tool_use_id)) {
            $text = if ($c.content -is [string]) { $c.content }
                    else { (@($c.content) | ForEach-Object { if ($_.text) { $_.text } }) -join "`n" }
            if (-not $text) { continue }
            $named = @($siblingNames | Where-Object { $text -match [regex]::Escape($_) })

            # Foreign run ids are the other half, and on the evidence #019 was filed on they are the
            # *only* half: that hire ran `cd <runs root> && ls -la`, and what came back named no
            # directory of ours — it named ten dated run folders. A leaf name is not a path, and a
            # run id is not a directory this script knows about, so neither the scrubber's tokens nor
            # the sibling list reaches it. #019 measured the same thing by hand and called it "a
            # foreign run id"; this is that grep, kept.
            foreach ($m in [regex]::Matches($text, '(?i)\b20\d\d-\d\d-\d\d-[a-z0-9]+(?:-[a-z0-9]+)*')) {
                if ($m.Value -ieq $RunId) { continue }
                if ($named -notcontains $m.Value) { $named += $m.Value }
            }

            $flat = ($text -replace '\s+', ' ')
            $shown += [pscustomobject]@{
                Line    = $lineNo
                Why     = $flagged[$c.tool_use_id]
                Named   = if ($named) { $named -join ', ' } else { '(named nothing of ours)' }
                Context = $flat.Substring(0, [math]::Min(160, $flat.Length))
            }
        }
    }
}

# --- the report ---------------------------------------------------------------------------------

"reach check — $RunId"
"  transcript      $transcript"
"  run folder      $Target"
"  mirror          $(if ($Dist) { $Dist } else { '(none recorded)' })"
"  names for C     $($siblingNames -join ', ')  (from the disk today, not the run's day)"
"                  plus any date-prefixed run id that is not this run's own"
''

function Section($title, $rows, $render) {
    if (-not $rows -and $Quiet) { return }
    "$title — $(@($rows).Count)"
    if (-not $rows) { "  none"; ''; return }
    foreach ($r in $rows) { "  $(& $render $r)" }
    ''
}

Section 'A. paths outside the run folder, mirror and scratch' $outside   { param($r) "line $($r.Line)  $($r.Tool)  [$($r.What)]  $($r.Path)" }
Section 'B. parent-directory traversal in a command'         $traversal { param($r) "line $($r.Line)  $($r.Tool)  …$($r.Context)…" }
Section 'C. what those calls printed back'                   $shown     { param($r) "line $($r.Line)  [$($r.Why)]  names: $($r.Named)`n      …$($r.Context)…" }
Section 'D. URLs fetched'                                    $urls      { param($r) "line $($r.Line)  $($r.Tool)  $($r.Url)" }

# A and B are the reaches. C is their payload and is not added in — counting it would double every
# hit that produced output. The payload's own severity is reported separately, because "it looked up
# and saw nothing of ours" and "it looked up and the listing named the repository" are the two
# different verdicts this whole script exists to tell apart.
$reaches = @($outside).Count + @($traversal).Count
$sawOurs = @($shown | Where-Object { $_.Named -notlike '(named*' }).Count

if ($reaches) {
    "VERDICT: $reaches reach(es) outside the run folder; $sawOurs of the results named something of ours."
    if ($sawOurs) {
        "         Those are in section C. A hire that saw the criteria invalidates the run; one that"
        "         saw only folder names is a finding to weigh and write up."
    } else {
        "         Nothing printed back named this repository or a sibling of the runs root, so the"
        "         reaches are recorded but there is no evidence the hire was shown anything of ours."
    }
    "         Section D is not counted: fetching is the job, and whether the playbook pointed at each"
    "         URL can only be answered by a person reading §0–§5."
    exit 1
}

"VERDICT: no reach outside the run folder, its mirror or the scratch directory."
"Section D's $(@($urls).Count) URL(s) still need checking against the playbook's own pointers by hand."
exit 0
