# `#055` — `tools/project.md` advertises a `hire/` folder to every hire, and it has never existed in any mirror

| | |
|---|---|
| Status | `proven` |
| Gate | `none` |
| Attribution | harness artefact — documentation, not tooling |
| Criterion | — |
| Target file | `tools/project.md` (the `## hire/` section), `CLAUDE.md`'s layout table |
| Evidence | `2026-08-03-r15` pre-run audit; refuted as a live hazard across all eleven earlier transcripts |
| Proof design | — |

**What happened.** `tools/project.md` is in the mirror and carries:

> ## `hire/` — fetched and run by a hired agent
>
> Shortcuts that spare a hire the derivation and the measuring.

`tools/hire/` is an **empty, untracked directory**. `git ls-files tools/` returns `project.md` and the
three `provenance/` scripts and nothing else, and git does not track empty directories — so the folder
has never been in a mirror and no hire has ever been able to reach it. `CLAUDE.md`'s layout table lists
it as *"Cross-stack hire tooling — fetched by a hire: **yes**"*.

Read charitably the section is a statement of *rules* for hire tooling, and its last paragraphs say so
(*"Nothing lands here on a hunch"*). Read as a hire reads it, the heading and the first sentence
describe a folder that is there.

**Why it was not fixed before the run that found it.** The `leak-auditor` raised it as noise in the
metric `#002` compares: a hire could spend turns hunting for advertised tooling. Measured instead of
assumed:

- `tools/project.md` appears in **ten of eleven** transcripts on record. Effectively every hire reads it.
- `tools/hire/` appears in **none**. Zero reaches, ever.

So the hazard is refuted for eleven runs, and editing a published file on the morning of a paid A/B to
chase it would have been the wrong trade — the arms' whole value is differing by one paragraph. Neither
`START.md` nor `MONSTER-DEV.md` mentions `tools/` at all, so the only route in is a hire listing the
mirror.

**What is left is an honesty defect rather than a cost one**, and it is worth one line: the repository
tells strangers, in two places, that something is fetched which cannot be. That is the class `#037` is
about.

**Proposed change.** Not drafted. Three options, in ascending honesty and cost: delete the empty
directory and leave the section as the rules it is; add a clause saying the folder is empty until a tool
earns its way in, which is what *"Nothing lands here on a hunch"* already implies; or move the rules into
`MONSTER-DEV.md` §5 where the arithmetic they govern lives, and drop the section. `CLAUDE.md`'s table row
needs correcting either way.

**Cost.** Trivial, and one thing to hold: whatever is written must not read as an invitation to start
filling the folder. The rules in that section are the strongest statement in the repository about why the
product is not a library, and they are worth keeping wherever they end up.

**Log.**

- `2026-08-03` `intake` — from the pre-run audit of `2026-08-03-r15`, filed with its own refutation
  attached so nobody re-raises it as urgent. `check-index.ps1` does not catch it: it verifies §2's stacks
  and §5's sheets against the tree, and `tools/project.md`'s pointers are not an index it reads.
- `2026-08-03` `proven` — the middle option, plus the empty directory removed. Three edits:

  - The heading becomes *"the rules for tooling a hire may fetch"* and the section opens by saying
    outright that there is no such folder and never has been, that this is the standard something would
    have to meet, and that a hire should not read the absence as anything missing — §5 carries the
    formula a tool would shortcut. The two rules are untouched, because the item is right that they are
    the strongest statement in the repository about why the product is not a library.
  - `CLAUDE.md`'s layout row is corrected: it named `tools/hire/` as fetched. It now names the *file*
    and says the folder does not exist.
  - The empty untracked `tools/hire/` is deleted. Local-only either way — git tracks no empty directory
    — but the item's one constraint is that nothing may *"read as an invitation to start filling the
    folder"*, and an empty folder of that name is exactly that invitation.

  **Option three was declined, and not on cost.** Moving the rules into `MONSTER-DEV.md` §5 would edit
  the product to repair a documentation defect, and it would bill every hire for a page of policy about
  tooling that does not exist. §5 is a roster a hire reads to get numbers out of.

  Applied, not shown to have helped — and here that is the whole of it, since the item's own measurement
  already refuted the cost hazard: `tools/project.md` in ten of eleven transcripts, `tools/hire/` in
  none. What was repaired is an honesty defect, the class `#037` is about, and no run will show it.
