# `#002` — The §4 plan step costs roughly a third more model turns, and the rise is in the build

| | |
|---|---|
| Status | `formulated` |
| Gate | `run` |
| Attribution | playbook gap |
| Criterion | cost envelope, not a numbered criterion |
| Target file | `MONSTER-DEV.md` §4 / §6 |
| Evidence | `2026-08-01-plan-sonnet`, `2026-08-01-index-sonnet` (against `2026-08-01-sonnet-base2`) |
| Proof design | — |

**What happened.** Model turns on the bar model, before the plan step and after it:

| | `sonnet-base2` | `plan-sonnet` | `index-sonnet` |
|---|---|---|---|
| total | **31** | 41 | **42** |
| turn 1, the plan | 12 | 11 | 14 |
| turn 2, the build | **19** | 30 | 28 |
| cost | $1.66 | $1.84 | $2.32 |

Over the +25 % soft ceiling, twice, on two consecutive Sonnet runs. `index-sonnet` also settles
what `plan-sonnet` could not: the `+§2 table` arm cannot plausibly cost anything and moved the
total by one turn, so the ~10-turn rise tracks the §4 change rather than the day.

**Why the current wording allows it.** Nothing in §4 or §6 bounds the build once a change set has
been announced. A plausible mechanism is that a hire which committed to a change set in public
then goes and verifies it — `index-sonnet` spent part of that budget finding and fixing a real
bug in its own work, an unnecessary `requestAnimationFrame` hop that delayed the start. That is a
mechanism, not a measurement.

**Proposed change.** None yet, deliberately. The gate for the plan step was **regression**, and
nothing regressed: 18a/18c/18d flipped and hold at 4/4 across two independent Sonnet runs. The
open question is whether the extra ten turns buy anything beyond the four marks, and no arm on
record separates *verifying the announced change set* from *doing more work in general*.

**Proof design.** A/B with cost, both arms Sonnet on `alt-a-left-to-right`, mirror on both sides
so the fetch path is held constant. Arm A carries §4 as it stands; arm B adds a sentence bounding
the build to the announced change set. What must flip is the build turn count, 28–30 → nearer 19;
what may not regress is 18a–18d, which is the only reason the plan step is in the playbook. The
bar model is also the right model here, because the overrun is measured on it. **Not yet
grilled**: the arm-B wording does not exist, and an A/B whose treatment is "some sentence" has no
proof design.

**Cost.** A sentence in §6 that bounds the build is a sentence that can be read as *do less
checking* — the opposite of what the plan step bought. Getting that balance wrong regresses the
four marks to save turns, which is the wrong trade at these prices.

**Log.**

- `2026-08-01` `intake` — from `2026-08-01-plan-sonnet` as F2, one sample per arm, explicitly not
  yet a finding.
- `2026-08-01` `formulated` — reproduced by `2026-08-01-index-sonnet` at 42 turns. Both of F2's
  hedges fail on that data and the `plan-sonnet` report has been corrected: turn 1 is **flat**,
  not 39 % cheaper — 11 and 14 turns at $0.37 and $0.59 against 12 at $0.61.
