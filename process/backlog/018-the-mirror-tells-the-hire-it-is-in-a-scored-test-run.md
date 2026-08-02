# `#018` — the mirror's own prose tells the hire it is a fresh agent in a scored test run, and eight of ten read it

| | |
|---|---|
| Status | `formulated` |
| Gate | `none` |
| Attribution | harness artefact |
| Criterion | the premise under every criterion — that the hire does not know it is being measured |
| Target file | `README.md`, `tools/project.md`, `monsters/README.md`, `process/tools/build-dist.ps1` |
| Evidence | all ten transcripts, scanned `2026-08-02` |
| Proof design | — |

**What happened.** `build-dist.ps1` excludes `process/`, `.claude/` and `CLAUDE.md`, verifies the
exclusion, and deletes a mirror that leaked. It works. What it does not check is whether the files
it *did* copy describe the harness — and three of them do.

`README.md:39-43`, in the mirror, under its own heading:

> ## Monster-Dev gets better by being tested
>
> Every improvement here has to earn its place. **A test run hires a fresh agent against a sample
> project, scores it criterion by criterion**, and the gaps it finds become proposed wording
> changes — which are then only kept if a rerun shows a hire actually behaving differently.

`tools/project.md:67-68`, in the mirror — the sentence written to keep the criteria out of the
mirror, inside the mirror:

> That is not tidiness. **The verifier encodes the acceptance criteria**, so publishing it under
> `tools/` would put "what is being measured" straight into the mirror a hire receives.

`monsters/README.md:49`, in the mirror:

> **Leave `default` alone** unless you mean to change what every client gets who has no preference.
> Changing it also **breaks comparability with every earlier test run** in `process/runs/`.

**Eight of the ten transcripts contain the `README.md` sentence**, as Read tool results with the
file's own line numbers attached:

> `…\n38\t\n39\t## Monster-Dev gets better by being tested\n40\t\n41\tEvery improvement here has to earn its place. A test run hires a fresh agent against a sample project, scores it criterion by criterion`

Three also contain the `tools/project.md` or `monsters/README.md` sentence. The `index-sonnet` hit
still reads `test/tools/`, which dates it correctly to before the rename.

**This one is worse than `#015`, and in the way that matters most.** `#015` split exactly by model:
six Opus runs contaminated, all four Sonnet runs clean, so the arm the gates are read off survived.
This one hits **both** models — `sonnet-base`, `sonnet-base2`, `plan-sonnet` and `index-sonnet` are
all in the eight. Sonnet is the bar. There is no clean arm.

Only `alt-a` and `live` are clean, and `live` only because it fetched over real URLs and never
listed a mirror directory.

**Why the current wording allows it.** `build-dist.ps1`'s own header states the goal as *"exactly
the surface a push to GitHub would make public, minus the two things that would invalidate the
run"* — and the model of *what invalidates a run* is a **path** model: `process/`, `.claude/`,
`CLAUDE.md`. Every check that follows asks whether a named folder arrived. None asks what the
permitted files say. A repository whose public README explains that it improves itself by scoring
test hires is a good README; it is simply not one a test hire may read.

**Proposed change.**

> **`README.md` joins the exclusion list.** It is the repository's face for a human on GitHub, and
> that is the only reader it has: a hire's entry point is `START.md`, by design and since the first
> run. Excluding it costs a hire nothing and costs production nothing, because in production there
> are no criteria to leak. This is the identical trade already accepted for `CLAUDE.md`.
>
> **The two dev-side sentences leave the published folders entirely.** `tools/project.md`'s
> paragraph about where the verifier lives, and `monsters/README.md`'s warning about comparability
> with earlier test runs, are about the harness. They belong under `process/`, which is excluded
> already, and neither is of any use to someone regenerating a sprite sheet or reading about the
> tools split.
>
> **And a check that cannot go stale, because a growing path list will.** After the mirror is
> assembled and before it is handed back, `build-dist.ps1` greps every `.md` in it for a small
> harness vocabulary — `acceptance criteria`, `test run`, `criterion`, `what is being measured`,
> `comparability` — and fails the build, deleting the mirror, naming file and line. No path is
> named, so a new published file cannot slip past it. This is `#013` Part 5's shape applied to a
> second leak class.

The vocabulary has to be validated against a mirror built from the *fixed* files, not the current
ones — the current ones trip it, which is the point. A term that fires on legitimate playbook prose
comes out of the list rather than the file being reworded around it.

**Proof design.** *`Gate: none`.* Half C: fix the harness, rerun, record nothing against the
product.

What it cannot do is repair eight runs. Unlike `#015`, no criterion is specifically compromised —
what is compromised is the premise beneath all of them, and there is no way to quantify what a hire
does differently knowing it is scored. The honest handling is the same as `#015`: a recorded
boundary in the eight reports and in the scenario, not a re-scoring and not a deletion.

**Cost.**

- **Eight of ten runs gain a caveat that cannot be bounded**, and this time it includes every Sonnet
  run — the bar. That is the real price, and the archive is worth less than it was yesterday.
- **The mirror drifts further from "what a push makes public."** It is already minus `CLAUDE.md`
  for this exact reason; this makes the gap a policy rather than an exception, and the header has to
  say so plainly.
- **A vocabulary check is a check that can start lying.** Add a term that fires on real playbook
  prose and someone will reword the playbook to satisfy the harness. Mitigation: the list is short,
  it is validated against a passing mirror, and a term that fires on `MONSTER-DEV.md` is removed
  rather than accommodated.
- **`README.md` excluded means a hire listing the mirror sees a repository with no README.** Mildly
  odd, and less odd than one that explains the experiment the reader is inside of.

**Log.**

- `2026-08-02` `intake` — found by the leak auditor built for `#017`, on its first pass, blind to
  the board.
- `2026-08-02` `formulated` — verified by hand before being written down: the three quotes read out
  of a freshly built mirror, and the transcript hits confirmed as Read tool results in eight of ten
  runs, including all four Sonnet runs.
