# Discussion — `2026-08-02`

A PM pass over all 21 items. Not a board item and not a second board: every answer below leaves as a
`Log` line in the item it concerns, and after that this file is a record of what was decided and
why, nothing more. `board.ps1` ignores it — the filter is `^\d{3}-`.

Ten factual errors found in the same pass were **not** left as questions. They are corrected in
place and logged in their items: `leak-auditor.md`'s claim about a scan that does not exist,
`#012`'s and `#014`'s two opposite errors about `check-index.ps1`, `#015`'s report count and its
blocker claim over `#011`, `#005`'s "planned" fixture, `#017`'s stale log line, `#013`'s rename
table, `#011`'s evidence count, and the `#009`/`#016` disagreement about which disguise came first.

Twenty-one questions remain, in five blocks. Each is **finding → question → recommendation**. The
recommendation is a starting position, not a decision.

## The state this pass found

21 items, 16 open, 5 `proven`; `board.ps1` warns at 25. Two check roles went into service on
`2026-08-02` — `leak-auditor` (`#017`) and `run-scorer` (`#016`) — and immediately produced four
items (`#018`–`#021`). The roles work. Three things sit *between* the items and none of them belongs
to any one item:

1. **One hole is open right now.** Closed in this pass, kept here because it is the pattern:
   `leak-auditor.md` shipped telling the auditor not to re-find what a `new-run.ps1` string scan
   finds. That scan is `#015` and is not built. `#017`'s Cost section predicted this exact trade in
   one direction; it happened in the other.
2. **Four items edit the same two hand-written lists in `build-dist.ps1`** (`#013` P5, `#014`,
   `#018`, `#019`), and five items write into `process/scenarios/alt-a-left-to-right.md`. `CLAUDE.md`
   calls the first of those *"the one invariant that silently invalidates everything."*
   *Both counts have since moved — B3 and C1 took two items off `build-dist.ps1`, and the second
   count was one too many to begin with. D1 and D2 carry the corrected figures; this line is left as
   the pass found it.*
3. **`#013` is a bottleneck** — eleven deliverables, at least six separable decisions, four items
   waiting on it, and one of those decisions collides with two standing rules.

---

## Block A — the board's own rules no longer describe the board

### A1 — `proven` means two different things in one file

`README.md` defines the state: *"the criterion flipped, nothing regressed, the change is applied."*
Twelve lines earlier the lane rule says a `Gate: none` item *"goes straight to `proven` when
applied."* All five `proven` items are `Gate: none` and not one of them flipped a criterion; `#008`
says so outright — *"this item reaches `proven` by being **applied**, not by being **shown to
help**."*

**Question.** Amend the state definition so it covers both lanes, or add a sixth state (`applied`)
for the `none` lane?

**Recommendation.** Amend the definition. A sixth state buys a distinction the `Gate` column already
carries, and every `proven` item on the board would have to be re-labelled.

### A2 — two attribution values are in use that the template does not define

`TEMPLATE.md:7` enumerates five: playbook gap / model disposition / implementation error / harness
artefact / scenario defect. In use: `stale documentation` (`#003` — borrowed from the *lane*
examples in `README.md`) and `owner decision` (`#008`, `#012`, `#013`, `#014`, `#016`, `#017` — six
items, which makes it the most common value on the board).

**Question.** Add `owner decision` to the enumerated set, or rewrite those six items to fit the
existing five?

**Recommendation.** Add it, and fold `stale documentation` into it or into `harness artefact`.
Six items is not a drift, it is a category the taxonomy was missing — the taxonomy was written for
findings out of runs, and half the board is now work the owner chose.

### A3 — three `Gate: run` items can never reach `grilled`

`README.md` requires a `grilled` entry to name *"which criterion flips and whether it has a
before-fail on record."* `#005`: *"a rule written before its first ambiguity has nothing to flip."*
`#011`: *"There is no treatment and no before-fail."* `#006`: the proof design is *"not designable"*
until something else exists. All three are honest, all three are coverage gaps rather than product
faults, and as filed all three are stuck in `formulated` permanently.

**Question.** A third lane (`coverage`), a move to `none`, or an explicit `blocked` marker that
keeps the lane and admits the wait?

