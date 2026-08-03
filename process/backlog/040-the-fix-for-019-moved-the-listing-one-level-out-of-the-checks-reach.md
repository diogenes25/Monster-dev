# `#040` — `#019`'s fix moved the dangerous listing one level beyond the check that was added to catch it, and the check reported clean

| | |
|---|---|
| Status | `proven` |
| Gate | `none` |
| Attribution | harness artefact |
| Criterion | all of A, B and E, for any run assembled since `#019` landed — and `#018`'s leak on top, via nine superseded mirrors |
| Target file | `process/tools/check-isolation.ps1`; the twenty directories in `..\monster-dev-testruns\` are an owner decision, see below |
| Evidence | found `2026-08-03` by the `leak-auditor`'s **second** pass on run `2026-08-03-r12`; every claim reproduced by hand before this was written |
| Blocked on | nothing for the fix. The clean-up is not this item's to take |
| Proof design | — |

**What happened.** `#019` found that every previous run folder sat one `ls ..` from the hire — ten
finished, already-scored implementations of the identical brief — and fixed it two ways at once:
the run moved from `..\monster-dev-testruns\<id>` down to `..\monster-dev-testruns\<id>\target`,
and `check-isolation.ps1` gained a sideways look.

The sideways look follows the **run folder**. After the move, the run folder's parent is the run
root, which by construction holds exactly `target` and `dist`. So the check inspects a directory
that cannot contain anything dangerous, and the listing it was written to catch moved to `..\..`,
where nothing looks at all.

Measured on `2026-08-03`, on a run assembled and about to be hired against:

```
check-isolation.ps1  ->  isolation OK — parent holds 1 other directory: dist
ls ..\..             ->  20 directories: 10 run folders + 9 superseded mirrors + this run
```

Two distinct exposures were sitting in that listing, and the second is worse:

- `2026-08-01-alt-a\` holds `index.html`, `script.js`, `style.css` and `assets/monster-walk.png` —
  a complete implementation of the brief, sprite included.
- **Nine `*.dist` mirrors still contain the root `README.md`.** That is `#018` exactly: the file
  that tells a hire it is a fresh agent in a scored test run, which reached eight of the first ten
  hires. `build-dist.ps1` greps the mirror it is building; it has no view of last week's mirrors
  left on disk beside it.

`#019` is `proven` and its own account is accurate about what it changed. What nobody did was ask
whether the check still pointed at the thing after the layout moved underneath it.

**Why the current wording allowed it.** The docstring states the rule correctly — *"the run
folder's parent may hold this run's own directories and nothing else"* — and that sentence was
true of the old layout, where the run folder's parent **was** the testruns root. The same words
describe a different directory after the move, and they describe it accurately, so nothing reads
as stale. `CLAUDE.md` repeats it in the same form.

This is the sharpest instance yet of the rule this repository already states about the mirror:
**a green check is not evidence.** Here the check was not merely weak, it was *actively
misleading* — it printed a sibling count of 1 and named `dist`, which reads as a positive
confirmation that the parent was inspected and found clean.

**What was applied.** The sideways look is now two levels: the run root may hold `target` and the
declared siblings, and the **testruns root may hold this run's folder and nothing else**. The two
levels are reported separately, because *"something is beside you"* and *"something is beside your
parent"* need different clean-ups.

Demonstrated three ways: the corrected check fails on the real run with **20 findings** where it
previously passed; a clean two-level layout still passes; and each level fires on its own against
a planted directory.

The check now **refuses run `2026-08-03-r12`**, which is correct and is the point. Nothing has
been hired.

**The clean-up is deliberately not part of this.** Twenty directories outside the repository, and
deleting them is not free:

- All ten results **are** preserved — `#012` backfilled every one into
  `process/stacks/html/css/impl-NN/step-4-result/`, verified by the `Source: run [[<id>]]` line.
- But `process/runs/<id>/worktree` exists for **none** of them. These ten predate `#013`'s
  per-turn capture, so the folders on disk hold the only full worktree; the repository has the
  deliverable and not the whole tree.

So the options are archive-outside-the-parent, capture-then-delete, or delete-and-accept, and the
choice belongs to whoever owns the material rather than to whoever found the defect.

**Cost.**

- **Every run assembled since `#019` is affected, and there has been one.** `2026-08-03-r12` was
  assembled and audited and not hired, so no measurement is damaged. Had the second audit not run,
  this run would have been spent inside that listing.
- **The nine leaking mirrors mean `#018` is not closed the way it reads.** `#018` is `proven` and
  the exclusion works; what was never true is that a hire cannot reach a copy of `README.md`. That
  belongs in `#018` as a boundary and is not folded in here.
- **The check is now strict enough to be annoying**, and that is the intended direction: the
  testruns root holding exactly one run means every run either gets cleaned up after or has to be
  moved aside. A check that made this convenient would be the check that just failed.

**Log.**

- `2026-08-03` `proven` — found by the `leak-auditor`'s **second** pass on the same setup. The
  first pass, on the same run, did not report it: it found three real pre-answers in the fixture
  and the answer script, all fixed, and the rebuilt setup was re-audited because a first verdict
  says nothing about a setup edited since. That re-audit is the only reason this was found before
  a turn was paid for, and it is the strongest argument on record for running the role twice.
- `2026-08-03` — every claim was reproduced by hand rather than taken from the report, which is
  the standing correction from `#032`, `#033` and `#035`: that reader's defects were real three
  times and its blast radius overstated three times. Here the blast radius was **understated** if
  anything — the report named the implementations, and the nine `README.md` copies turned out to
  be the sharper half.
- `2026-08-03` — the general shape, because it is the third time in two days: `#036` was a lesson
  written at the site that taught it and never carried to the neighbouring loop, `#003` named four
  sites when there were nine, and this is a *fix* that relocated its own subject. All three are
  the same failure to re-ask **"does the check still point at the thing?"** after changing the
  thing.
