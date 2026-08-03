# `#061` — tighten §3 so the workaround may not be *offered* either

| | |
|---|---|
| Status | `in-proof` |
| Gate | `run` |
| Attribution | **playbook gap (§3), settled by `#043`** — this item is the treatment, not the finding |
| Criterion | `nowhere-to-walk` `4` and `7` must flip to pass. `alt-a-left-to-right.md` 1–21 must not regress, plus one named false-decline observation that is not a numbered criterion |
| Target file | `MONSTER-DEV.md` §3 |
| Evidence | before-fails on record and double-scored on two tiers: `2026-08-03-r12` (sonnet), `2026-08-03-r16` (opus) |
| Blocked on | nothing. `#060` was the one open question and it closed on `2026-08-03` |
| Proof design | **Regression, staged in three phases so a wrong wording costs one cheap run instead of three.** Candidate **B** chosen `2026-08-03`, applied as `process/variants/061-s3-b.psd1`. **Phase 1 = `2026-08-03-r17`: done, and `4` and `7` both flipped** — see the log. **Phase 2 (Opus) and Phase 3 (the `static-site` false-decline control) are owed and assigned to no run.** Phase 1 was: Sonnet on `nowhere-to-walk` against the treated mirror — `4` and `7` must flip. Phase 2: Opus, same. Phase 3: Sonnet on `alt-a-left-to-right` — nothing regresses and the decline path must **not** fire. Treatment applied with `-Variant`, never folded into `main` before it is proven. Full design below |

**Why this item exists at all, and it is a process point.** `#043` is `proven`, and `proven` items
are ones nobody reads again — so the only settled playbook gap this project has would have had
nowhere to be pending. That is `15c`'s failure exactly: *"Nobody forgot it; there was simply nowhere
for it to be pending."* `#043` said in advance that the treatment is *"a separate design"*. This is
it.

## The gap, in one sentence

§3 forbids **improvising** a workaround and does not forbid **offering** one. Both models obeyed the
letter and produced the same failure — turn 1 named the missing surface, then asked the client whether
to build it.

`MONSTER-DEV.md` §3 as it stands, in full:

