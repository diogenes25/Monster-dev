---
type: audit
title: Pre-run audit — 2026-08-03-r13 (arm A of #002)
description: The leak-auditor's nine findings on the assembled setup, and what was decided about each before a turn was paid for.
resource: 2026-08-03-r13
tags: [audit, ab-arm, sonnet]
timestamp: 2026-08-03
---

# Pre-run audit — `2026-08-03-r13`

Written by hand before the first turn, because `hire.ps1` creates this folder on the first *paid*
turn and there is nowhere else for pre-run work to live. That is `#048`, and this is its second
instance in two runs.

`leak-auditor` on the assembled setup: **nine findings.** Every one of them is a property of the
`static-site` fixture, the `dom-css` stack note, or the mirror — so **every one is identical in both
arms of `#002`.** That is the reading that decides the run: arm A and arm B differ by one paragraph
in `MONSTER-DEV.md` §6 and by nothing else, so none of what follows can bias the comparison. What it
does damage is stated per finding.

## Acted on: nothing. The run proceeds.

## The one finding that was checked and refuted

`dist/tools/project.md:28-30` heads a section *"`hire/` — fetched and run by a hired agent —
shortcuts that spare a hire the derivation and the measuring"*, and **`tools/hire/` does not exist in
any mirror.** It is an empty, untracked directory locally; git does not track empty directories, so
no hire has ever been able to reach it. `CLAUDE.md`'s layout table asserts it is fetched. The
auditor's concern was that a hire reads the pointer and spends turns hunting — noise injected
directly into the number this A/B compares.

Measured instead of assumed, across all eleven transcripts on record:

- **`tools/project.md` appears in ten of eleven.** Effectively every hire reads it.
- **`tools/hire/` appears in none.** Zero reaches, ever.

So the dead pointer has stood in front of ten hires and cost zero turns. Editing a published file on
the morning of a paid A/B to chase a hazard eleven runs refute is the wrong trade, and this item's
whole value is that the two arms differ by exactly one paragraph. **Not fixed before the run**; filed
as a documentation defect instead. Neither `START.md` nor `MONSTER-DEV.md` points at `tools/` at all,
so the only route in is a hire listing the mirror.

## What the findings cost the guards, which is not nothing

The measured quantity — build-turn count — is pre-answered by nothing. Two of the *guards* are
weaker than they read, and the report must say so rather than report `4/4` and `10 pass` as if they
were clean:

- **Criterion `10` is pre-answered from two directions**, and it is the risk criterion every A/B on
  record leans on. `dist/stacks/dom-css/README.md:27-29` describes `index.html` as having *"sprite
  geometry in custom properties, a `steps(N)` walk cycle, and a small script deriving the crossing
  duration from the real viewport width"* — which is a checklist of `10a`, `10b` and `10c`'s three
  instruments. The phrase *custom properties* appears nowhere in `MONSTER-DEV.md`. Separately, the
  two provenance scripts in the mirror print a copyable `--frame-w` / `--sheet-w` / `steps(N)` block,
  and `build-dist.ps1`'s vocabulary grep reads only `.md`, so no mirror check looks at them. The
  scenario already says `10`'s ten passes were *"assent, not measurement"*; this says why.
- **`18c` is answered before turn 1.** `target/README.md:12` reads *"`assets/` — `logo.svg` lives
  here, and anything else static would too"*, which is where the sprite goes. `#015` repaired this
  fixture's README and the fixture note flags only `script.js:1-2`; this line survived. Criterion `9`
  is pre-answered twice over, the second time by the stack note's *"next to whatever
  `logo.svg`-equivalent it has"* — generic phrasing that degenerates into a string match in a fixture
  whose file is literally `logo.svg`.
- **Criterion `8`** — *"no dependency, no new animation library"* — is handed over as a project
  instruction: `target/README.md:19-20`, *"Keep it that way if you can — the site has survived three
  redesigns by not depending on anything."* A hire passes `8` by obedience without reasoning about
  §2.4.
- **`18b`** is restated in prose at `target/README.md:3,11` (*"no build step and no framework"*,
  *"smooth-scroll for the nav links, and nothing else"*), so it needs no investigation.

The `dom-css` note's orientation also hands over the **two-element structure** — gait on one element,
travel on another (`:14-16`) — above the note's `---` rule, i.e. inside the gate-free orientation
exemption. That is the one structural decision in a `dom-css` build that costs turns to get wrong, so
the absolute build-turn figures both arms produce are figures for a build that was already
half-specified by ungated advice. The 40-line cap holds (35 lines, `check-index.ps1` green) and the
leak happens anyway, which is a finding about the exemption rather than about the cap.

## One finding not accepted

`alt-a-left-to-right.md:81` — the auditor flagged, unsure, that *"einmal pro Tastendruck"* already
tells a hire every press must produce a crossing, so `4b` cannot fail. Read narrowly the row answers
*what one press does* and withholds the mid-walk repress case, which is what `4a`/`4b` exist to
separate. The author's reading stands; the auditor said itself it might be reading it more narrowly
than intended, and it was the other way round.

## What this does to the baseline #002 names

Checked while triaging, and it matters more than any single finding above. `#002`'s proof design says
*"`sonnet-base2`'s 19/31 is the floor to read against, not a third arm to re-run"*. But
`process/fixtures/static-site/README.md` and `tools/project.md` both changed on `2026-08-02` in
`ac2808b` — after every baseline run, all of which are dated `2026-08-01`. `#015`'s repair removed
the *"Expected Monster-Dev behavior"* heading those hires read.

So `19`, `28` and `30` were measured against a target and a mirror that no longer exist. **That is an
argument for this design rather than against it:** arm A re-measures the baseline under today's
mirror, on the same day, against the same fixture as arm B. The historical figures stay as context
and stop being the floor. `stacks/dom-css/README.md` is the one file that did *not* materially change
— `ac2808b` reworded only the placeholder below its `---` rule — so the orientation contamination
above is not new and was in front of the baseline hires too.

## Board

Nothing filed yet, on purpose: the procedure reads the open board at scoring time, so these are
carried here and filed with the run's report rather than twice. Candidates — the fixture README's
three surviving pre-answers, criterion `10` being pre-answered from two directions, and the
`tools/hire/` dead pointer.
