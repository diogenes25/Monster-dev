# `#046` — the hire read the playbook, the roster, the catalog and a stack note before it looked at the project

| | |
|---|---|
| Status | `intake` |
| Gate | `run` |
| Attribution | candidate playbook gap (§2 ordering) — **not settled**, one model, one run |
| Criterion | `nowhere-to-walk` `10`, and the `INFO` note under `8` |
| Target file | `MONSTER-DEV.md` §2 |
| Evidence | `2026-08-03-r12` |
| Blocked on | a second sighting. One run is not the signal, and this one had an unusual project |
| Proof design | — |

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

**Cost.** Stated for the shape of the eventual change rather than the change: §2 is the section every
hire reads on every job, and an ordering rule that makes a hire look at the project before reading its
own method could cost a turn on every run to save one here.

**Log.**

- `2026-08-03` `intake` — from `2026-08-03-r12`. Both scorings found the ordering independently; the
  blind pass reported it under `8` and `10` without being told to look.
