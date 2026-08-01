# Report + findings templates

Two files per run, both under `test/runs/`, never inside the target project.

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

---

## `test/runs/<run-id>.findings.md`

# Findings from run `<run-id>` — proposed, not applied

*Applying a finding in the same pass that produced it destroys the ability to tell whether the
next run improved because of the change or because of run-to-run variance. Propose here, apply
deliberately, then rerun the same scenario unchanged.*

## F1 — <one-line summary>

| | |
|---|---|
| Criterion | `<n>` |
| Attribution | playbook gap / implementation error / harness artefact |
| Target file | `START.md` / `MONSTER-DEV.md` §`<n>` / harness |
| Confidence | one run / reproduced across `<n>` runs |

**What the agent did.** *Behaviour, with evidence.*

**Why the playbook allowed it.** *The specific sentence — quoted — that was ambiguous, missing,
or too easy to skip. If no sentence is at fault, this is probably not a playbook gap.*

**Proposed change.**

> *Exact replacement wording, ready to paste. Not a description of a change.*

**Cost.** *What this addition costs: length in `START.md` (expensive — it must stay short), an
extra onboarding question (§4 is meant to be one short round), or a new rule that could
conflict with an existing one. A finding with no stated cost has not been thought through.*
