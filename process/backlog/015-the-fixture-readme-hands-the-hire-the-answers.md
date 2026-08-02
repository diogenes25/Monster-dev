# `#015` — every fixture's own README tells the hire the answer, and six of ten read the one that was in use

| | |
|---|---|
| Status | `formulated` |
| Gate | `none` |
| Attribution | harness artefact |
| Criterion | `8`, `9`; `13` by luck; `18a` / `18c` indirectly. On the unused fixtures: §2.4 and the whole of §3 |
| Target file | `process/fixtures/<name>/README.md` (all three), `process/tools/new-run.ps1` |
| Evidence | all ten run folders and all ten transcripts, scanned `2026-08-02`; all three fixture READMEs read the same day |
| Proof design | — |

**This blocks any run against a second fixture.** `#005` (the §2 first-match rule cannot be observed
with one row) needs one, and the §3 decline path has never been exercised at all, so the next run to
be spent against something other than `static-site` goes against `gsap-site` or `python-cli` — and
both of those are contaminated worse than the one that has been running. Fixing this is not tidying
up; it is a precondition.

It does **not** unblock `#011`, and an earlier version of this paragraph claimed it did. `#011` is
explicit: *"`gsap-site`, the other web fixture, does not close this either: it loads GSAP from
`cdn.jsdelivr.net` and its `package.json` declares a dependency nothing installs. It is a fixture
about *style conformance*, not about a build."* Its target is a fixture with a real build, which
does not exist. `#005` is only half unblocked for the same reason: it also waits on a second
*published* stack note, and there is one.

**What happened.** `process/fixtures/static-site/README.md:5` reads:

