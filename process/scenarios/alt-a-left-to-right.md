# Scenario: Alt+A easter egg, left to right

A repeatable Monster-Dev test run. The hired agent must never see this file — it
contains both the answer script and the acceptance criteria.

## Target project

A copy of `process/fixtures/static-site/` placed **outside** this repository, at
`../monster-dev-testruns/<run-id>/`, initialised as a git repo with a single
commit `Initial site`.

Outside, because a copy inside `process/` would put this repo's `CLAUDE.md` in the
subagent's ancestor chain — it gets auto-loaded regardless of any instruction not
to read it, and it gives away the purpose, the technique and the sign-off rule.
The git repo is what makes §8 ("no commit unless asked") falsifiable at all, and
`git status` afterwards is the exact diff surface for §9.

## What the hired agent is given

Its working directory is the run folder, and its entire prompt is the customer
brief below plus a dialogue protocol that describes the *channel* and says nothing
about *timing*:

> Der Kunde liest mit und antwortet. Beende deinen Zug, wenn du etwas von ihm
> brauchst — du bekommst eine Antwort und kannst danach weiterarbeiten.

Nothing else. No explanation of what Monster-Dev is, no substitution rules, no
hint about what is being measured.

**Why this wording, exactly.** It used to read „stell deine Fragen in der
**Abschlussnachricht** und stoppe". Run `2026-08-01-phase2` showed what that cost:
the hire built first and then explained itself with *„Du wolltest Fragen am Ende"*.
„Abschlussnachricht" reads as *questions come at the end*, i.e. after the work —
so the harness was quietly instructing the opposite of §4's "ask before you build",
and K7a was measuring my sentence rather than the playbook. Sonnet resolved the same
ambiguity the other way, which is why the two models appeared to disagree about §4
when they never did.

Keep any future rewording free of ordering cues. The sentence exists to tell a hire
that a human is reachable and how to reach them — not when to speak.

### Customer brief (German — the customer speaks German on purpose)

> Auf meiner Seite soll ein Easter-Egg: wenn man Alt+A drückt, läuft ein Monster
> von links nach rechts durchs Bild. Deine Einweisung steht hier:
> `<dist>/START.md`

`<dist>` is a copy of this repo's tracked files (`git ls-files`) minus `process/`,
`.claude/` and `CLAUDE.md`, so the agent can list that folder freely and still not
reach the harness, the skill, or the summary of the playbook. All three are
**tracked** — they no longer drop out on their own, which is why the mirror is
only ever built by `process/tools/build-dist.ps1`, which verifies what it built.

**Known limitation of this run:** the playbook expects to be fetched from a URL
(§0 derives the base URL from the fetch URL; §5 splits WebFetch for text vs. a
shell download for the binary PNG). WebFetch rejects `localhost` outright and
force-upgrades `http://127.0.0.1` to HTTPS, so a local HTTP server cannot stand
in for raw.githubusercontent.com. The agent therefore gets a filesystem path.
§0 and the WebFetch/curl split are **not tested** by this run and stay open until
the repo is pushed. The agent is deliberately *not* told to substitute paths for
URLs — how well the playbook degrades is itself a finding.

### Answer script (§4)

The customer is as vague as a real customer. Two things are withheld on purpose,
because they are the parts the playbook is most likely to miss:

| Question (§4) | Answer |
|---|---|
| Which monster? | „keine Präferenz, nimm deinen Standard" — the choice is *offered or not*, which is the measurement; picking one would replace it with a compliance check |
| One-time or loop? | „einmal pro Tastendruck" — **nothing** about what a second press does |
| Direction? | „von links nach rechts" |
| Speed / size? | „keine Präferenz" |
| React to anything? | „nur Alt+A, nicht beim Laden der Seite" |
| Where on screen? | „unten am Bildrand" |

Fallback for anything not in the table: „keine Präferenz, nimm deinen Standard".

The customer **never** mentions which way the monster should face, **never**
mentions a second key press, and **never** asks for a commit.

**What this answer costs, and how criteria 10 and 14b pay for it.** „Nimm deinen
Standard" routes an indifferent client to `green-fuzz-classic` — which is the sheet
`index.html` is built on, and `index.html` is reachable through `stacks/dom-css/`.
A hire that derived the geometry from §5 and a hire that copied the reference write
the same numbers, so neither criterion can tell them apart by the numbers alone.
The answer stays as it is: naming a sheet would replace *"was the choice offered"*
with a compliance check, which is the measurement this row exists for. What changes
is where 10 and 14b look. **14b** scores against whichever sheet the page actually
downloaded, identified by pixel size and never by name, so the tell is whether the
numbers and the sheet agree rather than which sheet it is. **10** is scored at two
window widths, because a derived duration moves with the viewport and a copied one
does not — that comparison is the one thing a copy cannot reproduce.

