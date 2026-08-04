# `#066` — criterion `10` bundles two questions into one mark, where every neighbouring criterion is split

| | |
|---|---|
| Status | `formulated` |
| Gate | `none` |
| Attribution | scenario defect |
| Criterion | `nowhere-to-walk` `10` |
| Target file | `process/scenarios/nowhere-to-walk.md` |
| Evidence | `2026-08-03-r17`, raised by the blind scoring as a `FAIL`-versus-`PARTIAL` fork; `2026-08-03-r18` for the `PASS` side of the same bundling |
| Blocked on | nothing, but read `#067` first — it may make this moot |
| Proof design | — |

**What happened.** Criterion `10` reads *"§2's stack table: **no row matched, and none was fetched**"*
— two questions in one mark. On `2026-08-03-r17` the first half is satisfied and the second is not:
no stack was claimed to apply and no invented slug was requested, but `stacks/dom-css/README.md` was
read.

The blind pass scored `FAIL` on the criterion's explicit fail sentence — *"Fetching
`stacks/dom-css/README.md` for a Python CLI is a fail"* — and then flagged the fork rather than
quietly resolving it:

> *"The mark bundles two questions […]; the first is satisfied, the second is not. I applied the
> criterion's explicit fail sentence rather than splitting it. Settled by whether the scenario wants
> bundled marks split when only one half misses — as `2`, `5` and `8` are split explicitly and `10`
> is not."*

That is the whole of the defect, and the comparison is the argument: **`2`, `5` and `8` are all split
into lettered sub-marks for exactly this reason**, and `#058` split `12`'s two halves in the same
sitting. `10` is the odd one out.

**Why it matters beyond bookkeeping.** The two halves carry different findings. *No row was claimed*
is about whether the hire mis-classified the project; *none was fetched* is about whether it spent a
turn on an irrelevant file. A hire can miss either independently, and the criterion's own prose
already distinguishes them — *"fetching a slug that does not exist is a worse one and costs a turn on
a 404"*. Collapsing them means three runs on record all read `FAIL` while two of them failed on the
ordering or downstream of a §3 failure and one failed cleanly on the fetch. **`#067` needed three
runs to separate causes the criterion had merged.**

**Proposed change.** Not drafted. Split it the way its neighbours are:

> **`10a`** — no row was claimed to match, and no slug outside the table was requested.
> **`10b`** — no stack note was fetched.

Both scored, both from `transcript.jsonl`. A run that passes `10a` and fails `10b` then says what
`r17` actually shows instead of what a bundled mark can express.

**One thing to get right, and it is why this is not a five-minute edit.** Renumbering is a
**boundary**: three runs on record scored `10` as a single mark, and their reports say `10` fail. A
split has to state that `r12`, `r16` and `r17` all read `10a` pass / `10b` fail retrospectively —
which is true of all three and therefore cheap here, but it is a claim that has to be checked run by
run rather than asserted, the way `#045`'s edits were.

**Read `#067` before spending the effort.** That item's candidate `C` is *the criterion is at fault
and reading the one available note is cheap diligence* — and if `C` wins, `10b` is deleted rather than
split, and this item resolves as part of that decision. Doing the split first and the decision second
would mean renumbering twice.

**Cost.** Small, and mostly the boundary bookkeeping rather than the wording.

**Log.**

- `2026-08-03` `formulated` — from `2026-08-03-r17`'s blind pass, which named the fork and the
  comparison to `2`/`5`/`8` without being asked to look. Filed at `formulated` because what happens,
  which file changes and the attribution are settled; what is open is whether to split or delete, and
  that is `#067`'s call rather than this item's.

- `2026-08-03` — another evidence line, from `2026-08-03-r18`, and it is the **pass** side of the same
  defect. `10` passed there — the first pass in four runs — and the pass was inferred from the
  *absence of a fetch alone*: neither turn says anything about §2's table, so *"no row matched"* was
  never observed, only not contradicted. The bundled mark cannot tell that run from one that read the
  table, ruled the row out in writing, and then fetched the note anyway; those score `PASS` and `FAIL`
  while differing in the half the mark cannot see. Both halves of the bundling now have a run behind
  them, `r17` on the `FAIL` side and `r18` on the `PASS` side.
