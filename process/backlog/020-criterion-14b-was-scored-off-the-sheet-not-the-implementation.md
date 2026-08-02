# `#020` — criterion `14b` asks about the implementation's numbers and was scored off the sheet's, in every run

| | |
|---|---|
| Status | `formulated` |
| Gate | `none` |
| Attribution | scenario defect |
| Criterion | `14b` |
| Target file | `process/scenarios/alt-a-left-to-right.md`, `process/tools/verify-run.mjs` |
| Evidence | `2026-08-01-plan-sonnet` (all three arms), found `2026-08-02` by the blind second scoring |
| Proof design | — |

**What happened.** `14b` asks:

> With no preference stated, did it use `green-fuzz-classic` — and **are the frame count, cell size
> and cycle in the implementation that sheet's?**

The evidence recorded for it in `2026-08-01-plan-sonnet.report.md:59`, for all three arms, is:

> `6348×300 = green-fuzz-classic`, `steps(23)`

`6348×300` is the **sheet's** size. The criterion asks about the implementation's. The
implementation, `worktree/style.css:66-69`:

```
--monster-frame-w: 184px;
--monster-frame-h: 200px;
--monster-sheet-w: calc(184px * 23);
--monster-cycle:   0.96s;
```

The sheet's cells are `276×300`. `184×200` is a uniform two-thirds scale of that — `276 × 2/3 =
184`, `300 × 2/3 = 200`, and the background-size follows at `184 × 23`. Frame count and cycle are
the sheet's; **cell size is not, and was never checked.**

Whether that is a pass is a real question and the criterion does not answer it. Scaling a sprite
down for display is ordinary and correct — a 300px monster on a marketing page would be enormous —
and the ratio is exact, so nothing is distorted. But *"cell size in the implementation is that
sheet's"* read literally is false, and a hire that had written `184×210` would have failed the same
criterion on the same evidence, because the evidence never looked.

**Why the current wording allows it.** The criterion names three quantities and one authority, and
does not say whether the third is compared literally or proportionally. Two of the three are
scale-invariant — a frame count and a duration cannot be scaled by accident — so only the ambiguous
one is unguarded, and it is unguarded in the direction where a real error hides: a *wrong aspect
ratio* is exactly the mistake that produces a squashed monster, and it is what `14b` was written to
catch.

**Proposed change.**

> **14b** With no preference stated, did it use `green-fuzz-classic`? And in the implementation:
> is the frame count that sheet's, is the cycle that sheet's, and does the cell **aspect ratio**
> match the sheet's cell to within a percent? A uniform scale is a pass and the display size is the
> hire's call; a changed aspect ratio is a fail, because that is the mistake this criterion exists
> to catch. Record the implementation's actual numbers, not the sheet's — the sheet's are in §5 and
> prove nothing about what was built.

**Proof design.** *`Gate: none`.* Scenario defect, the same lane as `#001`: there is no criterion for
this to flip because it *is* the criterion, and a run spent on it would measure nothing.

**Cost.** None to the product. It changes what `14b` means, so the scenario's *"criteria changed"*
note gains one more boundary line, alongside `15c` and section E. Runs before the edit compared on
frame count and cycle only; the aspect-ratio half has no prior measurement on record, because nobody
took it.

**Log.**

- `2026-08-02` `intake` — from the first blind second scoring under `#016`, backtesting
  `2026-08-01-plan-sonnet`. It scored `14b` PASS and then put it in `UNCERTAIN` with the arithmetic,
  which is exactly what that list is for.
- `2026-08-02` `formulated` — verified by hand against `worktree/style.css` before being written
  down. The primary report's evidence line was read the same day and does not mention the
  implementation's cell size at all.
- `2026-08-02` — **D3**: `verify-run.mjs` added to the target row. This item asks a criterion to
  record *the implementation's* numbers, and `measurements.json` carries `spriteNaturalSize` and the
  catalog's cell geometry — the **sheet's** numbers — and never reads the hire's
  `--monster-frame-w`. Rewording the criterion without extending the instrument would produce a
  criterion no run can satisfy, which is the fault `#021` names in its own words. **D2**: the
  scenario edit lands with `#001`, `#015` and `#021` under one boundary line.
