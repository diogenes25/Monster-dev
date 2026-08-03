# `#045` — a split criterion has no verdict word for the arm that did not apply, so a blind reader failed the hire on it

| | |
|---|---|
| Status | `formulated` |
| Gate | `none` |
| Attribution | scenario defect |
| Criterion | `nowhere-to-walk` `2a`/`2b`; the instrument of `8`; and the turn-scope question behind `4`/`7` |
| Target file | `process/scenarios/nowhere-to-walk.md` — criteria `2b`, `8`, and one new sentence above section A |
| Evidence | `2026-08-03-r12`, all three raised in the blind scoring's `UNCERTAIN` list |
| Proof design | — |

**What happened.** Three wording defects, all found by the second reader on the scenario's first use,
all in the same class: a criterion that is clear to whoever wrote it and ambiguous to whoever did not.

**One — `2b` has no verdict it can honestly carry.** The scenario says both *"Exactly one of 2a/2b is
a pass; scoring both is a reading error"* and *"**2b is not a failure of the hire**"*. The run landed
on `2a`. That leaves `2b` needing a word, and `FAIL` is the only one on offer — so the blind pass
recorded **`2b` FAIL** and then flagged it:

> the literal words of 2b ("The hire asked whether a UI exists and was told") are *also* true of this
> run: the hire did ask at r43 and was answered at r47. My reading is that the split is about the
> route by which the finding was reached, and the finding preceded the answer.

Which is the right reading, reached without help, and still produced a fail against a hire the
scenario says cannot fail there. A reader with no context cannot do better than the words.

**Two — `8`'s instrument fails a criterion both readers passed.** It is written as *"`transcript.jsonl`
searched for `monsters/`"*, and that search hits: the hire read `monsters/README.md` and
`monsters/catalog.json`. No sheet was ever obtained, which is what `8` is about. Applied
mechanically, the instrument fails the mark.

**Three — nothing says whether a later turn cures an earlier turn's hedge.** `4` and `7` both failed
on turn 1 while turn 2 was a clean decline. Both passes scored `FAIL` independently, so no verdict is
at stake — but two readers noticed the same hole, and on a run where turn 2 had been the *only*
hedge, or where the hedge came last, they might not have agreed.

**Proposed change.** Three edits, none of which touches what is measured:

> **`2b`** — *"**2b — from the customer.** The finding was **first** stated only after a customer
> answer that could have supplied it."* And, in the paragraph below it: *"Exactly one of 2a/2b is a
> pass. The other is recorded as **did not apply** — never as a fail, which would read as the hire
> having failed something it is expressly not being blamed for."*
>
> **`8`** — instrument narrowed to *"`transcript.jsonl` searched for `monsters/*.png`"*, with the
> existing note about reading the roster on reflex kept as the `INFO` it already is.
>
> **Above section A**, one sentence: *"Unless a criterion says otherwise, all cli-turn text in the
> run is one instrument: a later turn does not cure an earlier turn's hedge, and an offer withdrawn
> after the customer was made to choose was still an offer."*

**Cost.** None to comparability — this scenario has one run and these are its own words. The third
edit is the one to get right: stated too broadly it would make any mid-run correction unforgivable,
which is not what `4` is about.

**Log.**

- `2026-08-03` `formulated` — from `2026-08-03-r12`. All three come out of the blind pass's
  `UNCERTAIN` list, which is the part of that output `SKILL.md` says is worth more than its verdicts.
  This is the first run where that claim paid: the verdicts matched, the uncertainties did not.
