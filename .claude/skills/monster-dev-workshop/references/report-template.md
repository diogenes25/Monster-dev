# Report template

**One folder per run**, `process/runs/<run-id>/`, never inside the target project. The report is
`report.md` inside it, beside the measurements, the envelope and the blind second scoring. Everything a run turns
up *besides its own result* goes on the board — `process/backlog/`, one file per problem, shaped by
`process/backlog/TEMPLATE.md`. The report says what this run measured; the board carries what is
still open. A proposal therefore exists in exactly one place instead of being restated per run
and going stale in one of them.

There is no `findings.md` any more. The two on disk are historical records of runs scored before
the board existed, and everything still open in them is on the board.

---

## `process/runs/<run-id>/report.md`

# Run `<run-id>` — `<scenario slug>`

| | |
|---|---|
| Date | `<yyyy-mm-dd>` |
| Scenario | `process/scenarios/<slug>.md` |
| Fixture | `process/fixtures/<name>/` |
| Run folder | `../monster-dev-testruns/<run-id>/target/` |
| Playbook revision | `<git rev-parse --short HEAD>` |
| Hire | `claude -p` session `<session_id>`, `<n>` turns |
| Entry point | accepted without objection / **refused** — see `#050` |

*The `Entry point` row is not bookkeeping. `2026-08-03-r13` refused `START.md` as a prompt-injection
and supply-chain risk and produced no data, while `2026-08-03-r15` accepted it on a byte-identical
mirror in the same hour — so this is within-tier variance at a base rate of roughly one in twelve.
`#050`'s honest proof needs several arms per side and is the most expensive item on the board; one line
per report accumulates the rate as a by-product instead. State it even when nothing happened, for the
same reason the Reach section is stated when it found nothing.*

## Verdict

*Two or three sentences. What the run was trying to find out, and what it found. Then the
counts: passed / qualified / failed / deferred.*

## Criteria

*One row per numbered criterion from the scenario. `Evidence` is a command output, a measured
value, or a file:line — never "looks right".*

| # | Criterion | Result | Evidence | Attribution |
|---|---|---|---|---|
| 1 | | pass / qualified / fail / deferred | | — / playbook gap / implementation error / harness artefact |

*Qualified passes and every failure get a paragraph below the table. A pass needs no prose.*

### <n> — <criterion>

*What happened, what the evidence was, and — for a failure — why it is attributed the way it
is. For split criteria (asked vs. built), state both halves explicitly; never collapse them.*

## Reach

*What `check-reach.ps1` found, stated even when it found nothing — a section left out and a section
saying "no reach" read identically, and only one of them means the transcript was read. Give the
counts per section, and for any hit in A or B say what its paired result in C actually showed. `#041`
is why this exists: the runs root is a sibling of the working copy and the location was not changed,
so this measurement is the control that stands in for the move. Section D's URLs get checked against
the playbook's own pointers by hand — the script cannot do that half.*

- A/B/C/D: `<n>` / `<n>` / `<n>` / `<n>`. `<one clause on what, if anything, the hire was shown.>`

## Harness notes

*Anything that went wrong on the measurement side: permission denials that were widened and
rerun, tools that misbehaved, evidence that could not be collected. These are not product
findings.*

## Deferred

*Anything this scenario could not reach. There is no standing entry — §0 and §5 were proven by
`2026-08-01-live` and are not deferred; a mirror run simply does not exercise them.*

## Board

*Which items were touched, and how. One line each — the reasoning belongs in the item file, not
here, or it goes stale in whichever copy is read second.*

- `#<nnn>` — new at `intake` / another evidence line / `proven` / `rejected`, and in one clause why.