**Recommendation.** `blocked` as a header field, not a new lane. The lane is about *what proves the
item*, and for all three that answer is still "a run" — what is missing is the precondition, and a
field that names the precondition is also the thing that tells you when to look again.

### A4 — `#006` is filed against three of its own statements

Header: `Gate: run` + `Attribution: harness artefact`. Every other harness-artefact item on the
board is `none`. `Target file` is `stacks/dom-css/README.md`, a **published product file**, while
the body says *"Nothing is wrong with the product."* And the proposed change is *none, on
principle*.

**Question.** What is `#006` — a harness artefact, a coverage gap, or a note that §2 resolution is
unmeasurable until a gated pitfall exists and should say only that?

**Recommendation.** The last one. Re-file as a coverage gap blocked on a gated pitfall, `Gate: run`,
no target file. Its real content is the caveat every report has to carry, and that is worth keeping.

### A5 — the Evidence rule has been bent six times and never amended

*"An item with no run behind it is a hunch."* Six items carry an owner decision and a date instead.
`#008` argues the exception in place; nothing generalised it, and `#012`, `#013`, `#014`, `#016` and
`#017` then reused it.

**Question.** Amend the rule to admit an owner decision as evidence, or keep the rule and mark those
six as standing exceptions?

**Recommendation.** Amend. Six of twenty-one is the norm, and a rule everyone quietly steps over
stops being read at all — which is the failure mode this board was built against.

### A6 — `board.ps1` forbids a transition that has already happened

`board.ps1:109` refuses `grilled` to a `Gate: none` item. `#013` was grilled — seven decisions,
recorded in its log — and notes the contradiction without resolving it.

**Question.** Allow `grilled` in the `none` lane, or keep the rule and accept that grilling a
`none`-lane item leaves no trace in its state?

**Recommendation.** Allow it. The lane says what *proves* an item; it should not say whether the
item may be argued with first. `#013` is the proof that the big `none`-lane items need grilling
most.

---

## Block B — the contradictions between items

### B1 — `#014` and `#018` change the same file in opposite directions

`#018` removes the root `README.md` from the mirror, because *"it is the repository's face for a
human on GitHub, and that is the only reader it has."* `#014` adds to that same file a **See it
running** section listing ten run ids, their models, and what each run was for. Neither item
mentions the other; `#014` predates `#018` by hours. In the order `#018` → `#014` they are fine. In
the reverse order, or if `#014` lands alone, the mirror handed to every hire contains a list of ten
scored runs — a worse leak than the single sentence `#018` documents in eight of ten transcripts.

**Question.** Bind the order in both items, or move `#014`'s index out of the root README?

**Recommendation.** Bind the order, in writing, in both items. Moving the index defeats `#014`'s
purpose, which is that a GitHub visitor sees results without going looking.

### B2 — `#014` adds exactly the thing `#018` exists to abolish

`#018`: *"No path is named, so a new published file cannot slip past it."* `#014` adds one path name
to the two hand-written places `CLAUDE.md` calls a silent total loss — and books it as a cost.
Worse, the two do not actually cover each other: `#018`'s grep reads `.md` files, and `#014`'s demos
are `.html`, `.css`, `.js` and `.png`. Under both items, the answer sheet is protected by a path
string and nothing else.

**Question.** Does `docs/` get a content check rather than a path name — and what would that check
look for in a `.html` file that a published demo has and a fixture does not?

**Recommendation.** A content check keyed on the sprite: any mirror file referencing a sheet from
`monsters/` that the hire did not download is a finished implementation. That is checkable, it is
path-free, and it catches `#012`'s `step-4-result/` copies by the same rule.

### B3 — mirror exclusion is not containment, for two run classes

`2026-08-01-live` ran against real `raw.githubusercontent.com` URLs and never read a mirror.
`#014` switches GitHub Pages on. From then, `docs/demos/<run-id>/` is world-readable at a guessable
URL, and `build-dist.ps1` has no say in it. The identical hole applies to `#018`'s README exclusion.
No item names this.

**Question.** Does the real-URL run class survive publication at all, and if so what contains the
answer sheet for it — a separate branch for `docs/`, obfuscated demo names, or something else?

