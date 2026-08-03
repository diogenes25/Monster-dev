# `#061` — tighten §3 so the workaround may not be *offered* either

| | |
|---|---|
| Status | `grilled` |
| Gate | `run` |
| Attribution | **playbook gap (§3), settled by `#043`** — this item is the treatment, not the finding |
| Criterion | `nowhere-to-walk` `4` and `7` must flip to pass. `alt-a-left-to-right.md` 1–21 must not regress, plus one named false-decline observation that is not a numbered criterion |
| Target file | `MONSTER-DEV.md` §3 |
| Evidence | before-fails on record and double-scored on two tiers: `2026-08-03-r12` (sonnet), `2026-08-03-r16` (opus) |
| Blocked on | nothing. `#060` was the one open question and it closed on `2026-08-03` |
| Proof design | **Regression, staged in three phases so a wrong wording costs one cheap run instead of three.** Phase 1: Sonnet on `nowhere-to-walk` against the treated mirror — `4` and `7` must flip. Phase 2: Opus, same. Phase 3: Sonnet on `alt-a-left-to-right` — nothing regresses and the decline path must **not** fire. Treatment applied with `-Variant`, never folded into `main` before it is proven. Full design below |

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

Three, and the third is a combination. **None is chosen — choosing is the first thing the next
session does, and the choice changes what Phase 3 risks.**

> **A — forbid the offer.** Extend the third sentence: *"…not an easter egg. Don't offer to build one
> either — not as a question, not as a recommendation, not on condition. Naming what would have to
> exist first is the handover; asking whether you should build it hands back a decision you were hired
> to make."*
>
> **B — define *stop*.** Insert after the first sentence: *"Stopping means your turn ends with a
> finding, not with a question about what to do next. You may ask whether you have missed a surface
> that already exists; you may not ask whether to create one."*
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
