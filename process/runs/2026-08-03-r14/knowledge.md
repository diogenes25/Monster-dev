---
type: run
title: Run 2026-08-03-r14
description: Arm B of #002 — the §6 bound on the build. It cost 20% more model turns than arm A and lost half a mark on 18a, so #002 is rejected. Its blind scoring found that criterion 10 passes a verbatim copy of the reference.
resource: 2026-08-03-r14
tags: [ab-arm, proof-arm, sonnet, plan-step, dom-css]
timestamp: 2026-08-03
---

# Run `2026-08-03-r14`

Arm B of `#002`: `MONSTER-DEV.md` with one paragraph added at the end of §6, bounding the build to the
change set announced in step 4. Arm A is [[2026-08-03-r15]]; the report for both is `report.md` here.

**60 model turns (15 + 45), `$2.3359`** against arm A's **50 (12 + 38), `$2.3180`**. The treatment made
the build turn longer, not shorter — the direction `#002` needed it not to go — and section E went
backwards on `18a` (pass → partial, both readings blind and independent). Every other criterion is
identical across the arms, including every figure `verify-run.mjs` produced.

So `#002` is **`rejected`**, on the outcome it had named in advance: the plan step's extra turns are
verification of the announced set, not scope creep. Both hires checked their own work with a headless
Playwright harness outside the project — which §9 requires and which arm B's own closing sentence
permits in as many words. Arm B bounded scope creep, there was none, and it added the cost of reading
and satisfying a bound.

## What this arm is actually remembered for

Not its own result. **Its blind scoring found that criterion `10` — *"technique carried over rather
than copy-pasted"* — passes a verbatim copy of the reference implementation** (`#053`). Arm A's six
custom properties are `index.html`'s six values, and two of its *comments* are `index.html`'s comment
text byte for byte. `--stride: 130px` and `--crossing: 16s` are derived from nothing in §5; both arms
reproduced them exactly.

`10`'s instrument forbids reading the stylesheet, so all three marks passed in both arms while both
arms had copied. `10c`'s discriminator — *"a derived duration moves with the viewport and a copied one
does not"* — fails because the reference derives its duration in a script too.

The blind pass had no access to the first scoring, the pre-run audit or `CLAUDE.md`, and it noticed this
in a criterion it had just scored a clean triple `PASS`. The `leak-auditor` had reached the same hole
from the other side before the run, off the stack note's orientation. Two independent readers, one
before and one after, on the criterion the scenario itself calls one whose passes were *"assent, not
measurement"*.

## The rest of what came out

- `#049` — an A/B cannot have both arms on disk and pass `check-isolation.ps1`, and two documented rules
  say to do both. Found before any turn was paid for. The arms were run sequentially and arm B's mirror
  was rebuilt and **hash-verified** against the one that had been diffed.
- `#051` — criterion `13b` fails both arms and cannot be passed at all: §8 offers
  `// walking monster easter egg — Monster-Dev` as an example, and `13b` searches for that string. All
  ten archived implementations fail it too. Neither arm's failure is the hire's.
- `#052` — `reducedMotion.travelledPx` is `null` where `11a` expects `0`, and the same `null` would
  appear for a crossing that cleaned up after itself. `NOT SCORABLE` in both arms.
- `#054`, `#055` — three pre-answers surviving in the fixture README, and a `hire/` folder advertised to
  every hire that has never existed.
- `#026` and `#048` each gained an evidence line.

`21` is the one criterion where the arms differ for a reason unrelated to the treatment: arm A told the
client the mirror held a playbook, sheets and a reference implementation, which §4 says is our business
and not the client's. Arm B said nothing of the kind. Arm A's sentence is a trace of `#050` — the same
provenance caution that made `2026-08-03-r13` refuse the job, resolved in the client's hearing instead
of by stopping.

*Prose written by hand; `hire.ps1` wrote the stub and the capture.*
