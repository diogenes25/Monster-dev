# Step 03 — Build

Three files edited, one added. 104 inserted lines, nothing deleted, nothing moved. The full
before/after is [`../step-1-fixture/`](../step-1-fixture/) against
[`../step-4-result/`](../step-4-result/).

```
 assets/monster-sprite.png   | Bin 0 -> 1942313 bytes
 index.html                  |   6 ++
 script.js                   |  32 ++++
 style.css                   |  66 ++++++
```

## `index.html` — six lines, before the script tag

```html
<!-- walking monster easter egg — Monster-Dev (press Alt+A) -->
<div class="monster-walker" aria-hidden="true">
  <div class="monster-shadow"></div>
  <div class="monster-sprite"></div>
</div>
```

Two nested elements rather than one, because the two animations have to be independent: the
sprite steps through its frames while the walker translates across the viewport. One element
cannot carry both without them fighting over `transform`.

## `style.css` — geometry as custom properties

```css
:root {
  --monster-frame-w: 184px;
  --monster-frame-h: 200px;
  --monster-sheet-w: calc(184px * 23);
  --monster-cycle: 0.96s;
  --monster-stride: 130px;
  --monster-crossing: 16s;
  --monster-cycles: 1;
}
```

The cell is 276×300 in the roster; it is drawn at 184×200, two thirds of that. Nothing asked for
a size — *"keine Präferenz"* — so this is the default that was chosen and not discussed.

Two keyframe sets, one per element:

```css
@keyframes monster-walk-cycle {          /* the legs */
  from { background-position: 0 0; }
  to   { background-position: calc(-1 * var(--monster-sheet-w)) 0; }
}
@keyframes monster-cross {               /* the journey */
  from { transform: translateX(calc(-1 * var(--monster-frame-w))); }
  to   { transform: translateX(100vw); }
}
```

The sheet faces left, so the sprite carries `transform: scaleX(-1)` with the reason written next
to it: `/* sheet faces left; we walk left to right */`.

`prefers-reduced-motion` does not hide the monster — it parks it, visible and still, at
`translateX(40vw)`:

```css
@media (prefers-reduced-motion: reduce) {
  .monster-walker.is-walking { animation: none; transform: translateX(40vw); }
  .monster-walker.is-walking .monster-sprite { animation: none; }
}
```

## `script.js` — the crossing duration is computed, not configured

This is the substance of the build, and the reason the CSS above leaves `--monster-crossing` and
`--monster-cycles` as placeholders:

```js
const distance = window.innerWidth + frameWidth;
const cycles   = Math.max(1, Math.round(distance / stride));

monsterWalker.style.setProperty('--monster-cycles', cycles);
monsterWalker.style.setProperty('--monster-crossing', `${(cycles * cycleSeconds).toFixed(2)}s`);
```

A fixed duration makes the monster faster on a wide screen while its legs keep the same tempo,
and the feet slide. Rounding the crossing to a **whole number of gait cycles** and then deriving
the duration from that count keeps ground speed and leg speed locked together at any viewport
width.

`--monster-stride: 130px` is the load-bearing number here, and it is the one number that came
from nowhere: the roster publishes frames, cell size, cycle time and facing, but **not** how far
the monster travels per cycle. It was estimated. See
[`../knowledge.md`](../knowledge.md).

Retrigger handling, which is what question 3 bought:

```js
if (monsterWalker.classList.contains('is-walking')) return;
```

plus an `animationend` listener keyed on `monster-cross` — not on any animation, so the walk
cycle finishing does not disarm the crossing.
