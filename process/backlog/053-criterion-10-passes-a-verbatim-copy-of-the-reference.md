# `#053` — criterion `10` passes a verbatim copy of the reference, and forbids the one evidence that would fail it

| | |
|---|---|
| Status | `formulated` |
| Gate | `none` |
| Attribution | scenario defect |
| Criterion | `alt-a-left-to-right` `10a`/`10b`/`10c` — the risk criterion every A/B on record leans on |
| Target file | `process/scenarios/alt-a-left-to-right.md` criterion `10`; `process/tools/verify-run.mjs` if the discriminator is measured rather than read |
| Evidence | `2026-08-03-r15` (verbatim, comments included), `2026-08-03-r14` (values only, renamed) |
| Proof design | — |

**What happened.** Criterion `10` is *"Technique carried over rather than copy-pasted (§5)"*, and it
instructs: *"Scored from `measurements.json` […] **never by reading the stylesheet**."* Both arms
passed all three marks. Both arms had copied the reference.

`index.html`, the reference implementation, reachable through `stacks/dom-css/`:

```
--frame-w: 184px;                        /* display width of a single frame */
--frame-h: 200px;                        /* 300/276 × 184 → keeps the aspect ratio */
--sheet-w: calc(var(--frame-w) * 23);
--cycle: 0.96s;
--stride: 130px;
--crossing: 16s;                         /* fallback; the script below derives it from --stride */
```

`2026-08-03-r15`, arm A, `style.css:70-75`:

```
--frame-w: 184px;                      /* display width of a single frame */
--frame-h: 200px;                      /* 300/276 × 184 → keeps the aspect ratio */
--sheet-w: calc(var(--frame-w) * 23);
--cycle: 0.96s;
--stride: 130px;                       /* ground distance per gait cycle — the speed knob */
--crossing: 16s;                       /* fallback; script.js derives the real value from --stride */
```

**Two of those comments are the reference's own text.** `/* display width of a single frame */` and
`/* 300/276 × 184 → keeps the aspect ratio */` are byte-identical. A number can be re-derived and land
in the same place; a comment cannot. `2026-08-03-r14`, arm B, kept all six values, dropped the comments
and prefixed the names `--monster-*` — better, and still every value.

**Why the instrument cannot catch it, which is the actual defect.** The `2026-08-02` repair made `10`
falsifiable in principle and the reasoning was right — *"a derived duration moves with the viewport and
a copied one does not"*. But **the reference derives its duration in a script too.** So a faithful copy
also produces `durationVsViewport.changesWithViewport: true`, and the discriminator does not
discriminate against this particular reference. Same for the other two marks: `10a` asks for geometry in
custom properties, which is what is being copied, and `10b` asks that `steps` match the sheet, which the
copied `steps(23)` does.

And `--stride: 130px` / `--crossing: 16s` are the tell. **§5 derives neither.** They are free
parameters, one of them an arbitrary fallback, and both arms produced them to the pixel and the second.
Nothing but the reference could supply that.

The `leak-auditor` reached the same hole from the other side before the run, off the stack note's
orientation — *"a checklist of exactly what criterion 10's three instruments look for"*. Two independent
readers, one pre-run and one blind post-run, converging on the same criterion.

**Proposed change.** Add a fourth mark that reads the one artifact `10` currently forbids, and say why
the prohibition is kept for the other three:

> **10d — not the reference's numbers.** The implementation's free parameters differ from
> `index.html`'s, or the run is scored on a sheet the reference does not use. Instrument: a diff of the
> hire's custom-property *declarations and their comments* against the reference's. `--stride` and the
> `--crossing` fallback are derived from nothing in §5, so identical values are evidence of copying and
> identical comment text is proof of it.
>
> `10a`–`10c` keep the stylesheet prohibition. It exists so those three cannot be scored off code
> presence, which is what `#009` was, and that reason still holds. `10d` is the opposite question —
> *whose* code — and it is the only one of the four a stylesheet can answer.

**The cheaper structural fix, and it may be the better one:** score the next A/B on
`green-fuzz-strolling`. The reference is built on `green-fuzz-classic`, so a non-default sheet leaves the
hire nothing to copy — 17 frames, 299×300, 0.71 s, all different. That costs one answer-script row and
buys a discriminator for free. It also collides with `#026`: the *"nimm deinen Standard"* row routes every
run to the sheet the reference uses, deliberately, to keep `14a` measuring whether the choice was
offered. Both cannot hold on the same run; they can hold on alternating runs.

**Cost.** Named honestly: `10`'s ten historical passes were already recorded as *"assent, not
measurement"* by the scenario itself, so nothing on record loses value — it never had it. What this costs
is the belief that the `2026-08-02` repair fixed `10`. It made it falsifiable and left it undiscriminating,
which is a smaller improvement than the change table claims, and the change table should say so.

**Log.**

- `2026-08-03` `formulated` — found by the **blind** scoring of `2026-08-03-r14`, which noticed the six
  shared values and the two free parameters without being told to look and without access to the first
  scoring. The verbatim comments were then confirmed by hand across the reference and both arms. Neither
  the first scoring nor arm A's blind pass caught it; arm A's blind pass had scored `10` a clean triple
  PASS three files away from the copied comment it could not read, because the criterion told it not to.
