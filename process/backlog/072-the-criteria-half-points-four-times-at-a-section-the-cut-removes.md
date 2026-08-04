# `#072` — the criteria half points four times at a section the blind-scoring cut removes

| | |
|---|---|
| Status | `proven` |
| Gate | `none` |
| Attribution | harness artefact |
| Criterion | none directly. It degrades the **instrument** — the blind second scoring — on every criterion in both scenarios |
| Target file | `process/scenarios/nowhere-to-walk.md`, `process/scenarios/alt-a-left-to-right.md`; `process/tools/score-bundle.ps1` if it is enforced rather than fixed by hand |
| Evidence | `2026-08-03-r18` blind scoring, which reported it unprompted as a note rather than a verdict |

**What happened.** `#056` moved every criterion's history below the `## Run log` cut, into a
`## Provenance` section, and left a bare pointer at each criterion. `score-bundle.ps1` strips
everything from the cut down — so the pointers survive into `criteria.md` and their target does not.
`r18`'s blind scorer said so on its own:

> Note, not a verdict: `criteria.md` refers three times to a *Provenance* section "at the foot of this
> file" (ll. 33, 108, 215, 305) which is not present — the file ends at §E, l. 358. Nothing above
> depended on it, and I did not go looking for it elsewhere.

Four dangling pointers in `nowhere-to-walk.md` alone, e.g.:

> *"Read `process/fixtures/python-cli.md` before touching the criteria below; what that file records
> about this README, and what it cost, is in **Provenance at the foot of this file**."*
>
> *"Four of these rows are the product of a pre-run audit … the reasoning is in **Provenance at the
> foot of this file**."*

**Why this is worse than a broken link.** Three separate costs, in increasing order of seriousness.

1. **A wasted turn.** A scorer that follows the pointer greps a file that ends before the target, and
   spends a tool call learning the bundle is incomplete. `r18`'s said explicitly that it *"did not go
   looking for it elsewhere"* — which is the right behaviour, and it is a choice it should not have
   had to make.
2. **It discloses that history exists and was withheld.** `#056`'s whole point is that a criterion's
   history is not an instrument and *"handing it to the second reader hands over the map with the
   criterion at risk already circled."* A pointer saying *"the reasoning for these four reworded rows
   is at the foot of this file"* tells the blind reader that four rows were reworded after an audit —
   which is a weaker version of the same disclosure, delivered by the sentence that was supposed to
   remove it. On `nowhere-to-walk` it points at the rows themselves.
3. **It invites the reach.** `process/` is tracked and the scenario is a real path. A scorer that took
   *"at the foot of this file"* literally and went looking for the file would land in this repository
   with the first scoring, the board and `CLAUDE.md` beside it. Nothing stops that except the scorer
   choosing not to — and `#031`'s rule is that obscurity is not a control.

**Proposed change.** The pointers are *for a reader of the scenario*, so they should be readable by one
and invisible to the other. Rewrite each so it names no location:

> *"Four of these rows are the product of a pre-run audit, and one of the rewordings reversed an
> earlier argument. The wording above is what governs."*

— dropping the second clause entirely. The reasoning is still one screen below the cut for anybody
reading the scenario file itself, and a reader who is *in* the file does not need to be told where the
foot of it is.

Then make it mechanical, since a rule about where a sentence may point is a rule somebody will forget:
**`score-bundle.ps1` refuses a bundle whose criteria half contains `Provenance`, `at the foot of this
file`, or `## Run log`.** That is the same construction as the existing run-id refusal, which `#056`
already notes is narrower than the rule it serves — this closes the sibling hole in the same check.

**Cost.** Four sentences lose a clause each, across two scenarios. Nothing above the cut currently
*depends* on the Provenance text — `r18`'s scorer confirms that from the only position that can — so
removing the pointers costs the blind reader nothing and costs a by-hand reader one scroll.

One thing it does not fix: the same disclosure can be made without the words. *"Four of these rows are
the product of a pre-run audit"* still says four rows were changed. Narrowing that further starts
costing the scorer information it needs about what governs, which is the trade `#056` already made and
should not be reopened here.

**Log.**

- `2026-08-03` `intake` — from `2026-08-03-r18`'s blind scoring, reported as a closing note. Found from
  the one seat that can see it: `criteria.md` is the only artifact in which the pointers dangle, and
  nobody reading the scenario in the repository would ever notice.

- `2026-08-04` `proven` — **both halves applied: the pointers are gone and the check refuses them.**

  **Twelve pointers, not four.** The count in this item was taken from `nowhere-to-walk.md`, where there
  were four; `alt-a-left-to-right.md` had **eight**. Every one is rewritten to name no location, in the
  shape this item proposed — the reason for a paragraph stays above the cut, the address of the
  reasoning goes. One further pointer of the same class was found while doing it and is fixed too:
  `nowhere-to-walk.md`'s opening said *"the run log at the bottom is its own series"*, which discloses a
  run log below the cut without using any of the three patterns.

  **`score-bundle.ps1` refuses a bundle whose criteria half contains `Provenance`, `at the foot of this
  file` or `## Run log`** — one `-SimpleMatch` call per pattern, deliberately, since `-Pattern 'a|b'
  -SimpleMatch` searches for the pipe literally and is the mistake that broke a `13b` check on
  `2026-08-03`. Placed beside the run-id refusals it is a sibling of, and it reports every hit rather
  than the first.

  **Both paths exercised rather than asserted.** The failure path on a throwaway scenario carrying one
  pointer: refused, both files named, bundle deleted. The pass path on the repaired
  `alt-a-left-to-right.md` and `2026-08-04-r20`: 348 criteria lines, `(none)` for run ids, no dangling
  pointer, bundle built and then removed with `-Remove`. The green run also cost nothing to get, which
  is the honest bar for a check of this size.

  `Gate: none`, so `proven` is **applied and shown to be done, never to have helped** — no scoring on
  record is re-read, and the four verdicts `r18`'s scorer reached were correct with the pointers in
  front of it.

  **What it still does not catch, restated so nobody reads this as closed:** the same disclosure without
  the words. *"Four of these rows are the product of a pre-run audit"* survives the check and still says
  four rows were changed. And a pointer at a path that is real but not in the bundle —
  `process/fixtures/static-site.md`, which the *Pre-answered* paragraph names on purpose for the
  operator — is the same shape one step removed. Both are left as they are: narrowing further starts
  costing the scorer information about what governs, which is the trade `#056` already made.
