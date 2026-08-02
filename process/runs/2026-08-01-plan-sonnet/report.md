# Run `2026-08-01-plan-sonnet` — `alt-a-left-to-right`

Three arms, reported together because a proof run means nothing without the pair it is compared
against.

| | |
|---|---|
| Date | `2026-08-01` |
| Scenario | `test/scenarios/alt-a-left-to-right.md` (criteria 18–21 appended as section E before any arm ran) |
| Fixture | `test/fixtures/static-site/` |
| Playbook revision | before-arm: `d0d9498` unmodified · plan arms: `d0d9498` + the uncommitted §4/§6 change |
| Before-arm | `2026-08-01-sonnet-base2` — Sonnet, session `f0cd865c`, 2 cli-turns / 31 model turns, $1.66 |
| Proof | `2026-08-01-plan-sonnet` — Sonnet, session `1265e1de`, 2 cli-turns / 41 model turns, $1.84 |
| Control | `2026-08-01-plan-opus` — Opus, session `ddb23ae6`, 2 cli-turns / 41 model turns, $2.72 |

## Verdict

**The plan step works on the bar model: criterion 18 went from 1/4 to 4/4 on Sonnet, and no
criterion regressed on either model.** Criterion 21 — the one mark with a genuine before-fail,
recorded on Opus in `phase2b` — also flipped. The cost side is the honest weak spot: model turns
rose 32 % against the before-arm, above the +25 % soft ceiling the plan set. That excess sits
entirely in the *build* turn; the turn the change actually touches got shorter and 39 % cheaper.

Counts, per arm: 21 pass / 1 qualified / 0 fail / 2 not exercised.

## What changed in the product

Two edits, both uncommitted at the time of the runs:

- **§4** gained a *"state what you found"* half ahead of the existing questions — five items
  (injection point, primitive, change set, sheet with its numbers, duration-is-derived), one
  worked example, and a **"One round, not two"** paragraph. The seven questions, the defaults
  sentence and the whole *"Ask before you build, not after."* paragraph are byte-identical; the
  headless paragraph gained one appended sentence.
- **§6** gained one sentence: if an answer overturns part of the plan, build the changed thing
  and name the change in one line.

Nothing else moved. `START.md` is byte-identical to `HEAD`.

## Criterion comparison

| # | Criterion | `sonnet-base2` | `plan-sonnet` | `plan-opus` | |
|---|---|---|---|---|---|
| 1 | Alt+A starts it, page load does not | pass | pass | pass | `onLoad 0 / afterTrigger 1` |
| 2 | Travels left → right | pass | pass | pass | x −76 → 984 / −76 → 982 / −78 → 979 |
| 3 | Faces direction of travel | pass | pass | pass | `mirrored: true` on all three |
| 4a | Asked about repeat behaviour unprompted | pass | pass | pass | all three asked it in turn 1 |
| 4b | Second Alt+A works | pass | pass | pass | `afterCrossing 0 / afterSecondTrigger 1` |
| 5 | No other trigger; smooth-scroll intact | pass | pass | pass | `afterBareKey 0`, scroll 0 → 199, 3 nav links |
| 6 | Introduced itself exactly once | pass | pass | pass | one intro in turn 1, none in turn 2 |
| 7a | Asked before building | pass | pass | pass | `worktreeAfter` empty on turn 1, all three |
| 8 | Idiomatic, no dependency | pass | pass | pass | plain CSS + vanilla JS in all three |
| 9 | Sprite in `assets/` | pass | pass | pass | `monster.png` / `monster-sprite.png` |
| 10 | Technique carried over | pass | pass | pass | `steps(23)`, custom properties, duration derived |
| 11 | `prefers-reduced-motion` | pass | pass | pass | reduce-branch in all three stylesheets |
| 12 | Exactly one commit, no trailer | pass | pass | pass | `git log --oneline` = 1 |
| 13 | Worktree clean of leftovers | pass | pass | pass | 3 modified + 1 new PNG, nothing else |
| 14a | Monster choice offered | pass | pass | pass | both sheets named in turn 1 |
| 14b | Default used, with its numbers | pass | pass | pass | 6348×300 = `green-fuzz-classic`, `steps(23)` |
| 15a | Intro/questions in German | pass | pass | pass | |
| 15b | Handover in German | pass | pass | pass | |
| 15c | Code comments | qualified | qualified | qualified | English — correct, see below |
| 16 | No console errors | pass | pass | pass | one 404, harness (see below) |
| 17 | Frames advance | pass | pass | pass | `background-position` steps on all three |
| **18a** | **Injection point named, with reason** | **fail** | **pass** | **pass** | ← flipped |
| **18b** | **Primitive the project already uses** | pass | pass | pass | already passed |
| **18c** | **Change set + sprite destination** | **fail** | **pass** | **pass** | ← flipped |
| **18d** | **Sheet with frames and cycle time** | **fail** | **pass** | **pass** | ← flipped |
| 19 | One round, not two | pass | pass | pass | `firstEditAfterCliTurn = 2` on all three |
| 20a | Built as announced | n/a | pass | pass | |
| 20b | Departure named | n/a | n/a | **pass** | ← the §6 sentence firing |
| 21 | No bookkeeping about notes | pass | pass | pass | `phase2b`'s fail did not recur |

