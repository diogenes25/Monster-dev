<#
.SYNOPSIS
Sweeps every process/runs/*/hire.json and checks that `totals` agrees with `turns[]`, and that each
run's report quotes its own recorded cost.

.DESCRIPTION
Nothing compared these two until 2026-08-04, and three defects had accumulated in the gap — all
three on the same object, all three found by a reader doing the arithmetic by hand:

  #077  permissionDenials cast an ARRAY to [int], so it read 0 for every run ever. Two runs on
        record had a denial each, and one report wrote "no permission denials" off the total.
  #074  the per-turn summary printed the RUN totals under per-turn labels, so a report written by
        adding up the console lines counted turn 1 twice. Both #002 arms are wrong in every
        document that quotes them, by exactly turn 1's own figures.
  #063  total_cost_usd is priced at Anthropic rates for a local endpoint, and nothing on disk said
        which endpoint a run used.

All three are fixed in hire.ps1. This script is what stops the next one lasting fourteen runs.

`hire.ps1` computes `totals` FROM `turns[]`, so section A is not a self-check of its arithmetic in
the ordinary sense — it is a check of the *recomputation*, done here in a different expression than
the one that wrote the file. That is exactly what catches a cast: `[int]$array` and
`@($array).Count` disagree, and only a second opinion can say so. It also checks records written by
earlier versions of hire.ps1, which is where the two hidden denials actually were.

Section B is the one that would have caught #074 on the day. A report that quotes a cost figure but
never its own recorded total was written from the console rather than from the record — which is the
whole failure #074 describes, one layer up from the tooling.

Read-only. Touches nothing, and reports rather than throws on a mismatch, because most of what it
finds will be history rather than a live bug.

.PARAMETER RunId
Check one run instead of sweeping all of them.

.EXAMPLE
.\process\tools\check-hire-records.ps1

.EXAMPLE
.\process\tools\check-hire-records.ps1 -RunId 2026-08-04-r20
#>
[CmdletBinding()]
param(
    [string]$RunId
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path 'START.md')) {
    throw "Run this from the repository root — START.md is not here."
}

$pattern = if ($RunId) { "process\runs\$RunId\hire.json" } else { 'process\runs\*\hire.json' }
$records = @(Get-ChildItem $pattern -ErrorAction SilentlyContinue | Sort-Object FullName)

if (-not $records) { throw "no hire.json found for '$pattern'." }

$problems = @()

foreach ($f in $records) {
    $run = Split-Path (Split-Path $f.FullName -Parent) -Leaf
    $h   = Get-Content $f.FullName -Raw | ConvertFrom-Json
    $turns = @($h.turns)

    # --- A: totals against the envelopes they were summed from ---------------------------------
    #
    # Recomputed here rather than trusted. Cost is compared at the rounding hire.ps1 applies.
    $expect = [ordered]@{
        total_cost_usd    = [math]::Round(($turns | Measure-Object -Property { $_.envelope.total_cost_usd } -Sum).Sum, 4)
        num_turns         = ($turns | Measure-Object -Property { $_.envelope.num_turns } -Sum).Sum
        cliTurns          = $turns.Count
        permissionDenials = ($turns | ForEach-Object { @($_.envelope.permission_denials).Count } |
                             Measure-Object -Sum).Sum
    }

    foreach ($k in $expect.Keys) {
        $got  = $h.totals.$k
        $want = $expect[$k]
        if ($null -eq $want) { $want = 0 }
        if ($null -eq $got)  { $got  = 0 }
        if ([math]::Abs([double]$got - [double]$want) -gt 0.00005) {
            $problems += "A  $run — totals.$k is $got, envelopes sum to $want"
        }
    }

    # The tool names, when there were denials at all. A count with no names cannot answer the only
    # question a denial raises, which is whether the fence was too tight.
    $tools = @($turns | ForEach-Object { $_.envelope.permission_denials } |
               ForEach-Object { $_.tool_name } | Select-Object -Unique)
    if ($tools -and -not $h.totals.permissionDenialTools) {
        $problems += "A  $run — $($tools.Count) denial tool(s) in the envelopes ($($tools -join ', ')), none in totals"
    }

    # --- B: does the report quote this run's own cost? -----------------------------------------
    #
    # Narrow on purpose. A report legitimately quotes OTHER runs' figures and its own forecast, so
    # "every dollar figure must match" would fire on correct prose — and CLAUDE.md's rule about the
    # vocabulary list applies here too: a check that fires on legitimate text gets narrowed, never
    # accommodated by rewording the prose. What is checked is only that the run's own total appears
    # somewhere. That is the #074 signature exactly: r14 and r15 quote $2.3359 and $2.3180, and
    # neither figure is anywhere in its own hire.json.
    $reportPath = Join-Path (Split-Path $f.FullName -Parent) 'report.md'
    if (Test-Path $reportPath) {
        $report = Get-Content $reportPath -Raw
        $cost   = $h.totals.total_cost_usd
        if ($cost -and $report -match '\$\s?\d+\.\d{2}') {
            # Both the stored rounding and the 2-decimal form a report may legitimately use.
            #
            # INVARIANT CULTURE, and the first draft of this check did not use it: on a de-DE host
            # `'{0:0.0000}' -f 1.9517` is "1,9517", which matches no report ever written, so section
            # B fired on nine of fourteen runs including the three #074 names as correct. It failed
            # loudly rather than silently, which is the only reason it was a five-minute bug — but it
            # is the same family as the four instruments this project has caught confirming an
            # expectation, and a formatted number is where that keeps happening.
            $inv   = [cultureinfo]::InvariantCulture
            $forms = @(
                ([double]$cost).ToString('0.0000', $inv),
                ([double]$cost).ToString('0.00',   $inv)
            )
            if (-not ($forms | Where-Object { $report.Contains($_) })) {
                $problems += "B  $run — report.md quotes a cost but not its own total ($cost); written from the console?"
            }
        }
    }

    $localNote = if ($h.local) { '  LOCAL' } elseif ($null -eq $h.PSObject.Properties['local']) { '  (pre-#063 record)' } else { '' }
    # Invariant, so the figure printed here is the figure a report quotes. See section B.
    $costStr = ([double]$h.totals.total_cost_usd).ToString('0.0000', [cultureinfo]::InvariantCulture)
    "  {0,-24} {1,2} cli turn(s)  `${2,-9} {3,3} model turns  {4} denial(s){5}" -f
        $run, $turns.Count, $costStr, $h.totals.num_turns, $expect['permissionDenials'], $localNote
}

""
if ($problems) {
    $problems | Sort-Object | ForEach-Object { "  $_" }
    ""
    "$($problems.Count) disagreement(s) across $($records.Count) record(s) — A: totals vs envelopes, B: report vs record."
    "Not a throw. Most of what this finds is history; see #074 and #077 for which instances are known."
} else {
    "records OK — $($records.Count) record(s), totals agree with envelopes and every report quotes its own cost."
}
