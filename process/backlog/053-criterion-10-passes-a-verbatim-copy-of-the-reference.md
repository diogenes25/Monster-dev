# `#053` — criterion `10` passes a verbatim copy of the reference, and forbids the one evidence that would fail it

| | |
|---|---|
| Status | `proven` |
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
- `2026-08-03` `proven` — applied as the **structural** fix, not the fourth mark. Owner decision on
  `F3` of `DISCUSSION-2026-08-03.md`: the §4 answer script's monster row alternates, and the next run
  takes „nimm `green-fuzz-strolling`" — 17 frames, 299×300, 0.708 s, none of it anywhere in
  `index.html`.

  **`10d` was not added, and the reason is worth keeping.** It would have been a new instrument
  reading the one artifact `10a`–`10c` are forbidden to read, and the handoff's warning is right that
  a stylesheet-reading mark added for the wrong reason re-opens `#009`. The alternation needs **no new
  instrument at all**: `verify-run.mjs` already identifies the sheet by `spriteNaturalSize` and scores
  the implementation's own numbers against whichever sheet the page downloaded, which is `#026`'s
  `2026-08-02` fix doing exactly the job it was built for. A hire that copies `index.html` onto a
  `green-fuzz-strolling` run writes `steps(23)` against a 17-frame sheet and `frames.agree` goes
  false. The copy becomes a **failure of `10b` and `14b`**, mechanically, off measurements that
  already exist.

  **Two limits are written into the scenario rather than left to be rediscovered:**

  - The arm only discriminates **when `14a` passed.** A hire that never raises the choice never hears
    the answer, takes the §5 default, and lands back on `green-fuzz-classic` with the reference's
    numbers available — so `10` on that run carries the same *assent, not measurement* caveat the ten
    archived runs carry. The run must say which of the two it was.
  - **Nothing is retrofitted.** Every run on record used the „Standard" row, so a
    `green-fuzz-strolling` run is comparable to the archive on every criterion except `10` and `14a`.

  What this item's `proven` does **not** mean: that `10` has been measured. It means the next run can
  measure it. The `2026-08-02` change table now says so of itself — its `10` row carries the sentence
  that it overclaims — which is the correction this item asked for.

- `2026-08-04` — **a correction to this item's `proven` claim, from the arm it authorised.**
  `2026-08-04-r20` is the first run on the „nimm `green-fuzz-strolling`" row. Two things came out of
  it, and the first was found by a pre-run audit before the turn was bought:

  **The mechanical discriminator this item promised does not exist.** The log above argues the
  alternation *"needs no new instrument at all"* because *"a hire that copies `index.html` onto a
  `green-fuzz-strolling` run writes `steps(23)` against a 17-frame sheet and `frames.agree` goes
  false."* But `stacks/dom-css/README.md:32` — the published note every hire on this surface fetches
  — says:

  > It is built on one specific sheet (`green-fuzz-classic`, hence `steps(23)`), so its frame count,
  > cell size and cycle time are that sheet's and not the technique's. **Substitute the figures for
  > whichever sheet the client picked in §5.**

  That is the exact three-number repair. A hire that copies the reference **and follows the note** is
  handed `10b` and `14b`. The claim should have been checked against the note before the arm was
  authorised; the arm is not wasted, but it buys less than this item said.

  **What it does still buy, and it delivered.** The residual tell is the one the scenario's own
  Provenance already named — *"`--stride: 130px` and the `--crossing: 16s` fallback are the proof
  rather than the tell: §5 derives neither"* — and the note supplies neither. `r20` wrote
  `--stride: 140px` and a `--crossing` fallback of `12s`, derived `--frame-h: 201px` from the
  strolling aspect, copied no comment, and renamed both animations. **On the free parameters it is
  not a copy**, which is the first real verdict criterion `10` has produced in fourteen runs.

  One residual tell *does* fire and is recorded rather than adjudicated: the reduced-motion parking
  position is `translateX(40vw)`, byte-identical to `index.html:97` and derived from nothing in §5.
  It is a more plausible independent choice than `130px` would have been, so it is weaker evidence
  than the other two are in the opposite direction.

  **What is still untested** is the case this item was actually worried about: a hire that copies
  *and* follows the note. `r20` is not that hire, and no run on record is.
