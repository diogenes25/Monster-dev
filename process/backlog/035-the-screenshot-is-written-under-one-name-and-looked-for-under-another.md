# `#035` — the mid-walk screenshot is written under one name and looked for under another, so a blind bundle loses its only visual evidence in silence

| | |
|---|---|
| Status | `proven` |
| Gate | `none` |
| Attribution | harness artefact |
| Criterion | none in the event — the §D marks the screenshot supports were never actually short of it. Latent, and armed for the next run; see the `2026-08-03` log |
| Target file | `process/tools/verify-run.mjs` (`:362`), `process/tools/score-bundle.ps1` (`:121`) |
| Evidence | code review of `main...HEAD`, `2026-08-02`, from reading the two lines against each other; measured `2026-08-03` against all ten run folders and a rebuilt bundle, which is what corrected it |
| Blocked on | nothing |
| Proof design | — |

> **Half of this was wrong, and checking it is what proved the other half.** The name mismatch is
> real. The consequence — *"the bundle is built without the screenshot"* — is **false for every
> run on record**, and the paragraph below is kept as filed with the measurement underneath it.
> See the `2026-08-03` log; this is the second item in three where a confidently-reported
> consequence did not survive being run.

**What happened.** `verify-run.mjs` writes the mid-walk screenshot as `<out-stem>-midwalk.png` —
on disk that is `2026-08-01-alt-a-midwalk.png`. `score-bundle.ps1` copies `midwalk.png`. The names
never matched, the copy finds nothing, and the bundle is built **without** the screenshot and
without a line saying so.

**Measured `2026-08-03`, before anything was changed.** All ten run folders under `process/runs/`
hold a file called exactly `midwalk.png` — not one is called `<id>-midwalk.png` — and a bundle
built for `2026-08-01-index-sonnet` came out holding `criteria.md`, `git.txt`, `hire.json`,
`measurements.json`, **`midwalk.png`** and `transcript.jsonl`. The copy has never failed.

The reason is the `#012` backfill: it placed those files by hand and normalised the names, so
`score-bundle.ps1` was written against what was on disk rather than against what the verifier
writes. The two lines disagree exactly as reported, and the disagreement has never been reached,
because nobody has run `verify-run.mjs` into a run folder since the backfill. It is **latent** —
armed for the next run, which is the first one that would produce `measurements-midwalk.png` and
a bundle quietly missing its only image.

Two things make this worse than a typo.

The `run-scorer` is blind by construction: it sees the bundle and nothing else. A missing file it
was never told to expect is indistinguishable from a file that was never produced, so it scores
the visual criteria off the numbers alone and reports a verdict with no hedge. The second scoring
exists to disagree with the first; here it is quietly given less to look at.

And the bundle has a `MISSING.md` convention for exactly this. It was not used, because nothing
noticed anything was missing.

**Why the current wording allows it.** The two scripts were written a week apart and the name is
derived on one side and literal on the other. `#013`'s Phase 1 mapping table assumed
`<id>-measurements-midwalk.png` and the file on disk is `2026-08-01-alt-a-midwalk.png` — the same
disagreement, found once already in a different document and corrected there rather than at the
source.

**Proposed change.**

> One of the two names becomes the derived one, and the derivation lives in a single place. The
> simpler direction is for `score-bundle.ps1` to derive the name the same way `verify-run.mjs`
> does, from the run id, rather than for the verifier to write a fixed name — because the
> verifier's stem also names `measurements.json` and those two should keep matching each other.
>
> **And the copy is checked.** Whatever the name, a `step: copy screenshot` that finds nothing
> writes the `MISSING.md` line. That guard is the part that survives the next rename; the name
> agreement is what breaks again.

**Proof design.** *`Gate: none`.* Build a bundle for a run that has a screenshot and confirm it is
in the bundle; build one for a run that has none and confirm `MISSING.md` says so.

**What was applied**, in the direction the item's second half argued for rather than its first.

`verify-run.mjs` writes a **fixed name beside `OUT`** — `join(dirname(OUT), 'midwalk.png')` — and
not a stem derived from it. That is the opposite of the proposed change, and the measurement is
why: `midwalk.png` is the name that already exists in all ten run folders, so making the verifier
write it makes the two agree without touching a single file on disk. Deriving in `score-bundle.ps1`
instead would have renamed ten screenshots to fix a bug that has never fired.

**And the copy is checked, which is the part that survives the next rename.** Both optional copies
now record their own absence, not just the screenshot: a `$missing` list, written as one
`MISSING.md` at the end. The transcript branch used to write that file with `Set-Content` on its
own — so a second absence would have *overwritten* the first rather than joined it, which is the
same silent-loss shape one layer up.

Demonstrated both ways. `2026-08-01-index-sonnet`, which has everything: six files, `midwalk.png`
among them, no `MISSING.md`. `ph0-smoke`, which has neither measurements nor screenshot nor
transcript: `MISSING.md` names all three, each with what it costs the scorer.

**Cost.**

- ~~**The two blind scorings on record were run without the screenshot.**~~ **Struck `2026-08-03`:
  measured false.** Both had it. The bundles were built from the backfilled run folders, where the
  file is called `midwalk.png` and the copy succeeds. Neither scoring was less independent than
  intended and neither report needs a boundary added.
- **Deriving a name in two scripts is what caused this.** Deriving it in one and passing it is
  better; a shared helper for one filename is probably not.
- **The guard now writes `MISSING.md` where nothing was written before**, which means a scorer can
  meet a file that no earlier bundle had. That is the intent, and it is worth saying that the
  `run-scorer` role's instructions describe the convention but no bundle on record exercised it.

**Log.**

- `2026-08-03` `formulated` — from the same review as `#032`–`#034`. Filed on its own because it
  is a defect in the *evidence* the second scoring sees, not in a tool's error handling, which
  puts it beside `#016` rather than beside `#033`.
- `2026-08-03` `proven` — applied, and **the item's stated consequence did not survive the check.**
  The screenshot is in every bundle and always has been. What is real is a latent name
  disagreement plus an unchecked copy, which is a smaller finding and a differently-shaped fix:
  the verifier moved to the name already on disk, and the guard covers `measurements.json` as well
  because there was no reason it should not.
- `2026-08-03` — the pattern is now three for three and worth naming. `#032`'s `board` regex was
  reported *verified* and turned out latent; `#033`'s three were real but its `publish-demos.ps1`
  worry about a stale published branch turned out unspent; this one's consequence was false
  outright. **All three came from the same single-reader code review, and all three defects were
  genuine — it is the blast radius that was consistently overstated.** The reusable form: a reader
  tracing control flow can see that two names differ, and cannot see which name is on disk. Filing
  the defect from a read is right; filing the *consequence* from a read is what keeps needing
  correction. Every item from that review now carries a measured line under its claim.
