# Scenario: Alt+A easter egg, left to right

A repeatable Monster-Dev test run. The hired agent must never see this file — it
contains both the answer script and the acceptance criteria.

## Target project

A copy of `test/sample-static-site/` placed **outside** this repository, at
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

`<dist>` is a copy of this repo's tracked files only (`git ls-files`), so the
agent can list that folder freely and still not reach `CLAUDE.md`, `test/` or
`.git/`. It is the same surface a push to GitHub would make public.

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

## Run log

| Run | Date | Model | Result |
|---|---|---|---|
| `2026-08-01-alt-a` | 2026-08-01 | Opus | baseline — [report](../runs/2026-08-01-alt-a.report.md), [findings](../runs/2026-08-01-alt-a.findings.md) |
| `2026-08-01-phase1` | 2026-08-01 | Opus | restructure is behaviour-neutral; every criterion held, cost +36 % — [report](../runs/2026-08-01-phase1.report.md) |
| `2026-08-01-sonnet-base` | 2026-08-01 | Sonnet | bar baseline. Asked before building where Opus never did → K7 was model disposition, not a playbook gap. Also solved both `dom-css` pitfalls unaided, leaving the planned A/B with no arms — [report](../runs/2026-08-01-sonnet-base.report.md) |
| `2026-08-01-phase2` | 2026-08-01 | Opus | F2 proven: K4a flipped after four runs failing it. K7a turned out to be biased by the harness's own dialogue-protocol sentence, so it is unmeasurable rather than failing. Cost $4.04 — [report](../runs/2026-08-01-phase2.report.md) |
| `2026-08-01-phase2b` | 2026-08-01 | Opus | Prompt fix + roster. K7a flipped on the model that failed it three times — it was the harness, not the playbook and not the model. Roster works (14a/14b), K10 held. Cost $1.84, **−54 %**: asking first means building once — [report](../runs/2026-08-01-phase2b.report.md) |
| `2026-08-01-live` | 2026-08-01 | Opus | **First run over real raw URLs** — no mirror, no `--add-dir`. §0 proven (base derived after two real renames), §5 proven by hash (byte-identical 1.9 MB sheet cannot come through WebFetch). §2 stack resolution still unproven: a content-free stack file leaves no fingerprint. Cost $1.61 — [report](../runs/2026-08-01-live.report.md) |
