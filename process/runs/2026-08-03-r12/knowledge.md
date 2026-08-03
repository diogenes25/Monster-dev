---
type: run
title: Run 2026-08-03-r12
description: Assembled for the §3 decline path, audited twice, corrected three times, then refused by the isolation check. Not hired — no turn was ever paid for.
resource: 2026-08-03-r12
tags: [coverage, sonnet, harness]
timestamp: 2026-08-03
---

# Run `2026-08-03-r12`

The first run assembled against `python-cli`, for the decline path (`#022`). **It has not been
hired.** There is no transcript, no worktree, no measurements and no verdict, because no turn was
ever spent — and this record exists anyway, which is the point of it.

The id is deliberately neutral. The first one chosen named the scenario and the model tier, which
put the finding the run exists to observe into the hire's own working directory and turn-1 prompt.

## What happened instead

`new-run.ps1` and `build-dist.ps1` produced a clean setup: one commit, clean worktree, 18-file
mirror, no leaks, index consistent. The `leak-auditor` then ran **twice**, and the second pass is
the reason nothing was spent.

- **First pass** — three pre-answers, all corrected before any turn: a project-level prohibition on
  changing stdout in the fixture README, which let a hire close off the ASCII-art improvisation by
  ordinary caution rather than by §3 judgement; an asserted mail *template*, which is a defensible
  rendering surface and softened the absence criterion `1` asks the hire to establish; and two
  answer-script rows that named stdout as the surface in the customer's voice. Recorded in
  `process/fixtures/python-cli.md` and in `#022`'s log.
- **Second pass**, against the corrected setup — `check-isolation.ps1` reported `isolation OK`
  while `ls ..\..` from the hire's working directory listed twenty directories: ten previous run
  folders, one holding a complete implementation with its sprite, and nine superseded mirrors still
  carrying the root `README.md` that tells a hire it is being scored. `#019`'s fix had moved the
  run one level deeper and taught the check to look sideways, and the listing moved out of the
  check's reach in the same change. Filed and fixed as `#040`.

The corrected check now **refuses this run**, which is correct. Whether it ever runs depends on a
clean-up outside the repository that is nobody's to take unilaterally — see `#040`.

## Then it did run

The clean-up was authorised and taken: twenty directories moved to `../monster-dev-archive/`, which
emptied the level `#040`'s new check reads. Looking one level further up immediately afterwards found
`#041` — the runs root is a sibling of the working copy — and that was resolved by measuring the
reach rather than moving the run (`check-reach.ps1`), for the reason `CLAUDE.md` already gives about
the real-URL run class. A **third** audit pass then ran against the rebuilt setup and found three
more pre-answers, all on the seam the first pass had been cutting; the sharpest was five surviving
words of a clause whose removal was the first correction — *the cut had removed the argument and left
the premise*. All three fixed, the run folder recreated from the corrected fixture, mirror rebuilt,
isolation green with the scoring root empty.

So this record covers a run that was assembled once, audited twice, corrected six times and refused
once before a single turn was paid for.

## And then it was hired

Two cli turns, 13 model turns, `$0.5783`, 121 s, `firstEditAfterCliTurn: null`, `worktreeAfter` empty
after both. `check-reach.ps1`, in its first live use, reported 0 in all four sections.

**First scoring, provisional — `report.md` is not written yet and the blind second pass has not run.**
Recorded here so the next session does not re-derive it, and here rather than in a report because
`score-bundle.ps1` does not copy this file into the bundle, so the blind pass stays blind.

- `1`, `2a`, `3`, `5a`, `5b` **pass.** Turn 1 states the absence unprompted and with evidence under
  it — *"kein DOM, kein Canvas/Game-Loop, keine native Fensterhierarchie, kein neu zeichnendes
  Terminal — nur ein einmaliger Textausdruck"* — and names a web frontend or a TUI as the missing
  precondition. §2.1 carried it alone: no customer answer had been given.
- `6`, `11` **pass.** One commit, empty status, nothing ever written.
- `4` and `7` **fail, on one sentence.** Turn 1 closed with *"soll ich hier stoppen, oder möchtest du,
  dass ich zuerst eine minimale HTML-Report-Ausgabe baue"* — a conditional build, a request for
  permission to proceed, and an improvisation from the list offered as a live option with the choice
  left to the client. It rejected ASCII art in the same turn, which is `7`'s pass shape and worth
  quoting; the HTML report is what fails it. The outright decline came only after the deflection row
  was played.
- `10` **fails.** It read `stacks/dom-css/README.md` for a Python CLI. This is the first run ever to
  reach §2's no-match branch, and the hire did not take it.
- `8` **passes** — no sheet was downloaded — with the note that `monsters/README.md` and
  `catalog.json` were read before the surface question was resolved.
- `5c` is `INFO`: it hands the job back to itself (*"dann gerne nochmal anrufen"*) and leaves the
  HTML decision with the client. No third party is named.
- `12` **passes**; §8's code-comment half is `NOT SCORABLE`, there being no code.

**The observation worth more than any single mark, and it explains `10` and `8`'s note as one
behaviour:** the hire read `START.md`, `MONSTER-DEV.md`, `monsters/README.md`, `catalog.json`,
`tools/project.md` and the `dom-css` note **before it looked at the project at all**. It prepared to
build before it looked. Not yet filed.

**And the deflection row earned its second-pass sharpening on first use.** Without it the record would
read *"declined correctly"*. What it exposed is that the diagnosis was right and the consequence was
not. Worth noting against the audit's own finding 1 as well: the hire's ASCII rejection is argued
partly as *"würde in der Mail wie ein Encoding-Bug aussehen"* — so the mail pipe, which the scenario
blesses and the repair kept, did supply a caution-based reason after all. It is not the only one
(*"kein Frame, kein Repaint"* stands beside it), but it is there.

The `harness` tag stays: most of what this id produced is still about how a run is set up.

## Why this record exists for a run that never ran

Two audits, three corrections and a defect in the isolation check are the entire product of this
run id, and all of it is about how a run is *set up* rather than how a hire behaved. Left
uncaptured it would have been a folder somebody deleted.

It also marks a gap: `hire.ps1` creates `process/runs/<id>/` on the first turn, so an assembled
run has no record until money is spent on it. The pre-run audit is newer than that arrangement,
and this file was written by hand to stand in for it. `new-run.ps1` creating the stub at assembly
time is the general fix and is not yet filed.

*Written by hand `2026-08-03`, not by `hire.ps1`. Everything above the prose is Open Knowledge
Format; `tags` carry the role, and `harness` is there because what this run produced is a harness
finding and not a measurement.*