**Recommendation.** Publish demos from a branch that is not `main`, so the raw base URL a hire
derives in §0 cannot reach them. It costs one line of publish tooling and keeps the run class alive,
which matters because §0, §5's WebFetch/curl split and stack resolution are testable *only* in that
class.

### B4 — two items say opposite things about what the record tree does for `#006`

`#013:85`: the captured worktree is *"the exact trace `#006` is short of."* `#012:110`: ten
implementations of one job *"must not be mistaken for progress on it"*, because `#006` needs a
second **surface**.

**Question.** Which is it?

**Recommendation.** `#012` is right and `#013`'s sentence should go. A fingerprint proves *which
note was read*; ten runs against one note cannot produce one no matter how well they are captured.

### B5 — what is the next run actually for?

With `#015`'s blocker claim corrected: `gsap-site` does not unblock `#011` (it has no build);
`#005` needs a second *published* stack note as well as a fixture, and there is one. `python-cli`
exercises the §3 decline path, which has never been run and needs no second stack row.

**Question.** Once Wave 0 and Wave 1 are in, which run is spent next, and against which item as its
brief? `README.md`'s rule is absolute: no item in `grilled`, no run.

**Recommendation.** `python-cli` against the §3 decline path, as a new item. It is the only second
fixture that is unblocked by `#015` alone, and "does the hire correctly refuse" is the one section
of the playbook with no measurement at all.

### B6 — three leak word-lists, in three scripts, with no shared source

| Script | Terms | Scope | State |
|---|---|---|---|
| `new-run.ps1` | `Monster-Dev`, `MonsterLib` | run folder | `#015`, not built |
| `build-dist.ps1` | `acceptance criteria`, `test run`, `criterion`, `what is being measured`, `comparability` | mirror `.md` | `#018`, not built |
| `score-bundle.ps1:184` | `acceptance criteria`, `proof design`, `playbook gap`, `board` | scoring bundle | shipped |

Two overlap on one term; none derives from another.

**Question.** One shared source, or three deliberately separate lists with a stated reason each?

**Recommendation.** Three separate lists, and each one gains a comment saying which reader it
protects and why it is not the others'. They guard three different readers against three different
leaks; merging them would make every list the union of all three and every check noisier. What is
missing is not a shared source, it is the sentence saying why they differ.

### B7 — "what was this run for" is specified three times, three ways

`#012` wants a column in `process/stacks/html/css/knowledge.md`, values *baseline / control /
no-change arm / proof arm*. `#013` wants OKF `type`/`tags`/`resource` on `process/runs/<id>/`.
`#014` wants a sentence per run in the root README. `#013`'s own doctrine: *"the index **is** the
folder, and there is no second place for it to drift."*

**Question.** Which place is the source, and what do the other two derive from it?

**Recommendation.** `process/runs/<id>/` is the source — it is where the run *is*. The record-tree
column and the README line are both renderings, and if they are hand-written they will disagree
within a month. This is the same argument `#013` used to make the tag overview rendered rather than
a `TAGS.md`.

---

## Block C — splitting `#013`

Eleven deliverables. Four items wait on it: `#012` is its Phase 4, `#016`'s `score-b.md` path,
`#014`'s demo source, and `#019`'s declared collision.

### C1 — three items instead of one?

- **(a) `runs/` flat → folders**, plus `hire.ps1:75`. A pure refactor. Unblocks `#016`'s output path
  and `#014`'s source immediately, and has to happen with `#019` anyway.
- **(b) automatic capture in `hire.ps1` + `scrub-transcript.ps1`.** The actual problem the item is
  named for: the transcript and the worktree are the only irreplaceable things a run makes, and
  `new-run.ps1 -Force` has already destroyed one set.
- **(c) OKF frontmatter + tags + wikilinks + link checker.** A metadata convention. Needs nothing
  from (a) or (b), and carries the whole rule collision (C2, C3) by itself.

**Question.** Split?

**Recommendation.** Yes. (a) immediately, (b) next and on its own merits, (c) decided separately —
because as one item, (c)'s two unresolved collisions hold the backup hostage, and the backup is the
part that is losing data today.

### C2 — OKF frontmatter against the `Stack:` first-line rule

