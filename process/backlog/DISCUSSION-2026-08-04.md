# Discussion — `2026-08-04` — handoff

Written at the end of a session that spent **no hires** and closed seven items, so the next session
does not re-derive the ordering. It carries **one new item** (`#080`, found while editing) and one
thing the board deliberately cannot carry: the argument about what to do first.

`DISCUSSION-2026-08-03.md` is the direct predecessor and most of its *Proposed order* is now spent.
Read this one against it: the sequencing argument has changed shape, because the thing that was
blocking the next run has been removed and two items got **cheaper** rather than closer to done.

## Start here

1. `process/backlog/board.ps1 -Open -Full`
2. `process/runs/2026-08-04-r20/report.md` — `#061` Phase 3, the false-decline control, and the four
   things its blind pass found that the primary had not
3. This file's *The scheduling fact*, *Proposed order* and *What must not be done*
4. `DISCUSSION-2026-08-03.md`'s *What must not be done*, all four bullets of which still hold

## The state this session leaves

Three commits, no hire, seven items closed.

| Commit | What it was |
|---|---|
| `2134aca` | The day's own work, uncommitted until now: `#061` folded into §3 on `main`, `r19` and `r20` brought home, `#074`/`#077`/`#079` closed, `check-hire-records.ps1`, six items filed |
| `5808658` | **Five instrument repairs** — `#071`, `#072`, `#073`, `#076`, `#078`, all `Gate: none`, all in the path of the next run of either scenario |
| `97631b9` | **Two directions nothing was watching** — `#070` part 2 (a scored run in no run log) and `#075` (a hire writing inside the mirror) |

Board: **15 open** — 1 `intake` (`#080`), 14 `formulated` — 62 `proven`, 3 `rejected`. `board.ps1`,
`check-index.ps1` and `check-hire-records.ps1` all green; no scoring bundle on disk; the runs root is
empty.

**And nothing from today is published.** `main` is **22 commits ahead of `origin/main`**, which
includes `#061`'s §3 treatment, both of today's runs and every repair above. That matters for exactly
one reason and it is in *Proposed order* below: a run over real `raw.githubusercontent.com` URLs fetches
what is **pushed**, so today it would fetch a playbook without the treatment. Pushing is outward-facing
and stays a deliberate decision, like `publish-demos.ps1`'s two omissions.

## The scheduling fact has changed, and it is no longer the thing blocking a run

**`grilled` is still empty, so no run can be spent** — *no `Gate: run` item in `grilled`, no run*, and
that is still the rule that makes the board a queue. The next act is still grilling.

What has changed is *why*. On `2026-08-03` the answer to *"can we run?"* was **no, and fixing that
takes a batch of instrument repairs first** — two criteria in active use were known not to measure what
they claimed. That batch is spent. Today the answer is **yes, as soon as something is grilled**, and
the two cheapest candidates each got cheaper today for reasons that are not obvious from their item
files:

- **`#067` needs no dedicated run at all.** Its own log says the cheapest fifth observation is a
  by-product of any future `nowhere-to-walk` run, since criterion `10` is scored on every one. And
  `#071` just made that observation *mechanical*: `10`'s instrument now searches tool **inputs**, so
  the input/result distinction `r18`'s reader had to make by hand is what the criterion says. Grill the
  treatment; do not buy an arm for the observation.
- **`#050` is no longer the most expensive item on the board.** `DISCUSSION-2026-08-03.md` called it
  that, correctly at the time — one refusal in twelve, needing several arms per side. Its own
  `2026-08-04` entries have since narrowed it to **one discriminating arm**: both refusals lead with §0
  having no referent on a mirror run, both are Sonnet on `static-site`, and the only run on record over
  real URLs accepted the entry point without objection. So *one* real-URL Sonnet run on `static-site`
  separates *model disposition* from *run-class artefact*. That is the sharpest cheap question open.

## Proposed order

### 1. `#080` — one character and one decision, no run

The risk-criteria line in `alt-a-left-to-right.md` names `7a`, and there is no `7a`. Do part 1
(`7a` → `7`); leave part 2 (a mechanical criterion-reference check) filed unless a second stale
reference turns up — one instance is not the signal, and the pattern would probably become the fifth
instrument here to measure something other than what it names.

### 2. Grill `#050`'s §0 arm — and decide the push first

It is the cheapest decisive run available, and it is the one item whose answer changes what `START.md`
says. Two conditions, and they are the reason this is a grilling and not a run:

- **A real-URL run reads `main`, so the 22 commits have to be pushed first**, or the arm measures the
  pre-`#061` playbook and is not comparable with anything from today. That is a decision, not a step.
- **A real-URL run is the run class the mirror exclusions do not cover.** `CLAUDE.md` is explicit that
  this is a validity condition rather than a hole: measure the reach with `check-reach.ps1` section D
  and say in the report that you did. It is sharper now than it was on `2026-08-01-live` — `process/`
  on `main` today holds two more scenarios, twenty run records and this file.

