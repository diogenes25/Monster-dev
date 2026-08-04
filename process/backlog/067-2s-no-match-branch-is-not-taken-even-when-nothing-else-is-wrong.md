# `#067` — §2's no-match branch is not taken, even when the ordering is right and nothing is built

| | |
|---|---|
| Status | `proven` |
| Applied | **folded into `MONSTER-DEV.md` §2 on `2026-08-04`, verbatim** — unlike `#061`, whose fold-in carried a register edit and left `main`'s bytes differing from its arms'. So `process/variants/067-s2-b.psd1`'s `Insert` *is* the sentence on `main`, and a report citing that file cites what was measured. The variant now fails safely by construction (`#079`) |
| What `proven` does not include | **the cost rationale.** `#067` predicted one saved turn per no-match project; `2026-08-04-r21` took **12** model turns against `r17`'s 11. The criterion flipped, which is this gate's whole bar — but the turn saving did not appear, and the `Cost of leaving it` paragraph below is not evidence for anything until a second run reproduces it |
| Gate | `run` |
| Attribution | **playbook gap (§2), settled at the bar** — re-settled `2026-08-04` by applying this project's own bar rule to the split rather than by new data: **Sonnet is 2 of 2**, and the single run that takes the branch correctly is Opus. `CLAUDE.md` says the bar is Sonnet because *"Opus solves the known pitfalls unaided, which leaves nothing to measure"*, so `r18` is an instance of that asymmetry and not a counterexample. See the `2026-08-04` grilling entry |
| Criterion | `nowhere-to-walk` `10`. It costs a turn on every no-match project, which lands in `num_turns` |
| Target file | `MONSTER-DEV.md` §2 — the paragraph after the stack table |
| Evidence | `2026-08-03-r12` (sonnet), `2026-08-03-r16` (opus), `2026-08-03-r17` (sonnet) — three fetches, `r17` confound-free. **`2026-08-03-r18` (opus) does not fetch**, which is the observation that unsettles the row above |
| Blocked on | nothing |
| Proof design | **`2026-08-04-r21`** — regression, one Sonnet arm on `nowhere-to-walk`. Criterion `10` must flip against a **2-of-2** Sonnet before-fail (`r12`, `r17`; `r17` clean). Treatment is candidate `B`, three sentences inserted before §2's stack table via `build-dist.ps1 -Variant`, anchor *"Two sets of notes give you two answers to the same question and nothing that says which wins."* — verified to match exactly once. No Opus arm: `r18` already takes the branch untreated, so a treated Opus run can only confirm it still does. Full design in the `2026-08-04` entry |

**What happens.** §2's stack table has one row. Every run against `python-cli` — a 34-line stdlib
script with no DOM, no canvas and no window — has fetched `stacks/dom-css/README.md` anyway.

§2 is not vague about this:

> **Take the first row that matches, and fetch that one only.**
>
> | stack | you're here if | fetch |
> | `dom-css` | it renders to a DOM and its existing effects are CSS transitions or `@keyframes`, or it has no animation at all yet — and no tween library is already in use | … |
>
> If no row matches, that's the normal case rather than a problem — work from this playbook alone,
> exactly as every job did before the notes existed.

The `you're here if` column is **sufficient to decide without reading the note.** A CLI does not
render to a DOM. There is nothing to check.

**Why `2026-08-03-r17` is the observation that settles it, and the other two are not.** All three
failed criterion `10`, and for three different reasons — which is exactly why this took three runs to
see clearly:

| Run | When it fetched | Why that reading was confounded |
|---|---|---|
| `r12` (sonnet) | **before** looking at the project | no stack could have been resolved from anything yet — an *ordering* problem. Proposed as `#046` |
| `r16` (opus) | **turn 2**, after wrongly deciding to build an HTML page | `dom-css` is the *correct* row for a DOM surface. Downstream of the §3 failure, not a §2 finding |
| `r17` (sonnet) | **turn 1**, after `ls run`, `README.md` and `report.py` | **nothing left.** Ordering right, nothing built, no stack claimed, no invented slug, and a clean decline |