`CLAUDE.md:42`: *"every `impl-NN/knowledge.md` **opens with** a `Stack: <name>` line naming the
published stack it belongs to"* — repeated at `process/stacks/README.md:22`. That line is *"the
whole mapping between the two keys"* (`#008`). OKF makes the first line `---`, and its fields have
no slot for a published stack name; `resource` is already spent on the run id. `#013`'s Phase 5 edit
list does not include either sentence.

**Question.** `Stack:` becomes a frontmatter field — which one — or `process/stacks/` keeps its
plain first line and OKF applies only to `process/runs/`?

**Recommendation.** The second. The `Stack:` line is load-bearing for the two-tree design; a
metadata convention should not be the reason it moves.

### C3 — mandatory frontmatter against the frozen copies

Phase 3 requires OKF frontmatter on *"every `.md` under `process/stacks/`"*. That set includes
`step-1-fixture/README.md` and `step-4-result/README.md`, which are byte copies — *"a frozen **copy**
of the fixture by explicit design"* (`#012`) — and `#014` needs `step-4-result/` to stay byte
identical so a published demo is the thing that was handed back. `impl-01` already has two such
files; `#012` adds eighteen more.

**Question.** Exclude the frozen copies explicitly, or drop the "every `.md`" claim?

**Recommendation.** Exclude them, in the script and in the sentence. A copy that has been edited is
not a copy, and the four-step tree's whole value is that steps 1 and 4 are untouched.

### C4 — the capture backstop stops working under `#019`

The backstop: *"a directory under `../monster-dev-testruns/` (ignoring `*.dist`) with no
`process/runs/<id>/` beside it → FAIL."* `#019` replaces that layout with `<run-id>/target/` and
`<run-id>/dist/`; then "ignoring `*.dist`" matches nothing and the directory names are still run ids
only by luck. Neither item names this. Separately: the backstop makes a commit gate depend on the
contents of a directory **outside** the repository.

**Question.** Rebuild the backstop against `#019`'s layout, or key it on something inside the repo —
e.g. every run id cited by a report or a board item must have a `process/runs/<id>/`?

**Recommendation.** Key it inside the repo. A check that reads a sibling directory is a check that
behaves differently on another machine, and this one would gate commits.

---

## Block D — sequencing

### D1 — `build-dist.ps1` in one sitting

*Corrected before it was asked — by the answers to B3 and C1, which landed after this was written.*
As first put: *"four items edit the same two hand-written lists"* — `#013` P5, `#014`, `#018`,
`#019`. Today that is wrong twice. **B3** took `#014` off the file entirely, **C1** moved `#013`'s
check to `#024`, and `#023` never touched it. What is left is three items in one file, editing three
different lines:

| Item | What it edits |
|---|---|
| `#018` | the exclusion list at `:73` — the invariant itself — plus two new mirror checks |
| `#019` | the mirror's output path at `:56` |
| `#024` | one new check after assembly |

So the "same two hand-written lines" argument now applies to exactly one open item. `CLAUDE.md`'s
lesson from the `test/` → `process/` rename still applies to it alone: *"change every site, then
build one and look inside it; a green script is not evidence."*

**Question.** Land them together anyway, or pair only the two that need each other?

**Recommendation.** `#018` + `#019`, then build a mirror and read it. Not because they touch the same
list — they do not — but because `#019` moves where the mirror is written and `#018`'s new checks run
against it. `#024` is blocked on `#023` and `#013`, so including it would drag the whole capture
chain forward.

### D2 — one scenario boundary instead of four

*Corrected before it was asked:* **four** items write into `alt-a-left-to-right.md`, not five, and
`#018` is not one of them — it names four target files and the scenario is not among them. The four
are `#001` (`15c`), `#020` (`14b`), `#021` (`11`) and `#015` (a caveat recording that six runs were
scored while contaminated). Landed separately that is four comparability boundaries where one would
do — and every boundary makes the ten runs on record harder to read against the next one.

**Question.** One edit, one boundary line naming everything that changed on `2026-08-02`?

**Recommendation.** Yes. This is the cheapest decision on the list and the one with the longest tail.

### D3 — one verifier pass instead of three

