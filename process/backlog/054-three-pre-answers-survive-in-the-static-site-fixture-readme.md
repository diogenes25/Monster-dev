# `#054` — three pre-answers survive in the `static-site` fixture README after `#015` repaired it

| | |
|---|---|
| Status | `formulated` |
| Gate | `none` |
| Attribution | harness artefact |
| Criterion | `alt-a-left-to-right` `9`, `18c` (the `assets/` line), `8` (the no-dependency line), `18b` (the §2.4 restatement) |
| Target file | `process/fixtures/static-site/README.md`, and `process/fixtures/static-site.md`, which flags only `script.js:1-2` |
| Evidence | `2026-08-03-r15` and `2026-08-03-r14`, found by the pre-run `leak-auditor` and again by both blind scorings |
| Proof design | — |

**What happened.** `#015` repaired every fixture README on `2026-08-02` — the *"Expected Monster-Dev
behavior"* heading that six of the first ten transcripts read is gone, and the file is in character as
the client's own README. Three sentences in it still answer criteria:

| Line | Text | Answers |
|---|---|---|
| `:12` | ``assets/`` — *"`logo.svg` lives here, and anything else static would too"* | `9` (sprite location) and **`18c`** (where the sprite goes) |
| `:19-20` | *"Keep it that way if you can — the site has survived three redesigns by not depending on anything"* | `8` (no dependency, no new animation library) |
| `:3`, `:11` | *"One page, hand-written HTML and CSS, no build step and no framework"*, *"`script.js` — smooth-scroll for the nav links, and nothing else"* | **`18b`** (the primitive survey) |

None of these is out of character — a real project README says exactly these things, which is why
`#015`'s repair left them. What makes them worth an item is that **two of them answer section-E marks**,
and section E is the mark set every `#002`-class A/B is required not to regress. A guard that is
answered on paper before turn 1 cannot regress, so *"nothing regressed"* is a weaker statement than it
reads. Both `2026-08-03` arms scored `18c` a clean pass off text the fixture handed them.

`process/fixtures/static-site.md` records only `script.js:1-2` (which is `#025`). All three lines above
are unflagged, so nobody scoring a run against this fixture is told to discount them.

**Why the obvious fix is wrong.** Rewriting the README to withhold these facts makes it a worse fixture:
a project whose README does not say where static assets go is not a realistic project, and the whole
point of a fixture is that a hire meets an ordinary codebase. `#025` already argues the neighbouring
case — a leak that *"no README rewrite reaches"* — from the other side.

**Proposed change.** Record rather than remove, and make the recording reach the scoring:

> `process/fixtures/static-site.md` gains a **Pre-answered** section listing every line of the fixture
> that settles a criterion, with the criterion numbers. The scenario's criteria table then names those
> criteria as *contaminated by the fixture* the way it already names `8` and `9` for six earlier runs —
> and any report scoring them says so in one clause instead of scoring them clean.
>
> Nothing in the fixture changes. What changes is that a run cannot pass `18c` silently on a sentence
> the client wrote.

**And one thing that should change**, because it is not in character and is the only line here that a
real README would not carry in this form: `:12`'s *"and anything else static would too"* is an
instruction to a future contributor about where to put new files. *"`assets/` — `logo.svg`"* says the
same thing to a reader who is looking, and answers nothing.

**Cost.** The recording approach costs a clause in every report against this fixture, forever, and it
is the honest price of a realistic fixture. The alternative — a fixture engineered to withhold — buys
cleaner criteria by measuring a project nobody has.

**Comparability.** Nothing is lost either way: all twelve runs on record read this README, so the
contamination is uniform across the series rather than a boundary.

**Log.**

- `2026-08-03` `formulated` — from `2026-08-03-r15` / `-r14`. The `leak-auditor` found all three before
  the run and explicitly noted that the fixture note *"filed only `script.js:1-2`, so closing that one
  leaves this one"*; both blind scorings then reached `8` and `9` independently and put the fixture
  README in their `UNCERTAIN` lists without having read the audit.