`#046` was `rejected` on `r16`'s evidence — the §2 *ordering* hypothesis is dead, and correctly. What
survived it is a different and simpler claim: **the no-match branch is not taken.** `r17` is the first
run in which that is the only thing left to say.

**Why the current wording may allow it.** §2 tells a hire what to do when a row matches and what to
do when none does, but the no-match sentence is *permissive prose* — *"that's the normal case rather
than a problem"* — where the match instruction is an imperative: *"Take the first row that matches,
and fetch that one only."* A model reading the section as a checklist finds one action item (fetch
the note) and one reassurance (it's fine if nothing matches). The only prohibition in the paragraph
is about **inventing** a slug — *"Don't guess at a name that isn't in the table"* — which is a
different failure and the one nobody has committed.

There is also a charitable reading worth stating, because it is probably what the hires are doing:
with exactly one row in the table, reading the note is cheap diligence — *let me check whether this
applies*. That reading is defensible right up until you notice the table already answers it, and it
predicts the behaviour will get **worse** as rows are added, not better.

**Cost of leaving it.** One wasted turn per no-match project, in `num_turns` — which is one of the two
numbers `CLAUDE.md` states the tooling gate in. Small per run and structural: it is a cost the
playbook imposes on every project it is *not* the right playbook for, which is the population §3
exists to serve.

**Proposed change.** Not drafted, and the shape matters more than the words. Three candidates, and
the third is the one to argue with:

> **A — make the no-match branch imperative.** *"If no row matches, don't fetch any of them."* One
> clause, symmetric with the match instruction. Cost: it reads as distrust, and §2 is the section
> every hire reads on every job.
>
> **B — put the decision before the fetch.** Say that the `you're here if` column is what decides,
> and the note is what you read *once* a row has been chosen. That names the actual error: the hires
> are using the note to make a decision the table already made.
>
> **C — do nothing, and fix the criterion instead.** If reading the one available note is genuinely
> cheap diligence, `10` may be scoring a non-problem. Cost of this reading: it does not survive a
> second row. With two notes, *"read them to see which applies"* is two wasted fetches, and
> `#005`'s whole point is that the first-match rule is unobservable until a second row exists.

**B is the likely answer and C is the one that has to be refuted rather than skipped**, because if
`10` is scoring a non-problem then three runs have been carrying a fail that means nothing, and that
is a worse defect than the one this item describes.

**Proof design.** `Gate: run`, not written. Two things it will have to confront:

- **The regression is cheap and the before-fail is unusually strong** — three runs, two tiers, and
  `r17` gives a clean baseline where `10` is the *only* failing mark, so a flip is unambiguous.
- **`#005` and `#006` are entangled with it.** A second published stack note changes the answer to
  candidate `C` and is the precondition both of those items are blocked on. Whoever grills this
  reads all three: it is possible that adding the second note is the cheaper move and that this item
  resolves as a side effect.

**Log.**

- `2026-08-03` `formulated` — from `2026-08-03-r17`, `#061`'s Phase 1, where criterion `10` was the
  single remaining failure once `4` and `7` had flipped. Filed at `formulated` and not `intake`
  because what happens, which paragraph changes and the attribution are all settled: three runs, two
  tiers, three fetches, and Half C's bar for a gap is *every* model doing the same. What is open is
  the wording — and, more interestingly, whether candidate `C` is right and the criterion is at
  fault instead.

  Not merged with `#046`, which is `rejected` and stays so: that item's hypothesis was the read
  *order*, `r16` refuted it, and this one is about the fetch happening at all. Not `#006` either,
  which is about a stack note leaving no fingerprint in the result.

- `2026-08-03` — **fourth observation, and it splits the set 3–1.** `2026-08-03-r18` (opus, `#061`
  Phase 2) **took the branch correctly**: no stack note fetched, no row claimed, no invented slug. The
  only `stacks/` strings in its transcript are an `ls -R` of the mirror at `:17` and §2's own table
  inside `MONSTER-DEV.md` at `:21`.

  **This weakens the attribution row above and does not settle a replacement.** Half C's bar for a
  playbook gap is *every* model doing the same, and one hire in four now does not. It is also not
  cleanly a model disposition: `r16` and `r18` are **both Opus** and disagree with each other, on the
  same fixture, the same brief and mirrors differing only in §3. So the honest state is *three runs
  fetch, one does not, and nothing on record predicts which* — which is `#050`'s shape (within-tier
  variance) applied to a much cheaper behaviour.

  What the item may not do is quietly keep *settled* in its attribution row on the strength of the
  three runs that agreed. Either the row becomes a rate, or a fifth observation is bought — and the
  cheapest fifth observation is a by-product of any future `nowhere-to-walk` run, since `10` is scored
  on every one of them.

  Note the direction of the difference: `r18` is the **cheapest and cleanest** run on this scenario
  (13/0/0/1, `$0.6783`). Whatever made it skip the fetch did not cost it anything anywhere else.

