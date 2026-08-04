# `#052` — the reduced-motion instrument returns `null` where the criterion expects `0`, and cannot tell *never moved* from *moved, then hid*

| | |
|---|---|
| Status | `proven` |
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
- `2026-08-03` `proven` — applied to `verify-run.mjs`. The two point probes became one in-page poll,
  `pollTravel(maxMs)`, sampling every 100 ms from the trigger until the element is gone or 4 s pass.
  `travelledPx` is `max(x) − min(x)` over the samples actually taken; `samplesTaken`,
  `disappearedAfterMs` and `x.{first,last,min,max}` are new. `11a`'s wording is untouched, as the
  item argued it should be.

  The loop runs **in the page** rather than as 40 CDP round-trips, so the interval means what it says
  and the whole window costs one `Runtime.evaluate`. That also disposes of the wall-clock caveat: the
  block is ~200 ms longer than the two sleeps it replaced, not four seconds longer.

  **Verified against a known implementation rather than reasoned about**, which is the point of the
  note this run's report ends on — *a check that confirms what you expected has earned less trust
  than one that surprises you.* `index.html` under emulated reduced motion parks the walker at
  `translateX(40vw)`, so it is the *appeared and did not move* case the old instrument scored `null`:

  ```json
  "reducedMotion": { "x": { "first": 474, "last": 474, "min": 474, "max": 474 },
                     "travelledPx": 0, "samplesTaken": 38, "disappearedAfterMs": null,
                     "afterTrigger": 1, "stillOnScreenAfterCrossing": 1 }
  ```

  `0` where it used to be `null`, over 38 samples. A crossing that tidied up after itself now reads
  as a large `travelledPx` **plus** a `disappearedAfterMs`, so the two outcomes that shared one
  reading no longer do. The same run reproduced every other figure the reference is known for — 23
  steps, 11 whole cycles, 10.56 s against 6.72 s at the narrow width — so the poll did not disturb
  anything upstream of it.

  **One change to a field a report quotes, named because it is otherwise silent:**
  `reducedMotion.afterTrigger` is now derived from the poll's samples instead of probed once at
  0.8 s. Same question, and it can no longer miss an appearance shorter than the probe delay — but a
  reader comparing this field across the boundary is comparing two instruments.

- `2026-08-04` — **the same instrument, the sibling conflation, one level up.** This item fixed
  `travelledPx` so *never moved* and *moved, then hid* stopped reading alike. `2026-08-04-r20` shows
  that **`stillOnScreenAfterCrossing` now has the same problem**: it read `0` with
  `disappearedAfterMs: 3008`, which says *the hire chose to hide it under reduced motion* — and the
  hire did not. `style.css:115` parks it (`transform: translateX(40vw)`, animation none), exactly
  like `index.html` and `impl-01`; the disappearance is `script.js:35`,
  `setTimeout(() => walker.remove(), 3000)`, the **generic per-walker cleanup** that runs whether or
  not reduced motion is on.

  So the number conflates *hid it deliberately* with *the ordinary cleanup timer fired inside the
  observation window*. `11b` is `INFO` precisely so it can accumulate evidence for a future §5
  decision, and a number that mixes two behaviours accumulates nothing — the record is **3 park,
  0 hide**, not 2 park 1 hide as the raw figure suggests.

  **The primary scoring got this wrong off the number alone and the blind pass caught it** by reading
  the stylesheet and the timeout. Not filed as a new item: same instrument, same family, and whoever
  next opens `verify-run.mjs`'s reduced-motion path needs both halves in one place. What would fix
  it is a field saying **why** it left — animation end, explicit removal, or still there when the
  window closed.
