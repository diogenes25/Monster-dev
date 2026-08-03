# `#046` — the hire read the playbook, the roster, the catalog and a stack note before it looked at the project

| | |
|---|---|
| Status | `rejected` |
| Gate | `run` |
| Attribution | **model disposition** — the §2-ordering gap did not reproduce on a second model |
| Criterion | `nowhere-to-walk` `10`, and the `INFO` note under `8` |
| Target file | `MONSTER-DEV.md` §2 |
| Evidence | `2026-08-03-r12` (sonnet, the sighting), `2026-08-03-r16` (opus, the non-reproduction) |
| Blocked on | nothing — the second sighting is `#043`'s run, and this item reads different marks off the same transcript |
| Proof design | **Attribution run, no treatment — the same run as `#043`, assigned `2026-08-03-r16`.** One **Opus** arm on `nowhere-to-walk` against `process/fixtures/python-cli/`, mirror fetch path, playbook and scenario unchanged. The instrument here is the **read order in `transcript.jsonl`**, not a verdict: does a second model also reach the stack note before the project? See the `2026-08-03` grilling entry |

**What happened.** Turn 1's read order, from `transcript.jsonl`:

```
:8   START.md
:10  find <dist> -maxdepth 3
:14  MONSTER-DEV.md
:16  monsters/README.md
:18  monsters/catalog.json
:20  tools/project.md
:22  stacks/dom-css/README.md
:25  find <run>              ← the first look at the project
:28  report.py
:30  README.md
:32  sales.csv
```

Seven reads of the playbook and its assets before one look at the target. Two criteria record a
symptom of it and neither names the cause:

- **`10` fails.** `stacks/dom-css/README.md` was fetched for a project whose only source file is a
  Python script — and fetched at `:22`, *before* `:25`, so no stack could have been resolved from
  anything. §2 says *"If no row matches, that's the normal case rather than a problem"*, and the
  no-match branch was reached in the prose (neither turn claims a stack) but not in the fetch.
- **`8` passes with a note.** The roster and the catalog were read before there was any established
  place to put a sprite. No sheet was downloaded, so the criterion passes — but §5 was being prepared
  for while §2.1 was still open.

**Why the current wording may allow it.** §2 tells a hire to look at the project and then pick up the
matching stack note. It does not say the project comes **first**, and everything a hire needs in order
to be useful is upstream of the project in the document. A model that reads its brief front-to-back
before acting is behaving reasonably; the playbook simply never states the dependency.

**Why this is not filed as a gap.** Half C: a gap means every model does it, and this is one Sonnet
observation on a project unlike any other in the series — a fixture with three files, where reading
the target takes one command and reading the playbook takes seven. The eleven `static-site` runs are
not evidence either way, because there `dom-css` was the right answer whenever it was fetched, so an
identical ordering would have left no fingerprint. That is `#006`'s point arriving from a new
direction.

**Proof design.** `Gate: run`, and **it is `#043`'s run.** The two items came out of the same
transcript, need the same second model on the same scenario and fixture, and read different marks off
the result — so one run gives both a second sighting and there is nothing to gain by separating them.
`#043`'s entry carries the full design and the gate argument; what is particular to this item is the
instrument.

**The instrument is the read order, not a verdict.** `10`'s pass/fail is a weak reading of this item:
a hire could fetch `stacks/dom-css/README.md` *after* looking at the project and still fail `10`, and
a hire could get the ordering wrong and pass `10` by fetching nothing. What settles `#046` is the
sequence in `transcript.jsonl` — specifically **whether the first `find`/read inside the run folder
comes before or after the first read of `stacks/`** — with `monsters/README.md` and
`monsters/catalog.json` recorded beside it, since those are the `8` half.

So the run's `#046` output is a table like the one above, not a verdict word. Write it into the report
that way.

**What each outcome licenses.**

| Opus's read order | `#046` becomes | What follows |
|---|---|---|
| playbook and stack note before the project, as `r12` | **playbook gap (§2 ordering)** — two models, same behaviour | a §2 wording change becomes designable, under the cost below |
| project first, then §2's table, no stack fetched | **model disposition** | §2's dependency is inferable as written; `r12`'s ordering was one model's reading habit |
| project first but the stack note still fetched | neither, and it is the most interesting third answer | the ordering is not the cause of `10` at all, and `#006` is the item that gains — a content-free stack note leaves no fingerprint either way |

