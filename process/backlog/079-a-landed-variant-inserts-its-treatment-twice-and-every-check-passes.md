# `#079` — a variant whose treatment has landed inserts it a second time, and every check passes

| | |
|---|---|
| Status | `proven` |
| What `proven` means here | `Gate: none` — **the check is in and its failure path is re-runnable, which is the whole bar in this lane.** It has never caught a real mistake, because the one it was written from was made deliberately |
| Gate | `none` |
| Attribution | harness artefact |
| Criterion | — |
| Target file | `process/tools/build-dist.ps1` (the `-Variant` block), `process/variants/README.md` |
| Evidence | verified `2026-08-04` while folding `#061` in — not a run finding and not a hypothesis, the mirror is quoted below |

**What happened.** `#061`'s treatment was folded into `MONSTER-DEV.md` §3 on `2026-08-04`. Its arm
file `process/variants/061-s3-b.psd1` was then applied to a mirror built from the folded-in tree, on
purpose, to find out how it failed:

```
PS> .\process\tools\build-dist.ps1 -RunId zz-foldin-dup -Variant 061-s3-b
IndexOk : True          # returned the mirror; threw nothing
PS> grep -o "finishing with what you found" dist/MONSTER-DEV.md | wc -l
2
```

§3 in that mirror carries the treatment twice, once in each grammar — the arm's *"You may … you may
not"* followed immediately by the folded-in *"Asking … is fine; asking … is not"*:

> …say so plainly and stop. That means finishing with what you found, not with a question about what
> to build instead. You may ask whether you have missed a surface that already exists; you may not
> ask whether to create one. **That means finishing with what you found, not with a question about
> what to build instead. Asking whether you have missed a surface that already exists is fine;
> asking whether to create one is not.** Name what would need to exist first …

**Why the current mechanism allows it.** `After` + `Insert` is checked for the **anchor** matching
exactly once, and folding a treatment in leaves the anchor untouched by construction — `#061`'s
anchor is *"say so plainly and stop."*, which is the sentence the treatment was inserted *after* and
therefore the one sentence the fold-in could not disturb. So the count stays 1, the insert lands, and
the mirror passes the harness-vocabulary check, the frontmatter check and `check-index.ps1`, because
duplicated playbook prose is not any of the things they look for.

`process/variants/README.md` names three hard failures and this is not among them:

> **It must match exactly once.** Zero means the anchor was edited or mistyped and the arm would be
> built with no treatment in it. Two means the treatment lands in an arbitrary one of two places.

Both cases it does name are about *where* the insert goes. This one is about the insert being
**redundant**, which is `zz-noop`'s question — *"replaces a sentence with itself, so the edit changes
nothing"* — asked of `Replace` only. `Insert` has no equivalent, and an `Insert` whose text is
already in the file is the same defect: an edit that should be a no-op instead produces a file nobody
described.

**And it is the failure mode that README calls the worst one.** Its own words, about the two-match
case: *"the mirror still builds, the run still runs, and the two arms differ by an amount nobody can
state — which is worse than no A/B, because it still produces a number that looks like an answer."*
A double-inserted treatment is exactly that, one step further along: the arms differ by a treatment
applied twice, and the only reader who would notice is one who reads §3 in the mirror by eye.

**Proposed change.** One clause in the `-Variant` block, and it is the `Insert` counterpart of the
check `Replace` already has:

> An `Insert` whose text is already present in the file throws, the same way a `Replace` that changes
> nothing throws. `BROKEN: variant '<name>' inserts text already present in '<file>' — has this
> treatment been folded in?`

Plus a fifth `zz-` fixture, since the README's standard for a failure path is that it stays
re-runnable rather than being demonstrated once in a commit message: `zz-landed`, an `Insert` of a
sentence the playbook already contains.

**Cost.** Two lines in a script and one fixture file. The one substantive question is whether an arm
could ever legitimately want to insert text the file already has elsewhere — a duplicated sentence in
two sections as the treatment itself. No arm on record does, `#002`'s and `#061`'s both insert new
prose, and the throw names the fold-in case so an operator who really wants it knows what to relax.
Cheaper than the alternative, which is that a stale variant file is a live trap for as long as it
sits in the folder, and `#061`'s is now the second file in there whose treatment has landed.

**One thing this does not fix**, and it is why the banner went on the file as well as this item being
opened: an arm file for a landed treatment is *wrong* rather than merely dangerous, and no check can
say which of the two directions the operator meant. `061-s3-b.psd1` is kept because three reports
cite it, so it carries a `LANDED — DO NOT APPLY` header naming the inverse file a future untreated
arm would need. The check proposed here turns that header from the only defence into the second one.

**Log.**

- `2026-08-04` `intake` — found by deliberately misusing `-Variant` after `#061`'s fold-in, rather
  than by a run. Filed with the mirror quoted, because the whole point of the finding is that the
  mirror looks fine.

- `2026-08-04` `proven` — **applied in the same sitting, straight past `formulated` and `grilled`.**
  The lane's own reason: the attribution was settled by the evidence that filed it, and the proposed
  change was already exact. What went in:

  - **The check**, in `build-dist.ps1`'s `-Variant` block, positioned inside the `After` branch after
    the `Insert` key test and **before** the string is applied — so it throws through the same catch
    as every other variant failure and the mirror is deleted rather than handed back. The `Insert` is
    compared trimmed, since the leading space or newline that joins it to the anchor is a joining
    artifact and not part of the treatment.
  - **`zz-landed.psd1`**, the fifth negative fixture. Its anchor is *"Follow it in order."* and its
    insert is §1's *"One knock on the door is enough."* — a valid, once-matching anchor and text the
    file already has, which is precisely the combination the other four fixtures cannot express.
  - **`process/variants/README.md`** — the *changed something* rule stated as its own rule rather
    than folded into *matches exactly once*, because the point is that the match count cannot reach
    it. The `zz-` table went to five and its snippet now loops all of them.
  - **`build-dist.ps1`'s `.PARAMETER Variant` help**, one paragraph, same argument.

  **Verified, and the second half is the half that mattered:** all five fixtures throw, with
  `zz-landed`'s message naming the fold-in question — and `002-arm-b`, the one live arm on disk,
  still builds with `IndexOk: True` and its edit reported. A check that rejects the bad case and the
  good one is not a check, and this project has shipped an instrument that measured nothing four
  times (`#009`, `#010`, `#007`, and the `-SimpleMatch` grep of `2026-08-03`).

  **One thing looked at and left alone.** A rejected build deletes its mirror and leaves the empty
  run parent `<runs root>\<id>\` behind, which is what made the first reading of this session's test
  output look like a failure. It is litter and not an exposure — an empty folder in the runs root
  discloses nothing, and the two-level sideways checks already govern that directory — so the README
  now says to delete it instead of a check being added for it.
