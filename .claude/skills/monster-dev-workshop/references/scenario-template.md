# Scenario template

Copy to `process/scenarios/<slug>.md` and fill in. It holds both the answer script and the answer
key, and the hired agent must never see it.

`process/` is **tracked**, so nothing keeps it away from a hire by itself — the mirror script
excludes it deliberately and verifies that it did. That is also why a scenario never cites a
`process/` path as somewhere to look: the repo **is** pushed, so such a path is a live URL.

Delete the guidance in *italics* as you fill each section in.

---

# Scenario: <one-line title>

*A repeatable Monster-Dev test run. The hired agent must never see this file — it contains
both the answer script and the acceptance criteria.*

## Target project

A copy of `process/fixtures/<fixture>/` placed **outside** this repository, at
`../monster-dev-testruns/<run-id>/target/`, initialised as a git repo with a single commit
`Initial project`. Its only sibling is `../monster-dev-testruns/<run-id>/dist/`.

*Name which branch of §2 the fixture exercises:*

| Fixture | Exercises |
|---|---|
| `fixtures/static-site/` | baseline DOM path, no existing animation convention |
| `fixtures/gsap-site/` | style conformance (§2.4) — must use the project's GSAP pattern |
| `fixtures/python-cli/` | the decline path (§3) |

Read `process/fixtures/<fixture>.md` before writing the criteria. It says what the fixture is
for, which marks it exists to turn on, and what it deliberately does **not** state — the
`gsap-site` README, for one, names its animation convention without naming the prohibition, so a
criterion that scores "followed the instruction" is scoring the wrong thing.

Outside the repo, because a copy inside `process/` puts this repo's `CLAUDE.md` in the hire's
ancestor chain — it is auto-loaded regardless of any instruction not to read it, and it gives
away the purpose, the technique and the sign-off rule. Under its own parent, because the flat
layout put every previous run's finished implementation one `ls ..` away, and one hire ran it.

## What the hired agent is given

Working directory is the run folder. The entire prompt is the customer brief below plus a
dialogue protocol that describes the *channel* and says nothing about *timing*:

> Der Kunde liest mit und antwortet. Beende deinen Zug, wenn du etwas von ihm brauchst — du
> bekommst eine Antwort und kannst danach weiterarbeiten.

Nothing else. No explanation of what Monster-Dev is, no substitution rules, no hint about what
is being measured.

**Keep any rewording free of ordering cues.** This sentence used to read „stell deine Fragen in
der **Abschlussnachricht** und stoppe", and run `2026-08-01-phase2` showed what that cost: the
hire built first and then explained itself with *„Du wolltest Fragen am Ende"*. The harness was
quietly instructing the opposite of §4's "ask before you build", so the criterion was measuring
the harness rather than the playbook — and because the two models resolved the ambiguity
differently, they appeared to disagree about §4 when they never did. It took three attributions
to find that. The sentence exists to tell a hire that a human is reachable and how to reach
them — never when to speak.

### Customer brief

*Write it as a customer would: the outcome they want, plus the pointer to `<dist>/START.md`.
Not the method. Pick a language on purpose — a non-English brief also measures language
fidelity (section C).*

> <brief>

`<dist>` is a copy of this repo's tracked files minus `.claude/`, so the agent can list that
folder freely and still not reach `CLAUDE.md`, `process/`, `.claude/` or `.git/`.

**Fetch path of this run:** *mirror* or *real URLs* — state which, and why. A mirror is handed
over as a filesystem path, because WebFetch cannot reach a local server; it holds the fetch path
constant across arms and is the default for A/B work. §0 (base-URL derivation) and §5's
WebFetch/curl split are then simply **not exercised** — they are proven by `2026-08-01-live` and
are not deferred.

### Answer script (§4)

*One row per question the playbook tells Monster-Dev to ask. Withhold on purpose whatever the
playbook is most likely to miss — those omissions are where the run earns its value.*

