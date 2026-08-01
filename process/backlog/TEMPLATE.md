# `#<nnn>` — <one line, the problem and not the fix>

| | |
|---|---|
| Status | `intake` / `formulated` / `grilled` / `in-proof` / `proven` / `rejected` |
| Gate | `run` / `none` |
| Attribution | playbook gap / model disposition / implementation error / harness artefact / scenario defect |
| Criterion | `<n>` or — |
| Target file | `MONSTER-DEV.md` §`<n>` / `process/scenarios/<slug>.md` / harness / — |
| Evidence | `<run-id>` (add a run id per sighting, never a second item) |
| Proof design | run id once assigned, or — |

**What happened.** *Behaviour with evidence: a measured value, a command output, a quote from the
transcript. Never "looks wrong".*

**Why the current wording allows it.** *The specific sentence — quoted — that was ambiguous,
missing, or too easy to skip. If no sentence is at fault, this is probably not a playbook gap, and
the attribution above should say so.*

**Proposed change.**

> *Exact replacement wording, ready to paste. Not a description of a change.*

**Proof design.** *`Gate: run` only. Which gate from `CLAUDE.md` (regression / A-B / A-B with cost);
which criterion flips and whether it has a before-fail on record; which model reproduces the fault
and why that one; which arms, and what is held constant. An item cannot reach `grilled` without
this, because the alternative is spending a run to find out it had nothing to measure.*

**Cost.** *What the change costs: length in `START.md` (expensive — it has to stay short), another
onboarding question (§4 is one short round), a rule that could collide with an existing one, or
comparability with earlier runs. An item with no stated cost has not been thought through.*

**Log.**

- `<yyyy-mm-dd>` `intake` — from `<run-id>`.
