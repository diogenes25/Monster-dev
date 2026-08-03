# `#039` — the only runnable item was blocked on a tool that two documents described as future work, and no item said so

| | |
|---|---|
| Status | `proven` |
| Gate | `none` |
| Attribution | harness artefact |
| Criterion | — |
| Target file | `process/tools/build-dist.ps1`, `process/variants/` (new), `SKILL.md` |
| Evidence | found `2026-08-03` while picking `#002` up as the next run brief |
| Blocked on | nothing |
| Proof design | — |

**What happened.** `#002` has been `grilled` since `2026-08-02` and is the only item ever to reach
that state. `grilled` means *eligible as a run brief*, and `README.md`'s rule is that a run needs
one. So for a day, the board's answer to *"what can be run next"* was a single item that **could
not be built**.

Its arm B adds a paragraph inside `MONSTER-DEV.md` §6. `build-dist.ps1` took `-Without` and
nothing else — it could omit a whole file and could not change one. Two documents already said
this, and neither treated it as a defect:

- `build-dist.ps1`: *"Both are solved by the variant-overlay mechanism, not here."*
- `SKILL.md`: *"Both are the variant-overlay mechanism's job; until that lands, an A/B below file
  level cannot be built honestly, and saying so beats faking it."*

Both sentences are correct, careful, and written by somebody who had thought about it properly.
The second even names the temptation and refuses it. What neither does is **create an item**, and
the board is the only thing in this repository that carries work forward across sessions.

**Why the current wording allowed it.** The failure is not in either sentence; it is in the shape
of the gap. A missing tool that is *documented as missing* reads as a decision rather than as
work, and `build-dist.ps1`'s help is the last place anyone looks when asking what to run next.
Meanwhile `board.ps1` enforces the state rules faithfully and has no way to know that a `grilled`
item's proof design needs a tool that does not exist. **The board validates item state and never
item feasibility**, which is fine, but it means a blocker living in the tooling is invisible
exactly where the run is chosen.

`#002`'s own table had no `Blocked on` row at all, so nothing contradicted it either.

**What was applied.** `build-dist.ps1 -Variant <name>`, reading `process/variants/<name>.psd1`
and applied after the copy and **before every check**, so an arm is verified exactly as hard as a
plain mirror.

Anchored rather than a patch. A patch keys on line numbers and surrounding context and rots when
either moves; an anchor is a sentence quoted out of the file, which is also how the arm is
described in the item that asks for it, so the two cannot drift apart silently. `After` + `Insert`
inserts; `Replace` + `With` substitutes, and an omitted `With` deletes — the arm a fragment needs,
since `CLAUDE.md` already requires that deleting a fragment leave its entry true.

The anchor must match **exactly once**, and the mirror is deleted rather than handed back on any
failure. The three failure modes all share the property that makes this project's defects
expensive — none announces itself:

| | what would reach a run |
|---|---|
| 0 matches | an arm with **no treatment in it**, and two perfectly ordinary numbers |
| 2 matches | the treatment in an arbitrary one of two places |
| edit 1 applies, edit 2 throws | a mirror carrying **half** a treatment, indistinguishable from a correct arm |

Four negative-test variants are kept under `process/variants/zz-*.psd1`, one per failure, so the
error paths stay re-runnable instead of having been demonstrated once. `#033` is the precedent:
the paths nothing exercises are the paths that are wrong.

**The first draft had the `#033` defect in it.** All five failure modes threw correctly and all
five **left the mirror on disk** — the throws jumped past the `$failures` collection that keeps
this script's "deletes rather than hands back" promise. Found by running the negative tests and
reading the second line of the output, not the first. That is the third time in one sitting that
running the repaired code found what reading it did not, and the first where the defect was in a
fix written *by* the person who had just fixed the same class twice.

**Cost.**

- **A variant's text is quoted from the item that asks for it, and now lives in two places.**
  `#002` argues at length about arm B's wording, particularly its last sentence. The variant
  carries a comment saying so, but nothing enforces it, and an arm whose treatment has drifted
  from its rationale is unreadable afterwards.
- **`-Variant` makes an untested playbook change easy to run and easy to keep.** The gates are
  unchanged and a variant is a *treatment*, never a merge — but the distance between "arm B
  exists as a file" and "arm B is in `MONSTER-DEV.md`" is now one decision rather than one
  edit, and that decision must stay a proof gate.
- **Nothing has actually been measured with it.** The mechanism is demonstrated, both arms build,
  and they differ by exactly one hunk in exactly one file. `#002` itself is still unrun.

**Log.**

- `2026-08-03` `proven` — built and demonstrated on the day it blocked `#002`. Filed as its own
  item rather than inside `#002` because the finding is not the missing tool: it is that a
  documented, deliberate, correctly-reasoned gap sat outside the board for a day while the board
  reported an item as ready to run. The two sentences that described the gap were both edited to
  describe the mechanism instead, which is `#003`'s lesson applied at the moment the claim
  changed rather than a week later.
- `2026-08-03` — the negative tests exist because the first draft passed every positive test and
  failed every failure path silently. Recorded because the four `zz-` files look like clutter and
  are the only reason that is now known.
