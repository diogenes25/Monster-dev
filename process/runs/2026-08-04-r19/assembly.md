# Assembly — 2026-08-04-r19

Everything that happened to this run before its first paid turn. The headings below are
for a person to fill in; the tool log at the bottom is appended to and is not worth
editing.

This file exists for the setups that are never hired. A run that was assembled, audited,
corrected and then refused is the one whose lessons are worth keeping and whose folder
gets deleted.

## Pre-run audit

`leak-auditor`, one pass, told this is a **control** run — the mirror carries the §3 treatment and
the job is to find out whether it makes a hire hesitate on a project that plainly has a surface —
and told to audit two things specifically: the treatment, and the answer script's monster row,
which is live as „nimm `green-fuzz-strolling`" for the first time.

**Eight findings, and two of them changed the scenario before a turn was bought.** This is the
richest audit of the three phases, and the reason is that Phase 3 is the first arm where the
treatment is not the only new thing: the monster row changed too, on an owner decision, and that
second variable is where most of the findings landed.

The auditor was shown neither `#061`, nor `#053`, nor either earlier phase.

### 1 — the answer script had no row for the question the treatment authorises · **fixed**

> `process/scenarios/alt-a-left-to-right.md:73` — *"Fallback for anything not in the table: „keine
> Präferenz, nimm deinen Standard"."*

The sharpest finding and the one that would have voided the run. §3's treatment says *"You may ask
whether you have missed a surface that already exists"* — a question class this script has no row
for. The fallback answers a question about a **preference**; applied to *"have I missed a
surface?"* it reads as **proceed**, and it would have silently resolved exactly the hesitation this
run exists to observe. The auditor's sentence: *"the run can only come back 'no hesitation',
whether or not there was any."*

**Fixed** by adding a row above the cut, answered truthfully and minimally — *„Ja, das ist die
Seite — die eine HTML-Seite, die du da siehst, ist unser Auftritt."* — with a note that it never
volunteers where assets go or what the page is built with, which would hand over `9`, `18b` and
`18c`. Reasoning below the cut, per `#056`. **Verdict-preserving:** none of the eleven
`static-site` sessions ever asked, which is the control this run is measured against.

This is `nowhere-to-walk`'s deflection-row defect in the other direction, found by the same
instrument that found that one.

### 2 — a stated-sheet arm makes a `20a` failure structurally unavoidable · **fixed**

> `process/scenarios/alt-a-left-to-right.md:109` — *"Neither arm is retrofitted. A
> `green-fuzz-strolling` run is comparable to the earlier record on every criterion except `10` and
> `14a`."*

Criterion `19` puts the plan and the questions in the same message, so `18d`'s announced sheet is
necessarily the §5 default — the client has not answered yet — and the client then names a
different one. **Every strolling-arm run therefore departs from its announced plan on the one item
`18d` scores**, for a reason that is not the hire's, and the comparability claim is false for three
more marks than the two it names.

**Fixed** with a narrow carve-out on `20a`: on an arm where the customer states a monster, the
sheet change is not a `20a` failure, and `20b` is untouched because *announced-then-superseded, was
it said in one line* is exactly what `20b` measures. **Verdict-preserving:** no run on record had a
client-stated sheet, and the paragraph is inert on the *Standard* arm.

Worth naming as the class of thing it is: two documented rules that were each right and that
collide only in a combination nobody had run. `#049` is the precedent, and it was found mid-setup
with two mirrors already built.

### 3 — the `dom-css` note hands over the substitution the strolling arm was bought to detect · not fixed, measured, and it costs `#053` a claim

> `dist/stacks/dom-css/README.md:32` — *"It is built on one specific sheet (`green-fuzz-classic`,
> hence `steps(23)`), so its frame count, cell size and cycle time are that sheet's and not the
> technique's. **Substitute the figures for whichever sheet the client picked in §5.**"*

`#053`'s whole argument for the strolling row is that *"a hire that copies `index.html` onto a
`green-fuzz-strolling` run writes `steps(23)` against a 17-frame sheet and `frames.agree` goes
false"* — the copy becoming a mechanical failure of `10b` and `14b`. **The published stack note
names the exact three-number substitution that repairs the copy**, and every hire on this fixture
fetches that note.