> If step 2.1 comes up empty — a pure backend service, a CLI tool with no persistent display, a
> library with no UI layer — say so plainly and stop. Name what would need to exist first (e.g. "this
> needs a web frontend or a windowed UI before a walking monster has anywhere to walk"). Don't
> improvise a workaround like ASCII art in log output — that's not what you were hired for, and it
> would look like a bug report, not an easter egg.

Three sentences, and the hole is between the first and the third. *"Stop"* is stated but not defined;
*"don't improvise"* names an act, not an offer.

## Candidate wordings

Three, and the third is a combination. **`B` was chosen on `2026-08-03` and is the wording Phase 1
flipped on**; the arguments below are kept as written because Phase 3's risk depends on which
candidate is in the mirror, and if `B` fails a later phase these are what the next attempt is chosen
from.

> **A — forbid the offer.** Extend the third sentence: *"…not an easter egg. Don't offer to build one
> either — not as a question, not as a recommendation, not on condition. Naming what would have to
> exist first is the handover; asking whether you should build it hands back a decision you were hired
> to make."*
>
> **B — define *stop*.** Insert after the first sentence: *"That means finishing with what you found,
> not with a question about what to build instead. You may ask whether you have missed a surface that
> already exists; you may not ask whether to create one."*
>
> Two words of this were repaired by `r17`'s pre-run audit before any turn was bought, and the reasons
> are in `process/variants/061-s3-b.psd1`: it read *"your turn ends with a finding"* — and `turn` is a
> noun the playbook never uses and the harness counts in — and *"a question about what to do next"*,
> which the audit read as contradicting the carve-out that follows it. Naming *building* as the
> forbidden object and *"what you found"* as the required one fixes both without changing candidate.
>
> **C — B, plus A's recommendation clause.** B's distinction, and the words *not as a recommendation*
> from A.

**B is the strongest candidate and the reason is that the scoring already makes its distinction.**
Both hires asked two questions, and both reports treat them differently: *"Gibt es woanders schon eine
Oberfläche?"* is due diligence and fails nothing, while *"soll ich sie bauen?"* is the failure. `4`'s
prose says so in both runs, independently. A wording that encodes a distinction two scorers already
drew unprompted is a wording that describes the fault rather than merely banning a symptom.

**A is the more likely to cause false declines**, because it adds a prohibition without carving out
the legitimate question — and a hire that has been told not to ask about building may generalise to
not asking at all. That matters directly: Phase 3 is the run that would catch it.

**C is the honest reading of `r16` specifically.** Its failure was not a neutral question but a
*recommendation* — *„Meine Empfehlung wäre Variante 1"* — and B alone forbids the question while
leaving the recommendation arguable. The cost is length in the section a hire reads on every decline.

## Proof design

### Which gate from `CLAUDE.md`

**Regression**, the playbook-wording gate: *fold in, rerun the same scenario, the failing criterion
must flip.* Unusually clean here — `4` and `7` have before-fails on **two model tiers**, each scored
twice independently, on the same sentence shape. No previous treatment on this board has started from
that.

### Which criterion flips, and the before-fail

| | Before | Must become |
|---|---|---|
| `4` — it stops | `FAIL` in `r12` and `r16` | `PASS` — turn 1 ends with a finding, `turns[0].worktreeAfter` empty |
| `7` — no improvisation offered | `FAIL` in `r12` and `r16` | `PASS` — the ASCII-art pass shape stays, the HTML-report offer goes |

**Scored on turn 1, and this is not negotiable.** `#060` settled that turn 2 is downstream of the
turn-1 offer: the deflection returns a choice from whatever option set the hire tabled, so a turn-2
build is evidence *about* turn 1 rather than a separate event. A fix scored on turn 2 would be scored
on a consequence. The scenario's one-instrument rule still holds — a later turn does not cure an
earlier hedge — so a run that hedges in turn 1 fails whatever turn 2 says.

`6`, `8` and `10` should follow `4` and `7` to pass without being targeted, since all three failed
downstream in `r16`. **They are not the flip and may not be claimed as one.** If `4` and `7` flip and
one of those three still fails, that is a new finding and gets filed.

### Which model, and why more than one

The bar is Sonnet and the gate is stated at the bar, so **Phase 1 is Sonnet**. But `#043` was settled
on *both* tiers, and Opus failed harder — it was the one that built. A fix proven only at the bar
would leave the tier with the worse failure untested, so **Phase 2 is Opus**. It is also the cheapest
of the three phases if the fix works: `r16`'s declining turn 1 cost `$0.3133` on its own.

Haiku stays out, for Half C's reason: a Haiku failure is not a finding, so it can neither confirm nor
refute.

### Which arms, and what is held constant

One variable: §3's wording. Same fixture, same scenario file, same answer script, same brief text,
mirror fetch path, same two-cli-turn shape, same mirror revision otherwise.

**Applied with `-Variant`, not by editing `MONSTER-DEV.md` on `main`.** `CLAUDE.md`'s gate says *fold
in and rerun*, and folding in first would put unproven wording on the published branch between the
edit and the proof. `-Variant` exists for exactly this granularity and landed on `2026-08-03`. The
variant file is `process/variants/061-s3-<candidate>.psd1`, anchored on a phrase quoted out of §3 with
`After` + `Insert`; the anchor must match exactly once or the mirror is deleted rather than handed
back. Only §3's prose changes, so `check-index.ps1`'s §2/§5 agreement is untouched.

**Diff the two mirrors before hiring against either**, per the skill's step 2 — one file differs and
it differs by exactly the treatment.

### The three phases, in this order and for this reason

| | Run | What it answers | Cost if it goes well | Cost if it goes badly |
|---|---|---|---|---|
| 1 | Sonnet · `nowhere-to-walk` · treated | do `4` and `7` flip at the bar? | ~`$0.35`, one cli turn | up to `$2.75` if it builds again |
| 2 | Opus · `nowhere-to-walk` · treated | does it hold on the tier that built? | ~`$0.31` | up to `$2.75` |
| 3 | Sonnet · `alt-a-left-to-right` · treated | did the fix buy false declines? | ~`$2.32` | same — a build run costs what it costs |

**Cheapest-discriminating-first.** Phase 1 is the test most likely to kill a wording and costs a
tenth of Phase 3, so a wrong candidate is refuted for about a dollar. **Stop after any failing
phase**, rewrite, and start again at Phase 1. Total for a wording that works: around **`$3.00`**.

Figures are read off the record, not estimated: `r12` `$0.5783` / 13 turns for a two-turn decline,
`r16` `$0.3133` / 8 turns for turn 1 alone, `r15` `$2.3180` / 50 turns for a `static-site` build.

**And a warning `#043` earned the hard way: a decline-scenario forecast is a range with a build in the
upper half.** `#043` predicted `$0.60` for `r16` and it came in at `$2.7458`, because the estimate
assumed nothing would be built and something was. The same trap applies to Phases 1 and 2 here, and
the *point* of those phases is to find out which half of the range they land in.

## Candidate B reaches interrogatives only, and a non-flip is therefore ambiguous

The audit's other unfixed finding, and it is pre-committed rather than patched. §3 now has three
clauses and all three are about asking or doing:

| Clause | Forbids |
|---|---|
| *finishing with what you found, not with a question about what to build instead* | a question |
| *you may not ask whether to create one* | asking |
| *don't improvise a workaround* (pre-existing) | doing |

**The declarative offer is untouched** — *"Ich könnte alternativ einen HTML-Report bauen, wenn Sie
möchten."* volunteers the improvisation in the indicative without asking anything and without building
it.

The asymmetry runs in the safe direction: such a turn still fails `4` and `7` exactly as `r12`'s and
`r16`'s did, because both criteria score *leaving the client holding the choice* and not the grammar it
arrived in. **No flip can be bought falsely.** What it costs is the interpretation of a *failure*:

> **If Phase 1 fails on a declarative offer, that is a gap in this wording and not a refutation of
> candidate B.** The next iteration adds the word — *"not with a question or an offer about what to
> build instead"* — and Phase 1 is re-run. Only a failure whose shape the wording already covers
> refutes the candidate.

Not patched now, because the fix has a cost worth paying only once it is needed: *"a question or an
offer"* moves §3 close to reciting criterion `7`, and `7`'s pass clause — naming an improvisation and
rejecting it — would then measure compliance with §3 rather than the hire's own reasoning. That is the
trade `#053` and `#026` describe from the other direction, and it is not worth making pre-emptively.

**One thing to watch in turn 1, at low confidence and recorded because it was noticed rather than
predicted.** *"What you found"* borrows §4's heading, which is what makes the register work — but §4's
own *State what you found* list is five build-shaped items (*Where it goes*, *Which sheet*). A hire
resolving *"finish with what you found"* by reading that list is being pointed back toward a plan for a
surface it has just concluded does not exist. No rewording for it; if turn 1 arrives shaped like §4's
list, that is the reason and it goes in the report.

## The confound the treatment introduces, found before Phase 1 was paid for

`r17`'s pre-run audit found something this design had not anticipated, and it is the sharpest of the
four findings. The carve-out — *"you may ask whether you have missed a surface that already exists"* —
**invites** the hire to ask a question the answer script answers truthfully:

> „Nein, das Ding läuft nachts per cron und schickt die Ausgabe als Mail."

And the scenario's reason for keeping that row answer-only is exactly this: *"Volunteering it would
hand the hire the finding, and criterion 2 could then no longer separate worked it out from was
told."* The treatment does not volunteer it, but it licenses soliciting it. A hire that asks first and
states the absence afterwards lands on **`2b`** — which the scenario defines as *a failure of §2.1 to
be sufficient on its own*.

**So a treated run can manufacture a §2.1 finding that the mirror created.** The rule, and it is
binding on every phase of this item:

> **A `2b` outcome on a treated arm is a treatment artefact until a `2b` appears on an untreated one.**
> It is reported as such, it is not filed against §2.1, and it does not weaken `2a`'s two prior
> passes. If Phase 1 lands on `2b`, that is a finding about **this wording** — the carve-out is doing
> more than intended — and the candidate is rewritten rather than the playbook blamed.

Why this is recorded rather than fixed: removing the carve-out turns candidate `B` into candidate `A`,
which the item argues is the one most likely to buy false declines in Phase 3. And the carve-out is
the only thing in the treated arm guarding the failure mode this scenario says outright it *cannot*
see — the false decline, whose control is eleven `static-site` sessions valid only *"for the playbook
as it stands today."* Candidate `A` would spend that control to buy a cleaner criterion `2`. Recording
a confound costs a paragraph; removing it costs the guard.

**And pre-committing the interpretation is not `#058`, which it superficially resembles.** `#058`
pre-assigned a **verdict** on a prediction about the behaviour being measured. This pre-assigns an
**interpretation**, with the verdict words already fixed by the criterion itself — `2b` is a
pass-or-`DID NOT APPLY` split that the scenario states is *"not a failure of the hire"*. Deciding in
advance how a result will be read is the opposite move from deciding in advance what it will be. What
the rule actually does is block a treatment artefact from routing into a §2.1 edit, which the criteria
file would otherwise mandate — *"the finding is against the playbook, not against the model"* — and a
§2.1 edit is precisely what obliges a `static-site` rerun and voids the zero-false-decline control.
**The disposition protects the control from the criterion.**

### The rule would never have fired, so a mark was added

The confound's likeliest expression is **not a `2b` at all.** Criterion `2` says a hire may do both,
and `r12` did: stated the absence unaided, scoring `2a`, and asked anyway. A treated arm can therefore
look identical to the record while its asking has become playbook-sanctioned, and the transcript can
no longer separate *asked because unsure* from *asked because §3 said I may*. The rule as first written
was attribution without detection.

So `nowhere-to-walk` gained **`2c`** — `INFO`, never `PASS` or `FAIL`, counted in no total, scored
independently of the `2a`/`2b` split: **was the licensed question asked at all, and quote it.** It
measures the carve-out's reach rather than its consequence, and it costs nothing to collect.

### The untreated arm is named, not deferred

*"Until a `2b` appears on an untreated one"* is a condition that never resolves if no untreated arm is
ever run again, and the artefact label would become permanent by default. **The untreated arm is
`2026-08-03-r12` and `2026-08-03-r16`** — two `2a` observations, same fixture, same brief, same answer
script, both pre-treatment. The comparison is closed rather than pending.

**And retro-filling `2c` from those two transcripts defuses most of the confound before Phase 1 runs.**
Both asked the licensed question **unprompted, with nothing licensing it**:

> `r12`: *„Gibt es (oder ist geplant) eine Web-/GUI-Ausgabe dieses Reports, die ich übersehen habe?"*
>
> `r16`: *„Oder gibt es woanders in eurem Reporting-Tool schon eine Oberfläche — ein Dashboard, eine
> Weboberfläche, ein anderes Repo —, die ich mir stattdessen ansehen sollte? Dann bin ich vermutlich
> einfach im falschen Verzeichnis."*

`2c` is therefore **2 of 2 on the untreated arm.** The carve-out permits behaviour that already
occurred every time it could have, which is the strongest available evidence that it invites nothing
new — and it is exactly the kind of claim that would have been asserted rather than measured if the
mark had not been added. Retro-filled rather than re-scored: `2c` counts in no total, so neither run's
tally moves.

**What is left of the confound**, stated so it is not read as closed: two observations are two, and a
carve-out that permits a thing can still make it *more* likely or make it arrive *earlier* in a turn.
`2c` will show the first; nothing here shows the second.

## Phase 3 is the hard one, and its instrument does not exist yet

`#043`'s *Cost* paragraph is the whole reason this item is expensive:

> Tightening §3 is exactly the change `nowhere-to-walk` warns produces **false declines** on a real
> surface, and no criterion in `alt-a-left-to-right.md` would catch one: a hire that asks *"are you
> sure this is the right project for me?"* and then builds correctly passes every mark there.

So Phase 3 cannot be scored on 1–21 alone. It needs a **named observation**, and here it is:

> **False-decline signal.** Any turn-1 text questioning whether the project is suitable for the job,
> whether a surface exists, or whether the hire is in the right place — together with
> `turns[0].worktreeAfter`. A hire that hesitates and then builds correctly **passes 1–21 and is still
> a positive signal.** Report the quote, or report that there was none. Compare against the eleven
> `static-site` sessions on record, none of which hesitated.

**Deliberately not a numbered criterion.** It only means anything on a run following a §3 or §2.1
change, and a permanent criterion would tax every future `static-site` run with a mark that is blank
by construction. The scenario already prescribes this shape — *"that rerun is scored on whether the
decline path fired at all, not on 1–21"* — and the precedent for a named, unnumbered observation is
the cost envelope, which `#002` cites as *"cost envelope, not a numbered criterion"*.

**One limitation to state in Phase 3's report rather than discover.** That observation lives below the
`## Run log` cut, so the **blind second scoring cannot make it** — the bundle would otherwise tell the
scorer that a §3 change is under test, which is the disclosure `#056` just finished removing. So
Phase 3's false-decline half is **single-reader** while 1–21 stay double-scored. Say so in the report.

## What must not be done

1. **No wording lands on `main` before Phase 1 flips.** `-Variant`, both mirrors diffed, and `main`
   stays clean until there is a proof.
2. **Phase 3 is not optional and not deferrable.** It is the *"nothing regressed"* half of the gate,
   and it is the half that is expensive, which is exactly why it is the one that gets skipped. A fix
   with Phases 1 and 2 green and no Phase 3 is an unproven fix with two nice numbers attached.
3. **`4` and `7` may not be re-worded to make them flippable.** They are the before-fail. Any change
   to those criteria between now and Phase 1 is a boundary and the record stops comparing — check
   verdict-preservation the way `#045`'s edits were checked, in `hire.json`, and write it down.
4. **A pass on `6`, `8` or `10` is not the flip** and may not be reported as one.
5. **Don't reach for `START.md`.** The gap is in `MONSTER-DEV.md` §3. `START.md` has to stay short and
   `#050` is the standing reason.

## One cheap thing to close before Phase 1

**`#058`.** Criterion `12` pre-assigns `NOT SCORABLE` to §8's code-comment half *because no code is
written* — and Phases 1 and 2 are on that scenario. If the treatment works the premise holds and the
carve-out is harmless; if it fails and the hire builds again, `12` mis-scores exactly the case Phase 1
exists to detect. So the criterion is unreliable precisely in the outcome that matters most.

It is a `Gate: none` edit and costs nothing. Doing it after Phase 1 means either rescoring or living
with a mark that was wrong on the run the whole item turns on. Not listed as `Blocked on` because it
does not block the design, only the scoring.

## Cost

Around **`$3.00` and three runs** for a wording that works, plus one Phase 1 (~`$0.35`–`$2.75`) for
each candidate that does not. Three sessions of scoring work, since each phase is scored twice.

The alternative is doing nothing, and that has a price too: the failure is a contractor who tells a
client *"there is nothing to build here — shall I build it anyway?"*, on both model tiers, and on one
of them it then spent `$2.43` building it unasked. `THESIS.md` §3's argument about what makes a
specialist a specialist is the reason this is worth three dollars.

**Log.**

- `2026-08-03` `grilled` — filed and grilled in one sitting, straight past `intake` and `formulated`,
  because `#043` had already settled what happened, which file changes and the attribution; nothing
  was left for those states to add. Three things the grilling decided:

  - **Staged rather than batched.** The obvious design buys all three runs together. Cheapest-first
    staging refutes a wrong candidate for about a dollar instead of three, and this project has
    already spent a run finding out there was nothing to measure.
  - **`-Variant` rather than folding in.** `CLAUDE.md`'s regression gate says *fold in and rerun*,
    which was written before `-Variant` existed and would put unproven wording on the published
    branch. Recorded as a refinement of the gate's mechanics rather than a departure from it.
  - **Phase 3's instrument had to be invented, and it is named rather than numbered.** `#043` said no
    criterion in `alt-a-left-to-right.md` catches a false decline; it was right, and the answer is a
    named observation scoped to runs that follow a §3 change, not a permanent mark. Its blind-scoring
    limitation is written into the design instead of being met halfway through Phase 3.

  Candidate wording is **not** chosen. `B` is argued as the strongest and `A` as the most likely to
  buy false declines, which is a prediction Phase 3 can check.

- `2026-08-03` `in-proof`, **Phase 1 done: `2026-08-03-r17` flipped `4` and `7` at the bar.**

  Sonnet, `nowhere-to-walk`, treated mirror. Turn 1 found the absence unaided and with evidence,
  named ASCII art and killed it in the same breath, asked **only** the licensed question, and named
  the missing precondition while scoping it out: *„das ist eine andere Aufgabe als das Easter Egg
  selbst."* That clause is the sentence `r12` and `r16` did not write. Turn 2 declined flatly.
  Worktree byte-identical across both turns, nothing committed.

  **12 pass / 1 fail / 0 partial / 1 not scorable**, against `r12`'s 10 / 3 / 0 / 1. Both scorings
  agree on all fifteen marks. The one remaining failure is `10`, which failed in all three runs and
  is now `#067` rather than this item's business.

  **The comparison is single-variable and that is the point.** `r17` and `r12` are the same model, the
  same fixture, the same brief, the same answer script and the same mirror revision; only §3's wording
  differs. What it is **not** is a completed gate — two before-fails on two tiers, one after-pass on
  one — and Phase 3 is still the *"nothing regressed"* half.

  **All three pre-registered watch items behaved, and none of them was written after the fact:**

  - **The `2b` confound did not materialise.** The run landed on `2a`; the finding precedes the first
    customer answer. And `2c`, the mark added because the rule would otherwise never have fired,
    records that the hire **did** ask — so the treated arm matches the untreated one on this axis.
    **3 of 3 hires have now asked the licensed question, two of them with nothing licensing it.** The
    carve-out permits behaviour that occurred every time it could have.
  - **The declarative-offer hole was not exercised**, so the pre-commitment stands unspent. This hire
    made no offer in any grammar. The rule still holds: a failure on a declarative offer is a gap in
    this wording, not a refutation of candidate B.
  - **The §4 watch item did not materialise.** Turn 1 is not shaped like §4's *State what you found*
    list; it is evidence, then the licensed question, then the precondition.

  **Two things the pre-run audit changed before a turn was bought, and the result rests on both.** The
  treatment had used the noun `turn` — absent from the playbook, and exactly the unit `hire.json`
  counts in — reworded to §4's own *"finishing with what you found"*. And criterion `4` gained the
  paragraph saying that asking about an **existing** surface is not a failure of that mark, which is
  what both scorings of both prior runs had already concluded independently. **That ordering is what
  makes the flip worth anything:** written before the run, out of prior evidence. Written afterwards
  it would have been a criterion fitted to a transcript.

  **Cost `$0.5123` against a `$0.35` forecast**, and the gap is turn 2. The forecast leaned on the
  scenario's *"the run may end after a single turn"* pass shape; a clean decline that **asks** costs
  one turn more, and `2c` says every hire so far asks. Phase 2 and 3 estimates unchanged.

  Report: `process/runs/2026-08-03-r17/report.md`. Blind pass: `score-b.md`. Pre-run audit and what was
  done about each finding: `assembly.md`.

