# `#049` — an A/B cannot have both arms on disk and pass the isolation check, and two documented rules say to do both

| | |
|---|---|
| Status | `formulated` |
| Gate | `none` |
| Attribution | harness artefact |
| Criterion | — |
| Target file | `.claude/skills/monster-dev-workshop/SKILL.md` (step 2), `process/tools/check-isolation.ps1` (the level-2 sideways look), `CLAUDE.md` if the procedure changes |
| Evidence | `2026-08-03-r13` / `2026-08-03-r14`, found while assembling `#002`'s two arms |
| Proof design | — |

**What happened.** Two rules, both current, both written down, and they cannot both be obeyed.

`SKILL.md` step 2, on building an A/B:

> Build both arms and **diff the two mirrors before hiring against either**. One file should differ
> and it should differ by exactly the treatment.

`check-isolation.ps1`, the second level of the sideways look, added by `#040`:

> The testruns root may hold this run's folder and nothing else.

An arm lives at `<runs>/<id>/target` with its mirror at `<runs>/<id>/dist`. So two arms are two
directories in the runs root, and the moment both exist, **each arm fails isolation because of the
other** — with a message that is exactly right about the danger: `ls ..\..` would show a hire the
other arm, and for an A/B the other arm is a finished implementation of the *identical* brief against
the *identical* fixture. That is `#019`'s exposure in its sharpest possible form.

Both rules are correct. The conflict is that nobody ran a below-file-level A/B between `#040` landing
and `-Variant` landing — the same day — so the first attempt to use both is the first time they met.
`SKILL.md`'s own `-Without` example writes `<run-id>-armA`, which has the same shape and predates the
level-2 check.

**What was done instead, and it is not a workaround so much as the honest order.** Build both, diff
them, **delete the arm that runs second**, hire the first, archive it, then rebuild the second arm
with the same one-line command. Rebuilding is not hand-rolling: `build-dist.ps1 -Variant` is
deterministic and verifies what it built, so the arm that runs second is byte-identical to the one
that was diffed — and *that* can be checked rather than asserted, by hashing the mirror before
deleting it and after rebuilding.

**Proposed change.** Write the sequence down, because the alternative is that whoever runs the next
A/B rediscovers the conflict mid-setup, having already built two mirrors:

> **An A/B is assembled and run one arm at a time.** Build both mirrors, diff them, record the
> treated file's hash, then delete the second arm's folder. Hire arm A, capture it, move its run
> folder to the archive root, rebuild arm B with the same `-Variant` command, and check the hash
> matches what you recorded. Only then hire arm B.
>
> The reason is not tidiness: for an A/B the two arms share a brief and a fixture, so the other arm
> is the answer sheet, and `check-isolation.ps1` is right to refuse.

**Not proposed:** an `-Arm` allowance in `check-isolation.ps1` that lets sibling arms coexist. It
would be two lines and it would re-open the exposure on the one run class where the sibling is most
dangerous.

**Cost.** An A/B is now strictly sequential, so the two arms are separated in time by however long
the first takes. Nothing in the gates reads wall-clock, and both arms already share a mirror-build
date; but a run pair that straddles a change to this repository is no longer comparable, and the
procedure should say to build both mirrors up front — which it already does — precisely so the
*playbook* both arms read is frozen before either runs.

**Log.**

- `2026-08-03` `formulated` — found while assembling `#002`'s arms as `2026-08-03-r13` and
  `2026-08-03-r14`. Both mirrors built and diffed cleanly (one file, one paragraph, verbatim), and the
  conflict appeared at the next step. `#040` is a week old in commits and one day old in practice;
  this is the first A/B on the other side of it.
