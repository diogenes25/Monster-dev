# `#052` — the reduced-motion instrument returns `null` where the criterion expects `0`, and cannot tell *never moved* from *moved, then hid*

| | |
|---|---|
| Status | `formulated` |
| Gate | `none` |
| Attribution | harness artefact |
| Criterion | `alt-a-left-to-right` `11a` — `NOT SCORABLE` on its first real use |
| Target file | `process/tools/verify-run.mjs` (the `reducedMotion` block), and `11a`'s wording if the fix is there instead |
| Evidence | `2026-08-03-r15` and `2026-08-03-r14`, both `travelledPx: null` |
| Proof design | — |

**What happened.** `11a` was rewritten on `2026-08-02` to stop scoring code presence and start scoring
behaviour — one of the six criteria repaired in that pass, and the repair was right. Its instrument:

> **11a — scored.** It does not travel: `travelledPx` is 0.

Both arms measured:

```json
"reducedMotion": { "x": { "start": 500, "after3s": null }, "travelledPx": null,
                   "stillOnScreenAfterCrossing": 0, "waitedSeconds": 14 }
```

`null`, not `0`. Both implementations give the reduced-motion path a 2-second window
(`script.js`: `if (reducedMotion) setTimeout(endWalk, 2000)`) and the verifier samples at 3 seconds,
so the element is gone before the second reading and there is nothing to subtract. Scored
`NOT SCORABLE` in both arms, per the scenario's own rule that an instrument without a value is never
a `PASS`.

**And the sharper half, which the blind pass found and the first scoring did not:**

> the same `null` would appear for an implementation that travelled and *then* hid, so the current
> reading cannot distinguish the two.

So `null` is not merely a missing number. It is a value that **two opposite outcomes both produce** —
a correct static appearance and a full crossing that cleaned up after itself. That is the same defect
class as `#009`, where the verifier measured *CSS-visible* and called it *visible*: an instrument whose
reading does not separate pass from fail.

**Why it happened.** The 3-second sample is a reasonable choice against an implementation that parks
the monster and leaves it — which is what `index.html` does, and `11b` exists because of it. Neither
of the two hires that have now faced reduced motion did that; both showed it briefly and removed it.
The instrument was written against the reference implementation's shape and met a different one.

**Proposed change.** Sample the window rather than a point, and never report `null` for a measurement
that ran:

> Poll `getBoundingClientRect().x` every 100 ms from the trigger until the element is gone or 4 s have
> passed, and report `travelledPx` as `max(x) - min(x)` over the samples actually taken, plus
> `samplesTaken` and `disappearedAfterMs`. An element that was never there is `null`; an element that
> appeared and did not move is `0`. Those must not be the same value.

`11a` then reads unchanged and becomes scorable. If the fix goes into the criterion instead, it has to
name both the travel figure and the disappearance time, which is more wording for less precision — so
the tool is the better place.

**Cost.** Small. One caveat worth writing down: polling for up to 4 s per run is added wall-clock in a
verifier that already drives two viewport widths, and `#002`'s gate is stated in cost and turns — but
the verifier runs *after* the hire and outside the envelope, so it costs nothing that any gate reads.

**Log.**

- `2026-08-03` `formulated` — from `2026-08-03-r15` and `-r14`, the first two runs to reach `11a` since
  it became a behaviour criterion. Both `NOT SCORABLE`. The first scoring called it *"qualified —
  it appeared and was removed, so it demonstrably did not cross"*; the blind pass refused that and was
  right, because the reading it rests on is the same reading a full crossing would produce.
