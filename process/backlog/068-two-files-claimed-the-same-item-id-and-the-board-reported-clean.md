# `#068` — two files claimed the same item id and `board.ps1` reported clean

| | |
|---|---|
| Status | `proven` |
| Gate | `none` |
| Attribution | harness artefact |
| Criterion | none. It corrupts **citations**, which is how every item on this board references every other |
| Target file | `process/backlog/board.ps1` |
| Evidence | `2026-08-03` — two parallel sessions each filed a `#065`; the board rendered 67 items with two `065` rows and exited 0 |
| Blocked on | nothing |
| Proof design | `Gate: none` — applied. The check was exercised against a deliberate duplicate before it shipped, and confirmed quiet on the clean board |

**What happened.** Two sessions were working in this repository at the same time on `2026-08-03`.
One filed `#065 — a downloadable RAG instead of the fetched Markdown notes` at 23:00. The other filed
`#065 — §2's no-match branch is not taken` at 23:10. Both files were **internally consistent** —
heading id matched filename prefix in each — so `board.ps1`'s existing check passed on both, the board
printed *"67 item(s)"* with two `065` rows, and the script exited 0.

By the time it was noticed the second `#065` was already cited from **four other files**: `#061`'s
Phase 1 log, four places in `#066`, and both `report.md` and `knowledge.md` of the run that produced
it.

**Why the existing check could not see it.** `board.ps1` compares each heading's id against *its own*
filename:

```powershell
if ($id -ne $file.Name.Substring(0, 3)) { … }
```

That catches a renamed file with a stale heading, which is the failure it was written for. It is a
**per-file** check, and a duplicate is a **cross-file** property. Two files that each agree with
themselves both pass, and the board's own header says the folder is the index — *"An item that exists
is on the board; there is no second place to forget it"* — which is true and, on this failure, is
exactly what makes it invisible.

**Why it matters more than tidiness.** An id is the only citation key this folder has. `process/backlog/README.md`
says so outright: *"There is no search key, and that is deliberate: no key is stable across
scenarios."* Items reference each other as `#012`, reports cite items by number, and
`check-index.ps1` resolves **run** ids against `process/runs/` but has nothing to say about item ids.
So a duplicate makes every reference to that number ambiguous, and it resolves against whichever file
a reader happens to open. The older item loses silently, because a reader follows the number and not
the slug.

**What was done.** `board.ps1` groups items by id and fails on any group larger than one, naming
**both** files and stating the rule:

> `#065: claimed by 2 files — 065-a-downloadable-rag….md, 065-2s-no-match….md. An id is this folder's
> only citation key; a duplicate makes every reference to it ambiguous. Renumber one (first filed
> keeps the number) and move its citations with it.`

**It reports rather than renumbers**, deliberately. Which of the two moves is a judgement: first-come
is the rule, but the *cheaper* renumber may be the newer file, and the citations have to move with it
either way. A script that picked for you would rewrite other files' prose to resolve a collision it
does not understand.

**And the collision itself was resolved by the rule the message states.** The RAG item (23:00) kept
`#065`; the §2 item (23:10) became **`#067`**, and its six citations across four files were moved with
it. First-come, even though the older item is `rejected` and the newer one is live — a `rejected` item
is a permanent record that exists precisely to stop the idea being re-had, so its number is as
load-bearing as any other.

**Cost.** One `Group-Object` and a loop. The check runs on every invocation, and `board.ps1` already
gates commits by exiting non-zero.

**What this does not close.** Nothing checks item ids cited from *outside* `process/backlog/` — a
report citing `#099` when no such item exists still passes every script here. `check-index.ps1` does
that job for run ids (*"15 cited run id(s), every one with a folder in `process/runs/`"*) and could do
it for item ids by the same route. Not done now, because a dangling item citation is a wrong pointer
while a duplicate id is a **silently wrong** one, and only the second class had a live instance.

**Log.**

- `2026-08-03` `proven` — found by running the board after two parallel sessions had both filed, and
  fixed in the same sitting. Verified in both directions before shipping, which is this project's
  standing requirement for a new check: a deliberate duplicate makes it fire with both filenames
  named, and the clean board still exits 0. A check that has only been seen to pass is a check that
  has not been tested.

  Filed rather than left in a commit message for the reason `#059` gives: a fix that lives only in a
  report is a fix nobody finds when the same gap reopens. And this one has a specific way of
  reopening — the parallel-session condition that produced it is not rare, and the next collision
  will be between an item and a *deleted* one's number if renumbering ever reuses a slot.
