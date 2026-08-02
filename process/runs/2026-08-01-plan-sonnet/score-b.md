# Scoring — 2026-08-01-plan-sonnet

No `MISSING.md` present; bundle is complete (`criteria.md`, `transcript.jsonl`, `hire.json`, `measurements.json`, `git.txt`, `worktree/`, `midwalk.png`). No prior scoring or board found or consulted.

### A — Brief fulfilled

**1** PASS — `measurements.json:4-7`: `"onLoad": 0, "afterIdle": 0, "afterBareKey": 0, "afterTrigger": 1`. Loading/idling/bare-key never trigger it; the real Alt+A trigger does.
**2** PASS — `measurements.json:14-48` samples: `x` goes `-76 → 184 → 461 → 723 → 982` across `t=0..8`, monotonically increasing (left→right).
**3** PASS — `measurements.json:18,25,32,39,46`: `"mirrored": true` on every sample; `worktree/style.css:108`: `transform: scaleX(-1); /* sheet faces left; we walk left to right */` is active (not commented out), and the catalog (`transcript.jsonl:39`) confirms the sheet `"faces": "left"`.
**4** **4a** PASS — `hire.json:85`, question 3: „Was passiert, wenn man Alt+A nochmal drückt, während das Monster noch unterwegs ist — neu starten, ignorieren bis fertig, oder zweites Monster daneben?" — asked unprompted. **4b** PASS — `measurements.json:50-57`: `"afterCrossing": 0` (finished/reset), then `"afterSecondTrigger": 1` with `secondTriggerGeometry.x: -78` (back near the starting edge like the first trigger's `x:-76`) — a second press after completion walks again.
**5** PASS — `measurements.json:6` (`afterBareKey: 0`) plus `measurements.json:58-61`: `"navLinks": 3, "scroll": {"before": 0, "after": 199}` — nav smooth-scroll still functions.

### B — Playbook followed

**6** PASS — `transcript.jsonl:42` / `hire.json:85`: „Hi, ich bin Monster-Dev —…" appears exactly once; later text (`transcript.jsonl:150`) only references the name in a code-comment/cleanup context, not a repeated self-introduction.
**7** PASS — `hire.json:15-16`, turn 1 (`index:1`): `"worktreeBefore": [], "worktreeAfter": []"` — the five onboarding questions (`hire.json:85`) were sent while the worktree was still untouched.
**8** PASS — `git.txt:10-14`: only `index.html`, `script.js`, `style.css` modified, no new deps/files besides the sprite; `worktree/script.js` and `worktree/style.css` use the same plain vanilla style as the pre-existing code.
**9** PASS — `git.txt:8`: `?? assets/monster-sprite.png`; `worktree/assets/` listing shows it alongside `logo.svg`.
**10** PASS — `worktree/style.css:65-73` custom properties (`--monster-frame-w`, `--monster-cycle`, `--monster-stride`, …); `steps(23)` at `style.css:112` matches the downloaded sheet's 23 frames (`measurements.json:12`); `worktree/script.js:29-33` derives crossing duration from `window.innerWidth` and `--monster-stride`.
**11** PASS — `worktree/style.css:125-128`: `@media (prefers-reduced-motion: reduce) { .monster-walker.is-walking { animation: none; transform: translateX(40vw); } … }`.
**12** PASS — `git.txt:2`: single line, `9679b8f Initial site` — no second commit added.
**13** PASS — `git.txt:5-8`: exactly the three edited files plus the sprite, no other leftovers; confirmed by `transcript.jsonl:145-148` where the hire deletes its scratchpad npm install/screenshots and verifies nothing leaked. No `MonsterLib` string anywhere in `worktree/` (grep: no matches).
**14** **14a** PASS — `hire.json:85`, question 1 offers `green-fuzz-strolling` as an alternative, defaulting to `green-fuzz-classic` if no preference. **14b** PASS — `measurements.json:12`: `"spriteSlug": "green-fuzz-classic (23 frames of 276x300, cycle 0.958s)"` is the sheet actually fetched; `worktree/style.css:66-70` uses `184px/200px/0.96s` — not the raw catalog numbers, but exactly a uniform 2/3 scale of them (`276×2/3=184`, `300×2/3=200`, `6348×2/3=4232=184×23`), so frame count (23), aspect ratio and cycle (0.96 ≈ 0.958) are all faithful to the downloaded sheet at a chosen display size, not distorted or borrowed from the wrong sheet.

