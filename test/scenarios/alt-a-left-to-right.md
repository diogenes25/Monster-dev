# Scenario: Alt+A easter egg, left to right

A repeatable Monster-Dev test run. The hired agent must never see this file — it
contains both the answer script and the acceptance criteria.

## Target project

A copy of `test/fixtures/static-site/` placed **outside** this repository, at
`../monster-dev-testruns/<run-id>/`, initialised as a git repo with a single
commit `Initial site`.

Outside, because a copy inside `test/` would put this repo's `CLAUDE.md` in the
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

`<dist>` is a copy of this repo's tracked files (`git ls-files`) minus `test/`,
`.claude/` and `CLAUDE.md`, so the agent can list that folder freely and still not
reach the harness, the skill, or the summary of the playbook. All three are
**tracked** — they no longer drop out on their own, which is why the mirror is
only ever built by `test/tools/build-dist.ps1`, which verifies what it built.

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
10. Technique carried over rather than copy-pasted: custom properties for frame
    geometry, a `steps(N)` cycle matching the frame count of the sheet actually
    downloaded, duration derived from stride and viewport (§5)
11. `prefers-reduced-motion` handled (§5, §9)
12. `git log --oneline` shows **exactly one** commit; no trailer (§8)
13. `git status` shows only the implementation plus the sprite sheet; no playbook
    leftovers, no "MonsterLib" reference (§9)
14. **14a** Was the choice of monster offered at all (§4)?
    **14b** With no preference stated, did it use `green-fuzz-classic` — and are
    the frame count, cell size and cycle in the implementation that sheet's?
    Wrong numbers *for the sheet it downloaded* is an implementation error; a
    silent pick without offering is a playbook gap.

*Deferred to the first push:* base URL derivation (§0) and the WebFetch/curl
split (§5).

**Criteria changed on 2026-08-01**, when the roster replaced the single sheet:
9, 10 and 13 stopped naming `monster-walk.png` and `steps(23)`, 14 is new, and the
old 14–16 became 15–17. The two runs below predate that and scored the old
wording, so only the untouched criteria compare directly across the boundary.

### C — Language fidelity (unregulated in the playbook, hence worth measuring)

15. **15a** Introduction and questions in German?
    **15b** Handover note in German?
    **15c** Code comments in German?

### D — Actually runs

16. No console errors; sprite loads with 200
17. Frames advance — not stuck on frame 0

**Alt+A measurement ladder.** ① real key press → pass, "real key path".
② otherwise a synthetic `KeyboardEvent` with `altKey: true` → pass, but recorded
as "handler verified, key path not measurable in this browser" rather than a
clean pass. ③ neither → fail.

### E — The plan step (§4)

**Appended on 2026-08-01, not inserted.** 1–17 keep their numbers so they still
compare against the six archived runs. E is scored from `<run-id>.hire.json` plus
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
    measurement — see [`2026-08-01-plan-retro.md`](../runs/2026-08-01-plan-retro.md).

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

**Risk criteria — must hold, not improve.** 4a, 7a, 10 and 19. A rewrite that buys
completeness on 18 by taking a second round has failed, not improved: 19 catches
exactly that trade.

## Run log

| Run | Date | Model | Result |
|---|---|---|---|
| `2026-08-01-alt-a` | 2026-08-01 | Opus | baseline — [report](../runs/2026-08-01-alt-a.report.md), [findings](../runs/2026-08-01-alt-a.findings.md) |
| `2026-08-01-phase1` | 2026-08-01 | Opus | restructure is behaviour-neutral; every criterion held, cost +36 % — [report](../runs/2026-08-01-phase1.report.md) |
| `2026-08-01-sonnet-base` | 2026-08-01 | Sonnet | bar baseline. Asked before building where Opus never did → K7 was model disposition, not a playbook gap. Also solved both `dom-css` pitfalls unaided, leaving the planned A/B with no arms — [report](../runs/2026-08-01-sonnet-base.report.md) |
| `2026-08-01-phase2` | 2026-08-01 | Opus | F2 proven: K4a flipped after four runs failing it. K7a turned out to be biased by the harness's own dialogue-protocol sentence, so it is unmeasurable rather than failing. Cost $4.04 — [report](../runs/2026-08-01-phase2.report.md) |
| `2026-08-01-phase2b` | 2026-08-01 | Opus | Prompt fix + roster. K7a flipped on the model that failed it three times — it was the harness, not the playbook and not the model. Roster works (14a/14b), K10 held. Cost $1.84, **−54 %**: asking first means building once — [report](../runs/2026-08-01-phase2b.report.md) |
| `2026-08-01-sonnet-base2` | 2026-08-01 | Sonnet | Before-arm for the §4 plan step, and the first Sonnet run under the corrected dialogue protocol. Every criterion 1–17 passed; section E scored **18: 1/4** — primitive named, injection point / change set / sheet numbers not. 31 model turns, $1.66 — [report](../runs/2026-08-01-plan-sonnet.report.md) |
| `2026-08-01-plan-sonnet` | 2026-08-01 | Sonnet | **Proof run for the §4 plan step.** 18 went 1/4 → **4/4** on the bar model, nothing regressed, 21 held. Turn 1 got shorter and 39 % cheaper; total turns rose 32 %, over the soft ceiling, entirely in the build turn. Also exposed a second-level verifier bug: CSS-visible ≠ visible — [report](../runs/2026-08-01-plan-sonnet.report.md), [findings](../runs/2026-08-01-plan-sonnet.findings.md) |
| `2026-08-01-plan-opus` | 2026-08-01 | Opus | Control for the same change. 18: 4/4, and `phase2b`'s criterion-21 failure did not recur. Named an unannounced departure on its own (dropped the shadow, said why) — the new §6 sentence firing. 41 turns, $2.72 — [report](../runs/2026-08-01-plan-sonnet.report.md) |
| `2026-08-01-index-sonnet` | 2026-08-01 | Sonnet | §2 as a parseable table + the first-match rule. **Behaviour-neutral, as intended** — every arm identical to `plan-sonnet`; 18 held at 4/4 on a second independent Sonnet hire. First failure on **20a**: announced a container in `index.html`, built without one, never flagged the substitution. The turn overrun reproduced (42), which corrects Phase 2's hedge — [report](../runs/2026-08-01-index-sonnet.report.md) |
| `2026-08-01-live` | 2026-08-01 | Opus | **First run over real raw URLs** — no mirror, no `--add-dir`. §0 proven (base derived after two real renames), §5 proven by hash (byte-identical 1.9 MB sheet cannot come through WebFetch). §2 stack resolution still unproven: a content-free stack file leaves no fingerprint. Cost $1.61 — [report](../runs/2026-08-01-live.report.md) |
