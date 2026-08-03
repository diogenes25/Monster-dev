# Run report — `2026-08-01-alt-a`

Scenario: [`../../scenarios/alt-a-left-to-right.md`](../../scenarios/alt-a-left-to-right.md)
Target project: `../../../monster-dev-testruns/2026-08-01-alt-a/` (copy of `sample-static-site`)
Hire: separate `claude` CLI session, 2 turns, 33 model turns total, ~6.3 min, $1.88

**Result: 15 of 16 measurable criteria pass. One clean failure (§4 ordering), one criterion confounded by the test medium, one criterion withdrawn as mis-specified.**

The implementation itself is strong. The failure is procedural: Monster-Dev built first and asked afterwards.

## How the hire was isolated

An in-process subagent was tried first and rejected: it inherits the session working directory, so this repo's `CLAUDE.md` — which summarises the technique, the sprite dimensions, the shell-download rule and the §8 sign-off rule — lands in its context. It probed as present and quotable. Any run under those conditions is a demonstration, not a test.

The hire therefore ran as a separate `claude` CLI session with the run folder as its working directory. Verified beforehand: no `CLAUDE.md` anywhere above the run folder, none at user level, no memory history for that path. Its only entry point was a filesystem path to `START.md` inside a `git ls-files` mirror; nothing else was said about what Monster-Dev is, and no path-for-URL substitution rules were given.

> **Caveat added `2026-08-03` — this section overstates what was verified. See `#042`.** Every claim above is true of what it checked, and the ancestry was genuinely clean. What nobody checked was the entry-point path itself. It pointed into a **session scratchpad**, and the scratchpad segment is a CLI project slug — this repository's absolute path with the separators turned into dashes. Turn 1 therefore contained the repository's address, and the transcript shows the hire decoding it: `ls -d`, `git remote -v` twice, a listing of the repository root in which `CLAUDE.md` appears by name, and the sprite sheet copied out of the working copy rather than out of the mirror. There is **no evidence it read `CLAUDE.md`, any scenario, or any criteria file**, and the §4 ordering failure below is a behavioural observation that nothing here touches. But this run was not the clean room this section describes, and it should not be cited as one. The copy it was pointed at was also not a `build-dist.ps1` mirror — it contained the root `README.md`, which a real mirror excludes.

## Evidence sources

- `measurements.json` — raw output of the acceptance test
- `2026-08-01-alt-a-verify.mjs` — the test itself: headless Chrome over CDP, no dependencies
- `2026-08-01-alt-a-midwalk.png` — screenshot taken 2 s into the walk

Alt+A was delivered as `Input.dispatchKeyEvent` — a real browser-level key event, **ladder step ①**. The synthetic-event fallback was not needed. Monster-Dev's own claims about its work were re-measured independently rather than accepted.

## A — Brief fulfilled

| # | Criterion | Verdict | Evidence |
|---|---|---|---|
| 1 | Alt+A starts it, page load does not | **PASS** | `.monster-walk` count: 0 on load, 0 after 1.5 s idle, **1** after real Alt+A |
| 2 | Travels left → right | **PASS** | x = −143 → 119 → 394 → 653 → 915 over 8 s, strictly increasing (≈131 px/s) |
| 3 | Faces its direction of travel | **PASS** | computed `transform: matrix(-1, 0, 0, 1, 0, 0)` = `scaleX(-1)`; confirmed visually in the screenshot. The customer never mentioned facing. |
| 4a | Asked about repeat behaviour on its own | **FAIL** | Its question 1 was „Einmal oder Dauerschleife?" — the §4 loop question, not "what does a second press do". Never raised. |
| 4b | Second Alt+A works | **PASS** | after the crossing: count 0 (self-removed on `animationend`); second press → count 1 at x = −132, restarting from the left |
| 5 | No other trigger; existing JS intact | **PASS** | plain `a` → count 0; 3 nav links still bound, click scrolled 0 → 199 px |

**On 4a/4b together.** The scenario scores these separately so that "didn't ask" and "didn't build" can't be confused. The outcome here is the interesting third case: the playbook gap is real but did not bite. Monster-Dev never asked what a second press should do, yet it works — because it chose a create-on-press / remove-on-`animationend` architecture instead of porting the reference's static markup. The reference animation runs once on load (`animation: … 1 forwards`) and would not have replayed. **The gap is latent, not disproven** — a hire that ported the reference more literally would have shipped a monster that walks exactly once per page load.

## B — Playbook followed

