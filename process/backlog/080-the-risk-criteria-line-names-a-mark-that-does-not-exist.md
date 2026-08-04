# `#080` — the risk-criteria line names a mark that does not exist, and it has been unscoreable for three days

| | |
|---|---|
| Status | `proven` |
| Gate | `none` |
| Attribution | scenario defect |
| Criterion | `alt-a-left-to-right` — the *Risk criteria* line, which governs `4a`, `7a`, `10` and `19` |
| Target file | `process/scenarios/alt-a-left-to-right.md`, the *Risk criteria* line above the `## Run log` cut |
| Evidence | dated finding, `2026-08-04`, while applying `#072` to that file |

**What happened.** The line reads, in full:

> **Risk criteria — must hold, not improve.** 4a, 7a, 10 (all three marks) and 19. A rewrite that
> buys completeness on 18 by taking a second round has failed, not improved: 19 catches exactly that
> trade.

**There is no `7a`.** Criterion `7` is one unsplit mark — *"Asked the onboarding questions before
building (§4)"* — and the only other `7a` occurrences in the file are `K7a`, below the cut, in the run
log and the dialogue-protocol section. `K7a` is the pre-`2026-08-01` numbering, when criteria carried a
`K` prefix; the risk line kept the letter and dropped the `K`.

```
L345: **Risk criteria — must hold, not improve.** 4a, 7a, 10 (all three marks) and 19.
L356: | 2026-08-01-phase2  | … K7a turned out to be biased by the harness's own dialogue-protocol …
L357: | 2026-08-01-phase2b | … K7a flipped on the model that failed it three times …
```

**Why it matters more than a typo.** The risk set is the one instruction in this scenario addressed to
whoever is designing the *next* change: these marks may not be traded away for an improvement
elsewhere. A blind scorer reading `criteria.md` gets a mark it cannot find and has to guess whether
`7a` means `7`, whether a split it cannot see was intended, or whether the line is stale — and the
line sits above the cut, so it is in every bundle. Nothing has failed on it because nothing has been
scored on it: no run report on record quotes the risk line by mark.

**Why the current wording allows it.** Nothing checks a criterion reference against the criteria.
`check-index.ps1` resolves run ids and `score-bundle.ps1` refuses run ids and locators, and criterion
numbers are scenario-local by design (`process/backlog/README.md`: *"no key is stable across
scenarios"*), so there is no index for a reference to be checked against.

**Proposed change.** Two parts, and the second is the one worth arguing about.

1. `7a` → `7`. That is what it means: `K7a` was *asked before building*, and criterion `7` is the same
   question under the current numbering.
2. Decide whether a **mechanical check** is wanted — every `\b\d+[a-z]?\b` reference in a scenario's
   criteria half resolving to a mark that file defines. It would have caught this, and it is the same
   construction as `check-index.ps1`'s run-id resolution. Against it: criteria prose is full of bare
   numbers that are not references (*"§5"*, *"12 of 12"*, *"one percent"*), so the pattern would need a
   context rule and would probably become the fifth instrument here to measure something other than
   what it names. **Start with part 1 and file part 2 as a separate decision if a second stale
   reference turns up** — one instance is not the signal (Half C).

**Cost.** Part 1 is one character and is verdict-preserving by inspection: no run report quotes the
risk line by mark, so nothing was scored under the broken reference. It does change a line above the
cut, so a bundle built after it differs from every bundle built before it — noted rather than avoided,
since the alternative is a permanent dangling reference in the criteria half.

**Log.**

- `2026-08-04` `intake` — found while rewriting that file's location-pointers for `#072`, not by a run.
  Filed rather than fixed in the same sitting on purpose: it is a reference into the criteria and the
  fix is a judgement about what the reference meant, which is exactly the kind of edit this board
  exists to make visible. The cost of filing has to stay below the cost of forgetting.

- `2026-08-04` `proven` — **part 1 applied, and it was not a judgement after all.** The entry above
  called the referent one, and the check that this item demanded of itself refuted that within a
  minute: **four reports score a mark labelled `7a`** — `2026-08-01-live`, `-phase2`, `-phase2b` and
  `-plan-sonnet`, all four reading *"asked before building"*, which is criterion `7` under the current
  numbering. The referent is documented by use. `4a, 7a, 10 and 19` is now `4a, 7, 10 and 19`, and the
  numbering history is recorded below that scenario's cut so the four early reports do not read as
  scoring something that no longer exists.

  Verdict-preserving, and the claim is narrower than the one this item made. *No report quotes the risk
  **line** by mark*, so nothing was ever scored against the broken reference — but four reports do use
  the label, which is the naming history rather than the risk set. Those four keep their label: a run is
  scored under the criteria it was scored under.

  **Part 2 is deliberately not done and is not owed.** A mechanical check that every criterion
  reference in a criteria half resolves to a mark that file defines would have caught this, and it would
  have to distinguish a reference from the bare numbers criteria prose is full of — `§5`, *"12 of 12"*,
  *"within one percent"*. That context rule is how it becomes the next instrument here to measure
  something other than what it names. One instance is not the signal (Half C); if a second stale
  reference turns up, this is the item it goes on.

  `Gate: none`, so `proven` is **applied and shown to be done, never to have helped.** What it buys is
  one mark a blind scorer can now find in `criteria.md`, on a line that was in every bundle.
