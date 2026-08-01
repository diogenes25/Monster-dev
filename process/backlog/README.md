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
- **A run needs an item in `grilled` as its brief.** No item, no run. A board that nothing depends
  on is an archive.

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
- **`none`** — harness bug, scenario defect, stale documentation. Skips `grilled` and `in-proof` and
  goes straight to `proven` when applied. Half C already says this about harness artefacts: *"fix
  the harness, rerun, record nothing against the product."*

The lane exists because of `15c` itself. It is a scenario defect — there is no criterion for it to
flip and no run worth spending on it. A board that only carried provable items would have dropped
the very case that motivated it.

## The five states

```
intake ──▶ formulated ──▶ grilled ──▶ in-proof ──▶ proven
                    └── Gate: none ──────────────────┘   └▶ rejected
```

- **`intake`** — one line and a run id. Nothing more is required on purpose: the cost of filing has
  to stay below the cost of forgetting.
- **`formulated`** — what happened, which file would change, and the **attribution** from Half C:
  *playbook gap* / *model disposition* / *implementation error* / *harness artefact* / *scenario
  defect*. Nothing advances without one; this project has misattributed three times.
- **`grilled`** — the change, spelled out, **plus** its proof design, which answers four questions:
  which gate from `CLAUDE.md` applies; which criterion flips and whether it has a before-fail on
  record; which model reproduces the fault (Sonnet is the bar, but proving a fix needs a model that
  fails without it); which arms, and what is held constant.
- **`in-proof`** — a run id is assigned.
- **`proven`** — the criterion flipped, nothing regressed, the change is applied.
- **`rejected`** — no measurable difference, or the fault did not reproduce.

Rejected items stay. They are the only defence against having the same idea again in a year.

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
