# `#076` — the published `dom-css` note pre-answers three marks, and no pre-answered accounting can reach it

| | |
|---|---|
| Status | `intake` |
| Gate | `none` |
| Attribution | scenario defect |
| Criterion | `alt-a-left-to-right` `9`, `18b`, `18c` — two of them section-E marks, which every `#002`-class A/B is required not to regress |
| Target file | `process/scenarios/alt-a-left-to-right.md`, the *Pre-answered* paragraph |
| Evidence | `2026-08-04-r20`, found by that run's pre-run audit before a turn was bought |

**What happened.** `#054` established the rule that a run against `static-site` *"cannot score these
clean and silently"*, and built the `Pre-answered` table in `process/fixtures/static-site.md` to say
which marks the fixture answers on paper. **That table can only ever list lines inside the fixture**,
and two of the strongest pre-answers are not in the fixture — they are in the published stack note
every hire on this surface is told to fetch:

> `stacks/dom-css/README.md:21` — *"next to whatever `logo.svg`-equivalent it has."*
>
> The fixture's sole asset is literally `assets/logo.svg`. That is `9` (sprite location) and `18c`
> (where the sprite goes), answered by filename.

> `stacks/dom-css/README.md:14` — *"CSS `@keyframes`, with `steps(N)` stepping `background-position`
> across the sprite sheet for the gait, and a separate transform animation carrying the travel across
> the screen."*
>
> That is `18b` — the animation primitive *"named as what the work will build on"* — answered before
> §2.2 is reached.

**And it falsifies the fixture note's own statement of purpose.** `process/fixtures/static-site.md`
says the fixture exists so that *"the hire picks the injection point, the asset location and the
animation primitive from scratch — and every one of those is a §2 judgement rather than a lookup."*
With the note fetched, **two of the three are a lookup**. Every one of the thirteen runs on record
fetched it.

**Why the current wording allows it.** `#054`'s repair was scoped to the fixture because that is
where `#015` found the problem, and the paragraph it wrote into the scenario inherits the scope:

> *"Four marks are pre-answered by the fixture's own `README.md` […] the full list, with what each
> line says, is the **Pre-answered** table in `process/fixtures/static-site.md`."*

A reader following that pointer gets four rows and believes it is the list. It is the list *of
fixture lines*, and nothing says so.

**What it does and does not cost.** Nothing is re-scored and no comparison breaks: the note has been
identical for all thirteen runs, so the contamination is **uniform across the series** in exactly the
way `#054`'s four rows are. What it costs is the disclosure — *"nothing regressed on section E"* is
weaker than it reads, on **four** marks rather than two, and a report following the scenario's
one-clause instruction under-reports by two.

**Proposed change.** Widen the paragraph rather than the fixture note, because the fixture note is
about the fixture and should stay that way:

> **Six marks are answered on paper before turn 1, and that is scored around rather than repaired.**
> Four by the fixture's own files — the `Pre-answered` table in `process/fixtures/static-site.md` has
> them with line numbers. **Two more by `stacks/dom-css/README.md`, the published note §2 tells the
> hire to fetch:** `:21` names the asset location by the fixture's own filename (`9`, `18c`), and
> `:14` names the animation primitive (`18b`). A guard answered on paper before turn 1 cannot
> regress, so *"nothing regressed on section E"* holds cleanly for `18a` and `18d` and weakly for
> `18b` and `18c`, and any report scoring `8`, `9`, `18b` or `18c` says so in a clause.

**Not this: changing the stack note.** It is published material and it changes only through its own
gate. It is also *correct* — telling a hire to put the sprite where the project's other assets live
is orientation doing its job, and the note cannot know that one fixture's assets folder is the answer
to somebody's criterion. **The measurement adapts to the product here, not the other way round.**

**Cost.** Six lines in the criteria half, read by every blind scorer. Worth it: the blind pass of a
run that scores `9` clean should know the note said where to put it.

**The general shape, and it is why this is filed rather than patched in one report.** A pre-answer
can come from anywhere in the hire's context, and the accounting currently covers exactly one source
because that is where the first one was found — `#003`'s *"a list of sites is the list of sites
somebody found"*. The mirror is the other source, and it will grow: every stack note added under
`#005` or `#006` is a new candidate, and each is measured against whichever fixture happens to match
it.

**Log.**

- `2026-08-04` `intake` — from `2026-08-04-r20`'s pre-run audit, which read the mirror against the
  scenario and the fixture note together and noticed the note answers what the fixture note claims
  the fixture asks. Recorded rather than fixed before that run, because the note is uniform across
  the series and editing published material mid-arm would have added a variable to a control run.
