# `#043` — §3's decline was offered to the customer as a choice before it was taken

| | |
|---|---|
| Status | `grilled` |
| Gate | `run` |
| Attribution | candidate playbook gap — **not settled**, one model, one run |
| Criterion | `nowhere-to-walk` `4` and `7`, both failing on the same sentence |
| Target file | `MONSTER-DEV.md` §3 — but see the trap below before touching it |
| Evidence | `2026-08-03-r12` |
| Blocked on | nothing — the second sighting is designed below and shares its run with `#046` |
| Proof design | **Attribution run, no treatment.** One **Opus** arm on `nowhere-to-walk` against `process/fixtures/python-cli/`, mirror fetch path, playbook and scenario unchanged. Nothing flips: the question is whether `4` and `7` fail *again on a different model*. Shared with `#046`, which reads `10` and `8` off the same transcript. See the `2026-08-03` grilling entry for what each outcome licenses and for the two things this run may not be used for |

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
