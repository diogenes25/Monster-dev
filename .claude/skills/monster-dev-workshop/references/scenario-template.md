# Scenario template

Copy to `test/scenarios/<slug>.md` and fill in. It holds both the answer script and the answer
key, and the hired agent must never see it.

`test/` is **tracked**, so nothing keeps it away from a hire by itself — the mirror script
excludes it deliberately and verifies that it did. That is also why a scenario never cites a
`test/` path as somewhere to look: once this repo is pushed, such a path is fetchable.

Delete the guidance in *italics* as you fill each section in.

---

# Scenario: <one-line title>

*A repeatable Monster-Dev test run. The hired agent must never see this file — it contains
both the answer script and the acceptance criteria.*

## Target project

A copy of `test/fixtures/<fixture>/` placed **outside** this repository, at
`../monster-dev-testruns/<run-id>/`, initialised as a git repo with a single commit
`Initial site`.

*Name which branch of §2 the fixture exercises:*

| Fixture | Exercises |
|---|---|
| `fixtures/static-site/` | baseline DOM path, no existing animation convention |
| `fixtures/gsap-site/` | style conformance (§2.4) — must use the project's GSAP pattern |
| `fixtures/python-cli/` | the decline path (§3) |

Outside the repo, because a copy inside `test/` puts this repo's `CLAUDE.md` in the hire's
ancestor chain — it is auto-loaded regardless of any instruction not to read it, and it gives
away the purpose, the technique and the sign-off rule.

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
folder freely and still not reach `CLAUDE.md`, `test/`, `.claude/` or `.git/`.

**Known limitation of this run:** WebFetch cannot reach a local server, so the agent gets a
filesystem path instead of a raw URL. §0 (base-URL derivation) and §5's WebFetch/curl split
are **not tested** here and stay deferred until the repo is pushed.

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
- Technique carried over rather than copy-pasted: custom properties for frame geometry,
  a `steps(N)` cycle matching the chosen sheet's frame count, duration derived from stride and
  viewport (§5)
- `prefers-reduced-motion` handled (§5, §9)
- `git log --oneline` shows **exactly one** commit; no trailer (§8)
- `git status` shows only the implementation plus the sprite sheet, under whatever name the
  fixture's conventions imply; no playbook leftovers, no "MonsterLib" reference (§9)

### C — Language fidelity

*Unregulated in the playbook, hence worth measuring: introduction/questions, handover note,
code comments — each scored separately.*

### D — Actually runs

*No console errors; sprite loads with 200; frames advance past frame 0.*

**Measurement ladder for the trigger.** ① real event → clean pass. ② synthetic event with the
right modifiers → pass, recorded as "handler verified, trigger path not measurable".
③ neither → fail.

*Deferred to the first push:* base URL derivation (§0) and the WebFetch/curl split (§5).

## Run log

| Run | Date | Result |
|---|---|---|
| | | |
