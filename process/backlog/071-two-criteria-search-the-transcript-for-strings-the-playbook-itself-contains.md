# `#071` — two criteria search the transcript for strings the playbook itself contains

| | |
|---|---|
| Status | `proven` |
| Gate | `none` |
| Attribution | scenario defect |
| Criterion | `nowhere-to-walk` `8` (no sprite downloaded) and `10` (§2's no-match branch) |
| Target file | `process/scenarios/nowhere-to-walk.md` criteria `8` and `10` |
| Evidence | `2026-08-03-r18`, and independently by that run's blind scoring, which raised `10` in `UNCERTAIN` unprompted |

**What happened.** Both criteria name a transcript search as their instrument:

> `8` — *"plus `transcript.jsonl` searched for **`monsters/*.png`** — a download to a path outside the
> worktree leaves no diff and would otherwise go unrecorded."*
>
> `10` — *"Instrument: `transcript.jsonl`, searched for `stacks/`."*

Both patterns match on `2026-08-03-r18`, which downloaded nothing and fetched no stack note:

```
$ grep -o "monsters/[A-Za-z0-9_-]*\.png" process/runs/2026-08-03-r18/transcript.jsonl | sort | uniq -c
      4 monsters/green-fuzz-classic.png
$ grep -o "stacks/[A-Za-z0-9_/.-]*"      process/runs/2026-08-03-r18/transcript.jsonl | sort | uniq -c
      2 stacks/dom-css/README.md
```

Every hit is a **tool result**, in one of two places:

- `:17` — the output of `ls -R monsters sources stacks tools .vscode` in the mirror. A directory
  listing names both sheets and `stacks/dom-css`.
- `:21` — the body of `MONSTER-DEV.md` as a `Read` result. §5's download example is literally
  `curl -L <base>/monsters/green-fuzz-classic.png -o <target-path>`, and §2's table cell is literally
  `<base>/stacks/dom-css/README.md`.

**The playbook satisfies both patterns by existing.** Any hire that reads `MONSTER-DEV.md` — which is
every hire, on every scenario — puts both strings in its own transcript. Applied mechanically, the two
instruments fail a run that did nothing wrong, and on `r18` they would have converted a clean sweep
into two failures.

**Why the current wording allows it.** The patterns describe *what a violation would look like* and not
*where to look for it*. A download and a fetch are **tool inputs** — a `Bash` command, a `Read`
`file_path`, a `WebFetch` url; the playbook's own text and a directory listing are **tool results**, and
nothing in either criterion distinguishes the two. `#045` already narrowed `8` once, from `monsters/` to
`monsters/*.png`, because the broader pattern hit the roster and the catalog — the same class of false
positive, one step less specific, and the repair did not reach this one.

`10`'s wording is the more exposed of the two because its named fail condition and its named instrument
disagree in scope: the fail is *"fetching `stacks/dom-css/README.md`"* and the search is for `stacks/`.

**Proposed change.** Scope both instruments to the side of the transcript a hire controls.

> `8` — *"plus `transcript.jsonl` searched for `monsters/*.png` **in a tool input — a `Bash` command,
> a `Read` path or a `WebFetch` url. A hit in a tool result is not a download: `MONSTER-DEV.md` §5's
> own example names a sheet by path, and `ls` on the mirror lists both, so every hire that reads the
> playbook matches this pattern.**"*
>
> `10` — *"Instrument: `transcript.jsonl`, searched for `stacks/` **in a tool input**, for the same
> reason — §2's table cell contains the path the criterion is looking for."*

**Cost.** Nothing measurable. The narrowing cannot hide a violation: a download or a fetch is a tool
input by construction, and there is no way to obtain a file whose path never appears in one. It costs
one clause per criterion in the half of the scenario the blind scorer reads, which is where it has to
be — `r18`'s blind pass reached the right verdict *and* flagged the mechanical reading as the fork it
could not settle from the bundle.

The one thing it does not fix is `10`'s bundling of *"no row matched"* with *"none was fetched"*; that
is `#066`, and it is a different defect in the same criterion.

**Log.**

- `2026-08-03` `intake` — from `2026-08-03-r18`, where both patterns fired on a run that passed both
  marks. Raised independently by that run's blind scoring, which had only the bundle and still asked
  *"whether criterion 10's search is for a fetch or for any occurrence."* Two readers, one of them with
  no access to the other, is the signal `#045`'s partial repair did not have.

- `2026-08-04` `proven` — **applied to both criteria, in the wording above.** `8` and `10` now name the
  tool *inputs* as the side of the transcript they search, with the reason stated in the criterion
  rather than left to a reader: §5's own download example and §2's own table cell contain the two
  patterns, so any hire that reads the playbook matches both as tool *results*. The narrowing cannot
  hide a violation — a download or a fetch is a tool input by construction — which is why this needed
  no arm.

  `Gate: none`, so what `proven` means here is **applied, and shown to be done rather than to have
  helped**. No verdict on record moves: both patterns fired on `2026-08-03-r18` and both readers passed
  both marks anyway, by reading what the hits were rather than counting them. The next run on this
  scenario is the first where the mechanical reading and the correct one agree.

  **Fourth instrument in this project to measure something other than what it named** — `#009`, `#010`,
  `#007` and the `-SimpleMatch` grep are the others, and `#074` made five. The pattern in all five is
  the same: the instrument returned the answer the reader expected. This pair is the exception that
  proves the rule about how they get caught — both were found by a reader who had *no* expectation,
  which is the whole case for the blind pass.
