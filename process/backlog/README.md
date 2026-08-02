# The board

One file per problem, carried across runs. It exists because a finding written into a run file
dies there.

The evidence is on record. Criterion `15c` was withdrawn as mis-specified by run `alt-a`, never
rewritten, and re-litigated by every run since — four of them, each spending report space on the
same conclusion. Nobody forgot it; there was simply nowhere for it to be pending.

## What makes this a queue and not a fifth place to leave things

A folder alone would have lost `15c` again. Two rules do the work:

- **The open board is read before scoring a run.** If the finding is already here, its item gets
  another evidence line — no second item is created. That is what separates *seen once* (Half C:
  *one run is not the signal*) from *reproduced* (a case).
- **A run needs a `Gate: run` item in `grilled` as its brief.** No item, no run. A board that
  nothing depends on is an archive. The gate is named because `Gate: none` items may be grilled
  too — that is where a big change gets argued with — but they are never what a run is spent on.

There is no search key, and that is deliberate: no key is stable across scenarios. Criterion numbers
are scenario-local, one has already been redefined mid-series (`15c`), section E was appended rather
than inserted so the older numbers stayed comparable, and the most interesting items have no number
at all — the turn overrun is recorded verbatim as *"cost envelope, not a numbered criterion"*.
Reading a short board beats mis-keying a long one. `board.ps1` warns past 25 open items, which is
where the method stops holding.

## Two lanes

The header line `Gate:` says which one an item is in.

- **`run`** — a product finding. Passes through every state, and its `grilled` entry has to name the
  proof design before a run can be spent on it.
- **`none`** — harness bug, scenario defect, stale documentation, owner decision. Never reaches
  `in-proof`, because there is no run to assign; it goes to `proven` when applied. Half C already
  says this about harness artefacts: *"fix the harness, rerun, record nothing against the
  product."*

  It **may** pass through `grilled`, and the big ones should. The lane says what *proves* an item,
  not whether it may be argued with first — `#013` was grilled into seven decisions, two of which
  reversed the item as written, and under the old rule that had nowhere to be visible.

The lane exists because of `15c` itself. It is a scenario defect — there is no criterion for it to
flip and no run worth spending on it. A board that only carried provable items would have dropped
the very case that motivated it.

## The five states

```
intake ──▶ formulated ──▶ grilled ──▶ in-proof ──▶ proven
                              └── Gate: none ────────┘   └▶ rejected
```

- **`intake`** — one line and a run id, or a dated owner decision. Nothing more is required on
  purpose: the cost of filing has to stay below the cost of forgetting.
- **`formulated`** — what happened, which file would change, and the **attribution** from Half C:
  *playbook gap* / *model disposition* / *implementation error* / *harness artefact* / *scenario
  defect* / *owner decision*. Nothing advances without one; this project has misattributed three
  times.

  *Owner decision* was added on `2026-08-02`, after it had been in use on six items. The other five
  name the fault a run found; this one names work chosen rather than discovered, which is half of
  what the board now carries and had no honest label.
- **`grilled`** — the change, spelled out, **plus** its proof design, which answers four questions:
  which gate from `CLAUDE.md` applies; which criterion flips and whether it has a before-fail on
  record; which model reproduces the fault (Sonnet is the bar, but proving a fix needs a model that
  fails without it); which arms, and what is held constant.
- **`in-proof`** — a run id is assigned. `Gate: run` only.
- **`proven`** — the change is applied. In the `run` lane that means the criterion flipped and
  nothing regressed. In the `none` lane there is nothing to flip, so applied *is* the whole bar —
  and an item that reaches `proven` that way has been shown to be **done**, never to have **helped**.
  `#008` says so of itself, and five of five `proven` items are in that lane.
- **`rejected`** — no measurable difference, or the fault did not reproduce.

Rejected items stay. They are the only defence against having the same idea again in a year.

## `Blocked on`

An optional header field naming a precondition that is not another item and not a decision — a
fixture that has to be built, a second published stack note, a pitfall that has to turn up. Three
`Gate: run` items sit behind one (`#005`, `#006`, `#011`), and each says in its own words that it
has no before-fail and cannot have one until the precondition exists.

The lane stays `run`, because a run is still what will prove them. What the field adds is the thing
that tells you when to look again — without it those three read as neglected rather than waiting,
and they cannot leave `formulated` by any route the states describe.

## Why here and not at the repository root

`process/` is excluded from the `<dist>` mirror, and the board is full of acceptance criteria, model
dispositions and what the harness measures. A hire that read it would pass by knowing the answers.
`build-dist.ps1` enforces the exclusion and deletes a mirror rather than hand back a leaking one —
but the exclusion only covers this path. A board at the repository root would ship to every hire.

For the same reason as everything else on this side: no YAML frontmatter. The header table greps
just as well and matches the rest of the repo.

## Files

`<nnn>-<slug>.md`, cited elsewhere as `#012`. `TEMPLATE.md` is the shape. `board.ps1` renders the
columns — it reads the item files themselves, so there is no index that can drift out of step.

## What this replaced

`process/runs/<run-id>.findings.md` is gone. A run now writes its report and touches item files; the
proposal lives in exactly one place instead of being restated per run and going stale in one of them.
The two findings files already on disk — `alt-a` and `plan-sonnet` — stay as historical records of
runs scored under the old procedure. Both have been read onto the board: `alt-a`'s withdrawal of
`15c` is `#001`, and `plan-sonnet`'s F1/F2/F3 are `#001`, `#002` and `#003`.
