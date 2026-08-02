# `#002` — The §4 plan step costs roughly a third more model turns, and the rise is in the build

| | |
|---|---|
| Status | `grilled` |
| Gate | `run` |
| Attribution | playbook gap |
| Criterion | cost envelope, not a numbered criterion |
| Target file | `MONSTER-DEV.md` §4 / §6 |
| Evidence | `2026-08-01-plan-sonnet`, `2026-08-01-index-sonnet` (against `2026-08-01-sonnet-base2`) |
| Proof design | A/B with cost, two Sonnet arms on `alt-a-left-to-right`, mirror both sides — run id to be assigned |

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

**Proposed change.** Nothing is applied. What follows is **arm B's treatment**, written to be
tested and not to be merged: the gate for the plan step was regression, nothing regressed —
18a/18c/18d flipped and hold at 4/4 across two independent Sonnet runs — so §4 stays as it is
unless a run says otherwise.

Added to §6, after *"Match the surrounding code's naming, formatting, and structure conventions"*:

> The change set you named in step 4 is the scope of this step. Build that, and stop. If building
> it shows the set was wrong, say so and change it — but don't widen it quietly, and don't add
> hardening, refactors or fixes to things you happened to open. Checking that what you built works
> is part of building it, not something extra.

The last sentence is the load-bearing one and it is there to make the run *interpretable*, not to
soften the first three. §6 is read by every hire on every job, and a bound on the build that reads
as *do less checking* would regress the four marks to save turns.

**What the arms actually separate.** The mechanism named above — a hire that committed to a change
set in public then goes and verifies it — is **not** the mechanism this treatment bounds.
`index-sonnet` spent part of its build turn finding and fixing a real bug in its own work, which is
*inside* the announced change set and which arm B explicitly permits. That is deliberate, and it is
what makes the run worth spending:

- **Turns drop toward 19** → the ten turns were scope creep, and a sentence buys them back.
- **Turns do not drop** → the ten turns were verification of the announced set. Then the plan step
  costs a third more turns *because it works*, arm B is rejected, and the +25 % ceiling is the wrong
  instrument for a step that changes what a hire does rather than how much.

Both outcomes settle the open question. Neither is a failure of this item.

**Proof design.** A/B with cost, both arms Sonnet on `alt-a-left-to-right`, mirror on both sides
so the fetch path is held constant. Arm A carries §4 and §6 as they stand; arm B adds the paragraph
above. What must move is the build turn count, 28–30 → nearer 19; what may not regress is 18a–18d,
which is the only reason the plan step is in the playbook. The bar model is the right model here
because the overrun is measured on it — and `sonnet-base2`'s 19/31 is the floor to read against,
not a third arm to re-run.

**One confound to hold, and it is new since this item was written.** `#026` shows the answer script
routes both arms to the sheet `index.html` uses, and `#015` shows six of ten transcripts held the
fixture README. Neither damages *this* comparison, because both arms carry the same contamination
and the measurement is turns — but the run must not be scored against the ten on record for anything
except turns and cost.

**Cost.** A sentence in §6 that bounds the build is a sentence that can be read as *do less
checking* — the opposite of what the plan step bought. Getting that balance wrong regresses the
four marks to save turns, which is the wrong trade at these prices.

**Log.**

- `2026-08-01` `intake` — from `2026-08-01-plan-sonnet` as F2, one sample per arm, explicitly not
  yet a finding.
- `2026-08-01` `formulated` — reproduced by `2026-08-01-index-sonnet` at 42 turns. Both of F2's
  hedges fail on that data and the `plan-sonnet` report has been corrected: turn 1 is **flat**,
  not 39 % cheaper — 11 and 14 turns at $0.37 and $0.59 against 12 at $0.61.
- `2026-08-02` `grilled` — answer **E4**: arm B written, so the treatment exists and this item is no
  longer *"an A/B whose treatment is 'some sentence'"*. Writing it surfaced something the item had
  not noticed: the mechanism it hypothesises — verifying the announced set — is one arm B permits,
  so the treatment does not target it. Rather than reword the treatment, both outcomes are now
  named in advance; the run settles the question either way. Being `grilled` makes this eligible as
  a run brief, not scheduled — **D4** leaves it unscheduled.
- `2026-08-02` — **E4** also settled that §6 is edited **once**, by whoever holds both this
  intention and `#004`'s. The two pull opposite ways: this one bounds what a hire does, `#004`
  widens what it discloses. `#004` is waiting on a second sighting and its sentence is drafted
  there so neither has to be written twice.
