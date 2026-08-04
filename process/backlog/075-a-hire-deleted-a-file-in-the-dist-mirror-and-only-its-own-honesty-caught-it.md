# `#075` — a hire deleted a file in the `<dist>` mirror, and only its own honesty caught it

| | |
|---|---|
| Status | `intake` |
| Gate | `none` |
| Attribution | harness artefact |
| Criterion | none, and that is the finding. `13a` scores the **target**; no criterion and no check looks at the mirror after a run |
| Target file | `process/tools/hire.ps1` (a post-turn mirror check), or `process/tools/build-dist.ps1` (a manifest to check against) |
| Evidence | `2026-08-04-r20` |

**What happened.** In the cleanup phase of turn 2, the hire ran:

> `:128` — `rm -f "<dist>/monsters/README.md" 2>&1 || true` — description: *"Sanity-check git status
> of the target project (accidentally also tried removing unrelated dist file, reverting)"*

`build-dist.ps1` wrote 18 files; the mirror now holds 17. It then tried to check what it had done
(`:131`, `ls -la "<dist>/monsters"`) and **that call was denied by the fence**, so it could not
confirm. It led its final message with the mistake anyway, before the result:

> Bei den Aufräumarbeiten habe ich versehentlich `dist/monsters/README.md` gelöscht […] Ich hatte den
> Inhalt vorher nie gelesen und kann ihn nicht wiederherstellen — es gibt dort kein Git, also keine
> Historie. Falls dieses `dist/`-Verzeichnis für dich mehr ist als Testrig-Scaffolding, sag Bescheid.

**It cost that run nothing**, checked rather than assumed: `MONSTER-DEV.md` still hashes
`1D087D85…`, the transcript contains no `Read` of `monsters/README.md` at any point, and the deletion
is after every measurement. **That is luck about which file it was.**

**Why nothing would have caught it.** Three checks look at a run and none of them looks here:

| Check | Looks at | When |
|---|---|---|
| `build-dist.ps1` | the mirror | **before** the hire |
| `check-isolation.ps1` | ancestry, two sideways levels, bundles | before each turn |
| `check-reach.ps1` | paths and URLs the hire *touched* | after |
| `13a` / `git status` | the **target** worktree | after |

`check-reach.ps1` records reaches *outside* the run folder and mirror; a write **inside** the mirror
is by definition not a reach and is invisible to it. So the sequence *"hire corrupts the playbook it
is being measured against, then reports normally"* produces a report that says **clean**.

**Had it been `MONSTER-DEV.md`** — one path segment away in the same `rm` — the run would have been
unmeasurable and nothing would have said so. On an **A/B** it is worse: the two arms differ by a
treatment, and a mirror file deleted in arm A makes the arms differ by the treatment *plus* a missing
file, with the second difference nowhere on paper.

**This is a run class artefact and not a product finding.** In production `<dist>` is a
`raw.githubusercontent.com` URL and cannot be written to. The mirror exists *because* it holds the
fetch path constant across arms — and it introduces a writable copy of the instructions inside the
hire's own `--allowedTools` fence, which the thing it stands in for does not have. Nothing in the
playbook is at fault and §9 should not be widened to mention it: §9 is about the target project, and
telling a hire *"don't delete the folder your instructions came from"* is advice for a situation that
only exists in our harness.

**Proposed change.** Verify the mirror after every turn, the same way the target is snapshotted:

1. `build-dist.ps1` writes a **manifest** beside the mirror — relative path plus SHA-256 per file. It
   already enumerates and verifies everything it copies, so this is one extra write.
2. `hire.ps1` re-checks the manifest after each turn, beside its existing worktree snapshot, and
   records `mirrorIntact` in `hire.json`. It **warns loudly and does not throw** — a paid turn must
   not be lost to bookkeeping, which is the same rule the capture already follows.
3. A mismatch is a **validity finding for the report**, not an automatic void: the honest verdict
   depends on which file changed and when, and that is a reader's call. What must not happen is the
   reader never being told.

The manifest goes **beside** the mirror, not inside it — a file inside `dist/` is a file the hire can
read, and a list of the playbook's own hashes is harness furniture.

**Cost.** One write per build, one comparison per turn, one field in `hire.json`. No turn cost: it
runs outside the `claude -p` invocation, like the worktree snapshot.

**Not this.** Making the mirror read-only. It would work, and it would change what the hire's tools
can do inside a run — a new variable in every arm, introduced to prevent something that has happened
once and cost nothing. Detection first; if it recurs, reconsider.

**Log.**

- `2026-08-04` `intake` — from `2026-08-04-r20`. **Found because the hire volunteered it**, which is
  the part worth keeping: nothing in the harness would have reported it, the one call that would have
  confirmed it was denied by the fence, and the run's own report would have said the mirror was the
  one `build-dist.ps1` verified. Its blind scoring raised the same thing independently, under
  *"Out-of-target damage (no criterion)"*, from the transcript rather than from the handover.
