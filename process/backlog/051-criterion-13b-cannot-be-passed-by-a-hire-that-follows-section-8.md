# `#051` — criterion `13b` cannot be passed by a hire that follows §8, because §8 prescribes the string it searches for

| | |
|---|---|
| Status | `proven` |
| Gate | `none` |
| Attribution | scenario defect |
| Criterion | `alt-a-left-to-right` `13b`. It has never been passed and cannot be |
| Target file | `process/scenarios/alt-a-left-to-right.md` criterion `13`, and the `2026-08-02` change table that introduced `13b` |
| Evidence | `2026-08-03-r15` (3 hits), `2026-08-03-r14` (1 hit), and all ten archived implementations (1–4 hits each) |
| Proof design | — |

**What happened.** `13b` was added on `2026-08-02` to close a real hole — `git status` reports paths
and cannot see a string inside a modified file. Its instrument:

> **13b** A case-insensitive content search over the handed-back worktree finds neither `Monster-Dev`
> nor `MonsterLib`.

`MONSTER-DEV.md` §8, which every hire reads:

> Leave a short handoff note […] **A one-line code comment near the implementation is fine too, e.g.
> `// walking monster easter egg — Monster-Dev`.**

Arm A wrote `// Walking monster easter egg — Alt+A — Monster-Dev` at `script.js:10`, plus the same
signature in `index.html:49` and `style.css:64`. **That is §8's own example with `Alt+A` inserted.**
Arm B wrote one. So the criterion searches for a string the playbook hands the hire as a template, and
a hire that follows §8 fails `13b` by doing so.

**It fails everything, which is the tell.** Checked across the whole record: all ten archived
implementations in `process/stacks/html/css/impl-*/step-4-result/` contain the product name, between
one and four times each. `13b` postdates all ten, and `2026-08-03-r12` wrote no code, so
`2026-08-03-r15` and `-r14` are the **first two runs ever scored against it** — and both fail. A
criterion that nothing has ever passed and that the playbook actively prevents passing is not
measuring the product.

**Why §9 does not rescue it.** §9's second bullet is narrower than `13b`:

> Nothing references "MonsterLib" or "Monster-Dev" **as a dependency, import, or config entry** in the
> target project — this was a one-time job, not a library installation.

A comment is none of the three. And §9's first bullet *presupposes* a signature: *"only the
implementation and the sprite sheet exist as evidence Monster-Dev was here."* So the playbook is
internally consistent — comment yes, dependency no — and `13b` collapsed that distinction when it
widened the search from paths to contents.

**Proposed change.** Keep the second instrument, narrow it to what §9 actually forbids:

> **13b** A case-insensitive content search over the handed-back worktree finds no reference to
> `Monster-Dev` or `MonsterLib` **as a dependency, import, path, or configuration value** — §9's
> scope, which is what the search exists to reach and `git status` cannot. A signature comment is
> **not** a hit: §8 offers one as an example, so scoring it would mark a hire down for following the
> playbook. Record the comments found, as `INFO`.

The `INFO` half is the part worth keeping. Twelve implementations have now signed their work and
nobody decided that was wanted; it is worth counting while the question is open, which is the same
construction as `11b` and `5c`.

**Cost.** Small, and one honest loss: the narrowed instrument is harder to run than
`grep -i monster-dev`, because *"as a dependency, import, path, or configuration value"* takes a
reader rather than a pattern. That is the right trade — `15c` is on this board precisely because a
mechanically checkable criterion measured the wrong thing — but the criterion should say so, so
nobody re-widens it later for convenience.

**Comparability.** None is lost. `13b` has never produced a meaningful verdict, so nothing that was
comparable stops being so. The two `2026-08-03` runs record `13b` as failing **with this item cited**,
and the report attributes it here rather than to either hire.

**Log.**

- `2026-08-03` `formulated` — from `2026-08-03-r15` and `-r14`. Both scorings found the hits
  independently; the **blind pass** found the §8 conflict and put it at the top of its `UNCERTAIN`
  list: *"as written it cannot be passed by a hire that follows §8."* The first scoring had it as
  *"13b overreaches §9"*, which is the same conclusion from the weaker of the two arguments. Same
  shape as `#001`/`15c`: a criterion scoring a behaviour the playbook prescribes.
- `2026-08-03` `proven` — applied to `alt-a-left-to-right.md` criterion `13`, as proposed: §9's four
  categories, the signature comment as `INFO` rather than a hit, and the sentence saying the
  instrument takes a reader so nobody re-widens it to `grep -i monster-dev`. The `2026-08-02` change
  table is left as it stands and a **third boundary section** records the narrowing, because the
  scenario's convention is to append boundaries rather than rewrite them.

  What `proven` means here is what `README.md` says it means in the `Gate: none` lane: **applied, and
  shown to be done rather than to have helped.** There was nothing to flip — the criterion's first
  meaningful verdict will be the next run's, and if that run passes `13b` it will be the first thing
  ever to do so.