`#007` (favicon baseline) and `#021` (reduced-motion pass) both change `verify-run.mjs`'s
measurement set; `#021` books the bundling, `#007` does not mention it. `#020` needs a verifier
change too and does not say so: *"Record the implementation's actual numbers"* cannot be satisfied
from `measurements.json`, which carries `spriteNaturalSize` and the catalog's cell geometry —
the **sheet's** numbers — and never reads the hire's `--monster-frame-w`.

**Question.** One pass covering all three, with `verify-run.mjs` added to `#020`'s target row?

**Recommendation.** Yes, and it pairs with D2: the same sitting produces one scenario boundary and
one verifier change.

### D4 — the proposed order overall

- **Wave 0** — done in this pass: ten factual corrections, `leak-auditor.md` closed.
- **Wave 1** — scenario + verifier, one sitting: `#001`, `#020`, `#021`, `#007`, plus criteria `10`
  and `13` from E2. One boundary line, one verifier change.
- **Wave 2** — everything that touches paths, one sitting: `#015`, `#018`, `#019`, `#013`(a). Then
  build a mirror and look inside it.
- **Wave 3** — after Block C: `#013`(b), then `#013`(c) if approved, then `#012`, then `#014`.
- **Not scheduled, and not blocked on a decision:** `#002` (see E4), `#004` (waiting on a second
  sighting), `#005`, `#006`, `#011` (each waiting on something that has to be built or found).

**Question.** Does this hold, and is anything in Wave 3 urgent enough to move up?

**Recommendation.** One candidate to move up: `#013`(b), the capture. It is the only item on the
board where waiting costs data that cannot be recovered.

---

## Block E — what is not on the board yet

### E1 — three findings `#017` recorded and never filed

Quoted from `#017`: *"the fixture's `script.js:1` comment states the §2.4 answer independently of
the README, so `#015`'s fix does not reach it; the answer script's fallback selects exactly the
sheet `index.html` is built on, so criteria `10` and `14b` cannot separate a derivation from a copy;
and `monsters/README.md` gives a hire a reason to pick the default that has nothing to do with the
client."*

The middle one is the serious one. It says criterion `14b` was unmeasurable *before* `#020` found it
was measured off the wrong artifact — the answer script pre-selects the sheet, so a hire that
copies `index.html` and a hire that derives from the brief produce the same numbers.

**Question.** File all three? The middle one arguably supersedes `#020` rather than sitting beside
it.

**Recommendation.** File all three, and note in `#020` that fixing the criterion's wording does not
make it measurable while the answer script resolves the fork. Both changes are needed and they are
in different files.

### E2 — the scoring gap is structural, and two more criteria have it

`#020` and `#021` are the same defect at two depths: **section D criteria name their instrument;
section B criteria do not**, and section B contains behavioural and numeric claims that were scored
off whatever the instrument happened to emit. Two more:

- **Criterion `10`** — *"duration derived from stride and viewport."* `measurements.json` contains
  no stride, no viewport width and no duration. Every report records *"duration derived"* with no
  number on either side of the derivation. `10` is also one of the four **risk criteria** that must
  hold in every A/B, so it is load-bearing for every comparison on record.
- **Criterion `13`** — *"no 'MonsterLib' reference."* Scored from `git status --porcelain`, which
  reports paths and never content. No wrong verdict has been shown, and the criterion still names
  the pre-rename product.

**Question.** One item — *every criterion names its instrument* — instead of `#020`, `#021` and two
more single-criterion rewrites?

**Recommendation.** Yes, with `#020` and `#021` folded into it as its evidence. A per-criterion
rewrite fixes the criteria found so far; naming the instrument is what stops the fifth one.
Criterion `10` should be re-scored across the runs on record before the next A/B leans on it again.

### E3 — the blind second scoring is written outside the repository

Both `score-b.md` files are in `..\monster-dev-scoring\`. `process/runs/` has neither — not at
`<id>/score-b.md` and not at the `<id>.score-b.md` fallback `#016`'s Cost section names. Neither
`run-scorer.md` nor SKILL.md step 8 states an output path at all; step 8 ends at *"set the two
columns side by side."* This is `#013`'s complaint reproduced by the fix for `#016`, and the
evidence that produced `#020` and `#021` is currently unversioned.

