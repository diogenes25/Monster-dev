# `#002` — The §4 plan step costs roughly a third more model turns, and the rise is in the build

| | |
|---|---|
| Status | `rejected` |
| Gate | `run` |
| Attribution | playbook gap |
| Criterion | cost envelope, not a numbered criterion |
| Target file | `MONSTER-DEV.md` §4 / §6 |
| Evidence | `2026-08-01-plan-sonnet`, `2026-08-01-index-sonnet` (against `2026-08-01-sonnet-base2`) |
| Blocked on | nothing. Both blockers cleared `2026-08-03` — `build-dist.ps1 -Variant` exists with `process/variants/002-arm-b.psd1` as arm B, and `#034` is `proven` |
| Proof design | A/B with cost, two Sonnet arms on `alt-a-left-to-right`, mirror both sides — **arm A `2026-08-03-r15`** (playbook as it stands), **arm B `2026-08-03-r14`** (the §6 bound). `2026-08-03-r13` was arm A's first attempt and produced no data: the hire refused the entry point, see `#050` |
| Result | **`rejected` `2026-08-03`** — arm B cost +20 % model turns and lost half a mark on `18a`. Report: `process/runs/2026-08-03-r14/report.md` |

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
- `2026-08-03` — **this item is the only one in `grilled` and it cannot be run.** Found while
  picking it up as the next brief. Arm B adds a paragraph inside `MONSTER-DEV.md` §6;
  `build-dist.ps1` takes `-Without` and nothing else, so it can drop a whole file and cannot
  change one. The harness already knows this and says so in two places —
  `build-dist.ps1:56` and `SKILL.md:235`, the latter in as many words: *"until that lands, an A/B
  below file level cannot be built honestly, and saying so beats faking it."*

  So the mechanism is a **named, documented, unbuilt dependency of the only runnable item on the
  board**, and it had no item of its own. That is the finding, not the missing tool: `grilled`
  means *eligible as a brief*, and this one has been eligible since `2026-08-02` while being
  impossible to build. The state rule the board enforces does not reach a blocker that lives in
  the tooling.

  Not worked around. Hand-editing `MONSTER-DEV.md`, building arm B and reverting would produce
  the right two mirrors and leave nothing saying what the difference was — which is the same
  shape as the hand-rolled mirror `CLAUDE.md` forbids, and this item's whole value is that the
  two arms differ by exactly one paragraph.
- `2026-08-03` — a second precondition, cheaper and unrelated: `#034` sits in `hire.ps1`'s
  per-turn capture block, so it is in the path of every turn of this run. A scrub failure would
  take the worktree copy and `base.txt` with it, and the worktree is what criterion 18a–18d is
  read against. Worth clearing before a paid two-arm run rather than after.
- `2026-08-03` — **the overlay blocker is cleared.** `build-dist.ps1 -Variant <name>` applies
  `process/variants/<name>.psd1` to the mirror after the copy and before every check, and
  `002-arm-b.psd1` is this item's arm B: one anchored insertion into `MONSTER-DEV.md` §6, the
  paragraph quoted verbatim out of *Proposed change* above so the arm and its rationale cannot
  drift apart.

  The anchor is **not** the sentence this item names. *"Match the surrounding code's naming,
  formatting, and structure conventions"* continues — *"— this should look like it was written by
  whoever else works on this codebase, not bolted on."* — so anchoring there would have inserted a
  paragraph into the middle of a sentence. It anchors on the paragraph's end instead, which puts
  the text where the item intends it. Verified by building the arm and reading §6 in the mirror:
  the new paragraph sits between §6 and §7, one occurrence, 18 files, index OK.

  An anchor must match **exactly once**; zero and two are both hard failures, because either one
  still produces a mirror, a run and a number that nobody can state the meaning of. All four
  failure paths have a fixture in `process/variants/` and were made to fire.

  What is *not* cleared: this item is still `grilled` and not `in-proof`, `#034` is still in the
  capture path, and no run id is assigned. What changed is that arm B can now be built by a
  command instead of by hand-editing the playbook and remembering to revert it.

  Filed as `#039`, which is about the part that is not this item's: the mechanism was described as
  future work in two documents, blocked the only run-eligible item on the board for a day, and had
  no item of its own — `board.ps1` validates item *state* and cannot see a blocker living in the
  tooling.