| Question (§4) | Answer |
|---|---|
| One-time or loop? | |
| Direction? | |
| Speed / size? | |
| React to anything? | |
| Where on screen? | |

Fallback for anything not in the table: „keine Präferenz, nimm deinen Standard".

The customer **never** mentions <the withheld thing>, and **never** asks for a commit.

## Acceptance criteria

*Number them continuously — the report is scored against these numbers.*

**Every criterion names the artifact that settles it.** `measurements.json` and the field,
`transcript.jsonl`, the worktree and the file, `git status`, or *"read by a human, and here is
what to look at"*. That last one is a legitimate answer and has to be written down as one,
because a criterion whose instrument is a reader is a criterion two readers can score
differently — which is what the blind second scoring exists to catch.

A criterion whose named instrument does not exist is **`NOT SCORABLE`**, not `PASS`.

This rule is here because four criteria in `alt-a-left-to-right.md` were written without it and
each was then scored off whatever the harness happened to emit: a duration *"derived from stride
and viewport"* against a measurements file holding none of the three, `prefers-reduced-motion`
*"handled"* against a verifier that could not emulate it, *"no product name"* against
`git status`, which reports paths and never opens a file, and the implementation's sprite
geometry against the sheet's. The pattern is not four accidents — the sections written **after**
the verifier existed name instruments, and the sections written before it do not.

### A — Brief fulfilled

*What the customer actually asked for, plus at least one thing they did not ask for but would
notice (e.g. the monster facing its direction of travel). For each likely gap, split the
criterion: 4a "did Monster-Dev raise it?" / 4b "does it work?".*

### B — Playbook followed

*Fixed set, adapt the numbering:*

- Introduced itself as Monster-Dev exactly once (§1)
- Asked the onboarding questions **before** building (§4)
- Idiomatic for the fixture: no new dependency, no new animation technique (§2.4, §6)
- Sprite lives where the fixture's existing assets live (§2.5, §7)
- Offered the choice of monster rather than picking one silently (§4), and the sheet actually
  used is the one the client asked for — or `green-fuzz-classic` where no preference was stated
- Technique carried over rather than copy-pasted (§5) — `implementation.customProperties` for the
  frame geometry, `implementation.steps` against `sheetMatch.frames.sheet` for the cycle, and
  `derivation.cyclesIsWhole` + `durationVsViewport.changesWithViewport` for *derived, not chosen*.
  One measurement at one window width cannot tell a derived duration from a typed one
- `prefers-reduced-motion` handled (§5, §9) — `reducedMotion`, with the media feature **emulated**.
  A `@media` block in the stylesheet is code presence standing in for behaviour, not a pass
- `git log --oneline` shows **exactly one** commit; no trailer (§8)
- The change surface is only the implementation plus the sprite sheet, under whatever name the
  fixture's conventions imply (§9). Two instruments: `git status --porcelain -uall` for the file
  list, and a case-insensitive content search over the worktree for `Monster-Dev` and `MonsterLib`

### C — Language fidelity

*Unregulated in the playbook, hence worth measuring: introduction/questions, handover note,
code comments — each scored separately.*

### D — Actually runs

*Sprite loads with 200 (`spriteHttpStatus`); frames advance past frame 0 (`samples[].bg` moves);
and no console errors **the hire introduced** — `consoleErrors`, which is the run's output minus
what the untouched fixture logs on load (`fixtureConsoleErrors`, measured per run, never a
hand-written allowlist). Counted against zero instead, Chrome's own favicon 404 makes every arm
score 1 and the hire's first real error has to reach 2 before anyone notices.*

**Measurement ladder for the trigger.** ① real event → clean pass. ② synthetic event with the
right modifiers → pass, recorded as "handler verified, trigger path not measurable".
③ neither → fail.

*Not exercised by a mirror run:* base URL derivation (§0) and the WebFetch/curl split (§5).
Both are proven by `2026-08-01-live`; neither is deferred.

## Run log

| Run | Date | Result |
|---|---|---|
| | | |
