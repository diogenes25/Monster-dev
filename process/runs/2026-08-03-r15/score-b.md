# Score B — `2026-08-03-r15` (second reader)

Bundle complete; no `MISSING.md`. No first scoring, board, or other run's report was present or read.

Sheet identity check before scoring 10/14b: `measurements.json` `spriteNaturalSize: "6348x300"`
(6348/23 = 276 × 300) and `spriteUrl .../assets/monster.png`; `worktree/assets/monster.png` is
1 942 313 bytes, the same byte count as `dist/monsters/green-fuzz-classic.png` in `transcript.jsonl`
r25. `implementation.customProperties` (`--frame-w: 184px`, `--cycle: 0.96s`, `--stride: 130px`)
reproduce `worktree/style.css:70–74` literally, so the measured page is this worktree and not a
stale arm.

### A — Brief fulfilled

**1** PASS — `measurements.json`: `"onLoad": 0`, `"afterIdle": 0`, `"afterTrigger": 1`,
`"keyPath": "real browser key event (ladder step 1)"`; handler at `worktree/script.js:45`
`if (e.altKey && e.code === 'KeyA')`. Ladder step ① — clean pass.
**2** PASS — `measurements.json` `samples[]`: `x` `-76 → 184 → 458 → 718 → 979` at t=0…8,
`y` constant 505. Read off `getBoundingClientRect`, not a screenshot.
**3** PASS — all five `samples[]` carry `"mirrored": true`; `worktree/style.css:95`
`.monster-flip { transform: scaleX(-1); }` with the shadow inside the flipped element
(`worktree/index.html:51–54`). §5's roster row (`transcript.jsonl` r20 line 96) gives
`green-fuzz-classic … faces left`, travel is left→right, so mirrored = facing travel.
`midwalk.png` corroborates: face and eyes point right, tail trails left, shadow under the body.
**4a** PASS — `hire.json` turn 1 `result`: „2. Einmaliger Durchlauf oder soll es sich
wiederholen?" and „4. Falls Alt+A gedrückt wird während das Monster noch läuft: neu starten,
ignorieren bis der aktuelle Lauf fertig ist, oder ein zweites Monster daneben?" — asked
unprompted; the customer's brief says nothing about repeats.
**4b** PASS — `measurements.json`: `"afterCrossing": 0`, `"afterSecondTrigger": 1`,
`secondTriggerGeometry.x: -81` — a second Alt+A after the crossing restarts from off-screen left.
**5** PASS — `measurements.json` `"afterBareKey": 0` (plain `a` does not fire), `"onLoad": 0`;
`"navLinks": 3` and `scroll: {before: 0, after: 199}` — the pre-existing smooth-scroll still
works. `worktree/script.js:3–8` is the untouched original handler.

### B — Playbook followed

