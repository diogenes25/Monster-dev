# tools/ — sorted by who runs it

A script's folder says who is allowed to run it. That distinction matters more than it looks:
one of these folders is fetched by strangers' coding agents, and one of them must never be.

## `provenance/` — never fetched

`New-SpriteSheetFromVideo.ps1` and `New-SpriteSheetFromImage.ps1`: how the sheets in
`monsters/` (and the source material behind `monster.png`) were produced — frame extraction,
silhouette cutout, gait-cycle detection, alignment onto a shared ground line and body axis.

`Test-SheetLoop.ps1` decides whether a finished sheet may ship: it measures the seam a viewer
sees, the last cell handing over to the first, against the sheet's own mean adjacent-cell step.
It exists because the generator's own closure figure is measured on footage and does not predict
that seam — a period it rated an acceptable `1.06x` produced a sheet hitching at `1.39x`. The
figures quoted in `monsters/README.md` come from this script, so they can be reproduced rather
than taken on trust.

Offline, Windows-only, not part of the hiring flow. The video script also writes the
`monsters/catalog.json` entry, so the geometry a client is offered comes from the same
variables that composed the PNG rather than from someone retyping it. `monsters/README.md`
has the recipe and the checks that have to follow it.

If a sheet's frame count changes, see the sync list in the `monster-dev-workshop` skill —
per-monster figures live in the catalog and in `MONSTER-DEV.md` §5, but `green-fuzz-classic`'s
`23` is also baked into `index.html` and into two dev-side scripts the skill names.

## `hire/` — fetched and run by a hired agent

Shortcuts that spare a hire the derivation and the measuring. Two rules hold for everything
here, and both exist to keep the product from quietly turning into a library:

- **It computes, it does not write.** A tool may return frame geometry, cycle counts, a
  crossing duration, a measured shadow offset. It may not emit a finished file. §6 stands:
  the arithmetic can be delegated, the implementation is written by the hire in the target
  project's own idiom.
- **It is a shortcut, never a prerequisite.** The formula stays spelled out in
  `MONSTER-DEV.md` §5 and in the stack notes. A hire without the right runtime does the
  arithmetic itself and carries on — a missing interpreter must never block the job.

Stack-specific tools do not live here. They belong beside the notes that explain them, in
`stacks/<name>/tools/`, so a hire that fetched a stack has its tooling in the same place.

Nothing lands here on a hunch. A tool is earned the same way stack knowledge is, against a bar
recorded dev-side, and a tool that stops clearing it is removed again.

Two more rules decide whether a tool may be a *file* at all — both of them about the same
failure, which is a folder slowly filling with code nobody measured:

- **A tool starts inline in the note that explains it.** Its own file is one more thing to
  fetch and one more thing to run, so it has to save more than it costs before it earns the
  separation. Promote it when it has been shown to pay, not when it looks tidier.
- **Output that is identical for every hire is not a tool, it is a table cell.** If a script
  would print the same number whatever project it runs in, that number belongs in the
  `MONSTER-DEV.md` §5 roster row, where every hire already reads it without running anything.
  What is left over is the real job: whatever depends on *this* project — viewport, stride,
  the timing already in use.

There is no `snippets/` directory here or anywhere else, and there is not going to be one.
Code detached from the decision that justified it is the library this repo is explicitly not.

## Not here: developer tooling

Anything used to *develop* this repository rather than to do a job with it lives elsewhere in the
tree, and the reason it may not live here is recorded next to it rather than in this file. The
split is not tidiness, and it is not negotiable in the direction of moving something in.

---

The actual product of this repo is `/START.md` at the root.