## Acceptance criteria

### A — Brief fulfilled

1. Alt+A starts the monster; merely loading the page does **not**
2. Travels left → right across the page (evidence: `getBoundingClientRect().x`
   at two moments, not eyeballed screenshots)
3. Faces its direction of travel — never mentioned by the customer, and the
   reference walks the other way with `scaleX(-1)` commented out
4. **4a** Did Monster-Dev ask about repeat behaviour on its own?
   **4b** Does a second Alt+A press work?
   Fail 4b *without* 4a = playbook gap (§5). Fail 4b *with* 4a = implementation error.
5. No other trigger fires it; the existing smooth-scroll in `script.js` still works

### B — Playbook followed

6. Introduced itself as Monster-Dev exactly once (§1)
7. Asked the onboarding questions **before** building (§4)
8. Idiomatic: plain CSS/JS in the style of `style.css` / `script.js`, no
   dependency, no new animation library (§2.4, §6)
9. Sprite lives in `assets/` next to `logo.svg` (§2.5, §7) — under whatever name
   the site's own conventions imply; the slug is not required to survive
10. Technique carried over rather than copy-pasted (§5). Scored from
    `measurements.json` — `implementation`, `sheetMatch`, `derivation` and
    `durationVsViewport` — never by reading the stylesheet.
    **10a** Frame geometry lives in custom properties rather than in literals:
    `implementation.customProperties` carries the frame size and the cycle.
    **10b** `implementation.steps` equals `sheetMatch.frames.sheet` — the frame
    count of the sheet **actually downloaded**, identified by `spriteNaturalSize`.
    **10c** The crossing duration is derived, not chosen. Both halves required:
    `derivation.cyclesIsWhole` is true, because §5's arithmetic ends on a whole
    number of gait cycles and a picked number does not; and
    `durationVsViewport.changesWithViewport` is true, measured on the same page at
    a second window width. A duration that does not move with the viewport was
    typed, however plausible it looks.
11. `prefers-reduced-motion` handled (§5, §9). Scored from `measurements.json` →
    `reducedMotion`, with the media feature **emulated**. A `@media
    (prefers-reduced-motion: reduce)` block in the stylesheet is **not** a pass on
    its own: that is code presence standing in for behaviour, which is the
    substitution that has already produced three wrong verdicts in this harness.
    **11a** It does not travel — `travelledPx` is 0.
    **11b** It does not sit there for good — `stillOnScreenAfterCrossing` is 0.
    Two marks and not one, because they are settled by different things: §5 asks
    for *"something visible and still"* and 11a is that sentence measured, while
    11b is a judgement about what an easter egg should do that §5 does not make.
12. `git log --oneline` shows **exactly one** commit; no trailer (§8)
13. Two instruments, because the file list and the file contents are not the same
    question (§9). **13a** `git status --porcelain -uall` shows only the
    implementation plus the sprite sheet, no playbook leftovers. **13b** A
    case-insensitive content search over the handed-back worktree finds neither
    `Monster-Dev` nor `MonsterLib` — `git status` reports paths and never opens a
    file, so it cannot answer this half at all.
14. **14a** Was the choice of monster offered at all (§4)?
    **14b** Which sheet did the page actually download, and do the implementation's
    numbers belong to **that** sheet? Scored from `sheetMatch`, which identifies
    the sheet by `spriteNaturalSize` rather than by name: `frames.agree` is true,
    `cycleSeconds.deltaPct` is within a few percent, and `cellAspect.deltaPct` is
    within one percent. A uniform scale is a pass and the display size is the
    hire's call — `cellPx.scale` records it — while a changed aspect ratio is a
    fail, because the squashed monster is what this criterion exists to catch. If
    the hire *named* a sheet in the dialogue, that name and `sheetMatch.slug` must
    be the same one.
    Wrong numbers *for the sheet it downloaded* is an implementation error; a
    silent pick without offering is a playbook gap.

*Deferred to the first push:* base URL derivation (§0) and the WebFetch/curl
split (§5).

**Criteria changed on 2026-08-01**, when the roster replaced the single sheet:
9, 10 and 13 stopped naming `monster-walk.png` and `steps(23)`, 14 is new, and the
old 14–16 became 15–17. The two runs below predate that and scored the old
wording, so only the untouched criteria compare directly across the boundary.

**Criteria changed again on 2026-08-02 — one boundary, six criteria, and it is the
larger of the two.** Every run in the log below predates it. Each change is here
because a criterion was being scored off whatever the harness happened to emit,
and two of the six were caught by a reader who had never seen the run.