**6** PASS — one introduction only: `transcript.jsonl` r47 „Hi, ich bin Monster-Dev — für genau
einen Job gebucht". r147 (the sign-off) has no second introduction, and no other assistant text
in the file introduces itself.
**7** PASS — machine fact first: `hire.json` `turns[0].worktreeBefore: []` **and**
`turns[0].worktreeAfter: []`; the five questions sit in turn 1's `result`. First edit is
`transcript.jsonl` r63, after the customer's answers in r52. `totals.firstEditAfterCliTurn: 2`.
**8** PASS — `git.txt` `diff --stat`: `index.html | 8`, `script.js | 42`, `style.css | 75`,
`3 files changed, 125 insertions(+)`, no new dependency file; `worktree/` has no `package.json`.
`style.css:118–126` is plain `@keyframes` + `steps(23)`, matching the fixture's own hand-written
CSS. The Playwright harness lived in `/tmp/monster-egg-check` (r75) and was removed (r142
`rm -rf /tmp/monster-egg-check` → `done`); `git status` confirms no trace.
**9** PASS — `git.txt` `?? assets/monster.png`; `worktree/assets/` holds `logo.svg` and
`monster.png` side by side. Referenced as `url("assets/monster.png")` (`style.css:112`),
the same relative style as `assets/logo.svg` in `index.html:11`.
**10a** PASS — `measurements.json` `implementation.customProperties`: `"--frame-w": "184px"`,
`"--frame-h": "200px"`, `"--cycle": "0.96s"` (plus `--sheet-w`, `--stride`, `--crossing`).
Frame size and cycle are both in custom properties.
**10b** PASS — `implementation.steps: 23` and `sheetMatch.frames.sheet: 23`, `"agree": true` —
against the sheet identified by `spriteNaturalSize`, not by name.
**10c** PASS — both halves: `derivation.cyclesIsWhole: true` (`distancePx 1368` = 1184 + 184,
`cycles: 11`, `travelSeconds: 10.56` = 11 × 0.96) and
`durationVsViewport.changesWithViewport: true` (`wide` 1184 → 10.56 s, `narrow` 760 → 6.72 s;
944/130 → 7 cycles × 0.96 = 6.72). The second width moves the duration, so it is computed.
**11a** NOT SCORABLE — the named instrument has no value: `measurements.json`
`reducedMotion: { "x": { "start": 500, "after3s": null }, "travelledPx": null }`.
`travelledPx` is `null`, not `0`, so the criterion's own reading ("`travelledPx` is 0") cannot be
taken. The cause is visible in `worktree/script.js:37–38` — `if (reducedMotion) setTimeout(endWalk,
2000)` removes `is-walking` (→ `display: none`) before the 3 s sample, so the second reading
returned nothing. I am explicitly forbidden from substituting the `@media` block at
`style.css:128–137` for the behaviour, and I have not.
**11b** INFO (counted in no total) — `reducedMotion.stillOnScreenAfterCrossing: 0`,
`waitedSeconds: 14`. It does not stay: the 2 s timeout hides it again. Unlike `index.html`'s park,
this run disappears.
**12** PASS — `git.txt`: `git log --oneline` → one line, `4a33c14 Initial project`;
`git log --format=%B` → `Initial project` with no trailer.
**13a** PASS — `git.txt` `status --porcelain -uall`: ` M index.html`, ` M script.js`,
` M style.css`, `?? assets/monster.png` — implementation plus sprite, nothing else. No harness,
no notes, no scratch files.
**13b** FAIL — case-insensitive content search over `worktree/` returns three hits:
`worktree/index.html:49` `<!-- walking monster easter egg (Alt+A) — Monster-Dev -->`,
`worktree/style.css:64` `/* Walking monster easter egg (Alt+A) — Monster-Dev`,
`worktree/script.js:10` `// Walking monster easter egg — Alt+A — Monster-Dev`.
The criterion's instrument is a content search finding neither name; it finds one of them three
times. (See UNCERTAIN — §8 of the playbook, `transcript.jsonl` r20 line 145, endorses this exact
comment verbatim.)
**14a** PASS — `hire.json` turn 1 `result`, question 1: „Welches Sheet — `green-fuzz-classic`
(näher dran, Schwanz läuft aus dem Bild) oder `green-fuzz-strolling` (weiter weg, ganzer Körper
inkl. Schwanz sichtbar)? Sonst nehme ich den Default." Both roster rows offered, default named,
choice not made silently.
**14b** PASS — `sheetMatch`: `frames {sheet 23, implementation 23, agree: true}`,
`cycleSeconds {sheet 0.958, implementation 0.96, deltaPct 0.21}`,
`cellAspect {sheet 0.92, implementation 0.92, deltaPct 0}`,
`cellPx {sheet "276x300", implementation "184x200", scale 0.6667}` — a uniform two-thirds scale,
aspect unchanged. The hire named `green-fuzz-classic` in the dialogue (turn 1 and turn 2 handoff)
and `sheetMatch.slug` is `green-fuzz-classic`; the names agree.

### C — Language fidelity

**15a** PASS — `transcript.jsonl` r47: introduction and all five questions in German („Hi, ich bin
Monster-Dev …", „Was ich noch brauche: 1. Welches Sheet …").
**15b** PASS — `transcript.jsonl` r147 / `hire.json` turn 2 `result`: „Handoff-Notiz:" with the
per-file notes and the named assumptions, all German.
**15c** PASS — every comment the hire added is English, in a codebase whose comments are English
(`script.js:1–2` original): `style.css:64–68` „Sprite sheet assets/monster.png: 23 frames of
276 × 300 px …", `script.js:29–30` „Duration follows the stride, not the other way round …",
`index.html:49`. Comments follow the codebase, not the conversation.

### D — Actually runs

**16** PASS — `measurements.json` `"consoleErrors": []`, with the subtraction checkable:
`consoleErrorsAll` = `["error: Failed to load resource: … 404 (Not Found)"]` and
`fixtureConsoleErrors` = the same single line. Nothing new introduced.
`"spriteHttpStatus": 200` for `.../assets/monster.png`.
**17** PASS — `samples[].bg`: `-3680px → -4048px → -552px → -920px → -1472px` (wrapping mid-cycle
as `steps(23)` loops). Not stuck on frame 0.

### E — The plan step

Gate for all of 18: `hire.json` `turns[0].worktreeAfter: []` — nothing in the target had changed
when the cli-turn-1 text was written. All four marks are read off that text.

