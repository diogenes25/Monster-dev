# `#047` — a scenario's record of its own pre-run audit reaches the blind scorer, and it names the criterion the audit was worried about

| | |
|---|---|
| Status | `proven` |
| Gate | `none` |
| Attribution | harness artefact |
| Criterion | none directly — it weakens the *second* scoring of whatever criteria a run has |
| Target file | `process/scenarios/nowhere-to-walk.md` (where the audit record lives), or `process/tools/score-bundle.ps1` (where the cut is made) — see below, the choice is the item |
| Evidence | `2026-08-03-r12`; `score-bundle.ps1` reported the residue itself |
| Proof design | — |

**What happened.** `score-bundle.ps1` cuts the run-log table and then reports what it could not cut:

```
NOTE: the stripped scenario still names 2 run id(s) in its prose.
RunIdsInProse : 2026-08-01-live, 2026-08-03-r12
```

The second is **the run being scored**. What those passages say is not a verdict, but it is a map:

> Two of these rows used to name a surface, and that was the defect the pre-run audit of
> `2026-08-03-r12` found. […] scoring criterion `7` as a fail afterwards would have been scoring the
> answer script rather than the hire.

So the blind reader is told which run it is holding, that the setup was corrected before the run, and
**which criterion the people who designed it thought was at risk**. It read the passage and scored `7`
a fail anyway, and it independently verified the repaired fixture README before starting — so nothing
about this run's verdicts is in doubt. The exposure is real regardless: a second reader that knows
where to look is not the reader the second pass was designed to be.

**Why it happened, and why it will recur.** The practice of recording an audit's findings *inside the
scenario* is new and is correct — `#022`'s log argues at length that a correction is a new object
needing its own reading, and the scenario is where a person measuring stands. But a scenario is also
`criteria.md`, and `score-bundle.ps1` strips exactly one thing: the run-log table. Every scenario that
records its own corrections from now on carries this, and the more careful the audit, the sharper the
map.

The script is right not to strip prose by pattern — `#038`'s cost paragraph and the script's own
comment both say cutting prose would take criteria with it. So the fix is not a better stripper.

**Proposed change.** Two candidates, and choosing between them is what this item is for:

> **A — move the record.** The audit's findings go in `process/fixtures/<name>.md` and the item's log,
> where they already partly are, and the scenario keeps only the *current* wording of the answer
> script plus a bare pointer. The scenario stops being a history of itself. Cost: the reasoning for a
> deflection row is one file further from the row, and the row is where somebody about to reword it is
> looking.
>
> **B — fence the record.** A single `## Audit record` heading at the end of the scenario, cut by the
> same mechanism as `## Run log`, so the prose stays where it is written and never reaches a bundle.
> Cost: a second hardcoded heading, and a scenario that omits it leaks silently — the same shape as
> the exclusion-list problem `CLAUDE.md` describes, where a green script is not evidence.

**B** looks cheaper and is probably wrong for that reason: it adds a rule to remember. Not decided.

**Cost.** Small either way, and one thing not to trade: whatever is chosen must not make it *harder*
to record what an audit found. The audits are the most productive check this project has added.

**Log.**

- `2026-08-03` `formulated` — from `2026-08-03-r12`, the first run whose scenario carried its own audit
  record. The tooling behaved exactly as designed and told the operator to read the passages, which is
  how this was noticed; `#038` is its neighbour, one layer out — that one is what the bundle *writes*,
  this one is what it *keeps*.
- `2026-08-03` `proven` — **neither A nor B: a third option, decided by the owner.** The script already
  detected the residue and printed the right sentence about it; what failed was that the sentence was
  read and not acted on. So the reporting stays for other runs' ids, and **the run being scored naming
  itself is now a refusal** — `score-bundle.ps1` deletes the bundle and throws, the same shape
  `build-dist.ps1` uses, with the offending lines quoted and the remedy named (move the passage to the
  fixture note or the item log; never stop recording what an audit found).

  Why not A: it moves the reasoning for a deflection row one file away from the row, and that row is
  where somebody about to reword it is standing. Why not B: the item's own verdict, that a second
  hardcoded heading is a rule to remember and a scenario omitting it leaks silently. C needs neither —
  it is keyed on the run id the caller already passed.

  Verified against the real case rather than reasoned about: `nowhere-to-walk.md` names
  `2026-08-03-r12` at lines 109, 193 and 220, so a bundle for `r12` now refuses; a bundle for a new run
  id against the same scenario finds nothing and behaves exactly as before.

  **What this closes and what it does not.** It closes the sharpest case — *the blind reader is told
  which run it is holding.* It does **not** close the general one: a future run against
  `nowhere-to-walk` still reads that `2026-08-03-r12`'s audit found a defect and which criterion was at
  risk, and the criteria are shared between the two runs, so the map survives with a different label on
  it. That is a distinct question with the same two candidate fixes and it is **filed as `#056`** rather
  than left inside a `proven` item, because a `proven` item is one nobody reads again.