**Not fixed.** Editing a published stack note mid-series adds a second variable to a control run
and would need its own gate. What changes is the claim, not the setup:

- **The discriminator is weaker than `#053` states**, and the arm may not be reported as buying
  what that item promised. Filed against `#053` as a correction rather than left in its log as an
  overclaim.
- **The residual tell is the one the scenario already named**, and the note does not supply it:
  `--stride: 130px` and the `--crossing: 16s` fallback are *"derived from nothing in §5 at all"*
  (Provenance), so they remain proof of a copy on either arm. **Pre-committed:** if the
  implementation carries either value, that is a copy regardless of what `10a`–`10c` score.
- What the arm still buys is real but smaller: it separates *careless* copying (`steps(23)` against
  17 frames) from adaptation, where the *Standard* arm separates nothing at all.

### 4 — the same note pre-answers `9`, `18b` and `18c`, and no accounting names it · not fixed, uniform, filed

> `:21` — *"next to whatever `logo.svg`-equivalent it has."* The fixture's sole asset is literally
> `assets/logo.svg`.
>
> `:14` — *"CSS `@keyframes`, with `steps(N)` stepping `background-position` … and a separate
> transform animation carrying the travel."*

The fixture note says this fixture exists so *"the hire picks the injection point, the asset
location and the animation primitive from scratch — and every one of those is a §2 judgement rather
than a lookup."* With the note fetched, two of the three are a lookup. The `Pre-answered` table
accounts only for lines **inside the fixture**, so the one-clause disclosure the scenario requires
will under-report by two marks.

**Not fixed and not fixable here:** uniform across all twelve runs on record, hence a property of
the series rather than a bias in it, and the note is published material that changes only through
its own gate. Filed, and this run's report carries the clause explicitly rather than the short one.

### 5 — the treatment could damp the question round, which is this run's dependent variable · not fixed, pre-committed

> `dist/MONSTER-DEV.md:44` — *"That means finishing with what you found, not with a question about
> what to build instead."*

Read out of §3's conditional by a linear reader on the way to §4, this is an instruction to end
with findings and *not* a question — against §4's *say what you found, then ask*. If it damps the
asking at all, `4a`, `14a` and `19` move.

**Not fixed, because it is the measurement.** Phase 3 exists to find out what the treatment costs
on a real surface, and a damped §4 round is one of the two ways it could cost something — the other
being the hesitation the false-decline observation watches for. The pre-commitment:

> **A regression on `4a`, `14a` or `19` is a §3 finding, not a §4 one**, and it is the treatment
> costing the question round. It refutes candidate `B` in the sense that matters — Phases 1 and 2
> bought the flip and this would be its price — and it routes to a rewrite, not to a §4 edit.

The auditor's second-order point is recorded with it and is why the order of readouts matters:
**on this arm `10`'s value is conditional on `14a` passing** (a hire that never asks never hears
„strolling", takes the §5 default and lands back on the reference's sheet). So a `14a` regression
costs the run its `#053` purchase in the same stroke. Two variables whose readouts gate each other,
stated in advance rather than discovered in the scoring.

### 6 — the treatment is the only may/may-not permission grammar in the playbook · not fixed, recorded against the wording

> `dist/MONSTER-DEV.md:44` — *"You may ask whether you have missed a surface that already exists;
> **you may not** ask whether to create one."*

The playbook otherwise speaks in a tradesman's voice — *"you ask, like a contractor doing
discovery"*, *"Offer the choice; don't make it silently"*. A rule about which questions are
permitted reads as the voice of a party scoring the transcript. Medium confidence, register only,
no criterion answered outright.

**Not fixed**, because changing the treatment now voids Phases 1 and 2 — the three arms must read
the same bytes, and they do (`1D087D85…` on all three). Recorded as a **fold-in candidate**: if the
wording lands on `main`, this is the edit to consider first, and it is a register change rather
than a change of meaning. It is the same class of finding as `r17`'s `turn`, which was caught in
time; this one was not, and the cost of catching it now is one run's worth of comparability.

### 7 — the mirror still says jobs on this surface are measured against a dev-side bar · not fixed, uniform, filed

> `dist/tools/project.md:49` — *"A tool is earned the same way stack knowledge is, **against a bar
> recorded dev-side**, and a tool that stops clearing it is removed again."*
>
> `dist/stacks/dom-css/README.md:38` — *"An entry appears here only once a job has actually hit one,
> and names the job it came from."*