### C — Language fidelity

**15** **15a** PASS — `hire.json:85` intro and all five questions are in German. **15b** PASS — `hire.json:162`: handover text ("Fertig. Zusammenfassung: …") is fully German. **15c** FAIL — `worktree/script.js:10-14`, `worktree/style.css:64,90,108`, `worktree/index.html:49`: every added code comment is in English (e.g. `// Crossing duration is derived from the real viewport width so the monster covers a whole number of gait cycles…`, `/* sheet faces left; we walk left to right */`), not German.

### D — Actually runs

**16** PASS — `measurements.json:10`: `"spriteHttpStatus": 200`. One entry in `measurements.json:64`: `"error: Failed to load resource: the server responded with a status of 404 (File not found)"`, but no resource the hire's code references is missing (`worktree/index.html` only points to `style.css`, `assets/logo.svg`, `assets/monster-sprite.png` [200], `script.js`), and the diff shows only additions (`git.txt:11-14`), so this 404 predates the hire's changes — consistent with an unrequested browser favicon lookup, not a defect it introduced.
**17** PASS — `measurements.json:19,26,33,40,47`: `bg` values differ across every sample (`-3680px`, `-4048px`, `-736px`, `-1104px`, `-1472px`) — not frozen on one frame.

### E — The plan step

**18** **18a** PASS — `hire.json:85`: „Einbaupunkt: direkt im `<body>` von `index.html`, `fixed` positioniert — es gibt hier nur die eine Seite, die ist also schon die 'immer da'-Hülle." — names the file and the reason. **18b** PASS — same record: „Kein Animations-Framework im Einsatz — `script.js` macht nur Smooth-Scroll… Ich baue also mit purem CSS (`@keyframes` + `steps()`)." **18c** PASS — same record: „Was sich ändert: `index.html` bekommt ein neues Monster-Element, `style.css` die Sprite-Animation, `script.js` den Alt+A-Listener… Das Sprite-Sheet landet in `assets/`." **18d** PASS — same record: „Sheet: `green-fuzz-classic` (Standard) — 23 Frames, 0,96 s pro Gangzyklus…" All four marks sit in `hire.json:85` (cli-turn 1), and `hire.json:15-16` confirms `worktreeAfter: []` for that turn.
**19** PASS — `hire.json:179`: `"firstEditAfterCliTurn": 2` (>1); the plan and the five questions are both in the single `hire.json:85` message.
**20** **20a** PASS — plan (`hire.json:85`) vs. build (`worktree/index.html`, `style.css`, `script.js`, `git.txt`) match on injection point, files touched, sheet, frame count, cycle, and mirroring. **20b** PASS — no departure occurred (nothing in the built files contradicts a specific claim made in the plan), and none is hidden in `hire.json:162`.
**21** PASS — `transcript.jsonl:37`: the stack note read says „*No measured pitfalls recorded for this stack yet.*" and neither `hire.json:85` nor `hire.json:162` says anything like "there are/aren't notes for this stack."

## UNCERTAIN

- **14b** — the implementation's cell geometry (184×200) is a uniform 2/3 scale of the catalog's real cell size (276×300), not the literal numbers. I read "cell size… that sheet's" as satisfied by a proportionally-faithful scale-down, but a stricter reading that wants the literal pixel values would fail this.
- **16** — the 404 in `measurements.json:64` carries no request URL, so my attribution to an unreferenced favicon (rather than something the hire's code touches) is an inference from absence, not a direct read. A network log would settle it.
- **21** — `hire.json:162` states „Nichts vom Monster-Dev-Playbook selbst wurde ins Zielprojekt kopiert" to the customer. That's not "stack notes" bookkeeping in the literal sense the criterion describes, but it is the same genus of "telling the client about our internal process" the criterion is worried about. Could go either way depending on how narrowly §21 is meant.
- **C (language, general)** — no numbered criterion covers it, but several intermediate progress lines in the session (`transcript.jsonl:67,70,87,114,135,147`, e.g. "The sprite looks right — matches the catalog…") are in English despite the German-only conversation frame ("Der Kunde liest mit"). Doesn't map to 15a/15b/15c cleanly since those name specific artifacts (intro+questions, handover, code), but it may bear on how German-only the interaction is judged to be overall.

SCORE: 28 pass / 1 fail / 0 partial / 0 not scorable
