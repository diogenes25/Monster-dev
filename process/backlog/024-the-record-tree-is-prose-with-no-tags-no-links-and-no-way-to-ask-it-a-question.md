# `#024` — the record tree is prose with no tags, no links and no way to ask it a question

| | |
|---|---|
| Status | `formulated` |
| Gate | `none` |
| Attribution | owner decision |
| Criterion | — |
| Target file | `process/runs/**/knowledge.md`, `process/tools/check-index.ps1`, `process/tools/build-dist.ps1`, `process/stacks/README.md`, `process/backlog/README.md`, `CLAUDE.md` |
| Evidence | owner decision `2026-08-02`; split out of `#013` the same day (answer **C1**) |
| Blocked on | `#013` for the `knowledge.md` the frontmatter goes on — `#023` landed `2026-08-02` |
| Proof design | — |

**Split out of `#013` (answer C1).** This is the metadata convention, and it is separated because it
needs nothing from the run capture and the run capture should not wait for it. `#013` is losing data
today — a transcript and a worktree per run, one set already destroyed. This item is losing nothing;
it is buying a way to ask the archive a question. Bundled, its two rule collisions held the backup
hostage.

**What happened.** `process/stacks/` is prose with no links, no tags and no backlinks. There is no
way to ask *"everything we know about stride"* or *"which runs touched §4"*. Today that costs
little, because the tree holds one implementation. `#012` adds eighteen more files to it and `#013`
adds a scrubbed transcript per run; at that size an unindexed tree is a folder people stop opening.

**Why the current wording allows it.** No rule is broken. The tree is four days old and was defined
by `#008` as a place to *put* things; nothing has yet asked it a question it could not answer by
being read end to end.

**Proposed change — and it is smaller than `#013` had it.**

*Frontmatter, on runs only (answer **C2**).*

> `process/runs/*/knowledge.md` adopts the **Open Knowledge Format** (Google Cloud, v0.1,
> `2026-06-12`): Markdown with YAML frontmatter, required `type`, optional `title`, `description`,
> `resource`, `tags`, `timestamp`. Four `type` values, and no more without an item: `run`,
> `implementation`, `surface`, `observation`.
>
> **`process/stacks/` keeps plain Markdown.** `CLAUDE.md:42` requires every `impl-NN/knowledge.md` to
> *open with* a `Stack: <name>` line naming the published stack it belongs to, repeated at
> `process/stacks/README.md:22`, and `#008` calls that line *"the whole mapping between the two
> keys"*. OKF makes the first line `---` and has no field for a published stack — `resource` is spent
> on the run id. A metadata convention is not a good enough reason to move a line the two-tree design
> rests on.

*Tags, and the honest consequence of C2.*

> Tags are **free-form**, not a controlled vocabulary. `check-index.ps1` enforces the form
> (lowercase-kebab) and nothing else, and **renders** a tag overview from the files themselves — it
> does not write one. That is `board.ps1`'s doctrine applied unchanged: the index *is* the folder,
> and there is no second place for it to drift. Synonyms are therefore not prevented; they are made
> visible — `stride` and `schrittlaenge` appear next to each other and someone merges them.

**A controlled vocabulary was considered and rejected**: it is a second index that can drift, and
`process/backlog/README.md` has already reasoned this out once — *"There is no search key, and that
is deliberate."* That reasoning was about scenario-local criterion numbers and does not transfer
whole, but the hazard does.

Under C2 the tag overview covers `process/runs/` and not `process/stacks/`, which is the tree the
navigability complaint was actually about. That is a real reduction and is recorded rather than
absorbed: what remains reachable in the record tree is the `Stack:` line, and wikilinks, which need
no frontmatter. **If a tag layer over `process/stacks/` is wanted, it needs its own decision** —
C2 closed the frontmatter route to it, and no other route has been designed.

*Wikilinks, in both trees, because they are body syntax.*

> Cross-references are `[[wikilinks]]` in the body of any file in the record tree, `process/stacks/`
> included — plain Markdown carries them and no frontmatter is required. `check-index.ps1` fails on
> a link with no target, as it already does on a `DEAD POINTER`.

*The frozen copies (answer **C3**), which C2 has already spared.*

> `step-1-fixture/**` and `step-4-result/**` are byte copies by explicit design (`#012`), and `#014`
> needs `step-4-result/` byte-identical so a published demo is the thing that was actually handed
> back. `#013` required frontmatter on *"every `.md` under `process/stacks/`"*, which would have
> edited them. **C2 removes that requirement wholesale**, so C3 has nothing left to exclude — but the
> rule is stated here anyway, because the next convention will walk into the same files: **nothing
> writes into `step-1-fixture/` or `step-4-result/`.** A copy that has been edited is not a copy, and
> the four-step tree's whole value is that steps 1 and 4 are untouched.