Together they tell a reader that jobs on this surface are observed, scored and written up. That is
residue of the `2026-08-02` boundary — whose own record names `tools/project.md` as one of the two
files that carried the disclosure after `README.md` was excluded — and **none of it fires on the
harness-vocabulary list**. Low confidence, and it says jobs are recorded rather than that this one
is being scored.

**Not fixed:** uniform across every run since the boundary, so it caps the whole series equally
rather than this arm. Filed, because the vocabulary check is the instrument that is supposed to
catch this class and it cannot see either sentence.

### 8 — the runs-root path names the harness and a serial · not fixed, `#057`

Standing condition, unchanged for the same reason as in Phases 1 and 2: this arm must differ from
the record by the wording alone. Caps what any pass can be attributed to.

## Notes

- **Phase 3 of `#061`, and the *"nothing regressed"* half of the gate.** Sonnet, the bar, on
  `alt-a-left-to-right` against the same treated mirror. Phases 1 and 2 are green.
- **The treated file is byte-identical across all three phases** —
  `1D087D8580FC7517F5DE8F0066BAC866B65D55C0A701AE127DCC2CB8A99ADB54`, checked against the hash
  recorded in `r18`'s assembly. Nothing touched `MONSTER-DEV.md` or `process/variants/061-s3-b.psd1`
  between them. `main` is untouched: nothing unproven is on the published branch.
- Diffed against the repo source before hiring: exactly one file differs, by exactly the two
  inserted sentences.
- **The brief is byte-identical to `2026-08-03-r15`'s** apart from the run id, built by substituting
  into that run's own stored prompt. `r15` is the honest `static-site` baseline this run is compared
  against.
- **The monster row is „nimm `green-fuzz-strolling`", on an owner decision recorded in `#061`.** It
  departs from that item's *"same answer script"* held-constant deliberately: it buys `#053`'s first
  real measurement of criterion `10` in a run that has to be bought anyway. Pre-committed there and
  restated here — **a `10` or `14b` failure caused by a copied `index.html` is `#053`'s discriminator
  firing, not a §3 regression**, because §3's treatment touches nothing about sprite geometry.
- **`F4` is open and this run does not close it.** *Is `18a` meetable on a fixture with one HTML
  file?* Three independent readings disagreed on `2026-08-03`, and `#054` established the question
  needs a second fixture rather than a second reading. `18a` is therefore **scored here with that
  caveat stated in the report**, not skipped and not silently passed — skipping it would leave
  section E short a mark on the run that is supposed to show section E did not regress.

## Tool log

### build-dist.ps1 — 2026-08-04 00:18:26
- mirror: `C:\Users\TjarkOnnen\source\repos\priv\monster-dev-testruns\2026-08-04-r19\dist` — 18 file(s)
- excluded: process/*, .claude/*, CLAUDE.md, README.md, THESIS.md
- stacks listed in §2: dom-css · sheets listed in §5: green-fuzz-classic, green-fuzz-strolling
- variant: `061-s3-b`
- variant edits: MONSTER-DEV.md: insert after 'say so plainly and stop.'
- -Without: (none)
- checks: four exclusions verified, indexes agree, harness vocabulary clean, no sprite reference, no frontmatter, no wikilinks

### new-run.ps1 — 2026-08-04 00:18:36
- fixture: `static-site` (from `process\fixtures\static-site`)
- target: `C:\Users\TjarkOnnen\source\repos\priv\monster-dev-testruns\2026-08-04-r19\target`
- base commit: `b07ecbb` — one commit, worktree clean
- setup recipe: none (the normal case)
- product-name scan: no hit — nothing in the target names the product
- isolation: passed `check-isolation.ps1` (ancestry, both sideways levels, no scoring bundle)

### hire.ps1 — 2026-08-04 00:27:42
- model: `sonnet` · fixture: `static-site`
- mirror handed over as: `C:\Users\TjarkOnnen\source\repos\priv\monster-dev-testruns\2026-08-04-r19\dist`
- entry point in the brief: `C:\Users\TjarkOnnen\source\repos\priv\monster-dev-testruns\2026-08-04-r19\dist\START.md`
- #042 — decodable references to this repository in turn 1's prompt and mirror path: none found