- `2026-08-04` `grilled` — **candidate `B`, one Sonnet arm, and `C` is refuted by measurement rather
  than by argument.** Four decisions, and two of them come from numbers this item did not have.

  **`C` is dead: the fetch is a full model turn and it buys nothing.** *"Reading the one available note
  is cheap diligence"* was the reading that had to be refuted, and the transcripts refute it twice
  over. The `Read` of `stacks/dom-css/README.md` sits **alone in its own assistant message** in all
  three runs — one `tool_use` block, nothing batched with it — so *"one wasted turn"* is measured and
  not asserted: 1 turn of `r17`'s 11, about 9 % of a decline run, in the one run class whose whole
  point is being cheap. And the turn buys nothing, because the note's decision-relevant content is a
  **restatement of the table cell the hire has already read**: *"You are here if the project renders to
  a DOM … You are not here if the project already uses GSAP."* Everything else in those 35 lines —
  primitive, asset location, the `index.html` pointer — presupposes that the row matched. `C` also
  does not survive `#005`: with a second row it is two wasted turns rather than one.

  **The attribution is re-settled without buying the fifth observation, by applying this project's own
  bar rule.** Split by tier rather than counted: **Sonnet 2 of 2 fetch** (`r12`, `r17`), Opus 1 of 2.
  So the observation that unsettled this row is *Opus-only* — and `CLAUDE.md` says the bar is a
  Sonnet-class hire precisely because *"Opus solves the known pitfalls unaided, which leaves nothing to
  measure"*. `r18` is that asymmetry, not a contradiction of it. The row goes back to **playbook gap
  (§2), settled at the bar**, and the fifth observation this item asked for is no longer owed: it would
  only have refined a rate that the bar rule says is measured on the wrong tier.

  **Candidate `B`, and the reason is structural rather than aesthetic.** `A` (*"if no row matches,
  don't fetch any of them"*) is symmetric and cheap and names only the symptom. The cause is that the
  **applicability test exists twice in the product** — in §2's `you're here if` column and again as the
  note's opening paragraph — and that duplication is *required*, not accidental: `CLAUDE.md`'s
  gate-free orientation exemption exists so a note can answer *"am I in the right stack"*. A hire
  facing two sources for one question opens the fuller one. `B` says which of the two decides and
  leaves the note untouched, so the exemption is not disturbed.

  The wording, three sentences, inserted **before** the table because putting the decision before the
  fetch is the whole of `B`:

  > **The `you're here if` column is what decides, and it is answerable from what step 2 already
  > found — without opening anything.** A note tells you how earlier jobs on that surface went, not
  > whether you are on it. So a note is what you read *after* a row matches; if none matches, there is
  > nothing to open.

  The last clause folds `A`'s imperative in as a *consequence* of the rule instead of a prohibition,
  which is what keeps §2 — a section every hire reads on every job — out of the distrust register.

  **Proof design: regression, one arm.** `CLAUDE.md`'s first gate — *fold in, rerun the same scenario,
  the failing criterion must flip*. Criterion `10` on `nowhere-to-walk`, before-fail on record and
  **2 of 2 at the bar** with no Sonnet counterexample, which is what makes a single treated pass worth
  something here where the same shape was nearly worthless for `#050`: there the untreated rate was
  88 % acceptance, here it is 0 % correct-branch on Sonnet. Held constant: fixture, answer script,
  dialogue protocol, and §3's treatment as folded into `main` — `r17` ran against that same §3, so the
  arms compare. Varied: the three sentences, via `-Variant`, anchor verified to match exactly once.
  **No Opus arm**, because `r18` already takes the branch untreated and a treated Opus run can only
  confirm that it still does.

  What a failure would mean, decided in advance: if criterion `10` still fails on the treated arm, the
  fault is not the no-match branch's *register* but its position — and the next candidate is `A`
  applied to the sentence order rather than a further clause. Not the criterion; `C` is refuted and
  stays refuted.

  **`#066` is unblocked by this and not resolved by it.** That item waits on whether `10` should be
  split, and its own note says to read this one first. Nothing here splits it: this arm scores `10` as
  it stands, and if it flips, the bundling `#066` describes is a question about a mark that now passes.

  **`#005` and `#006` read in the same sitting, as this item requires.** Neither is closer to
  unblocked and neither changes the design: `#005` needs a second published stack note and `#006`
  needs a gated pitfall in any note, and this treatment adds neither. What the reading does settle is
  that the second row would make `C` *worse* rather than better, which is the one direction this item
  was unsure about.

- `2026-08-04` `proven` — **`2026-08-04-r21`, and criterion `10` flipped at the bar.** 13 pass / 0
  fail / 0 partial / 1 not scorable, **both scorings agreeing on every mark** — the first clean sweep
  on this scenario at the Sonnet tier, matching `r18` (Opus) mark for mark. No stack note fetched, no
  row claimed, no invented slug, no 404. `$0.5109`, 12 model turns, reach clean in all four sections,
  mirror verified intact.

  **The before/after is 2-of-2 against 1-of-1 at the bar**, which is the whole reason a single treated
  arm was enough here and was nearly worthless for `#050`: on Sonnet the untreated behaviour had no
  counterexample.

  **What the treatment actually changed, measured rather than asserted.** Every tool call of both
  runs, by side of the fence:

  | | `r17` (untreated) | `r21` (treated) |
  |---|---|---|
  | into **our** tree | **2** — the stack note, and `tools/project.md` | **0** |
  | into the **client's project** | 3 | **6** — incl. `sales.csv`, the dotfiles, `Glob **/*` |
  | model turns / cost | 11 / `$0.5123` | 12 / `$0.5109` |

  So the effort was **redirected, not saved**: nothing on our side of the fence, twice as much on the
  actual project, which is what §2 is for. The extra turn is real and the cost is flat to within
  0.3 %.

  **Two things this run may not be credited with**, both in the report. `r17` also read
  `tools/project.md` and `r21` did not — that file is not a stack note, so the treatment does not
  mention it, and this arm cannot separate *the sentence worked* from *this session was less curious*.
  And the arms are **not byte-identical outside the treatment**: `r17` ran §3 as variant `061-s3-b`
  while `r21` ran §3 as folded into `main`, which differ by one register edit. Neither can plausibly
  reach a criterion about §2's table, and both arms passed §3's own marks either way — but *"held
  constant except the treatment"* is false as written, and the report says so rather than this item
  quietly not mentioning it.

  **The run also bought the third narrowing of `10`'s own instrument** (`#071`): the pattern hit the
  `ls` of the mirror's `stacks` directory, so applied mechanically it would have failed the very run
  that took the branch correctly. Found by this run and independently by its blind pass. The verdict
  stands on the criterion's named *fail condition*, which both readers applied identically.

  `#066` is unblocked and unresolved: it asks whether `10` should be split, and `10` now passes, so
  the bundling it describes is a question about a mark nothing currently fails.
