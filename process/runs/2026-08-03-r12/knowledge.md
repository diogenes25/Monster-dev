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
