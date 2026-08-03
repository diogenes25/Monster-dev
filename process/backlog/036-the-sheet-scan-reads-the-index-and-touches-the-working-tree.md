# `#036` — the stray-sheet scan reads the git index and then opens files from the working tree, without the guard the same file already wrote for that

| | |
|---|---|
| Status | `proven` |
| Gate | `none` |
| Attribution | harness artefact |
| Criterion | — |
| Target file | `process/tools/check-index.ps1` (`:169`) |
| Evidence | code review of `main...HEAD`, `2026-08-02` |
| Proof design | — |

**What happened.** The stray-sheet scan enumerates PNGs with `git ls-files` and then calls
`Resolve-Path` and `Image::FromFile` on each. `git ls-files` lists the **index**, not the working
tree. A PNG that has been deleted but not yet staged is still in the index, so `Resolve-Path`
throws and `check-index.ps1` dies with a path error instead of reporting on the indexes it exists
to compare.

The same file already knew this. Thirty-odd lines further down, the citation loop carries the
guard and a comment saying exactly why:

> `ls-files` lists the index, not the working tree. Without this guard, deleting a run folder made
> this block throw *"cannot find report.md"* instead of reporting the orphan — the check failing
> for the wrong reason, which is indistinguishable from the check being broken.

That comment was written after the failure had already happened once. The lesson reached the loop
that produced it and not the loop above it.

**Why the current wording allows it.** The two loops were written at different times and neither
references the other. Nothing in the file states the invariant once — *anything derived from
`git ls-files` may be absent from disk* — so it has to be remembered per loop.

**What was applied.** The guard, verbatim from the loop below, with a comment that names the other
site rather than restating the reason. `check-index.ps1` runs green.

The invariant is deliberately **not** hoisted into a helper. Two loops with the same two-line guard
and a cross-reference is legible; a `Get-TrackedFilesOnDisk` wrapper would hide the thing that has
now bitten twice behind a name that does not mention it.

**Cost.**

- **The scan now silently skips a deleted-but-indexed sheet.** That is the correct trade — it is
  what the other loop does, and a sheet that is not on disk cannot reach a mirror — but it does
  mean the check no longer notices that case at all, and nothing else does either.
- **Applied without reproducing it first**, unlike `#032`'s four. It is the file's own established
  pattern copied to a second site, and the reason is documented three lines from where it was
  needed; a synthetic deleted PNG would have demonstrated a mechanism that is already on record in
  this repository.

**Log.**

- `2026-08-03` `proven` — from the same review as `#032`–`#035`, applied immediately because the
  fix is a pattern the file already contains. Recorded rather than folded into `#032` because the
  interesting part is not the bug: it is that a lesson was written down *at the site that taught
  it* and never generalised to the neighbouring loop. That is the same shape as `#003`, which named
  four sites when there were nine.