| | What it used to be | What settles it now |
|---|---|---|
| `10` | prose about technique, scored from nothing | `derivation`, `durationVsViewport`, `implementation.customProperties`. It is now falsifiable — before this it could not fail |
| `11` | *"handled"*, scored by finding a `@media` block | `reducedMotion`, with the media feature emulated, split into `11a` travel and `11b` disappearance. The harness had no reduced-motion path at all and never had, and `11b` is a judgement §5 does not make, so it is an open question rather than a settled criterion |
| `13` | one instrument, `git status`, and the pre-rename product name | two instruments, and both product names. `git status` reports paths and cannot see a string inside a modified file |
| `14b` | the sheet's frame count, cell size and cycle | the **implementation's**, against whichever sheet was downloaded, with aspect ratio in place of literal cell size |
| `15c` | *"Code comments in German?"* — a pass for behaviour §6 and §8 forbid | comments follow the codebase; English is the pass |
| `16` | console errors counted against zero, so every arm scored *"1 (favicon)"* | errors **new since the untouched fixture**, with the baseline measured per run |

Three consequences, none of them repairable by the edit:

- **`10` is a risk criterion and has never been able to fail.** Every A/B on
  record leans on it. Its ten passes were assent, not measurement.
- **`11`'s seven passes were scored on code presence**, and three of the reports
  below describe watching the behaviour anyway. That evidence cannot be re-sourced.
- **Criteria `8` and `9` are contaminated in six runs** — `alt-a`, `phase1`,
  `phase2`, `phase2b`, `live` and `plan-opus` — where the fixture's own README told
  the hire the answer. Five of the six carry the caveat in their report;
  `plan-opus` has none to carry it, which is why it is recorded here.

A criterion whose named instrument does not exist is scored **`NOT SCORABLE`**, not
`PASS`.

### C — Language fidelity (unregulated in the playbook, hence worth measuring)

15. **15a** Introduction and questions in German?
    **15b** Handover note in German?
    **15c** Do the code comments follow the codebase rather than the conversation?
    The fixture's comments are English, so English is the pass. German comments in
    an English codebase are a §6 failure, not a language-fidelity success — §8 says
    it outright: *"Code comments are the other way round: those follow the
    codebase."*

### D — Actually runs

16. No console errors **the hire introduced** — `measurements.json` →
    `consoleErrors`, which is the run's console output minus whatever the untouched
    fixture logs on load. The baseline is in `fixtureConsoleErrors` and is measured
    on every run rather than written down once as an allowlist, and
    `consoleErrorsAll` is kept beside it so the subtraction can be checked instead
    of trusted. Sprite loads with 200 — `spriteHttpStatus`.
17. Frames advance — not stuck on frame 0 (`samples[].bg` moves)

**Alt+A measurement ladder.** ① real key press → pass, "real key path".
② otherwise a synthetic `KeyboardEvent` with `altKey: true` → pass, but recorded
as "handler verified, key path not measurable in this browser" rather than a
clean pass. ③ neither → fail.

### E — The plan step (§4)

**Appended on 2026-08-01, not inserted.** 1–17 keep their numbers so they still
compare against the six archived runs. E is scored from `<run-id>/hire.json` plus
the cli-turn-1 text, and did not exist for any run before `sonnet-base2`.

18. **Before anything in the target changes**, Monster-Dev states what it found.
    Four independent marks. Each is scored from the cli-turn-1 text *and* requires
    `turns[0].worktreeAfter` to be empty — content stated after the build is a
    changelog and scores nothing, however complete.
    - **18a — Injection point.** A file *in this project*, named, with the reason
      it is that one and not another.
    - **18b — Animation primitive.** What the project already animates with, or
      that it animates with nothing yet, named as what the work will build on.
    - **18c — Change set.** Which existing files get edited, what is new, and
      where the sprite goes.
    - **18d — Sheet.** The sheet it will use with that row's frame count and
      cycle time from §5.

    Four marks rather than one because the archive shows hires omitting
    *different* halves: `phase2b` scored 4/4 and `live` 1/4 on the same model and
    the same brief. A binary criterion records both as PASS and destroys the
    measurement — see [`plan-retro.md`](../runs/plan-retro.md).

19. **One round, not two.** The plan and the questions arrive in the same message.
    Evidence: `totals.firstEditAfterCliTurn` > 1, and the plan text sits in
    cli-turn 1. Splitting into "here is my plan" and then "here are my questions"
    is a fail even when both halves are good.

