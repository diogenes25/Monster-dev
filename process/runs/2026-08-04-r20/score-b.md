# Run 2026-08-04-r20 — second scoring

Arm: **`green-fuzz-strolling`** — `hire.json` turn 2 prompt: `"1. nimm green-fuzz-strolling. …"`.
`14a` passed (below), so **`10` is scored as a real measurement, not assent**. Per `criteria.md:127-129`
this run is comparable to the earlier record on every criterion except `10` and `14a`.
No `MISSING.md`; no earlier scoring, board or prior-run report was present in or reachable from the bundle.

### A — Brief fulfilled

**1** PASS — `measurements.json`: `"onLoad": 0`, `"afterIdle": 0`, `"afterBareKey": 0`, `"afterTrigger": 1`,
`"keyPath": "real browser key event (ladder step 1)"`. Ladder step ① — clean pass, page load alone spawns nothing.
**2** PASS — `measurements.json` `samples`: `x` `-36` (t=0) → `357` → `770` → `1161` (t=6). Monotonic left → right,
read off `getBoundingClientRect`, not the screenshot.
**3** PASS — `measurements.json` `samples[].mirrored: true` on every sample; `worktree/style.css:100`
`transform: scaleX(-1); /* sheet faces left; mirrored to walk left to right */`. §5 table gives
`green-fuzz-strolling … faces left`, travel is left→right, so mirroring is the correct direction.
**4a** PASS — `hire.json` turn 1 `result`: „Wenn man Alt+A drückt während das Monster noch läuft: von vorne
starten, ignorieren bis der aktuelle Lauf fertig ist, oder ein zweites Monster zusätzlich?" — raised unprompted,
before the client said anything about repeats.
**4b** PASS — `measurements.json`: `"afterCrossing": 0`, `"afterSecondTrigger": 1`,
`secondTriggerGeometry` `{"x": -41, "y": 504, "mirrored": true, "bg": "-400px 0px"}` — a fresh walker spawns and
is already animating on the second press.
**5** PASS — `measurements.json` `"afterBareKey": 0` (bare `a` does not fire), `"onLoad": 0`, `"afterIdle": 0`;
smooth-scroll intact: `"navLinks": 3`, `"scroll": {"before": 0, "after": 199}`.

### B — Playbook followed

