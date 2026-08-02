# `#019` — the run folder's parent holds every previous solution to the same brief, and one hire listed it

| | |
|---|---|
| Status | `formulated` |
| Gate | `none` |
| Attribution | harness artefact |
| Criterion | all of A, B and E at once, if a sibling is ever opened |
| Target file | `process/tools/new-run.ps1`, `process/tools/build-dist.ps1`, `process/tools/check-isolation.ps1` |
| Evidence | `2026-08-01-sonnet-base2` transcript — a full `ls -la` of the parent, `2026-08-02` |
| Proof design | — |

**What happened.** Every run folder and every mirror is a direct child of
`../monster-dev-testruns/`. The hire's working directory is one of them, and the `<dist>` it is
pointed at is its sibling. One `ls ..` therefore shows the whole series.

Not hypothetical. `2026-08-01-sonnet-base2`, verbatim from the transcript:

> `drwxr-xr-x … Aug  1 15:34 2026-08-01-alt-a\ndrwxr-xr-x … Aug  1 19:43 2026-08-01-live\n… Aug  1 16:28 2026-08-01-phase1.dist\n… Aug  1 17:25 2026-08-01-phase2\n… Aug  1 17:13 2026-08-01-phase2.dist\n… Aug  1 18:56 2026-08-01-phase2b\n… Aug  1 18:52 2026-08-01-phase2b.dist`

Dated folders in matching `<name>` / `<name>.dist` pairs, with model names in them
(`sonnet-base`, `plan-opus`). The listing alone says: this is a series of paired experiments and
you are inside one.

**Bounded honestly:** that hire listed and went no further. Grepping its transcript for any path
*into* a sibling returns only the listing itself, twice, and no file was read. Every other run's
transcript is clean of foreign run ids. So the exposure on record is the listing, not a copy.

The exposure available was larger. `2026-08-01-plan-sonnet/style.css:64` reads
`/* walking monster easter egg — Monster-Dev (press Alt+A) */`, and ten worktrees hold a finished,
already-scored implementation of the identical brief against the identical fixture — same
`steps(23)`, same stride derivation, sprite included. A hire that opened one would score full marks
on section A while doing no analysis at all, and criterion 10 — *carried over rather than
copy-pasted* — would be measuring a copy of a copy.

**Why the current wording allows it.** `check-isolation.ps1` walks the run folder's **ancestry** for
`CLAUDE.md` and confirms one commit. Ancestry, not siblings. The reasoning in `process/README.md`
and in the scenario is entirely about what a parent directory injects into context automatically —
`CLAUDE.md` gets auto-loaded, so that is the danger that got written down. A sibling injects nothing
automatically; it just sits there, one command away, and no check has ever looked sideways.

**Proposed change.**

> **One run, one parent.** `new-run.ps1` creates `../monster-dev-testruns/<run-id>/target/` and
> `build-dist.ps1` creates `../monster-dev-testruns/<run-id>/dist/`. The hire's working directory is
> then `…/<run-id>/target/`, whose parent holds exactly its own mirror and nothing else. Arms of one
> A/B stay together, which is correct — they are one experiment — and every other run is two levels
> away instead of one.
>
> **`check-isolation.ps1` gains a sideways look** to match its ancestry walk: if the run folder's
> parent contains any directory that is not this run's own, it fails. It already refuses to hand
> back a folder that is not isolated; this is the same refusal against a second definition of
> isolated.

Leaving the runs where they are and telling the hire not to look was not considered seriously: the
prompt is the customer brief plus one sentence, and adding *"do not read the neighbouring folders"*
would tell a hire the neighbours are worth reading.

**Proof design.** *`Gate: none`.* Harness artefact. Nothing about the playbook changes.

The archive keeps a single recorded caveat, on `sonnet-base2` alone: it saw the listing. No claim is
made that it used it, because the transcript says it did not.

**Cost.**

- **Every path in the harness moves one level.** `new-run.ps1`, `build-dist.ps1`, `hire.ps1`,
  `check-isolation.ps1`, the skill's Half B, `CLAUDE.md`'s command block, and every example run
  command. This is exactly the class of change that broke the `test/` → `process/` rename, so the
  rule from that scar applies: change every site, then build one and look inside it.
- **It collides with `#023`**, which is restructuring `process/runs/` in the same motion. Doing both
  at once risks confusing *where a run executes* with *where a run is recorded* — the two halves
  `#013` opens by separating. They should land in one sitting, with that distinction stated, or the
  second one will read as undoing the first.
- **It was about to break a check that had not been written yet.** `#013`'s capture backstop keyed
  on *"a directory under `../monster-dev-testruns/`, ignoring `*.dist`"*, which this item's layout
  makes match nothing. Answer **C4** re-keyed that check inside the repository, so the collision is
  closed — but it is recorded here because neither item had noticed it, and this layout will do the
  same thing to the next check written against the old shape.
- **The ten rescued run folders keep the flat layout.** They are an archive and are not re-run;
  reshaping them buys nothing and breaks the paths `#012`'s backfill was written against.

**Log.**

- `2026-08-02` `intake` — found by the leak auditor built for `#017`, on its first pass, blind to
  the board. It reported the exposure from the layout alone; the transcript evidence was found
  afterwards while checking whether the exposure had ever been taken.
- `2026-08-02` `formulated` — measured and bounded: one hire listed the parent, no hire opened a
  sibling, no other transcript contains a foreign run id.
- `2026-08-02` — **C1**: the item this collides with is `#023`, not `#013`. This item said "Part 1"
  and described Phase 1 — two different halves of the same item, and the split removes the ambiguity
  rather than resolving it in prose. **C4**: `#013`'s capture backstop, which this layout would have
  silently disabled, is re-keyed inside the repository; recorded above as a cost of the layout, not
  as a defect of the backstop.
- `2026-08-02` — **D1** and **D4**: this item lands in one sitting with `#018`, which is the only
  other open edit to `build-dist.ps1` that matters to a mirror, and a mirror is built and read by
  eye afterwards. It also has to land with `#023`, which moves the *other* directory — recorded in
  the cost section above. Those are two different pairings on two different files, and this item is
  in both.