**Do not fix `#050` by reassuring the hire.** That bullet from `2026-08-03` is unchanged and is the
most important sentence in either handoff.

### 3. Grill `#067` — the treatment, not the observation

Candidates `A`/`B`/`C` are drafted in the item. **`C` has to be refuted rather than skipped**: if
reading the one available note is genuinely cheap diligence, then three runs have been carrying a fail
that means nothing. Read `#005` and `#006` in the same sitting — a second published stack note changes
`C`'s answer and is the precondition both are blocked on, and it is possible that adding the note is
the cheaper move and `#067` resolves as a side effect. `#066` sits behind this one and may be moot
after it.

### 4. `#064` — the biggest product gap, and its setup is desk work

The playbook never reads the target project's own agent instructions, and a collision with them is
resolved silently. Its fixture, its fixture note and its scenario are **this item's own to write**,
which means the expensive half is a non-run sitting and can happen in parallel with any grilling
above. Nothing is blocked on it and nothing blocks it.

### 5. Not now

`#004`, `#005`, `#006`, `#011`, `#025`, `#029`, `#030`, `#037`, `#057`, `#063`, `#066`. Unchanged by
this session; each waits on something named in its own `Blocked on` row, on a second sighting, or on
an item above it.

## What must not be done

All four bullets of `DISCUSSION-2026-08-03.md`'s list still hold as written — in particular **do not
redraft `#002`'s sentence** and **do not fix `#050` by reassuring the hire**. Its second bullet (*do
not run `alt-a-left-to-right` before `#051` and `#053`*) is spent and is replaced by these:

- **Do not run `alt-a-left-to-right` and compare `20a` across `2026-08-04` without reading the
  boundary.** `index-sonnet` moves on both `20` marks under the landed threshold, in opposite
  directions. Nothing is re-scored; the boundary is in that scenario's Provenance and in `#078`.
- **Do not read a `2026-08-04`-or-later report's silence about the mirror as clean.** The `Mirror` row
  is now part of the report template for the same reason the `Reach` section is: a section left out and
  a section saying *"intact"* read identically, and only one of them means anything was checked. Every
  run before today reads `no-manifest`, which is **not** a pass.
- **Do not state that an edit is verdict-preserving without having read the reports.** Twice in two
  days an item asserted it and was wrong — `#074` on two published cost figures, `#078` on
  `index-sonnet`'s `20a`. Both were written by the same reader who wrote the thing being checked.
- **Do not push as a side effect of anything.** Today's 22 commits are the first time the published
  playbook and the working copy have diverged this far, and the push is what makes `#050`'s arm
  possible — which makes it a decision worth taking on purpose rather than while doing something else.

## Questions that are the owner's

`F1`, `F2` and `F3` from `2026-08-03` are **answered and applied** — `F1` as `#022`'s precedent written
into `process/backlog/README.md`'s `proven` paragraph, `F2` as *25 is a trigger, not a stop*, `F3` as
the alternating monster row, which `r20` then spent and which produced criterion `10`'s first real
verdict. `F4` is still open and unchanged: **is `18a` meetable on a one-page fixture?** It needs a
second fixture, not a third reading, and `#064`'s new fixture may be the cheapest place to find out.

### `G1` — is `#050` one question or two?

Its attribution row now carries a contest inside it: *model disposition* in the header, *run-class
artefact* in the `2026-08-04` log entries. One real-URL arm settles which. **Worth deciding before the
arm is bought:** if it comes back *accepted*, is that a `proven` for a §0 clause nobody wrote, or does
`#050` split into a §0 wording item and a separate within-tier-variance observation that keeps
accumulating one line per report? Recommendation: **split it.** The rate line costs nothing and should
outlive whatever §0 ends up saying.

### `G2` — should the board template require the verdict-preservation check to be *shown*?

Every scenario edit in the `Gate: none` lane can silently stop an A/B comparing, and the two items that
got it wrong this week both *claimed* the check in prose. `#073` and `#078` now quote the transcript
lines they checked against, which is what made `#078`'s claim collapse. The cheap version is one line
in `TEMPLATE.md`: *a scenario edit names the runs it was checked against and quotes what settled each.*
Against it: it taxes every wording fix, and most of them touch marks nothing has ever scored.

### `G3` — how long does `no-manifest` stay acceptable?

`totals.mirrorIntact` is `null` for all fourteen runs on record and will be `true` from the next one.
That is honest, and it means the field says nothing about the series until a run is scored under it. No
action; recorded so nobody later reads fourteen `null`s as fourteen failures.

## Added after the handoff was written — the session continued

Everything above stands as written; this section says what happened next rather than editing the
argument to look prescient. Four things changed, and one of them removes the sentence *"`grilled` is
still empty"* from the top of this file.

