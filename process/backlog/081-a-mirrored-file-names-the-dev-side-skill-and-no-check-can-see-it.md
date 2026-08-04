# `#081` — a file inside the mirror names the dev-side skill, and the vocabulary check cannot see it

| | |
|---|---|
| Status | `intake` |
| Gate | `none` |
| Attribution | harness artefact |
| Criterion | none directly. It degrades the premise under **every** mark in sections A and B — that the hire does not know it is being measured (`#018`'s class) |
| Target file | `tools/project.md` § the sync paragraph; `process/tools/build-dist.ps1`'s `$HARNESS_VOCABULARY` if it is to be caught mechanically |
| Evidence | `2026-08-04-r21`'s pre-run audit, and `2026-08-03-r17`, which **read that file** |

**What happened.** `tools/project.md` is published — it is in the mirror, 18 files of which this is
one — and it says:

> `tools/project.md:24` — *"If a sheet's frame count changes, see the sync list in the
> `monster-dev-workshop` skill — per-monster figures live in the catalog and in `MONSTER-DEV.md` §5,
> but `green-fuzz-classic`'s `23` is also baked into `index.html` and into two dev-side scripts the
> skill names."*

That hands a hire the **name of the dev-side skill** — the file holding the run procedure, the
scenario template and the criteria machinery — in a repository whose working copy is three `cd ..`
from the run folder (`#041`) and whose `process/` and `.claude/` trees are world-readable on `main`
by design (`#031`). It is a search term for the one tree the blindfold exists to keep shut.

Two more lines in the same file, weaker and folded in here rather than filed separately:

> `:4` — *"one of these folders is fetched by strangers' coding agents, and one of them must never
> be."*
>
> `:49-50` — *"Nothing lands here on a hunch. A tool is earned the same way stack knowledge is,
> against a bar recorded dev-side, and a tool that stops clearing it is removed again."*

The first tells the reader that it *is* the strangers' coding agent; the second that knowledge here
is admitted against a measurement bar recorded elsewhere. A scenario-blind reader plausibly extracts
only *"this project has a contribution bar"*, which is ordinary open-source prose — but together with
`:24`'s skill name they stop being generic.

**It is not hypothetical: `2026-08-03-r17` read the file.** That run's ninth and last tool call of
turn 1 was `Read: <dist>\tools\project.md`, immediately after it fetched the stack note. So one run on
record has had `:24` in its context. `2026-08-04-r21` did not read it — which is one of the
differences between the two arms of `#067`'s regression, in `r17`'s disfavour and outside the
treatment.

**Why nothing caught it.** `build-dist.ps1`'s check 3a greps every mirrored `.md` for a harness
vocabulary — `acceptance criteri`, `test run`, `test hire`, `test harness`, `criterion by criterion`,
`what is being measured`, `comparability`, `A/B`. **A skill name is none of those.** The check was
built from the leaks somebody had already found (`#003`'s shape), and all three of those were prose
*describing* the experiment. This is a **pointer** to it, which is a different thing and reads as
ordinary developer documentation.

The path list cannot help either: `tools/` is published on purpose, because `tools/project.md` § `hire/`
states the rules cross-stack hire tooling would have to meet.

**Proposed change.** Two parts, and the order matters because one of them is cheap and safe and the
other is a check that could go wrong.

1. **Reword `:24` so it names no dev-side artefact.** The sentence's job is to tell a contributor that
   changing a sheet means updating several places; it can do that without naming where the list lives:
   *"…is also baked into `index.html`. If you change a sheet, grep for its figures before assuming
   §5 and the catalog are the only copies."* That is strictly more useful to the reader it is written
   for, and it removes the term.
2. **Decide whether the vocabulary list gains an entry.** `monster-dev-workshop` is a literal string
   and cheap to grep, and unlike the eight terms already there it cannot fire on legitimate playbook
   prose — `MONSTER-DEV.md` and `START.md` never mention it. Against: a list of names is `#003` again
   at one remove, and the next dev-side artefact will be called something else. **Recommendation: add
   it anyway**, because the failure it catches is silent and the false-positive risk is nil — but add
   `.claude/` and `process/` as literal strings in the same pass, since a mirrored file naming either
   path is the same leak by a different route.

**Cost.** Part 1 is one sentence in a published file, and it changes the mirror — so it may not be
done in the middle of a series that is comparing arms. `#067`'s regression is closed, so the window
is now. Part 2 costs a rebuild of every future mirror and would have to be verified against the
current tree first: if any published file already names `process/` or `.claude/`, the check fails on
day one and the finding is bigger than this item.

**Not this: dropping `tools/` from the mirror.** It carries the `hire/` rules a contributor needs and
`MONSTER-DEV.md` does not point at it, so a hire only reaches it by listing the mirror — which is
legitimate behaviour and not something to design around by removing published material.

**Log.**

- `2026-08-04` `intake` — from `2026-08-04-r21`'s pre-run audit, which found it **before** the turn was
  bought and was told not to act on it, because acting would have changed that arm's mirror relative
  to `r17`'s and cost the regression its comparability. Recorded in that run's `assembly.md` with the
  reason. The `r17` sighting was found afterwards, while comparing the two arms' tool calls for the
  report — which is what makes this a case rather than a possibility.
