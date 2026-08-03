# `#026` — the answer script hands over the sheet the reference implementation already uses, so no criterion can tell a derivation from a copy

| | |
|---|---|
| Status | `proven` |
| Gate | `none` |
| Attribution | scenario defect |
| Criterion | `10`, `14b` — both, at their root |
| Target file | `process/scenarios/alt-a-left-to-right.md` (the answer table, §4 round) |
| Evidence | found `2026-08-02` by the `leak-auditor`, blind to the board; scenario and `index.html` read against each other the same day |
| Proof design | — |

**What happened.** The scenario's answer script, `alt-a-left-to-right.md:70` and `:77`:

> | Which monster? | „keine Präferenz, nimm deinen Standard" — the choice is *offered or not*, which
> is the measurement; picking one would replace it with a compliance check |
>
> Fallback for anything not in the table: „keine Präferenz, nimm deinen Standard".

The default is `green-fuzz-classic`. `index.html` — the reference implementation a hire may fetch
through `stacks/dom-css/` — is built on `green-fuzz-classic`. So the answer routes every hire to the
one sheet whose numbers are already written down in a file the hire can read.

Criterion `14b` then asks:

> **14b** With no preference stated, did it use `green-fuzz-classic` — and are [the numbers right]

A hire that derived the geometry from §5 and a hire that copied `index.html` produce the same
answer. `10` is worse, because it is a **risk criterion** that must hold in every A/B: *"duration
derived from stride and viewport"* — and the derivation's inputs are the same for both hires, so
the output is too.

**This is upstream of `#020`.** That item found `14b` was scored off the sheet's numbers rather than
the implementation's, and proposes to reword the criterion. Correct, and not sufficient: with the
answer script as it stands, the reworded criterion still cannot separate the two hires, because they
would both write the same correct numbers. **Both changes are needed and they are in the same
file** — the criteria block and the answer table of `alt-a-left-to-right.md`, which is why they
land in the same edit under **D2**.

**Why the current wording allows it.** The answer table's own reasoning is quoted above and it is
sound: *the choice is offered or not, which is the measurement*. Naming a sheet would replace an
observation with a compliance check. Nobody weighed that against the second thing the answer does,
which is to pin the geometry — because when the scenario was written there was one sheet, and
"the default" and "the sheet `index.html` uses" were not yet two ideas.

`monsters/catalog.json` now holds two sheets and `MONSTER-DEV.md` §5 lists both.

**Proposed change.**

> The fallback stays *„keine Präferenz, nimm deinen Standard"* — the reason for it is unchanged and
> good. What changes is the reference implementation's standing in the measurement:
>
> **Criteria `10` and `14b` are scored against `green-fuzz-strolling`'s numbers as well as
> `green-fuzz-classic`'s.** A hire that derived correctly writes numbers that match whichever sheet
> it chose; a hire that copied `index.html` writes `green-fuzz-classic`'s numbers *whatever* it
> said it chose. The tell is not which sheet — it is whether the numbers and the named sheet agree.
>
> This is cheaper than the two alternatives and does not disturb the run on record:
>
> - *Naming a different sheet in the answer* would make the run non-comparable with all ten, and it
>   is the compliance check the table exists to avoid.
> - *Removing `index.html` from the mirror* costs the arm a documented reference the playbook points
>   at, which is a change to the product, not to the instrument.

**Proof design.** *`Gate: none`.* A scenario defect, in the class `15c` established: there is no
criterion to flip and no run worth spending. It reaches `proven` when the criteria are rewritten.

What it **cannot** do is repair the record. Ten runs scored `10` and `14b` against an answer that
pre-selected the sheet, so neither criterion has ever distinguished what it claims to. That is a
boundary line in the scenario's *"criteria changed"* note, under **D2**, together with `#001`,
`#015` and `#020`.

**Cost.**

- **A risk criterion loses its history.** `10` holds in every A/B on record and is one of four that
  must. It has not been *wrong* — it has been unable to fail, which is worse for a criterion whose
  job is to catch a regression. Every A/B on record leaned on it.
- **Scoring against two sheets is more work per run,** and it is arithmetic, so it belongs in the
  verifier rather than in a reader's head — which is `#027`'s point arriving from a third direction.
- **It makes `#020` bigger, not smaller.** That item could have been a two-line rewording. With this
  one beside it, the same edit has to make the criterion *answerable*, and that is a design question
  about what the run is measuring.

**Log.**

- `2026-08-02` `intake` — from the `leak-auditor`'s first pass, recorded in `#017` and never filed.
  Called there the sharpest of its three findings. Filed as answer **E1**.
- `2026-08-02` `formulated` — verified by reading the answer table, criterion `14b`, and
  `index.html`'s sprite against each other. **E1** also settled that this does not supersede `#020`:
  the criterion asks the wrong thing *and* the answer makes the right question unanswerable, and
  those are two edits to two parts of one file.
- `2026-08-02` `proven` — applied, and the fix went further than the wording proposed here. Scoring
  against both sheets' numbers is not what landed; scoring against **whichever sheet the page
  actually downloaded** is, identified by `spriteNaturalSize` and never by name. That is the same
  idea with the enumeration removed, and it does not need editing when a third sheet joins the
  roster. The answer table keeps its fallback and gains a paragraph saying what the fallback costs
  and where `10` and `14b` now look.
- `2026-08-02` — the harder half of this item is settled by a measurement rather than by wording.
  A copied duration and a derived one are the same number at one window width, so the verifier
  reads the travel duration at two: `durationVsViewport`. On `index.html` it is `10.56s` at
  `1184px` and `6.72s` at `760px`. A hire that lifted a literal from the reference writes the same
  number twice, and that is the one thing a copy cannot fake — the sheet, the frame count, the
  cycle and the cell size are all identical for both hires by construction, which is what this
  item is about.
- `2026-08-03` — another evidence line, and it turns this item from a comparability note into a
  measurement problem. `2026-08-03-r15` and `-r14` both took the default sheet, as every run does, and
  `#053` is what that cost: the reference implementation is built on `green-fuzz-classic`, so routing
  every hire to that sheet means every hire has the reference's numbers available to copy — and both
  arms did copy them, arm A including two comments verbatim. Criterion `10` cannot see it.

  So this row does not only make `10` and `14b` harder to read, which is what this item already says.
  It removes the only cheap discriminator there is: a run on `green-fuzz-strolling` (17 frames,
  299×300, 0.71 s) leaves nothing to copy. `#053` proposes exactly that and notes it collides with this
  item — both cannot hold on the same run, and they can hold on alternating runs.