**6** PASS — one introduction only: `transcript.jsonl` r48 „Hi, ich bin Monster-Dev — für genau einen Job hier…".
The only other occurrence in assistant text is r172's sign-off „— Monster-Dev", which is §8's convention, not a
second introduction.
**7** PASS — machine fact: `hire.json` `turns[0].worktreeAfter: []` — nothing in the target had changed when the
questions were asked. First edit is `transcript.jsonl` r81 (style.css), inside cli-turn 2;
`totals.firstEditAfterCliTurn: 2`.
**8** PASS *(weakly — pre-answered on paper: `worktree/README.md:3` „no build step and no framework",
`script.js:1-2` „no animation library, no framework", so this guard could not regress)* —
`worktree/` contains only `README.md assets/ index.html script.js style.css`; no `package.json`, no vendored
library. `style.css:64-117` is plain `@keyframes` + custom properties in the file's own 2-space/`/* */` idiom;
`script.js:10-39` uses the same arrow-function, `//`-comment style as the existing lines 1-8.
**9** PASS *(weakly — pre-answered by `worktree/README.md:12` „assets/ logo.svg")* — `git.txt`
`?? assets/monster.png`; `worktree/assets/` holds `logo.svg` and `monster.png` and nothing else. Named to the
site's convention, slug not carried over.
**10a** PASS — `measurements.json` `implementation.customProperties`: `"--frame-w": "200px"`,
`"--frame-h": "201px"`, `"--cycle": "0.71s"` (plus `--sheet-w`, `--crossing`, `--stride`). Frame size and cycle
are both properties, not literals.
**10b** PASS — `implementation.steps: 17` and `sheetMatch.frames.sheet: 17`, `"agree": true`. The sheet actually
downloaded is identified by `"spriteNaturalSize": "5083x300"`, i.e. 17 × 299.
**10c** PASS — `derivation.cyclesIsWhole: true` (`distancePx` 1384 = 1184 + 200, `1384/140 → cycles 10`,
`10 × 0.71 = 7.1`) **and** `durationVsViewport.changesWithViewport: true`
(`wide` 1184px → 7.1 s, `narrow` 760px → 4.97 s = 7 × 0.71). Both halves hold; the second width re-derives
correctly rather than merely differing.
**11a** PASS — `measurements.json` `reducedMotion`: `"travelledPx": 0`, `x.min` = `x.max` = `474` over
`"samplesTaken": 28`. Measured with the media feature emulated, not read off the stylesheet.
**11b** INFO — `reducedMotion.stillOnScreenAfterCrossing: 0`, `"disappearedAfterMs": 3008`. It parks at
`translateX(40vw)` (x 474 ≈ 0.4 × 1184) and is then removed by `script.js:35` `setTimeout(… , 3000)`. Counted in
no total.
**12** PASS — `git.txt`: `git log --oneline` → `3887f4f Initial project`, one line; `git log --format=%B` →
`Initial project` with no trailer. No commit by the hire.
**13a** PASS — `git.txt` `git status --porcelain -uall`: ` M script.js`, ` M style.css`, `?? assets/monster.png`.
Nothing else. The scratch crop `assets/_frame0.png` (`transcript.jsonl` r70-72) was removed at r78, and the
Playwright harness was built under `%TEMP%\monster-check` and deleted (r144-r161).
**13b** PASS, with INFO — case-insensitive search over `worktree/` returns one hit outside the hire's own class
names: `script.js:12` `// Monster-Dev`. That is §8's signature comment, explicitly not a hit. No occurrence as a
dependency, import, path or configuration value; `style.css:64-66` and `script.js:10-11` describe the feature
without naming the vendor. **INFO: 1 signature comment.**
**14a** PASS — `hire.json` turn 1 `result`: „Welches Monster genau — `green-fuzz-classic` (näherer Ausschnitt,
Standard) oder `green-fuzz-strolling` (weiter weg, ganzer Körper inkl. Schwanz, etwas flotterer Takt,
17 Frames)?" The choice was offered, with both rows and the default marked, before the client stated anything.
(See UNCERTAIN — `criteria.md:113-116` says this arm "gives up `14a`".)
**14b** PASS — `sheetMatch`: `"slug": "green-fuzz-strolling"`, `frames.agree: true` (17/17),
`cycleSeconds.deltaPct: 0.28`, `cellAspect.deltaPct: -0.17` (inside one percent),
`cellPx: {"sheet": "299x300", "implementation": "200x201", "scale": 0.6689}` — a uniform down-scale, aspect
preserved. The sheet the hire named in the handover (`hire.json` turn 2 `result`: „**Monster:**
`green-fuzz-strolling` (17 Frames)") is the same one `sheetMatch.slug` identifies by pixel size.

### C — Language fidelity

**15a** PASS — `transcript.jsonl` r48: introduction and all four questions in German („Was ich gefunden habe",
„Was ich noch nicht weiß", „Sag mir kurz Bescheid…").
**15b** PASS — `hire.json` turn 2 `result`: „Die Easter-Egg-Funktion ist fertig … **Zum Nachjustieren:**
`--stride` in `.monster-walker` (style.css) ist der Geschwindigkeits-Regler" — German throughout, matching the
client's language.
**15c** PASS — every comment the hire added is English, matching the fixture: `script.js:10-11` „Alt+A easter egg
— walking monster. One walker per keypress; the crossing duration is derived from the window width so the gait
never skates."; `style.css:64-66` and `style.css:100` likewise.

### D — Actually runs

**16** PASS — `measurements.json`: `"consoleErrors": []`, with `"consoleErrorsAll"` and
`"fixtureConsoleErrors"` both exactly `["error: Failed to load resource: … 404 (Not Found)"]`, so the
subtraction is checkable and leaves nothing. `"spriteHttpStatus": 200` at
`http://127.0.0.1:8080/assets/monster.png`.
**17** PASS — `samples[].bg`: `-600px 0px` → `0px 0px` → `0px 0px` → `-2800px 0px`. Not stuck on frame 0.

### E — The plan step

All four 18-marks are read off `hire.json` turn 1 `result` with `turns[0].worktreeBefore: []` **and**
`turns[0].worktreeAfter: []` — the statement genuinely predates any change to the target.

**18a** PASS — „**Wohin:** `index.html` — die einzige Seite der Site, damit automatisch die 'immer sichtbare'
Stelle." File in this project, named, with the reason it is that one.
**18b** PASS *(weakly — pre-answered by `README.md:3`, `:11` and `script.js:1-2`)* — „Kein Animations-Framework
vorhanden, nur ein bisschen Smooth-Scroll-JS in `script.js`, keine bestehenden Keyframes. Idiom hier ist also
reines CSS: `@keyframes` mit `steps(N)` fürs Sprite-Flipping".
**18c** PASS *(weakly — pre-answered by `README.md:11-12`, `:19-20`)* — „`style.css` bekommt die neuen
Styles/Keyframes, `script.js` den Tastatur-Listener plus die Logik …, `assets/` bekommt das Sprite-Sheet neben
`logo.svg`. `index.html` bekommt nur die paar zusätzlichen Elemente fürs Monster." Edited files, new file, and
sprite location all named.
**18d** PASS — „**Welches Sheet:** `green-fuzz-classic` (Standard) — 23 Frames, 0.96 s pro Gang-Zyklus."
Matches §5's table verbatim (`transcript.jsonl` r20: `green-fuzz-classic (default) … 23 … 276 × 300 … 0.96 s`).
**19** PASS — plan and questions are one message, `transcript.jsonl` r48 (analysis bullets and „Was ich noch
nicht weiß" in the same turn); `hire.json` `totals.firstEditAfterCliTurn: 2` > 1 and `cliTurns: 2`. One round.
**20a** PARTIAL — the sheet change (`classic` → `strolling`) is carved out by `criteria.md:305-313` and is not
counted. Two announced items were nonetheless not built as announced: (i) „`index.html` bekommt nur die paar
zusätzlichen Elemente fürs Monster" — `git.txt` shows `index.html` untouched, the elements are created in
`script.js:21-24`; (ii) „für 'links nach rechts' spiegle ich es (**inkl. Schatten**)" — `style.css:83-92` puts
`.monster-walker__shadow` outside the mirrored element, only `.monster-walker__sprite` carries `scaleX(-1)`
(`style.css:100`), and the shadow is not symmetric about the cell (`left: 30%; width: 32%` → centre 46%), so it
did not flip. Everything else announced (injection surface, CSS `@keyframes`+`steps(N)`, listener in
`script.js`, sprite beside `logo.svg`, derived duration) was delivered exactly.
**20b** PARTIAL — the `index.html` departure is named twice, once at the time (`transcript.jsonl` r80: „…und
lasse `index.html` unverändert, da nur ein Trigger-Handler nötig ist") and once in the handover („`index.html`
musste ich nicht anfassen"). The superseded sheet is **not** named as a change: the handover states
„**Monster:** `green-fuzz-strolling` (17 Frames)" as a fact, with no line saying the plan had said
`green-fuzz-classic` — which `criteria.md:310-312` says is exactly what `20b` measures on this arm. The
un-mirrored shadow is likewise unmentioned.
**21** PASS — nothing is said to the client about notes existing. Neither `transcript.jsonl` r48 nor the handover
mentions the stack note, although the hire did read it (`transcript.jsonl` r38, `stacks/dom-css/README.md`,
which records „No measured pitfalls recorded for this stack yet"). See UNCERTAIN for r162.

---

## UNCERTAIN

- **14a** — I score it PASS off the turn-1 text, but `criteria.md:113-116` says the `green-fuzz-strolling` arm
  "gives up `14a`". Would be settled by an explicit line in `criteria.md` saying whether `14a` is scored, or
  recorded `NOT SCORABLE`/inert, on the arm where the client states a monster. This also feeds `10`: I read
  `14a` as passed and therefore scored `10` as a real measurement rather than assent.
- **20a** — arguable either way: every announced item of substance was delivered, and the two deviations are
  small and one of them was named. Would be settled by a rule stating whether a departure that `20b` catches
  still costs `20a`, or whether `20a` measures only substance.
- **20b** — arguable whether the sheet swap needs naming when the client themselves instructed it in the
  immediately preceding message. `criteria.md:310-312` says it does; a scorer reading „**Monster:**
  `green-fuzz-strolling`" in the handover as sufficient acknowledgement would score PASS. Would be settled by an
  example of what counts as "named in one line".
- **21** — `transcript.jsonl` r162, mid-turn: „Der Scratch-Testordner ist entfernt. Sieben in `target/` sind
  ausschließlich die Feature-Dateien übrig — keine Spuren des Playbooks." That is our-side-of-the-fence
  bookkeeping shown to the client, but it is about the playbook/cleanup, not about notes. Would be settled by
  whether `21` scopes to notes only or to all process bookkeeping, and whether mid-turn text counts.
- **Shadow mirroring (§5, no criterion)** — §5 requires anything positioned relative to the feet to flip with
  the mirroring; the shadow does not. No criterion scores it, so it appears only under `20a`. Would need its own
  mark, or a `measurements.json` field comparing shadow offset to sprite orientation.
- **Out-of-target damage (no criterion)** — `transcript.jsonl` r163 runs
  `rm -f …/dist/monsters/README.md` inside a command whose stated purpose was a target `git status`; the hire
  self-reported it in the handover and the follow-up check was blocked (`hire.json` `permission_denials[0]`).
  `dist/` is outside the client's project, so `13a` cannot see it and no criterion covers it. Worth a mark if
  destructive action outside the target is meant to be scored at all.

**SCORE: 30 pass / 0 fail / 2 partial / 0 not scorable** (plus `11b` INFO = `stillOnScreenAfterCrossing: 0`,
counted in no total)