**Question.** Write to `process/runs/<id>.score-b.md` now, or wait for `#013`(a) and write to
`process/runs/<id>/score-b.md`?

**Recommendation.** Now, at the flat path, and move it with everything else in `#013`(a) — which is
exactly what `#016`'s Cost section already says should happen. Also state the path in
`run-scorer.md` and in step 8, because an unnamed output is why there is no file.

### E4 — `#002` is waiting for nobody

The only `Gate: run` item whose treatment does not exist. Its own proof design says *"the arm-B
wording does not exist, and an A/B whose treatment is 'some sentence' has no proof design."* The
open question it names is real — whether the §4 plan step's extra ten turns buy anything beyond the
four marks it demonstrably wins — but nothing will answer it until someone writes the §6 sentence
that bounds the build. It also shares §6 with `#004`, and the two pull in opposite directions:
`#002` would tell a hire to do less, `#004` to disclose more.

**Question.** Write arm B now, or reject the item and keep the turn-count observation as a note on
`#004`?

**Recommendation.** Write arm B, and write it together with `#004`'s sentence so §6 is edited once
by someone holding both intentions. `#002` is the only item on the board about *cost*, and cost is
one of the three numbers the tooling gate is stated in.

---

## Answers

*Filled in as we work through it. Each answer also goes into its item's `Log`.*

### Block A — settled `2026-08-02`, all six as recommended

**A1 — the `proven` definition is amended, no sixth state.** `README.md` now defines it once for
both lanes: applied, plus a flipped criterion where there is one to flip. It also says plainly what
`proven` in the `none` lane does *not* mean — that the item was shown to help. Five of five
`proven` items are in that lane.

**A2 — `owner decision` joins the enumerated attributions.** Six items were already using it; the
five existing values all name a fault a run found, and half the board is now work that was chosen
rather than discovered. `stale documentation` goes: `#003` is re-attributed to `harness artefact`,
because the fault is dev-side apparatus gone wrong — `references/report-template.md` tells every
report to record something untrue.

**A3 — a `Blocked on` header field, not a third lane.** The lane keeps meaning *what proves this*.
Added to `#005` (a second published stack note), `#006` (a gated pitfall in any published note) and
`#011` (a fixture with a real build, ecosystem undecided). `board.ps1 -Full` prints it, so a blocked
item now reads as waiting rather than neglected.

**A4 — `#006` re-filed.** Target file dropped; it named a published product file while the body
said nothing was wrong with the product and proposed no change. With `Blocked on` in place,
`Gate: run` + `harness artefact` is coherent: a run will prove it, the instrument is the fault, and
the field says why neither can happen yet. Attribution stays `harness artefact` rather than becoming
`coverage`, since A3 declined to create that value.

**A5 — Evidence admits a dated owner decision.** The rule read *"an item with no run behind it is a
hunch"* and had been stepped over six times without amendment. It now reads: a run id per sighting,
or a dated owner decision; neither is a hunch. `board.ps1`'s failure message says the same.

**A6 — `grilled` is allowed in the `none` lane; `in-proof` still is not.** `board.ps1:109` used to
refuse both. The lane says what proves an item, not whether it may be argued with first — and
`#013` is the case: seven decisions, two of which reversed the item as written, with no state to be
visible in. `in-proof` stays forbidden, because that state assigns a run and this lane has none.

Files changed: `README.md`, `TEMPLATE.md`, `board.ps1`, and items `#003`, `#005`, `#006`, `#011`.

### Block B — settled `2026-08-02`, all seven as recommended

**B1 — `#018` lands before `#014`,** written into both as a precondition rather than a note. Until
`README.md` leaves the mirror, `#014`'s *See it running* section is a list of ten scored run ids in
front of every hire.

**B2 — a content check, not a path name.** `#018`'s `.md` vocabulary grep gains a sibling keyed on
the artifact: any mirror file referencing a `monsters/` sheet, other than §5 and the sheets
themselves, is a finished implementation — fail, delete, name the file. The reasoning that made
this necessary is that a finished implementation is `.html`/`.css`/`.js` and contains none of the
harness words, so the worst possible leak is exactly the one a prose grep misses.