- **`#080` is `proven`** and `intake` is empty. Its own claim that the referent was a judgement was
  refuted by the check it demanded of itself: four reports score a mark labelled `7a`, all reading
  *"asked before building"*. Documented by use, not inferred.
- **`#050` is `grilled`** — the first item in that state since `#002`. Six decisions, three of which
  contradict what the item said when it was filed: the arm can only **refute** (an acceptance is worth a
  factor of ~1.14), a branch push swaps one provenance contradiction for another *in the dimension the
  arm measures*, and the discriminator is **three one-turn probes** rather than one scored run, because
  both refusals on record happened in turn 1 for ~`$0.12`. The continuation rule is fixed before the
  first probe. `#050`'s `Blocked on` is now the push.
- **`hire.ps1` can launch a mirror-less run**, which it could not: `-Dist` was a hard requirement and
  `2026-08-01-live` predates the wrapper. `-EntryUrl` plus a recorded `fetchPath` field — `#063`'s
  lesson a second time, because a run class identified only by a *missing* argument would poison
  `mirrorIntact` and section D. **It also surfaced a defect committed earlier the same day**: `#075`'s
  per-turn check binds `-DistPath` as `Mandatory`, so a real-URL run would have died at parameter
  binding after the paid turn and before the record was written. Guarded.
- **The 24 unpushed commits are re-authored to `tjark@onnen.de`**, and `user.email` is set repo-locally.
  19 of them carried the work account's noreply address. Tree hash identical before and after, author
  dates preserved, `pre-reauthor-2026-08-04` left as the anchor.

**And the push is blocked on something no decision here can fix.** It was attempted and **refused with
403**: the only authenticated identity is `Tjark-fiskaltrust` and the repository is `diogenes25`. So
*Proposed order* step 2 is spent, step 2's precondition is not, and `#050` sits in `grilled` waiting on
an interactive `gh auth login` — the one thing in this whole sequence that has to happen outside a
session.

Order from here, unchanged apart from that: resolve the identity and push → the three probes → the
treatment, designed against whatever they say.

## And then `#067` was grilled, run and proven — same day

`#067` did not wait behind the push, because its arm is a mirror run. It went `grilled` →
`in-proof` → `proven` in one sitting, and `2026-08-04-r21` is on record.

- **Candidate `C` was refuted by measurement, not by argument** — the item's own precondition for
  advancing. The note fetch sits alone in its own assistant message in all three untreated runs, so
  *"one wasted turn"* is 1 of `r17`'s 11 and not a figure of speech, and what the turn buys is a
  restatement of the table cell the hire has already read.
- **The attribution was re-settled without buying the fifth observation**, by applying this project's
  own bar rule: Sonnet is 2 of 2 and the one run that takes the branch correctly is Opus, which is
  the asymmetry `CLAUDE.md` names when it says the bar is Sonnet.
- **Criterion `10` flipped**, 13/0/0/1, **both scorings agreeing on every mark** — the first clean
  sweep on that scenario at the bar. `$0.5109` for the run plus `$1.0258` for the blind pass.
- **The cost rationale did not materialise**, and the item's header now says so: 12 model turns
  against `r17`'s 11. What the treatment bought was a **redirection** — zero tool calls into our tree
  against `r17`'s two, six into the client's project against three.
- **The instrument was wrong for the third time**, and the blind pass found it independently from the
  bundle alone. It now names the note *file* rather than the `stacks` directory, and for the first
  time reproduces every recorded verdict on the scenario.
- Two new items: `#081` (a mirrored file names the dev-side skill, and the vocabulary check can only
  see prose *describing* the harness, never a pointer to it — `r17` read that file) and `#082`
  (criterion `4`'s carve-out permits a question and says nothing about the clause that follows it).

**So the board is 15 open — 2 `intake`, 12 `formulated`, 1 `grilled` — and the one `grilled` item is
`#050`, still waiting on the push.** `#064` is now the whole of the non-run work: the biggest product
gap, its fixture and scenario its own to write, blocked on nothing.

## One thing about this session's own method

The seven items closed here were all written by the previous session, and **the two that mattered most
were wrong in their own proposed change** — not in the finding, in the fix.

`#078` said its threshold was verdict-preserving and named the reason. Reading the report it named
showed the reason was false and that the run it cited as a `fail` had made the same deviation as the run
scored `partial`. `#075` said the manifest goes beside the mirror because a file inside `dist/` is
readable by the hire; the run folder is one `ls ..` away and `check-isolation.ps1` ignores files there,
so *beside the mirror* was the leak it was avoiding, one level out.

Neither was findable from the item. Both took reading the thing the item pointed at — a report, and a
check's own source. That is the same lesson as the four instruments that measured something other than
what they named, arriving from the other end: **an item is a claim about files it is not reading.** The
board is a queue, not a specification, and a `Gate: none` item is applied by somebody who checks it
rather than by somebody who executes it.
