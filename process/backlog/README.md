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

**And 25 is a trigger, not a stop** — decided `2026-08-03`, because the warning had no stated
meaning and the obvious reading was the wrong one. Past 25, the next session is spent closing
`Gate: none` items; **nothing is ever blocked from being filed.** The reasoning above is about the
cost of *reading* a long board, and refusing new items to protect the read would trade a finding
for a formatting problem — which is the one thing this folder exists to prevent. The cost of
filing has to stay below the cost of forgetting, and a filing cap inverts that at exactly the
moment the board is busiest.

The evidence that the trigger is the right shape is the session that decided it: the board stood at
20, eight `Gate: none` items were closed without a single run being spent, and it came out at 12.
A `Gate: none` backlog is not pressure on the method — it is the cheapest work available.

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

  **A third way in, discovered by use on `2026-08-03` and settled as a rule rather than a state.**
  Some `Gate: run` items are not proposals at all — they ask whether a path in the playbook works,
  and the run that answers them changes nothing. `#022` is the worked case: §3's decline path had
  no evidence behind it after eleven sessions, `nowhere-to-walk` was built to exercise it, and the
  run found that §3 fires one turn late. Nothing flipped, so `proven` in its usual sense does not
  apply; and `rejected` is plainly wrong, because §3 *did* fire and the exercise did what it was
  built to do.

  Such an item reaches **`proven` plus a mandatory `What proven means here` row** in its header
  table, second row, saying in as many words that the exercise ran and was scored and that nothing
  was flipped — and pointing at the log entry to read before citing the item. `#022` carries one and
  is the template. `#005`, `#006` and `#011` will all arrive here, since each says in its own words
  that it has no before-fail and cannot have one until its precondition exists.

  The row is not enforced by `board.ps1`, deliberately: an ordinary `Gate: run` item that really did
  flip a criterion must not be nagged for a caveat it does not have, and no script can tell the two
  apart. This is a rule for whoever closes the item.

  A sixth state (`exercised`) was considered and declined — `A1` had already declined it once, for
  a different reason — as was amending this paragraph's definition a second time. **A rule
  discovered by use is cheaper than a state nobody has needed twice**, and the qualifying row puts
  the caveat where a reader of the item is standing rather than in a legend.

  This is **not** the question `A3` asked, and two places said it was until `2026-08-03`. `A3`
  asked why `#005`, `#006` and `#011` *"can never reach `grilled`"* and was answered by the
  `Blocked on` field below, which is about visibility and says nothing about the ending verdict.
- **`rejected`** — no measurable difference, or the fault did not reproduce.

Rejected items stay. They are the only defence against having the same idea again in a year.

## `Blocked on`

An optional header field naming what has to happen before this item can move: another item, a
decision, or something that has to exist — a fixture that has to be built, a second published stack
note, a pitfall that has to turn up. Four `Gate: run` items sit behind one (`#005`, `#006`, `#011`,
`#022`), and the first three each say in their own words that they have no before-fail and cannot
have one until the precondition exists.

The lane stays `run`, because a run is still what will prove them. What the field adds is the thing
that tells you when to look again — without it those three read as neglected rather than waiting,
and they cannot leave `formulated` by any route the states describe.

## Why here and not at the repository root

`process/` is excluded from the `<dist>` mirror, and the board is full of acceptance criteria, model
dispositions and what the harness measures. A hire that read it would pass by knowing the answers.
`build-dist.ps1` enforces the exclusion and deletes a mirror rather than hand back a leaking one —
but the exclusion only covers this path. A board at the repository root would ship to every hire.

No YAML frontmatter here — but **not** for the same reason as everything else on this side, and
that sentence used to say otherwise. The published rule is about billing a hire for metadata only
we read, and nothing on this side is ever fetched, so it does not apply. The board's actual reason
is narrower and worth stating plainly: `board.ps1` parses the header table, converting it would
break the parser, and there is no question the board cannot already answer. Since `2026-08-02`
`process/runs/*/knowledge.md` *does* carry frontmatter, so this is now two conventions inside
`process/` rather than one — an accepted cost, recorded as a decision rather than left to be
discovered by whoever notices the inconsistency.

## Files

`<nnn>-<slug>.md`, cited elsewhere as `#012`. `TEMPLATE.md` is the shape. `board.ps1` renders the
columns — it reads the item files themselves, so there is no index that can drift out of step.

## What this replaced

`process/runs/<run-id>/findings.md` is gone. A run now writes its report and touches item files; the
proposal lives in exactly one place instead of being restated per run and going stale in one of them.
The two findings files already on disk — `alt-a` and `plan-sonnet` — stay as historical records of
runs scored under the old procedure. Both have been read onto the board: `alt-a`'s withdrawal of
`15c` is `#001`, and `plan-sonnet`'s F1/F2/F3 are `#001`, `#002` and `#003`.
