# `#069` — `CLAUDE.md` carried every incident narrative into every session, as a third copy

| | |
|---|---|
| Status | `proven` |
| Gate | `none` |
| Attribution | owner decision |
| Criterion | none — no criterion reads `CLAUDE.md`. It is not fetched by a hire, so the gates cannot see this at all. See *What proven means here* |
| What proven means here | The cut is **applied and verified against the tooling**, not shown to have helped. Nobody has measured a session working better against a shorter `CLAUDE.md`, and by the nature of the file nobody can with the three gates. Read this row before citing the item as evidence that the file is now the right length |
| Target file | `CLAUDE.md`, `monsters/README.md` |
| Evidence | owner decision `2026-08-03`; measured before and after; applied in `3f22ebc` |
| Blocked on | nothing |
| Proof design | — |

**What happened.** `CLAUDE.md` had grown to **29,678 B / 267 lines** (29,411 B as the committed LF
blob) and is loaded into *every* session in this repository, whether or not the session touches a
run. Measured against the other three documents, most of its bulk was a **third copy** of material
that already had a home:

| String in `CLAUDE.md` | Also in |
|---|---|
| `#042`, `#048`, `#056`, `run-root`, `scratchpad`, `harness vocabulary` | 4–5 board items each, **and** `SKILL.md` |
| the `#019` → `#040` → `#041` chain | `process/README.md`, in the same substance |
| `1.06x` → `1.39x`, the shipped-seam case | `monsters/README.md`, the file `CLAUDE.md` already named as *"full recipe"* |

The authoritative copy of an incident is its board item, which carries the evidence. The rationale
copy is `process/README.md`. `CLAUDE.md`'s copy was the third — and the only one billed to every
session. `process/README.md` already said so of the procedure: *"the exact sequence … lives in the
`monster-dev-workshop` skill. Keep it that way rather than duplicating steps here; when the two
disagree, the skill is what actually gets executed."* The `Commands` section was that duplicate,
and a competing copy that can drift.

**What was done.** `CLAUDE.md` → **23,836 B / 185 lines** (23,651 B as blob), **−19.7 %**:

| Section | Before | After |
|---|---|---|
| `Commands` incl. the run harness | 10,433 | 6,038 — a nine-row command table plus eight rules no exit code enforces |
| One run, one parent | 4,077 | 3,156 |
| The mirror is a blindfold, not a vault | 2,940 | 2,512 |
| The one invariant that silently invalidates everything | 1,942 | 1,885 |
| Sprite-sheet pipelines | 1,930 | 606 — a pointer and the two traps that are easy to get wrong from outside |

Untouched: *What this repository is*, *Two features*, the layout table, *The proof gates*, *The
shape of published knowledge*, the skill pointer, the `START.md` / `MONSTER-DEV.md` rule.

**The one rule the cut had to obey.** Provenance in this file is **load-bearing against
re-optimisation** — it says of itself *"a green script is not evidence"* and *"so the rule is stated
rather than assumed"*. A bare rule gets sharpened away by the next reader. So no narrative was
deleted without leaving a clause of consequence and a **verified** item id in its place — `#008`,
`#015`, `#018`, `#019`, `#040`, `#041`, `#042`, `#047`, `#048`, `#054`, `#056`, `#057`, each headline
read before it was cited, because this project has misattributed three times.

**One pointer would have been a lie, so material was moved rather than dropped.** `CLAUDE.md`
already named `monsters/README.md` as holding the *"full recipe and the checks that follow it"* —
but that file documented only the video generator: no `-DarkThreshold` / `-NoTealFill` /
`-TailFadePx` / `-Period`, and no `New-SpriteSheetFromImage.ps1` at all. Both were written into
`monsters/README.md` (4,254 → 6,353 B), parameter names and *"writes no catalog entry"* checked
against the scripts themselves rather than copied from the prose being retired.

**Where it stopped, and why that is a decision and not an omission.** The target was ~15 KB and it
came out at 23.8. What remains is **rules**, not narrative. Going further would mean moving rules
into lazily-loaded files — trading context cost against the risk that a rule is not read at the
moment it matters, for sentences like *"`hire.ps1` is the only way to hire"* and *"a report silent
about what the hire reached has not checked it"*. That is a different trade from the one this item
made, and it was not taken.

**Cost.** Three specific things a reader of `CLAUDE.md` alone no longer gets: the per-flag detail of
the harness scripts (now the skill's, verified present for every command except `publish-demos.ps1`,
whose row therefore keeps its detail); the HTTP-200 and full-tree-listing measurements behind the
blindfold argument (`#031`); and the `#019`/`#040` archaeology in full. Each is one hop away. The
standing risk is the ordinary one for any pointer: `monsters/README.md` and `SKILL.md` must now stay
true, and nothing checks a `CLAUDE.md` pointer the way `check-index.ps1` checks §2 and §5.

**Verification.** `check-index.ps1` exit 0. `board.ps1` exit 0. A mirror was built against a scratch
runs root and **looked inside** rather than trusted: 18 files, `IndexOk: True`, none of the five
excluded names present, the new `monsters/README.md` text present, and all seven vocabulary terms at
zero across the whole assembled tree — the last one mattering because `monsters/README.md`, unlike
`CLAUDE.md`, ships to a hire, and its earlier *"comparability"* sentence is one of the three leaks
that put check 3a in `build-dist.ps1`. Scratch mirror and its `assembly.md` record removed
afterwards.

**Log.**

- `2026-08-03` `proven` — owner decision, argued and applied in the same session. Landed in
  `3f22ebc`, a commit named for `#061` Phase 1: a parallel session ran `git add -A` while this was
  being written, so the change carries no commit message of its own. This item is that record.
  Filed alongside `#065`, which came out of the same conversation.