**B3 — the demos go on a `gh-pages` branch and leave `main`.** Mirror exclusion is not containment:
a run over real `raw.githubusercontent.com` URLs never reads a mirror, and once Pages is on, a
`docs/` inside `main` is world-readable at a guessable URL regardless. The base URL a hire derives
in §0 points at `main`; keep the demos off it and both run classes close at once. This deleted four
sub-deliverables from `#014` — the exclusion glob, the backstop entry, a `check-index.ps1` filter
and a mirror inspection.

*Interaction worth recording:* B3 removed B2's original motivation. The sprite check is kept
anyway, because its value was never `docs/` specifically — it is `#018`'s own principle that a new
published file must not be able to slip past, and a path list cannot deliver that.

**B4 — `#012` is right, `#013`'s sentence is withdrawn.** A fingerprint proves *which note was
read*; ten captures of one surface cannot produce one. What the capture gives `#006` is an
instrument for later, not evidence now, and all three items say so the same way.

**B5 — the next run is `python-cli`, the §3 decline path.** Filed as `#022`. It is the only second
fixture that `#015` alone unblocks, and §3 is the only section of the playbook with no evidence at
all behind it — eleven sessions on record, every one against a page with an obvious surface. It
needs a scenario, and then `grilled`, before a run.

**B6 — three lists stay three lists,** each gaining a comment naming the reader it protects and why
it is not the other two: `new-run.ps1` guards the hire's working copy, `build-dist.ps1` the mirror,
`score-bundle.ps1` the blind scorer. A shared source would be the union of all three and would make
every check noisier.

**B7 — `process/runs/<id>/` is the source for *what a run was for*.** `#012`'s column and `#014`'s
README line are rendered from it, not typed — the same argument `#013` used to make the tag
overview rendered rather than a `TAGS.md` that could drift.

Files changed: items `#006`, `#012`, `#013`, `#014`, `#015`, `#018`, new `#022`; `README.md` and
`TEMPLATE.md` again, because `Blocked on` was defined too narrowly to say "another item" and was
being used that way within the hour.

### Block C — settled `2026-08-02`, all four as recommended

**C1 — `#013` splits three ways.** `#023` takes the `runs/` layout and arrives `grilled`, because it
was grilled inside `#013` the same day and nothing about it is newly proposed. `#013` keeps the
capture and the scrubber — what it is named for, and the only part losing data today. `#024` takes
OKF, tags, wikilinks, the link checker and the mirror boundary check, and stays `formulated`,
because C2 changed what it covers.

The split is worth more than tidiness. Four items were waiting on `#013`, and **none of them was
waiting on the same third of it**: `#016` and `#014` want the folder (`#023`), `#012` wants the
capture (`#013`), `#018` cites the mirror check (`#024`). One of those citations was wrong about
which half it meant — `#019` said *"Part 1"* and described Phase 1, which are the capture and the
layout respectively. That ambiguity is what an eleven-deliverable item costs, and it is now gone.

**C2 — OKF applies to `process/runs/` only.** `process/stacks/` keeps its plain `Stack: <name>`
first line. That line is the whole mapping between the two trees called `stacks/`; a metadata
convention is not a good enough reason to move it, and OKF has no field to move it *into* —
`resource` is spent on the run id.

*Consequence, recorded rather than absorbed:* the tag overview now covers `process/runs/` and not
`process/stacks/` — which is the tree the navigability complaint was actually about. What remains
there is the `Stack:` line and `[[wikilinks]]`, which are body syntax and need no frontmatter. A tag
layer over `process/stacks/` would need its own decision; C2 closed the frontmatter route to it and
no other route has been designed. Written into `#024` as an open fork, not as a plan.

*And the wikilink hazard goes up, not down.* `process/stacks/` is the tree paragraphs are promoted
*from*, and under C2 it keeps wikilinks while losing frontmatter — so the `[[` half of the mirror
check is now the load-bearing half. The `---` half stays as a standing guard on a rule that has
just acquired an exception.