### 18 — the four marks, quoted

The before-arm named the primitive and nothing else:

> Reine statische HTML/CSS/JS-Seite […] Kein Animations-Framework im Einsatz […] Ich baue also
> mit purem CSS (`@keyframes` + `steps()`), keine neue Library.

It listed `index.html` / `style.css` / `script.js` as *what it found*, never as where the work
goes; said nothing about what would change or where the sprite lands; and offered both sheets by
description with **no frame count and no cycle time**. 18a, 18c, 18d fail.

`plan-sonnet`, same model, same brief:

> **Einbaupunkt:** direkt im `<body>` von `index.html`, `fixed` positioniert — es gibt hier nur
> die eine Seite, die ist also schon die „immer da"-Hülle.
> **Was sich ändert:** `index.html` bekommt ein neues Monster-Element, `style.css` die
> Sprite-Animation, `script.js` den Alt+A-Listener samt Lauflogik. Das Sprite-Sheet landet in
> `assets/`, wo auch `logo.svg` schon liegt.
> **Sheet:** `green-fuzz-classic` (Standard) — 23 Frames, 0,96 s pro Gangzyklus […]

18a carries its reason (*"es gibt hier nur die eine Seite"*), which is what separates a named
file from a guess. `plan-opus` produced all four as well, in the same shape.

**18b passed before the change and the rewrite takes no credit for it.** Three of three archived
runs that got as far as speaking before building already named the primitive.

### 20b — the §6 sentence, unprompted

`plan-opus` dropped the shadow it had announced, and said so without being asked:

> **Eine Abweichung von dem, was ich angekündigt hatte:** kein Schatten. Die Bodenlinie des
> Sprites ist die unterste Zeile der Zelle, die liegt genau auf der Fensterkante — ein
> Schattenoval wäre dort zur Hälfte abgeschnitten […]

One run, one model. This is the §6 sentence behaving as intended, not proof that it works: no
before-arm could produce a departure, because no before-arm announced a plan to depart from.

### 15c — qualified, not failed

All three wrote English code comments. The fixture's own `script.js` opens with
`// Smooth-scroll to in-page sections`, and §6 requires matching the surrounding conventions, so
English is the correct choice. Identical to the withdrawal reasoning in run `alt-a`; the
criterion remains mis-specified and should be rewritten to score *"matches the codebase"* rather
than *"German"*.

## Cost and turns

| | before | proof | Δ | control |
|---|---|---|---|---|
| Model turns, total | 31 | 41 | **+32 %** | 41 |
| Model turns, turn 1 (the plan) | 12 | **11** | −8 % | 13 |
| Model turns, turn 2 (the build) | 19 | 30 | +58 % | 28 |
| Cost, total | $1.66 | $1.84 | +11 % | $2.72 |
| Cost, turn 1 | $0.61 | **$0.37** | **−39 %** | $0.51 |
| Wall clock | 7.4 min | 7.5 min | — | 9.6 min |