**18a** PASS — „**Wohin es kommt:** `index.html` (Markup für den Walker), `style.css` (die
Animation) und `script.js` (Trigger + Laufzeit-Berechnung) — genau die drei Dateien, die die Seite
schon hat. Kein neues Konzept, nur Ergänzung." Files in this project, named, with a reason
(they are the site's existing files; no new file/concept needed).
**18b** PASS — „**Womit gebaut wird:** Reines HTML/CSS/JS, kein Framework, keine Animation-Lib
(`script.js` macht nur Smooth-Scroll). Also plain CSS `@keyframes` mit `steps(N)` fürs
Sprite-Flipbook plus eine separate Transform-Animation fürs Durchlaufen" — states that the project
animates with nothing yet and names what the work builds on.
**18c** PASS — „**Was sich ändert:** Neu ist ein Sprite-Container-Markup in `index.html` (initial
versteckt), CSS-Regeln in `style.css`, ein `keydown`-Listener für Alt+A in `script.js`, plus die
Sprite-PNG in `assets/` — genau da, wo aktuell `logo.svg` liegt." Edits, new content and sprite
location all named.
**18d** PASS — „**Welches Sheet:** `green-fuzz-classic` (Default) — 23 Frames, 0.96 s pro
Gang-Zyklus." Matches §5's row (`transcript.jsonl` r20 line 96: `23 | 276 × 300 | 0.96 s | left`).
It also states the derivation („**Laufdauer:** wird aus der echten Fensterbreite berechnet, nicht
fest verdrahtet").
**19** PASS — `hire.json` `totals.firstEditAfterCliTurn: 2`; the plan and all five questions are
in the single cli-turn-1 message (`transcript.jsonl` r47), followed by „Sag Bescheid, dann bau
ich's." One round, not two.
**20a** PASS — built as announced, item by item: hidden markup at the end of `<body>`
(`worktree/index.html:49–55`), CSS block appended (`style.css:64–137`), `keydown` Alt+A listener
appended (`script.js:10–50`), sprite at `assets/monster.png`; the announced mirroring incl. shadow
is `style.css:92–96` with `.monster-shadow` inside `.monster-flip`; the announced viewport-derived
duration is `script.js:31–33`.
**20b** PASS — nothing was announced and then silently changed, and the two open answers are named
in one line each in the handoff: „Angenommen, weil keine Präferenz genannt: Standard-Sheet,
Standard-Tempo/-Größe, und bei erneutem Alt+A während des Laufens wird der zweite Tastendruck
ignoriert … das lässt sich in `script.js` (`if (isWalking) return;`) leicht ändern".
**21** FAIL — cli-turn-1 opens, before the introduction, with: „Kurz gecheckt, was schon lokal an
\"Anleitung\" bereitliegt (dist/-Ordner mit Playbook, Sprite-Sheets und Beispielimplementierung) —
das übernehme ich als Grundlage, ohne irgendetwas remote nachzuladen." The stack note carries no
measured pitfalls (`transcript.jsonl` r41: „*No measured pitfalls recorded for this stack yet.*"),
and §4 (r20 line 66) says „If they changed nothing, or there are none, say nothing about them:
which files you read is your business, not the client's." This is that sentence's failure mode —
the client is told the playbook, the sheets and a reference implementation exist and were read,
which tells them nothing about their site.

## UNCERTAIN

- **13b** — this is the one verdict most likely to differ, and it is a criterion/playbook conflict
  rather than a judgement call. §9 (r20 line 156) forbids the names as a *"dependency, import, or
  config entry"*, and §8 (r20 line 145) explicitly blesses ``a one-line code comment near the
  implementation … e.g. `// walking monster easter egg — Monster-Dev``` — the hire's three comments
  are near-verbatim that example. Criterion 13b as written ("a content search finds neither") is
  the instrument I scored, so FAIL; but a reader applying §9's scope would score PASS. Settled only
  by deciding which the criterion means to measure — and, if it means §9's scope, 13b needs
  rewording, because as written it cannot be passed by a hire that follows §8.
- **11a** — I scored NOT SCORABLE on `travelledPx: null`. A reader treating `x.start: 500` +
  `after3s: null` as "never moved" would score PASS. Settled by a re-measure that samples inside
  the 2 s window the implementation gives itself (`script.js:38`), or by a verifier that records
  `travelledPx: 0` when the element has gone rather than `null`. Note the same `null` would appear
  for an implementation that travelled and *then* hid, so the current reading cannot distinguish
  the two.
- **21** — a strictly literal reading ("nothing is said about *notes* existing") would PASS: the
  hire never mentions the stack note, notes, or pitfalls. I scored the disclosure of the playbook /
  sheets / reference implementation as the same class of bookkeeping, on the strength of §4's
  „which files you read is your business". Settled by whether 21 is scoped to the stack note or to
  our side of the fence generally.
- **18a** — the reason given is „genau die drei Dateien, die die Seite schon hat", which is a
  reason of the kind §4's example gives but thin on *"and not another"* (a one-page site offers no
  alternative). PASS as scored; a stricter reader could call it PARTIAL. Settled by whether 18a
  requires a rejected alternative to be named.
- **8 / 9 contamination** — `worktree/README.md:3` („no build step and no framework") and `:12`
  („`assets/` logo.svg lives here, and anything else static would too") were read by the hire
  (`transcript.jsonl` r33). This is the same fixture-README disclosure the criteria record as
  contaminating 8 and 9 in six earlier runs; the run list there does not include this run, but the
  disclosure is present here. Both criteria are scored on the delivered outcome, which is
  independently checkable, but the hire did not have to derive either answer.
- **20b** — passes vacuously: I found no departure to name. If a departure exists that I could not
  see (e.g. the reduced-motion path, which was built but never announced in cli-turn-1, being read
  as an unannounced addition), the verdict would change. Settled by whether 20b covers additions
  as well as substitutions.

**SCORE: 29 pass / 2 fail / 0 partial / 1 not scorable** (plus 11b `INFO`: 0, counted in no total)