- `2026-08-03` `in-proof` — **both preconditions cleared, run ids assigned: arm A `2026-08-03-r13`,
  arm B `2026-08-03-r14`.** `#034` reached `proven` (a scrub failure no longer takes the worktree copy
  and `base.txt` with it, which was the reason not to spend a two-arm run through that capture path),
  and `-Variant` landed the same day.

  **Neither id carries an arm letter, and that is deliberate.** `2026-08-03-r12` found that a run id
  is part of the mirror surface: the hire's working directory *is* the run folder and turn 1 is handed
  an absolute path through it, so anything the id says is in the hire's own prompt and in the output
  of its first `pwd`. `r13a`/`r13b` would have told both hires that a second arm exists — i.e. that
  this is a comparison — which is the one thing neither may know. Two consecutive neutral ids say
  nothing, and the mapping lives here.
- `2026-08-03` `rejected` — **arm B cost more turns, not fewer.** Report:
  `process/runs/2026-08-03-r14/report.md`.

  | | `sonnet-base2` | `plan-sonnet` | `index-sonnet` | **arm A** `r15` | **arm B** `r14` |
  |---|---|---|---|---|---|
  | turn 1, the plan | 12 | 11 | 14 | **12** | **15** |
  | turn 2, the build | 19 | 30 | 28 | **38** | **45** |
  | total | 31 | 41 | 42 | **50** | **60** |
  | cost | $1.66 | $1.84 | $2.32 | **$2.3180** | **$2.3359** |

  **+20 % model turns, +0.8 % cost** — more turns, individually cheaper. The build turn went 38 → 45,
  the direction this item needed it not to go. And section E, the mark set the whole plan step exists
  for, went *backwards*: `18a` pass → partial, both readings independent and blind. Every other
  criterion is identical in the two arms, including every figure the verifier produced.

  This is **outcome 2 of the two named above**, and the paragraph naming it was written before the run:
  *"Turns do not drop → the ten turns were verification of the announced set. Then the plan step costs
  a third more turns because it works, arm B is rejected, and the +25 % ceiling is the wrong instrument
  for a step that changes what a hire does rather than how much."* That sentence is now the finding
  rather than a hypothesis, and it settles what this item asked without a further run.

  **The mechanism is confirmed and the remedy is refuted, and those are the same fact.** Both hires
  verified their own work with a headless Playwright check outside the project — which §9 tells them to
  do and which arm B's own last sentence permits in as many words (*"Checking that what you built works
  is part of building it, not something extra"*). So arm B bounded scope creep, there was none, and it
  added the cost of a hire re-reading a bound it then had to satisfy. The section *"What the arms
  actually separate"* above predicted exactly this and it should be read as the item's best work rather
  than as a near miss.

  **The sentence stays on file and must not be redrafted.** A `Gate: run` item that is rejected is the
  only defence against having the idea again, and this idea is unusually re-inventable: *"tell the hire
  to build only what it announced"* reads like free money every time. It costs 20 %.

  Three things this run establishes beyond the item's own question:

  - **The +25 % soft ceiling is the wrong instrument for §4 and should be retired for this step.** It
    was written for changes that make a hire do the same work differently. The plan step makes it do
    different work, and the extra turns are the work. Not filed as an item because the ceiling is not
    written down anywhere as a rule — it lives in this item's prose — so retiring it means this
    paragraph, which is now written.
  - **This item's stated floor was already invalid.** *"`sonnet-base2`'s 19/31 is the floor to read
    against, not a third arm to re-run"* — but `process/fixtures/static-site/README.md` and
    `tools/project.md` both changed on `2026-08-02` in `ac2808b`, after every baseline run, and `#015`
    removed the *"Expected Monster-Dev behavior"* heading those hires read. `19`, `28` and `30` were
    measured against a target and a mirror that no longer exist. **Arm A is the honest baseline at 38
    build turns**, which is above every historical figure — so the drift the two arms were built to
    control for was real and larger than the effect being chased.
  - **What the run cannot say**, stated because the verdict does not need it and a reader will look for
    it: whether +20 % is the treatment or the day. One arm each, one fixture, and this series has no
    repeat measurement of a single arm to quote a spread from. The verdict rests on the sign, which is
    the opposite of what arm B needed, not on the size.

  Six items came out of the two arms besides this answer: `#049` (an A/B cannot have both arms on disk),
  `#050` (a hire refused the entry point outright), `#051` (`13b` contradicts §8), `#052` (the
  reduced-motion instrument), `#053` (**criterion `10` passes a verbatim copy of the reference** — found
  by arm B's blind pass, and worth more than this item's own result), `#054`/`#055` (fixture and
  documentation). `#026` and `#048` each gained an evidence line.