20. **20a** Built as announced. **20b** Any departure from the announced plan
    named in one line rather than silently applied.
    Fail 20a *without* 18 = playbook gap. Fail 20a *with* 18 = implementation
    error. Never blur the two.

21. **No bookkeeping about notes.** With no measured pitfalls in the stack note,
    nothing is said about notes existing. "There are notes for this stack, I read
    them" is a fact from our side of the fence and tells the client nothing.
    `phase2b` failed this; it is the one criterion in E with a before-fail on
    record.

**Risk criteria — must hold, not improve.** 4a, 7a, 10 (all three marks) and 19.
Note that 10 became falsifiable on 2026-08-02 and its history is therefore assent
rather than measurement; an A/B that leans on it is leaning on one run's worth of
evidence, not ten. A rewrite that buys
completeness on 18 by taking a second round has failed, not improved: 19 catches
exactly that trade.

## Run log

| Run | Date | Model | Result |
|---|---|---|---|
| `2026-08-01-alt-a` | 2026-08-01 | Opus | baseline — [report](../runs/2026-08-01-alt-a/report.md), [findings](../runs/2026-08-01-alt-a/findings.md) |
| `2026-08-01-phase1` | 2026-08-01 | Opus | restructure is behaviour-neutral; every criterion held, cost +36 % — [report](../runs/2026-08-01-phase1/report.md) |
| `2026-08-01-sonnet-base` | 2026-08-01 | Sonnet | bar baseline. Asked before building where Opus never did → K7 was model disposition, not a playbook gap. Also solved both `dom-css` pitfalls unaided, leaving the planned A/B with no arms — [report](../runs/2026-08-01-sonnet-base/report.md) |
| `2026-08-01-phase2` | 2026-08-01 | Opus | F2 proven: K4a flipped after four runs failing it. K7a turned out to be biased by the harness's own dialogue-protocol sentence, so it is unmeasurable rather than failing. Cost $4.04 — [report](../runs/2026-08-01-phase2/report.md) |
| `2026-08-01-phase2b` | 2026-08-01 | Opus | Prompt fix + roster. K7a flipped on the model that failed it three times — it was the harness, not the playbook and not the model. Roster works (14a/14b), K10 held. Cost $1.84, **−54 %**: asking first means building once — [report](../runs/2026-08-01-phase2b/report.md) |
| `2026-08-01-sonnet-base2` | 2026-08-01 | Sonnet | Before-arm for the §4 plan step, and the first Sonnet run under the corrected dialogue protocol. Every criterion 1–17 passed; section E scored **18: 1/4** — primitive named, injection point / change set / sheet numbers not. 31 model turns, $1.66 — **no report of its own**; its numbers are the before-arm inside [`plan-sonnet`'s](../runs/2026-08-01-plan-sonnet/report.md) |
| `2026-08-01-plan-sonnet` | 2026-08-01 | Sonnet | **Proof run for the §4 plan step.** 18 went 1/4 → **4/4** on the bar model, nothing regressed, 21 held. Turn 1 got shorter and 39 % cheaper; total turns rose 32 %, over the soft ceiling, entirely in the build turn. Also exposed a second-level verifier bug: CSS-visible ≠ visible — [report](../runs/2026-08-01-plan-sonnet/report.md), [findings](../runs/2026-08-01-plan-sonnet/findings.md) |
| `2026-08-01-plan-opus` | 2026-08-01 | Opus | Control for the same change. 18: 4/4, and `phase2b`'s criterion-21 failure did not recur. Named an unannounced departure on its own (dropped the shadow, said why) — the new §6 sentence firing. 41 turns, $2.72 — **no report of its own**; it is the control arm inside [`plan-sonnet`'s](../runs/2026-08-01-plan-sonnet/report.md), and it has a [blind second scoring](../runs/2026-08-01-plan-opus/score-b.md) |
| `2026-08-01-index-sonnet` | 2026-08-01 | Sonnet | §2 as a parseable table + the first-match rule. **Behaviour-neutral, as intended** — every arm identical to `plan-sonnet`; 18 held at 4/4 on a second independent Sonnet hire. First failure on **20a**: announced a container in `index.html`, built without one, never flagged the substitution. The turn overrun reproduced (42), which corrects Phase 2's hedge — [report](../runs/2026-08-01-index-sonnet/report.md) |
| `2026-08-01-live` | 2026-08-01 | Opus | **First run over real raw URLs** — no mirror, no `--add-dir`. §0 proven (base derived after two real renames), §5 proven by hash (byte-identical 1.9 MB sheet cannot come through WebFetch). §2 stack resolution still unproven: a content-free stack file leaves no fingerprint. Cost $1.61 — [report](../runs/2026-08-01-live/report.md) |
