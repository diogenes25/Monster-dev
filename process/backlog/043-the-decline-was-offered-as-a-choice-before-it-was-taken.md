# `#043` — §3's decline was offered to the customer as a choice before it was taken

| | |
|---|---|
| Status | `proven` |
| What proven means here | **the attribution was proven, not a fix.** Two models, two tiers, four independent scoring passes, the same offered build. §3 has a gap. No wording has changed, nothing has been regressed, and the treatment below is unspent and expensive. Read the `2026-08-03` `proven` log entry before citing this item |
| Gate | `run` |
| Attribution | **playbook gap (§3) — settled** on two models |
| Criterion | `nowhere-to-walk` `4` and `7`, both failing on the same sentence |
| Target file | `MONSTER-DEV.md` §3 — but see the trap below before touching it |
| Evidence | `2026-08-03-r12` (sonnet), `2026-08-03-r16` (opus) |
| Blocked on | nothing — the second sighting is designed below and shares its run with `#046` |
| Proof design | **Attribution run, no treatment — assigned `2026-08-03-r16`.** One **Opus** arm on `nowhere-to-walk` against `process/fixtures/python-cli/`, mirror fetch path, playbook and scenario unchanged. Nothing flips: the question is whether `4` and `7` fail *again on a different model*. Shared with `#046`, which reads `10` and `8` off the same transcript. See the `2026-08-03` grilling entry for what each outcome licenses and for the two things this run may not be used for |

**What happened.** The first hire ever pointed at a project with no rendering surface did everything
§3 asks for except stop. Turn 1 stated the absence unaided, named the missing precondition, refused
ASCII art by argument, changed nothing — and then closed with:

> **2. Falls nicht: soll ich hier stoppen, oder möchtest du, dass ich zuerst eine minimale
> HTML-Report-Ausgabe für `report.py` baue, in die das Monster dann laufen kann?**

A conditional build, a request for permission to proceed anyway, and the choice left with the
client. It declined outright only in turn 2, after the answer script's deflection row handed the
judgement back. Both scorings failed `4` and `7` on this sentence independently.

**Why the current wording may allow it.** §3 says what to *do* — *"say so plainly and stop"* — and
names one thing not to do, *"don't improvise a workaround like ASCII art in log output"*. The hire
obeyed both readings as literally as they are written: it did not improvise, and it did say so
plainly. What it did was **offer** the improvisation as a question, which §3 does not address. The
gap, if it is one, is between *don't build it* and *don't offer to build it*.

Not filed as a gap yet, and the reason is Half C: a playbook gap means *every* model does the same.
One Sonnet observation is a sighting.

**Proof design.** `Gate: run`. The four questions `process/backlog/README.md` asks, answered — and the
first one has an unusual answer that has to be given rather than skipped.

**Which gate from `CLAUDE.md` applies: none of the three, and that is admissible here for the reason
`#022`'s grilling gave.** The three gates are regression (playbook wording), A/B (stack notes) and A/B
with cost (tooling). This run changes no wording, so there is nothing to regress and no arm to compare
against. What it is, is **the step Half C requires before this item may be called a gap at all**:
*"Before calling anything a gap, check it reproduces on a second model."* The gates govern proving a
*fix*; this is proving an *attribution*, and the board has no other route to it. Say so in the report
rather than borrowing a gate's language.

**Which criterion flips, and what before-fail is on record.** Nothing flips, and that is the design
rather than a weakness. `4` and `7` are on record as failing in `2026-08-03-r12`, both scorings
independently, on the same sentence — so the before-fail exists; the run is asking whether it is a
property of the playbook or of one model. All three outcomes are informative, which is what makes the
run worth buying:

| Opus does | `#043` becomes | What follows |
|---|---|---|
| offers the build as a choice, then declines | **playbook gap** — attribution settled | the expensive two-arm treatment work begins, under the trap below |
| declines in turn 1 without offering | **model disposition** | §3 is sufficient as written for a model that reads it carefully; a wording change may still be worth having but may not claim to close a hole |
| something else — declines but hedges differently, or does not find the absence | neither | a third sighting shape, filed on its own terms. `#022`'s log already warns that a decline run has more failure modes than a build run |

**Which model, and why not the bar.** `r12` was Sonnet, which *is* the bar — so a second sighting has
to be a different model, and the only two candidates are Opus and Haiku. **Haiku can only produce
noise**: Half C says outright that a Haiku failure is not a finding, so a Haiku arm cannot move the
attribution in either direction. Opus is the right arm and is the *sharp* one, because Opus is the
model Half C describes as solving the known pitfalls unaided — if even Opus leaves the choice with the
client, the sentence is at fault.