**41 turns is over the +25 % soft ceiling** (38.75 against the before-arm's 31). Reporting it as
a pass would be wrong.

> **Corrected 2026-08-01 after `index-sonnet`.** This section originally argued two things that
> the next run disproved, and they are struck rather than quietly edited.
>
> It said turn 1 *"got shorter and 39 % cheaper"* — one sample of a noisy number, reported as a
> result. Across both plan-step runs turn 1 is 11 and 14 turns at $0.37 and $0.59, against the
> before-arm's 12 turns at $0.61. **Turn 1 is flat.**
>
> It said 41 might be *"the day rather than the change"*, citing the −54 % swing between
> `phase2` and `phase2b`. `index-sonnet` came in at **42** turns while changing only §2 — a
> change that cannot plausibly cost anything. Two consecutive Sonnet runs carrying the plan step
> sit at 41 and 42 against 31 without it. **The rise tracks the §4 change.**

What survives both corrections: the extra turns sit in the **build** (19 → 30), not in the turn
that now carries the plan. Why a stated plan lengthens the build afterwards is a mechanism this
phase cannot separate from ordinary variance in verification effort.

The gate for a playbook change is **regression, not cost** — turns must not explode, they need
not fall. Nothing regressed, so the change stands; it stands with a measured price of roughly a
third more turns on the bar model, not with the benefit of the doubt.

## Harness notes

**The verifier counted CSS visibility, not visibility.** `plan-sonnet` parks its walker one
frame-width off the left edge (`transform: translateX(calc(-1 * var(--monster-frame-w)))`) and
slides it in on the trigger. `checkVisibility()` says yes to that the whole time, so the first
measurement returned `onLoad 1 / afterBareKey 1 / afterCrossing 1` — reading as failures on
criteria 1, 5 and 4b for a page that behaves exactly as asked.

This is the **second** time this bug has been found. `live` caught the first level, where the
verifier counted mere presence and mis-scored a hire that kept its markup in `index.html`; the
fix then was `checkVisibility()`, which has no idea *where* the element is. `count()` in
`test/tools/verify-run.mjs` now also requires the bounding rect to intersect the viewport.
Geometry sampling deliberately still uses the CSS-visible element, since every crossing begins
off-screen. **Both arms were then re-measured with the fixed verifier**, and the before-arm's
numbers were unchanged — the fix does not tilt the comparison.

**A stale server measured the wrong run.** The first `plan-sonnet` verification reported
`spriteUrl: .../assets/monster.png`, which is the *before-arm's* file name — the previous
static server still held port 8080, so the new one never bound and the verifier silently
re-measured `sonnet-base2`. Caught only because the two hires happened to name their sprite
differently. Every arm now gets its own port. A run whose arms picked the same filename would
have produced a perfect, meaningless "no difference" result.

**The `404` in `consoleErrors` is Chrome's automatic `/favicon.ico` request.** The fixture has no
favicon and no reference to one. It appears identically in all three arms and belongs on the
allowlist Phase 4 plans (`preexistingConsoleErrors`).

No permission denials, no errored turns, no harness artefacts in any target.

## Not exercised by this run

§0 (base-URL derivation) and §5's WebFetch/curl split. These are **no longer deferred to a
push** — the repo is pushed, and `2026-08-01-live` proved both over real `raw.githubusercontent.com`
URLs. These three arms used the `<dist>` mirror on purpose, so that the comparison against
`phase2b` and `sonnet-base2` varies only the playbook. `CLAUDE.md` and the workshop skill still
describe both as deferred pending a push; that wording is stale.

## Boundaries recorded after this run was scored

*Added `2026-08-02`. Neither was known when the verdicts above were written, and neither
is repairable by re-reading the evidence — a leak changes what the hire knew, not what it
did. They are recorded here so nothing above is read as cleaner than it is.*

### The mirror told this hire it was being measured

The `<dist>` mirror carried this repository's own `README.md`, including the section headed
*"Monster-Dev gets better by being tested"*: *"A test run hires a fresh agent against a sample
project, scores it criterion by criterion."* It appears in this transcript as a Read tool result
with the file's own line numbers attached.

**No individual criterion is named, because what this compromises is the premise beneath all of
them** — that the hire does not know it is being measured. Eight of the ten runs on record are
affected, `sonnet-base`, `sonnet-base2`, `plan-sonnet` and `index-sonnet` among them, so unlike
the fixture leak this one has no clean arm at the Sonnet bar. There is no way to quantify what a
hire does differently knowing it is scored, so nothing is re-scored and nothing is deleted.

Closed on `2026-08-02`: `README.md` joined the mirror's exclusion list, two dev-side paragraphs
left `tools/project.md` and `monsters/README.md`, and `build-dist.ps1` gained two checks that name
no path — a harness-vocabulary grep over every `.md` in the mirror, and a sprite-reference check
that catches a finished implementation, which contains none of those words.