**The confound this run does not remove, and it is this item's own.** `python-cli` is a three-file
fixture where reading the target costs one command and reading the playbook costs seven. A model that
front-loads its instructions is behaving *more* reasonably here than it would on a large codebase, so
even two sightings on this fixture cannot separate *"§2 never states the dependency"* from *"the
project was too small to be worth looking at first."* Recorded rather than solved: the second sighting
is still what the board requires before an attribution, and a fixture that would settle the confound
does not exist. `#005`'s missing second stack note and `#006`'s fingerprintless note are the two items
that would have to move first.

**Cost.** Stated for the shape of the eventual change rather than the change: §2 is the section every
hire reads on every job, and an ordering rule that makes a hire look at the project before reading its
own method could cost a turn on every run to save one here.

**What this run costs:** nothing beyond `#043`'s, which is the point of sharing it. Around $0.60 and 13
model turns for both items.

**Log.**

- `2026-08-03` `intake` — from `2026-08-03-r12`. Both scorings found the ordering independently; the
  blind pass reported it under `8` and `10` without being told to look.
- `2026-08-03` `grilled` — **shares `#043`'s run**, since both need the same second model against the
  same scenario and fixture and read different marks off one transcript. Two things the grilling
  changed about this item as filed:

  - **The instrument moved off criterion `10`.** `10` is a symptom and a lossy one: a hire can fail
    `10` with the ordering right and pass it with the ordering wrong. What settles this item is the
    sequence in `transcript.jsonl` — whether the first read inside the run folder precedes the first
    read of `stacks/` — reported as a table rather than a verdict word.
  - **A confound was named that no amount of repetition removes.** `python-cli` is small enough that
    front-loading the playbook is the *more* reasonable habit, so even two sightings here cannot
    separate a §2 wording gap from a fixture artefact. `#005` and `#006` are the items that would have
    to move before a fixture exists that could. The second sighting is still worth buying — the board
    requires it before an attribution — but it will not close the item on its own, and this is written
    down now so the run's report is not read as though it had.


- `2026-08-03` `rejected` — **`2026-08-03-r16`, Opus. The fault did not reproduce, and the item's own
  instrument is what acquits §2.** Turn 1's read order:

  ```
  :6   START.md
  :9   ls dist/
  :13  MONSTER-DEV.md
  :17  ls + find <run>          ← the first look at the project, third read of the run
  :19  report.py
  :21  README.md
  :23  sales.csv
  :26  the finding
  ```

  **Turn 1 touched nothing else in the mirror at all** — no `stacks/`, no `monsters/`, no
  `catalog.json`, no `index.html`, no `tools/project.md`. Every one of the seven playbook reads that
  made up `r12`'s ordering is absent, and the project was read third. That is the second outcome row:
  §2's dependency is inferable as written, and `r12`'s ordering was one model's reading habit.

  **Criterion `10` still failed, and that is exactly why the instrument was moved off it.** The
  `stacks/dom-css/README.md` read is at `:31` — **turn 2**, after the customer's answer and after the
  hire had decided to generate an HTML page, for which `dom-css` is the *correct* row. The grilling
  entry above predicted this shape almost word for word: *"a hire could fetch
  `stacks/dom-css/README.md` after looking at the project and still fail `10`."* A run scored on `10`
  alone would have recorded a reproduction that did not happen. The report attributes `10` downstream
  of `#043`'s §3 gap instead.

  So this lands on the **third** outcome row rather than the second — project first, stack note still
  fetched — which this item called *"the most interesting third answer"*. It resolves to
  `rejected` all the same: the §2-ordering hypothesis is what was on trial and it is dead. What the
  third row adds is that `#006` gains, not `#046`.

  **The confound is now moot rather than unresolved.** `python-cli` being a three-file fixture cannot
  separate a §2 gap from a fixture artefact — but with the gap gone there is nothing left to separate.
  If a future run on a *large* fixture shows a hire front-loading the playbook again, that is a new
  sighting and this rejection is the thing to read first: it records that at least one model does not.

  Rejected items stay, and this one earns its keep twice. It is the standing answer to *"shouldn't §2
  say the project comes first?"* — measured, on two models, and no. And it is a worked case for
  the rule its own grilling wrote down: **choose the instrument that settles the item, not the
  criterion that happens to be nearby.**
