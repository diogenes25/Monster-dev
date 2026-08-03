# `#056` — a scenario's audit record names the criterion that was at risk to the blind scorer of *every* later run against it

| | |
|---|---|
| Status | `proven` |
| Gate | `none` |
| Attribution | harness artefact |
| Criterion | none directly — it weakens the *second* scoring of whatever criteria the scenario has |
| Target file | both scenarios, `process/tools/score-bundle.ps1`, the skill and the scenario template |
| Evidence | `2026-08-03-r12`; found while applying `#047`, and **much larger in `alt-a-left-to-right.md`** than as filed — see the `2026-08-03` `proven` entry |
| Proof design | `Gate: none` — applied, not proven by a run. What can be checked mechanically is checked: `score-bundle.ps1` now refuses a bundle whose criteria half names any run id, and both refusal paths were exercised against a probe scenario before the real bundles were rebuilt |

**What happened.** `#047` is closed by a refusal: `score-bundle.ps1` now deletes a bundle whose
stripped scenario names **the run being scored**. Verified — `nowhere-to-walk.md` names
`2026-08-03-r12` at lines 109, 193 and 220, and a bundle for `r12` refuses.

A bundle for a *different* run against the same scenario does not, and should not — the guard is keyed
on the caller's run id and a foreign id is exactly the residual anchor `#047` decided to report rather
than strip. But the passage it reports is this:

> Two of these rows used to name a surface, and that was the defect the pre-run audit of
> `2026-08-03-r12` found. […] scoring criterion `7` as a fail afterwards would have been scoring the
> answer script rather than the hire.

**The criteria are shared between the two runs.** So the blind scorer of a future `nowhere-to-walk`
run reads that the setup for an earlier run had a defect, and that criterion `7` was the one thought
to be at risk. The label on the map changed; the map did not. A second reader that knows where to look
is not the reader the second pass was designed to be.

**Why this is a separate item and not a line in `#047`.** `#047`'s question was *which run is the
scorer holding*, and the answer to it is mechanical, cheap and now enforced. This one is *which
criterion is the scorer told to look at*, and it cannot be answered by keying on a run id, because the
disclosure survives every id. It also gets worse on its own schedule: the more careful the audit, the
sharper the map, and `#047`'s log says so.

**Proposed change.** Not drafted. `#047`'s two original candidates both still apply, and `C` being in
place changes the balance between them:

> **A — move the record.** The audit's findings go in `process/fixtures/<name>.md` and the item's log,
> and the scenario keeps only the *current* wording of the answer script plus a bare pointer. Cost: the
> reasoning for a deflection row is one file from the row, and the row is where somebody about to
> reword it is looking. `#047` declined A partly on that cost — but the `Pre-answered` section written
> for `#054` is a working precedent for a fixture note carrying exactly this kind of material.
>
> **B — fence the record.** A `## Audit record` heading cut by the same mechanism as `## Run log`.
> Cost: a second hardcoded heading, and a scenario omitting it leaks silently. **`C` weakens this
> objection**, because a missing heading no longer leaks *the sharpest* thing — self-naming is caught
> mechanically either way.

**Cost.** Small either way, and one thing not to trade, quoted from `#047` because it has not stopped
being true: whatever is chosen must not make it *harder* to record what an audit found. The audits are
the most productive check this project has added.

**Log.**

- `2026-08-03` `intake` — found while applying `#047`'s chosen fix and verifying what it did *not*
  cover. Filed rather than written into `#047`'s log, because that item is now `proven` and a `proven`
  item is one nobody reads again.
- `2026-08-03` `proven` — **neither `A` nor `B`, and the item was three times its filed size.**

  **The scope first, because it is the part that was wrong.** This was filed against
  `nowhere-to-walk.md`, on the strength of one paragraph naming criterion `7`. Checking
  `alt-a-left-to-right.md` before choosing a fix found the same defect several times over and much
  sharper: its three criteria-boundary sections sat **above** the cut and read *"`13b` had failed
  **12 of 12**"*, *"`r15` and `r14` both **passed** all three marks of `10`, both **failed** `13b`"*,
  *"`10`'s **ten passes** were assent"*, *"`11`'s **seven passes** were scored on code presence"*.
  A blind scorer of the next `static-site` run would have read every criterion's verdict history,
  by number, with counts. The `nowhere-to-walk` paragraph was the smaller instance of the pair.

  That killed option `A` — *move the record into `process/fixtures/<name>.md`* — outright. The
  boundary sections are about **criteria**, not about the fixture, and a fixture note is the wrong
  home for them however well the `#054` precedent worked for the `Pre-answered` table.

  **What was done instead is `B` without `B`'s cost.** `B` proposed a second fenced heading cut by
  its own mechanism, and objected to itself: a scenario that omits the heading leaks silently. But
  the cut already in place takes **everything from `## Run log` down**, so a section placed *after*
  the run log is already excluded — by a heading that `score-bundle.ps1` hard-fails on when absent.
  Both scenarios now carry a `## Provenance` section there. No second heading was added and no new
  silent-omission mode exists.

  **The rule this establishes, which is the durable part:** above the cut goes what a scorer needs
  to reach a verdict — the setup, the *current* wording of the answer script, the criteria, and the
  rules for scoring them. Below it goes how the file got that way. A criterion's history is not an
  instrument. Stated in both scenarios, in the skill's step 1, and in the scenario template.

  **And `#047`'s NOTE was escalated to a refusal, which is what makes this more than discipline.**
  `score-bundle.ps1` now deletes a bundle whose criteria half names **any** run id, not just the run
  being scored. The old NOTE said *"read those passages before trusting a close verdict"* — advice
  to the wrong person, since by the time anybody reads it the disclosure is already in the bundle.
  The reason it was ever a NOTE was that *stripping* prose by pattern would take criteria with it;
  **refusing** was available all along and hands the passage back to a human instead.

  `#047`'s own check was kept and moved **first**, so its sharper message still fires. It is not
  redundant: the general check keys on a *dated* id, so a run called `ph0-smoke` is caught only by
  the specific one.

  **Verified rather than asserted**, in this order: a probe scenario proved both refusal paths fire
  and delete their bundle, and that the `#047` message wins when both apply; real bundles were then
  rebuilt for `2026-08-03-r12` against `nowhere-to-walk` and `2026-08-03-r14` against `alt-a` — the
  first would have been refused before this change — and both came out with `RunIdsInProse: (none)`,
  all 13 and all 21 criteria still present, and no verdict-shaped residue. The scoring root was left
  empty, since a bundle blocks the next hire.

  **Two things this does not close, and both are stated rather than left to be discovered.**

  - **The refusal is narrower than the rule.** *"Its ten passes were assent"* names no run and gives
    the same thing away. `## Provenance` stays a discipline applied by a reader; the script catches
    only the anchor that makes a disclosure attributable.
  - **The sweep found two passages the refusal could not have.** `` `phase2b` failed this `` and
    *"did not exist for any run before `sonnet-base2`"* name runs **undated**, so the pattern misses
    them. Both were moved by hand. The pattern was deliberately **not** widened — a looser one starts
    firing on ordinary words — and the limit is recorded in the `alt-a` provenance section where the
    second one used to live.

  One consequence for the imminent `#043`/`#046` run: the caveat both items carry — *"the blind
  scorer will read the passage naming criterion `7`"* — is discharged. It does not need declaring in
  that run's report any more, because the passage is below the cut.
