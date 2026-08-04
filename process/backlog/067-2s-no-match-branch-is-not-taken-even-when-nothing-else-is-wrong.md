# `#067` — §2's no-match branch is not taken, even when the ordering is right and nothing is built

| | |
|---|---|
| Status | `formulated` |
| Gate | `run` |
| Attribution | **playbook gap (§2) — no longer settled.** Three runs on two tiers fetch, one does not, and the two Opus runs disagree with each other — see the `2026-08-03` log entry for `r18`. The *treatment* is not designed either |
| Criterion | `nowhere-to-walk` `10`. It costs a turn on every no-match project, which lands in `num_turns` |
| Target file | `MONSTER-DEV.md` §2 — the paragraph after the stack table |
| Evidence | `2026-08-03-r12` (sonnet), `2026-08-03-r16` (opus), `2026-08-03-r17` (sonnet) — three fetches, `r17` confound-free. **`2026-08-03-r18` (opus) does not fetch**, which is the observation that unsettles the row above |
| Blocked on | nothing |
| Proof design | — |

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
