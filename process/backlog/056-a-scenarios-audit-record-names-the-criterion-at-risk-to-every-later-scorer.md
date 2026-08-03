# `#056` — a scenario's audit record names the criterion that was at risk to the blind scorer of *every* later run against it

| | |
|---|---|
| Status | `intake` |
| Gate | `none` |
| Attribution | harness artefact |
| Criterion | none directly — it weakens the *second* scoring of whatever criteria the scenario has |
| Target file | `process/scenarios/nowhere-to-walk.md` (where such a record lives today), or `process/tools/score-bundle.ps1` |
| Evidence | `2026-08-03-r12`; found while applying `#047` |
| Proof design | — |

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