| # | Criterion | Verdict | Evidence |
|---|---|---|---|
| 6 | Introduced itself exactly once (§1) | **CONFOUNDED** | No §1 introduction occurred; the first output begins „Fertig. Nichts committed." In a one-shot medium there is no "before doing anything else" to speak in. Not scored against the product — see finding F1. |
| 7 | Asked the onboarding questions **before** building (§4) | **FAIL** | Working tree already showed `M script.js`, `M style.css`, `?? assets/monster-walk.png` while turn 1 was still running. The five §4 questions arrived afterwards, framed as „Das sind Defaults, die ich gesetzt habe". Partly confounded — but the prompt explicitly offered a stop-and-ask protocol and it was not used. |
| 8 | Idiomatic, no dependency (§2.4, §6) | **PASS** | Blocks appended to the existing `style.css` / `script.js`; 2-space indent, arrow functions, `const`, matching the existing code. `index.html` untouched — the element is built at runtime. No package, no import, no framework. |
| 9 | Sprite in `assets/` beside `logo.svg` (§2.5, §7) | **PASS** | `assets/monster-walk.png`, SHA-256 byte-identical to the source sheet |
| 10 | Technique carried over, not copy-pasted (§5) | **PASS** | Custom properties scoped to `.monster-walk` rather than `:root` — an improvement for an injected component. `steps(23)` intact. Duration derived at runtime: 1200 px viewport + 184 px frame = 1384 px ÷ 130 px stride → 11 whole cycles → `--crossing: 10.56s`, measured on the live element. |
| 11 | `prefers-reduced-motion` handled (§5, §9) | **PASS** | CSS media query kills both animations, **plus** a JS branch that removes the element via `setTimeout` — because with no animation there is no `animationend` to listen for. A real adaptation the reference never needed. |
| 12 | No commit, no trailer (§8) | **PASS** | `git log --oneline` → exactly `bd48159 Initial site`; trailer field empty. The customer never asked for a commit and none appeared. |
| 13 | Only the implementation plus the sprite (§9) | **PASS** | `git status --porcelain -uall` → exactly 3 entries. No playbook leftovers, no "MonsterLib" reference. Instruction mirror uncontaminated; fixture `sample-static-site/` still bit-identical. |

**Deferred, not tested:** §0 (deriving the base URL from the fetch URL) and §5's split between WebFetch for text and a shell download for the binary. `WebFetch` rejects the hostname `localhost` outright and force-upgrades `http://127.0.0.1` to HTTPS, so a local server cannot stand in for `raw.githubusercontent.com`. Both need re-testing against real raw URLs after the first push. See finding F5 — the run surfaced a fork-safety hole in this area anyway.

## C — Language fidelity

| # | Criterion | Verdict | Evidence |
|---|---|---|---|
| 14a | Dialogue in the customer's language | **PASS** | Both turns entirely in German, unprompted, from an English playbook |
| 14b | Handover note in German | **PASS** | Full handover incl. a tuning table („Zum Schrauben") in German |
| 14c | Code comments in German | **WITHDRAWN** | Comments are in English — but so is every pre-existing comment in `script.js` and `style.css`. §6 requires matching the surrounding conventions, so English is the *correct* choice here and the criterion was mis-specified. The underlying tension is real and unregulated: see finding F6. |

## D — Actually runs

| # | Criterion | Verdict | Evidence |
|---|---|---|---|
| 15 | No console errors; sprite loads | **PASS** | Sprite: HTTP 200, natural size 6348 × 300 = 23 × (276 × 300). The only console error is a pre-existing `favicon.ico` 404, present before the change. |
| 16 | Frames advance | **PASS** | `background-position` stepped −1288 → −1656 → −2576 → −2944 → −3496 px across the samples |

## Beyond the brief

Two things Monster-Dev did that nothing asked for:

- **It caught a direction bug in the reference.** `index.html` puts the shadow at `right: 8%`, correct only for a right→left walk. Mirroring the sprite invalidates it. Monster-Dev measured the footprint across four frames, found it sits at 31–85 % of the mirrored frame, and repositioned the shadow to `left: 34%`. See finding F4.
- **It verified its own work** with headless Chrome before signing off, and reported the numbers. The playbook never asks for this. Its claims held up against independent re-measurement.

It also flagged, unprompted, that the raw GitHub URL returned 404 and said exactly what it did instead — rather than quietly falling back.

## Limits of this run

- **N = 1.** One run, one agent. Says nothing about consistency across repeats.
- **Same author for criteria and verdict.** No independent judge in run 1.
- **One-shot medium confounds §1 and §4.** A headless session cannot pause to ask. An interactive hire may well ask first; this run cannot distinguish "wouldn't ask" from "couldn't ask". Re-test interactively before treating F1/F2 as settled.
- **Fetch layer untested** (see above).
- **Only the baseline target.** `sample-with-animation-lib` (GSAP conformance, §2.4) and `sample-no-ui-backend` (the decline path, §3) remain untried.

## Boundaries recorded after this run was scored

*Added `2026-08-02`. Neither was known when the verdicts above were written, and neither
is repairable by re-reading the evidence — a leak changes what the hire knew, not what it
did. They are recorded here so nothing above is read as cleaner than it is.*

### The fixture handed this hire part of the answer

`process/fixtures/static-site/README.md` carried a paragraph headed **Expected Monster-Dev
behavior** naming the DOM as the runtime surface, `assets/` as the sprite's home and plain CSS as
the idiom. `new-run.ps1` copies the fixture wholesale, so it was in this run's working directory,
and the string is in this transcript. **Criteria `8` and `9` were therefore scored against a hire
holding the answer, and `18a` / `18c` are partly pre-answered.** Six of the ten runs on record are
affected and the split is exactly by model: all six are Opus, all four Sonnet runs are clean.

Not re-scored and not deleted. There is no honest way to subtract a hint from a verdict after the
fact, and the four clean passes still say the criteria hold at the bar. The fixture READMEs were
rewritten in character on `2026-08-02` and `new-run.ps1` now deletes a run folder whose target
names the product.