> **Expected Monster-Dev behavior:** find the DOM as the runtime surface, notice there's no existing
> animation library or pattern to conform to, pick `assets/` as the natural place for the sprite
> sheet (it's the only assets folder here), and decide for itself where the monster should live
> (there's only one page) and how to animate it (plain CSS is the obvious idiomatic choice here,
> mirroring `index.html`'s own reference technique closely).

`new-run.ps1:70` is `Copy-Item -Recurse $source $target`: the whole fixture folder, README included.
It is present in **all ten** rescued run folders, and the string appears in **six of the ten**
transcripts.

| Read during analysis | Surfaced by the hire's own §9 cleanup grep | Never in context |
|---|---|---|
| `alt-a`, `phase1`, `phase2`, `phase2b`, `plan-opus` | `phase2`, `live` | `sonnet-base`, `sonnet-base2`, `plan-sonnet`, `index-sonnet` |

Two routes in, both quoted. `phase2`, out of a Read tool result with the file's own line numbers
still attached:

> `…marketing page. No framework, no build step, no existing animation of any kind.\n4\t\n5\t**Expected Monster-Dev behavior`

and `live`, out of the hire grepping for its own traces before handover:

> `--- leftover refs ---\n./index.html:49:  <!-- walking monster easter egg (Alt+A) — Monster-Dev -->\n./README.md:5:**Expected Monster-Dev behavior:** find the DOM as the runtime surface…`

**The split is exactly by model.** All six contaminated runs are Opus; all four Sonnet runs are
clean. Sonnet is the stated bar, so the arm the gates are read off is the uncontaminated one — but
Opus is where the §4 proof runs (`phase2`, `phase2b`), the plan-step control (`plan-opus`) and the
real-URL run (`live`) sit.

**The two fixtures nobody has run yet are worse, and they cite the playbook by section number.**
`static-site` is the mild case. Read the same day:

> `gsap-site/README.md:5` — **Expected Monster-Dev behavior:** notice the existing animation
> library/pattern (**§2.4** in `MONSTER-DEV.md`) and build the walking-monster animation using GSAP
> the same way `animations.js` already does — a `gsap.timeline()`/`gsap.to()` sprite-position or
> frame tween — instead of introducing plain CSS `@keyframes` from scratch. Reusing `index.html`'s
> reference technique verbatim here **would be a wrong answer**…

> `python-cli/README.md:5` — **Expected Monster-Dev behavior:** find no visible-output surface in
> step **§2.1** and follow **§3** — decline gracefully and say what would need to exist first…
> It should **not** improvise something like printing ASCII art to stdout as a workaround.

The first hands over the entire §2.4 judgement — *which primitive does this project already animate
with* — which is the only thing `gsap-site` exists to measure, and pre-marks the wrong answer. The
second hands over the §3 decline *and* names the exact improvisation the criteria score against,
which is Half A invariant 6 quoted back at the hire.

Neither has ever been hired against, so nothing on record is damaged by them. They damage the next
run instead.

**Which criteria this touches.**

- **`9` — sprite lives in `assets/` next to `logo.svg`.** The README says *pick `assets/` as the
  natural place for the sprite sheet*. For six runs this scored a hire that had been handed the
  answer.
- **`8` — idiomatic plain CSS/JS, no dependency, no new animation library.** The README says *plain
  CSS is the obvious idiomatic choice here*.
- **`18a` / `18c` — injection point and change set.** The marks `2026-08-01-plan-retro.md` shows
  hires splitting on, and the README pre-answers part of both.
- **`13` — `git status` clean, no leftover reference.** Undamaged, but only by luck. No hire
  modified the file: `git status --porcelain` over all ten worktrees shows `script.js`, `style.css`,
  sometimes `index.html`, plus the sprite — never `README.md`. A hire that had tidied a
  *pre-existing* mention of Monster-Dev out of the project's README would have taken a §9 failure
  for the harness's own text.

**Why the current wording allows it.** `new-run.ps1`'s header already reasons this out, for a
different file:

> A recipe stored beside the fixture would be copied into the target with everything else, and would
> then show up in `git status` — the exact diff surface §9 is scored on.

Every word of that applies to the README, which predates the recipe rule by ten runs. The fixture
folder was never split into *the target project* and *our notes about the target project*; the notes
are simply inside the project.

**Proposed change.**

> A fixture folder contains **only what the target project would contain**. Notes *about* a fixture
> move to `process/fixtures/<name>.md` — a sibling of the folder, not a file inside it — for the
> same reason and in the same shape as `process/tools/setup/<fixture>.ps1`.
>
> A fixture keeps a `README.md` when a real project of that kind would have one, written entirely in
> character. **All three are rewritten**, not just the one in use: `static-site`'s becomes the Acme
> Kite Co. README, `gsap-site`'s an ordinary README for a small GSAP-animated site, `python-cli`'s an
> ordinary README for a CSV report tool. None mentions a monster, a sprite, Monster-Dev or a playbook
> section.
>
> `new-run.ps1` gains a backstop after the copy and before the commit, in the shape of the
> cleanliness check it already ends with: if `Monster-Dev` or `MonsterLib` appears anywhere in the
> run folder — case-insensitively, which also catches the `MONSTER-DEV.md` section citations in
> `gsap-site` and `python-cli` — the folder is deleted rather than handed back, and the offending
> file and line are reported. Those two product names and nothing wider: `monster` alone would
> false-positive the moment a fixture legitimately has one, which is precisely `#014` option (b).

**Proof design.** *`Gate: none`.* Half C: *"fix the harness, rerun, record nothing against the
product."* Nothing about the playbook changes and nothing is claimed about hire quality.

What the fix **cannot** do is repair the six runs. Criteria `8` and `9` for `alt-a`, `phase1`,
`phase2`, `phase2b`, `live` and `plan-opus` were scored against a hire holding a hint, and no rerun
makes them retroactively clean. The honest handling is a recorded boundary, the way `15c` and
section E are recorded — a caveat line in the report of each contaminated run and one in the
scenario's *"criteria changed"* note — not a silent re-scoring and not a deletion.

**Five of the six have a report; `plan-opus` does not.** `process/runs/` holds
`2026-08-01-plan-opus-measurements.json`, `.brief.txt` and `.hire.json` and no `.report.md`, so
there is nothing to caveat. (`sonnet-base2` is missing one too, on the clean side of the split.)
Two of ten runs were never written up, which is a gap in the archive this item cannot close and
should not paper over: `plan-opus`'s boundary goes in the scenario note only, and the two missing
reports belong to whoever settles what `process/runs/` is supposed to contain per run.

**Cost.**

- **Five reports gain a caveat**, and the sixth contaminated run has no report to put one in.
  The archive reads worse afterwards, and that *is* the archive getting better.
- **`8` and `9` lose their strongest evidence.** Both passed in every run on record; four of those
  passes stay clean, which is still enough to say the criteria hold at the bar — but it is four, not
  ten.
- **The in-character README has to stay in character.** It is the exact file `#014` option (b) would
  write a requirement into. The two items have to be read together, or the next change quietly
  undoes this one.
- **One more condition under which `new-run.ps1` refuses to hand back a folder.** Accepted on the
  same grounds as the isolation and cleanliness checks it already has: a run folder that looks ready
  and is not is the expensive failure, because nothing downstream questions it.

**Log.**

- `2026-08-02` `intake` — found while formulating `#014`. The fixture already carries a description;
  it is addressed to the wrong reader.
- `2026-08-02` `formulated` — measured rather than inferred: README present in all ten rescued run
  folders, the string in six of ten transcripts, the split exactly by model, both routes in quoted
  from the transcripts, and `git status` over all ten worktrees confirming no hire touched the file.
- `2026-08-02` — scope corrected from one fixture to all three while planning the leak auditor
  (`#017`). `gsap-site` and `python-cli` cite `MONSTER-DEV.md` section numbers and prescribe the
  answer outright. Neither has been hired against, which makes this a blocker on the next run rather
  than a repair of the archive: `#005` and `#011` both need one of those two fixtures.
- `2026-08-02` — **B6**: the scan's two product names stay its own list rather than being merged
  with `build-dist.ps1`'s harness vocabulary or `score-bundle.ps1`'s criteria terms. Three readers,
  three leaks; a shared list would be the union of all three and would make every check noisier.
  What the answer adds is a comment on the list saying which reader it protects — here, the hire's
  own working copy — and why it is not the other two.
- `2026-08-02` — three corrections during the PM pass over the board. The blocker claim above was
  overstated: `#011` says in so many words that `gsap-site` does not close it, and `#005` waits on a
  second published stack note as well as on a fixture. `plan-opus` has no report file, so the
  caveat lands in five reports and the scenario note, not six reports. Both fixed in place;
  `sonnet-base2` turns out to have no report either, which is a second archive gap and is not this
  item's to close.
- `2026-08-02` — **E1**: `#025` files a leak this item's fix does not reach.
  `process/fixtures/static-site/script.js:1-2` states the §2.4 answer in the project's own code —
  no product name, no section number, no README. The rule proposed here, *"a fixture contains only
  what the target project would contain"*, does not exclude it, because a target project might well
  carry that comment. Recorded as a boundary of this item rather than absorbed into it.
- `2026-08-02` — **D2**: the caveat line in the scenario's *"criteria changed"* note lands with
  `#001`, `#020` and `#021` under one dated boundary. The five report caveats are this item's alone
  and land with it. **D4**: this item stays in the paths wave and remains what `#022` waits on.