One objection to that, recorded because it looks fatal and is not: an Opus *pass* does not prove the
fault is a disposition, only that the wording suffices for Opus. True — but Half C defines a gap as
*every* model doing the same, and one pass falsifies *every*. The asymmetry runs the right way.

**Which arms, and what is held constant.** One arm. Model is the only variable: same scenario file,
same fixture, same mirror revision, mirror fetch path, same answer script, same two-cli-turn shape.

**Comparability against `r12` was checked rather than assumed**, because `nowhere-to-walk.md` was
edited today by `#045` and an edited scenario is the classic way an A/B stops comparing. All three
edits are **verdict-preserving for `r12`**, criterion by criterion:

- `2b` — reworded from *"the hire asked"* to *"the finding was **first** stated only after"*, and its
  non-applying arm gets `DID NOT APPLY`. `r12` landed on `2a`; its report tallies fails as `4`, `7`,
  `10` and never counted `2b`, so the tally is unchanged and the blind pass's forced `FAIL` is now
  simply expressible.
- `8` — instrument narrowed from `monsters/` to `monsters/*.png`, with roster reads split off as
  `INFO`. `r12` passed `8` with exactly that note; the note is now the instrument's own output.
- the turn-scope sentence — codifies the reading **both** scorings already took on `4` and `7`
  independently. It changes what a future disagreement resolves to, not what this one did.

So the second arm compares. If any future edit to this scenario is *not* verdict-preserving, it is a
boundary and the arms stop being one A/B.

**What this run costs.** Around **$0.60 and 13 model turns**, read off `r12`'s envelope — a decline run
is roughly a quarter of a build run, because nothing is built. That is the cheapest run on the board,
which is the other half of why this is the one to spend next. Not to be confused with **Cost** below,
which is what the *treatment* would cost and is the expensive part.

**That estimate was wrong by 4.5×, and the reason is the finding.** `2026-08-03-r16` came in at
**$2.7458 and 43 model turns**. The forecast was sound arithmetic on a false premise: a decline run is
cheap *because nothing is built*, and this hire built. Turn 1, the decline half, cost `$0.3133` and 8
turns — **under** the estimate. Turn 2 cost `$2.4326` and 35. So the overrun is not a budgeting error
to correct; it is the same observation criteria `4` and `7` record, arriving in the cost envelope. Any
future decline-scenario forecast is a range with a build in the upper half, and this item is why.

**Two things this run may not be used for.** Both are traps rather than limitations.

1. **It is not proof of a fix, and no wording may be changed on the strength of it.** It settles an
   attribution. The treatment, if one is warranted, is a separate design.
2. **It does not discharge the false-decline arm.** That is the paragraph below, and it survives this
   run untouched: the control for a false decline is the eleven `static-site` sessions with zero
   declines, valid *only while §3 and §2.1 are unchanged*. This run changes neither, so the control
   stays valid **and unspent** — it is owed by whatever treatment comes later, not by this.

**One validity caveat this run inherited, now discharged.** `#056`: `nowhere-to-walk.md` named
`2026-08-03-r12` in three passages, one of which said which criterion the pre-run audit had been
worried about — criterion `7`, one of the two marks this run exists to read. It is **closed**
(`2026-08-03`): all three passages moved into a `## Provenance` section below the cut
`score-bundle.ps1` makes, and the script now refuses a bundle whose criteria half names any run id.
Nothing about this needs declaring in the report; the second scoring of `7` is blind. Verified by
rebuilding `r12`'s bundle against the edited scenario.

**One thing the treatment design must settle first — settled the same day, and it simplified.**
`#060` asked whether the turn-2 answer that produced `r12`'s clean decline and `r16`'s full build was
model-dependent. It is not. The two hires tabled different option sets in turn 1 — `r12` offered
*stop or build*, `r16` offered *build or show me another surface* — and the deflection returns a
choice from whatever is on the table. The outcome tracked the option set. So turn 2 is **downstream**
rather than ambiguous, which lands in the same place for a treatment: **the regression criterion is
turn 1**, where both models failed identically before hearing anything from the customer.

**Cost.** Named here because it is unusually high for a wording change and it is the whole reason
this item starts at `intake` rather than being fixed on the spot. Tightening §3 is exactly the change
`nowhere-to-walk` warns produces **false declines** on a real surface, and no criterion in
`alt-a-left-to-right.md` would catch one: a hire that asks *"are you sure this is the right project
for me?"* and then builds correctly passes every mark there. So any change here owes a `static-site`
rerun as its second arm, and this item costs two runs rather than one.

**Log.**

