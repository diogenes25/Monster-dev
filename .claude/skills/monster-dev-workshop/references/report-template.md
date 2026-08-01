# Report template

**One file per run**, under `test/runs/`, never inside the target project. Everything a run turns
up *besides its own result* goes on the board — `test/backlog/`, one file per problem, shaped by
`test/backlog/TEMPLATE.md`. The report says what this run measured; the board carries what is
still open. A proposal therefore exists in exactly one place instead of being restated per run
and going stale in one of them.

There is no `<run-id>.findings.md`. The two on disk are historical records of runs scored before
the board existed, and everything still open in them is on the board.

---

## `test/runs/<run-id>.report.md`

# Run `<run-id>` — `<scenario slug>`

| | |
|---|---|
| Date | `<yyyy-mm-dd>` |
| Scenario | `test/scenarios/<slug>.md` |
| Fixture | `test/sample-<name>/` |
| Run folder | `../monster-dev-testruns/<run-id>/` |
| Playbook revision | `<git rev-parse --short HEAD>` |
| Hire | `claude -p` session `<session_id>`, `<n>` turns |

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

## Harness notes

*Anything that went wrong on the measurement side: permission denials that were widened and
rerun, tools that misbehaved, evidence that could not be collected. These are not product
findings.*

## Deferred

*Standing entry until the repo is pushed: §0 base-URL derivation, §5 WebFetch/curl split.
Plus anything else this scenario could not reach.*

## Board

*Which items were touched, and how. One line each — the reasoning belongs in the item file, not
here, or it goes stale in whichever copy is read second.*

- `#<nnn>` — new at `intake` / another evidence line / `proven` / `rejected`, and in one clause why.