**C3 — dissolved by C2, and stated anyway.** The frozen copies needed excluding from *"frontmatter
on every `.md` under `process/stacks/`"*; C2 removed that requirement wholesale, so there is nothing
left to exclude. The rule is written into `#024` regardless — **nothing writes into
`step-1-fixture/` or `step-4-result/`** — because the collision was with the *idea* of a convention
over that tree, and the next one will arrive at the same two files.

**C4 — the capture backstop is keyed inside the repository.** Every run id cited by a report, a
scenario or a board item must have a `process/runs/<id>/`. Its first form read a sibling directory,
which was wrong twice over: `#019` was about to make the pattern match nothing, and independently of
that it made a commit gate depend on a directory outside the repository — the same commit passing on
one machine and failing on another.

What that trades away is in `#013` in plain words: a run executed and then cited nowhere leaves no
trace inside the repository, so no repo-internal check can miss it. The per-turn capture is what
covers that case, and it covers it by construction.

Files changed: `#013` rewritten to its remaining third, new `#023` and `#024`, and the inbound
citations in `#012`, `#014`, `#016`, `#018`, `#019`.

### Block D — settled `2026-08-02`, all four as recommended

Two of the four findings were wrong by the time they were asked, and both are corrected above rather
than answered around. That is worth naming as a pattern: **a sequencing plan decays as soon as the
items it sequences are answered.** B3 and C1 changed which items touch `build-dist.ps1` inside the
same afternoon. Any plan below has the same shelf life.

**D1 — `#018` and `#019` land together, then a mirror is built and read by eye.** The original
argument does not survive: after B3 and C1, `#018` is the *only* open item that edits the exclusion
list — the two hand-written lines `CLAUDE.md` calls the invariant. The pairing survives on a
different one. `#019` moves where the mirror is written and `#018` adds two checks that run against
it; landing them apart means writing the checks twice or writing them against a path about to move.
`#024`'s check comes later, behind `#023` and `#013`, and `#018`'s log says the three path-free
mirror checks should read alike when they all exist.

**D2 — one edit, one dated boundary line.** `#001`, `#015`, `#020` and `#021` all write into
`alt-a-left-to-right.md`, three changing what a criterion means and one recording that six runs were
scored contaminated. Four separate boundaries through the same ten runs, for changes made on one
day, would be four reasons a future comparison has to be qualified. The cheapest decision on the
list with the longest tail.

**D3 — one `verify-run.mjs` pass covering three items,** and `verify-run.mjs` is now in `#020`'s
target row. `#021` had booked the bundling and named `#007`; neither had noticed `#020`. Its
criterion asks for *the implementation's* numbers and `measurements.json` records the **sheet's** —
`spriteNaturalSize` and the catalog's cell geometry, never the hire's `--monster-frame-w`. Rewording
the criterion alone would have produced one no run can satisfy, which is the exact fault `#021`
is filed for.

**D4 — the order, with `#023` and `#013` moved forward.**

| Wave | Items | Why together |
|---|---|---|
| 0 — done | ten corrections, `leak-auditor.md` | — |
| 1 | `#001`, `#015`*, `#020`, `#021`, `#007` — plus `#023` and `#013` in parallel | one scenario boundary (D2), one verifier pass (D3); the capture touches none of those files |
| 2 | `#015`, `#018`, `#019` | everything that moves a path; `#019` pairs with `#023` above and with `#018` here |
| 3 | `#012`, `#024`, `#014` | each needs the wave above it to exist first |

\* `#015`'s scenario caveat is a Wave 1 line; the fixture rewrite and the `new-run.ps1` scan are
Wave 2. It is the one item that genuinely spans two sittings.

Not scheduled and not blocked on any decision: `#002` (see E4), `#004` (waiting on a second
sighting), `#005`, `#006`, `#011` — each waiting on something that has to be built or found.
`#022` follows `#015` and then needs a scenario written.

`#023` and `#013` move forward for one reason and it is not their size. The capture is the only
place on this board where waiting is paid for in data: every run executed before it lands keeps its
transcript and its worktree in one location outside the repository, and `new-run.ps1 -Force` has
already destroyed one set. Everything else on the board can wait a week and lose nothing.

Files changed: `#001`, `#007`, `#013`, `#015`, `#018`, `#019`, `#020` (target row and log), `#021`,
`#023`.