*The boundary, enforced at the only place that cannot go stale.*

> **Nothing about what a hire fetches changes.** `stacks/<name>/README.md` stays the only exit from
> this tree, gate-controlled, frontmatter-free, 40-line orientation cap plus measured pitfalls. A
> fetched knowledge base and a generated public export were both considered and **rejected by owner
> decision on `2026-08-02`**: each costs a turn per fetch — the metric the tooling gate is stated in
> — and reopens the criteria leak `build-dist.ps1` exists to close.
>
> The enforcement lives in **`build-dist.ps1`, against the finished mirror**: every `.md` in it whose
> **first line** is `---`, or which contains `[[`, fails the build and the mirror is deleted rather
> than returned. Note the first-line restriction — `---` as a horizontal rule is legal and
> load-bearing in a stack note, where it separates orientation from pitfalls. No path is named, so
> the check cannot go stale when a new published path appears.

The wikilink half of that rule is a hazard this item found rather than inherited. A paragraph
promoted through the gate carries its `[[stride]]` with it, and a hire then reads a pointer into a
tree it cannot fetch — the same failure as *"citation is an identifier, never a locator"*, arriving
by a new road. **C2 raises this half rather than lowering it**: `process/stacks/` keeps wikilinks
and loses frontmatter, and `process/stacks/` is precisely the tree paragraphs are promoted *from*.
The `---` half stays as a standing guard on a rule that now has an exception.

*Scripts, deliberately minimal.* A script is knowledge like prose: it lives with the run that
produced it, runnable and tagged. The route out is the one `CLAUDE.md` already states — start
inline, A/B with cost, and only then a file under `stacks/<name>/tools/`. No staging area is built,
because there is nothing to stage: `tools/hire/` is empty, `stacks/dom-css/tools/` does not exist,
and **none of the ten runs produced a script**. The tooling gate is in the same position §7 is in
under `#011` — written down, never exercised.

The frontmatter rule survives all of this intact, because it was never a rule about Markdown. Its
stated reason is in the workshop skill: *"It bills every hire for metadata only we read."* That is a
rule about **fetched** files, and `process/` is never fetched. The sentence in
`process/backlog/README.md` — *"For the same reason as everything else on this side: no YAML
frontmatter"* — is the one that has to change, because its "same reason" does not survive
inspection: the board's justification is consistency, not billing. The board itself does **not** move
to OKF; converting it would break `board.ps1`'s parser for no gain. Two metadata conventions in one
repository is the accepted cost, recorded as a decision rather than left to be discovered.

**Proof design.** *`Gate: none`.* A developer-side format: no criterion to flip, no run to spend,
`proven` by being applied — and, because Part 5 touches the mirror, only after a mirror has been
built and **looked inside**. A green script is not evidence and this repository has the scar.

One claim is deliberately **not** made: that a traversable record makes hires better. It is not
measured here and could not be. Only an A/B in front of `stacks/dom-css/README.md` can establish
that, and this item puts no line into that file.

**Cost.**

- **A rule gains an exception, which is the expensive kind.** "No YAML frontmatter" becomes "no YAML
  frontmatter on anything a hire fetches" — correct, and one reading away from someone adding
  frontmatter to a published note because *"the wiki has it"*. The mirror check is the mitigation,
  and it has to be mechanical for exactly that reason.
- **Two conventions inside `process/`**, after C2: OKF under `process/runs/`, plain Markdown with a
  `Stack:` first line under `process/stacks/`. Defensible per tree and confusing in aggregate; the
  boundary between them is a directory name, which is at least the kind of boundary a script can
  check.
- **The wiki rots unless the link check lands with it, not after it.** This repository already treats
  index drift as a first-class hazard; a `[[wikilink]]` graph with no checker reintroduces exactly
  that under a nicer name.
- **The sharpest cost, and the least visible.** The better this tree reads, the more publishable it
  looks. The one-way street currently holds partly because `process/stacks/` is awkward prose nobody
  would think to ship. Making it navigable and pleasant removes that accidental friction, and then
  only the gate is left holding the line. The mirror check exists for this reason alone, and it is
  the part most likely to be quietly eroded.

**Log.**

- `2026-08-02` `formulated` — split out of `#013` as answer **C1**(c), carrying its Parts 4 and 5 and
  the matching phases. It stays `formulated` rather than arriving `grilled` with its siblings,
  because C2 changed what it covers: the tree the navigability complaint named is now out of scope
  for the tag layer, and no replacement has been designed.
- `2026-08-02` — **C2**: OKF applies to `process/runs/` only; `process/stacks/` keeps the `Stack:`
  first line. **C3**: dissolved by C2, and the byte-identity rule for `step-1-fixture/` and
  `step-4-result/` is stated explicitly anyway, since the collision was with the convention and not
  with this wording of it.