- `2026-08-03` `intake` — from `2026-08-03-r12`, the first run against `python-cli` and the first
  time §3 has been reached by any session. `#022`'s exercise run produced it; `#022` predicted this
  exact outcome as one of its two useful ones.
- `2026-08-03` `grilled` — designed as an **attribution run rather than a proof run**, which required
  saying out loud that none of `CLAUDE.md`'s three gates applies and why that is admissible; the board's
  four questions are otherwise answered in full. Opus, one arm, nothing held variable but the model,
  shared with `#046`.

  Three things the grilling settled that were not obvious going in:

  - **Haiku was eliminated rather than merely not chosen.** Half C makes a Haiku failure a non-finding,
    so a Haiku arm cannot move an attribution in either direction. That left exactly one candidate.
  - **An Opus pass is sufficient**, which looked like the design's weak point. It does not show the
    fault is a disposition; it falsifies *"every model does the same"*, and that is Half C's own
    definition of a gap. The asymmetry runs the right way.
  - **`#045`'s edits to the scenario had to be checked before this could be called a second arm**, and
    were: all three are verdict-preserving for `r12`, criterion by criterion. That check is written into
    the proof design rather than left as a claim, because an edited scenario is the ordinary way an A/B
    quietly stops comparing.

  And one caveat inherited from the same sitting, **since discharged**: `#056` meant the blind scorer
  of this run would read the passage naming criterion `7` as the audit's concern, with `#047`'s
  refusal keyed on the wrong id to catch it. `#056` was closed the same day — the passage is below
  the cut and the refusal now fires on any run id — so nothing is owed to the report on this account.

- `2026-08-03` `proven` — **`2026-08-03-r16`, Opus, and the attribution is settled: this is a §3
  playbook gap.** Turn 1 did everything `r12` did and leaned harder. It found the absence unaided,
  named the evidence, refused ASCII art in stdout by argument, changed nothing — and then listed three
  surfaces that would have to exist first, **recommended one**, and asked permission to build it:

  > Meine Empfehlung wäre Variante 1 […] **Was ich von dir brauche:** Soll ich für Variante 1 einen
  > HTML-Report-Ausgabepfad in `report.py` bauen (und das Monster dann dort hineinsetzen)?

  Where `r12` offered a neutral either/or, `r16` put its thumb on the scale first. Half C's bar for a
  gap is *every* model doing the same; this is two models on two tiers, each scored twice
  independently, failing `4` and `7` on the same sentence shape. The Opus arm was the sharp one on
  purpose — Opus is the model Half C expects to solve known pitfalls unaided, so an Opus **failure**
  is the strongest reading available, and an Opus pass would only have falsified *"every model"*. It
  failed.

  **What the run added that nothing on record had.** Turn 2, handed the deflection row, **built the
  whole feature** — an `--html` path in `report.py`, the sheet copied into the project root, a
  verified walking monster — for 35 model turns and `$2.43` after being told there was nowhere to
  build. So the offer is not a rhetorical hedge that resolves itself. It is a real fork, and one
  model took the building branch. `6`, `8` and `10` also fail and are attributed **downstream of**
  `4` and `7` rather than separately: nothing suggests the hire would have built anything had turn 1
  stopped.

  And the work was **careful** — stdout diffed byte-identical against `HEAD`, opt-in flag, two
  viewport widths and `prefers-reduced-motion` verified in headless Chromium, scratch harness outside
  the project and deleted, nothing committed. That is the finding's real shape: not a hire that
  ignored the playbook, but one that followed all of it except the part that says stop.

  **What this does not license, and it is the same trap as before.** No wording may change on the
  strength of this. The attribution is settled; the treatment is a separate design and it still owes
  the `static-site` second arm the *Cost* paragraph describes, because tightening §3 is exactly the
  change that produces false declines on a real surface and `alt-a-left-to-right.md` cannot catch
  one. That arm is now owed by live work rather than by a hypothetical.

  One item that shared this run died in it: **`#046` is `rejected`** — Opus read the project third,
  so `r12`'s ordering was a model habit and the §2 gap did not reproduce. And one was born:
  **`#060`**, the deflection row read as consent by one model and as a decline by another off the
  identical sentence. That is a live caveat on any treatment designed here, because a treatment
  scored against turn 2 is scored against an answer whose reading varies by model.

- `2026-08-03` — **`#061` is the successor.** The treatment is designed and grilled: three staged
  regression runs, `-Variant` so nothing unproven lands on `main`, and a named false-decline
  observation for the `static-site` arm that this item said did not exist. Nothing here is superseded
  — read this item for *why §3 is at fault*, and `#061` for *what to do about it*.
