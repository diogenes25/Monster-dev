# `#009` — The verifier keeps measuring a proxy for visibility, and the proxy keeps being wrong

| | |
|---|---|
| Status | `proven` |
| Gate | `none` |
| Attribution | harness artefact |
| Criterion | `1`, `4b`, `5` — all three mis-scored at once |
| Target file | `process/tools/verify-run.mjs` |
| Evidence | `2026-08-01-live`, `2026-08-01-plan-sonnet` |
| Proof design | — |

**What happened.** Twice, in two different disguises, and that is why it is on the board rather than
only in a report's harness notes.

*Level one, `2026-08-01-live`.* The verifier counted mere **presence** in the document. A hire that
kept its markup in `index.html` from page load was scored as if the monster were already walking.
Fixed by switching to `checkVisibility()`.

*Level two, `2026-08-01-plan-sonnet`.* `checkVisibility()` has no idea *where* an element is. That
hire parks its walker one frame-width off the left edge —
`transform: translateX(calc(-1 * var(--monster-frame-w)))` — and slides it in on the trigger.
`checkVisibility()` says yes the whole time, so the measurement returned
`onLoad 1 / afterBareKey 1 / afterCrossing 1`: three failures on criteria 1, 5 and 4b for a page
that behaved exactly as the customer asked.

**Why the current wording allows it.** Not a wording problem, and not a product fault. It is the
recurring failure mode of a verifier that has to stand in for *"the user can see it"* and keeps
picking a cheaper proxy: in the document → styled visible → inside the viewport. Each fix was
correct and each was still a proxy.

**Proposed change.** Applied during the run, per Half C (*"fix the harness, rerun, record nothing
against the product"*): `count()` requires the bounding rect to intersect the viewport as well.
Geometry sampling deliberately still uses the CSS-visible element, since every crossing legitimately
begins off-screen.

**Proof design.** *`Gate: none`.* A harness fix has no criterion to flip. Recorded as `proven`
because the value here is the pattern, not the patch: the next variant of this bug will arrive as a
fourth proxy that looks obviously right, and the two entries above are what make it recognisable as
a variant instead of a discovery.

**Cost.** Both arms were re-measured with the fixed verifier and the before-arm's numbers were
unchanged — the fix does not tilt the comparison it was found inside.

**Log.**

- `2026-08-01` `intake` — level one, from `2026-08-01-live`: presence ≠ visibility.
- `2026-08-01` `proven` — level two found and fixed in `2026-08-01-plan-sonnet`: CSS-visible ≠
  visible.
- `2026-08-02` — filed onto the board. Both levels had lived only in report harness notes, which is
  the shape of record that let `#001` be re-derived four times.
