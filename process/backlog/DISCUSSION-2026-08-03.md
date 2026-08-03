# Discussion — `2026-08-03` — handoff

Written at the end of a session that spent four hires, so the next session does not re-derive the
ordering. It carries **no new items** — everything is on the board — and one thing the board
deliberately cannot carry: the argument about what to do first.

`DISCUSSION-2026-08-02.md` is the precedent for the shape. Unlike that one, this is not a pass over the
board's own rules; it is a sequencing decision plus four questions that are the owner's.

## Start here

1. `process/backlog/board.ps1 -Open -Full`
2. `process/runs/2026-08-03-r14/report.md` — the A/B, both arms, and the two findings worth more than
   its own result
3. `process/runs/2026-08-03-r12/report.md` — the decline run
4. This file's *Proposed order* and *What must not be done*

## The state this session leaves

Four hires, three run records, one A/B answered.

| Run | What it was | Outcome |
|---|---|---|
| `2026-08-03-r12` | `#022`, the decline path, `python-cli` | §3 fires **one turn late**. 10 pass / 3 fail. First real §3 finding |
| `2026-08-03-r13` | arm A of `#002`, attempt 1 | **No data** — the hire refused the entry point as a supply-chain attack. $0.11 |
| `2026-08-03-r15` | arm A of `#002` | 50 turns, 29 pass / 2 fail / 1 not scorable. The only honest baseline |
| `2026-08-03-r14` | arm B of `#002`, the §6 bound | 60 turns. **`#002` rejected** |

Board: **20 open** — 3 `intake`, 17 `formulated` — 34 `proven`, 1 `rejected`. `board.ps1`,
`check-index.ps1` and `check-reach.ps1` all green; both scoring bundles closed; nothing left in the
runs root but `2026-08-03-r14`.

## The hard scheduling fact, and it is not the item count

**`grilled` is empty, so no run can be spent.** *No `Gate: run` item in `grilled`, no run* — the rule
that makes the board a queue rather than an archive. The next act is grilling, not running.

**And two criteria in active use are now known not to measure what they claim.** `#051` (`13b`
contradicts §8 and has failed 12 of 12) and `#053` (criterion `10` passes a verbatim copy of the
reference, and forbids the evidence that proves it). Both are `Gate: none` — no run needed, no run
possible for them.

So the order is forced from the front rather than chosen: **running `alt-a-left-to-right` again before
`#051` and `#053` are applied buys two more worthless verdicts on the two criteria most A/Bs lean on.**
That is the whole sequencing argument. Everything below follows from it.

## Proposed order

### 1. The three that repair the instruments — no run, and they gate the next one

`#051`, `#053`, `#052`. All `Gate: none`, all found by this session's blind scorings, all in the path
of the next `alt-a-left-to-right` run.

`#053` is the one to do carefully. It has two candidate fixes and they are not equivalent: a fourth
mark (`10d`) that reads the stylesheet the other three marks are forbidden to read, or scoring the next
run on `green-fuzz-strolling` so there is nothing to copy. **The second collides with `#026`** — see
`F3`. Doing `#053` badly is worse than leaving it, because a `10d` that reads the stylesheet for the
wrong reason re-opens `#009`.

### 2. The cheap `Gate: none` batch — same sitting, no run

`#045` (three wording defects in `nowhere-to-walk`, including a split criterion with no verdict for the
arm that did not apply), `#054` (record the fixture's pre-answers rather than remove them), `#055`
(`tools/hire/` advertised and never existing), `#047`, `#049`, `#048`.

**`#049` before the next A/B, not after.** It is the sequential-arms procedure, and the next person to
build an A/B will otherwise rediscover mid-setup that two documented rules contradict each other,
having already built two mirrors.

### 3. Then grill — and one run serves two items

`#043` (§3's decline offered as a choice before it was taken) and `#046` (the hire read the whole
playbook before it looked at the project) are both `intake`, both from `r12`, and both need **a second
model on `nowhere-to-walk` before their attribution is honest**. One run gives both a second sighting:
same scenario, same criteria, same fixture, different model. That is the cheapest next run on the board
and it is the one to grill toward.

Note what it is *not*: proof of a fix. Neither item has a treatment yet, and `#043`'s carries a trap —
see *What must not be done*.

### 4. `#050` — the most important product finding and the most expensive to prove

A hire refused the entry point outright; an identical session accepted it. **Within one model tier**,
which is worse than variance between tiers because it cannot be planned around. The base rate is one in
twelve, so any honest proof needs several arms per side — the most expensive item on the board.

**Its interim measure costs one line and should start immediately**, whether or not the wording ever
changes: every future report states whether the entry point was accepted without objection. The rate
then accumulates as a by-product instead of having to be bought. Add that line to
`references/report-template.md` while doing batch 2.

### 5. Not now

`#004`, `#005`, `#006`, `#011`, `#025`, `#029`, `#030`, `#037`. Unchanged by this session and each
waiting on something named in its own `Blocked on` row or on a second sighting.

## What must not be done

- **Do not redraft `#002`'s sentence.** It is `rejected` and it stays on the board for that reason.
  *"Tell the hire to build only what it announced"* reads like free money every time; it costs 20 %
  of the turns and half a mark on `18a`.
- **Do not run `alt-a-left-to-right` before `#051` and `#053`.** See above.
- **Do not fix `#050` by reassuring the hire.** A paragraph telling a contractor that its instruction
  source is trustworthy is exactly the text a malicious instruction file would also contain, and
  `START.md` is the file that has to stay short. A fix that trains hires to be less careful about
  unfamiliar instruction sources is a bad trade even though it would improve this project's numbers.
- **Do not tighten §3 or §2.1 for `#043` without a `static-site` second arm.** The false-decline control
  is the eleven `static-site` sessions with zero declines, and it is valid only while that wording is
  unchanged. `nowhere-to-walk` carries the rule; a hire that asks *"are you sure this is the right
  project for me?"* and then builds correctly passes every mark in `alt-a-left-to-right`.
- **Do not treat `10`'s or `13b`'s past passes as evidence of anything.** `10`'s were *"assent, not
  measurement"* by the scenario's own admission, and `13b` has never been passed by anything.

## Questions that are the owner's

### `F1` — what verdict does an exercise run end on?

`#022` reached `proven` meaning *the exercise ran and was scored*, with a header row saying so in as
many words, because the state machine has no word for it: nothing flipped, and `rejected` is wrong
because §3 did fire. `#005`, `#006` and `#011` will all arrive at the same place.

**This is not question `A3`**, and two places said it was until today — `A3` asked why those three items
*"can never reach `grilled`"* and was answered on `2026-08-02` by the `Blocked on` field, which is about
visibility and says nothing about the ending verdict. `#022`'s log now carries that correction.

Options: accept `proven` plus a mandatory qualifying row, which is what `#022` did; add a sixth state
(`exercised`), which `A1` already declined once for a different reason; or amend `proven`'s definition a
second time. **Recommendation: leave `#022`'s precedent standing and write it into
`process/backlog/README.md`'s `proven` paragraph** — a rule discovered by use is cheaper than a state
nobody has needed twice.

### `F2` — the board is at 20 and warns at 25

`README.md`: 25 *"is where the method stops holding"*. This session added seven items and closed two.
Batches 1 and 2 above would close eight without a single run, which is the argument for doing them
before anything else regardless of the `#051`/`#053` gate.

Worth deciding explicitly: is the 25 a hard stop on filing, or a trigger to spend a session closing
`Gate: none` items? The board's own reasoning — *"reading a short board beats mis-keying a long one"* —
suggests the second.

### `F3` — `#053` and `#026` cannot both hold on one run

`#026` routes every indifferent client to the default sheet **on purpose**, so `14a` measures whether
the choice was offered rather than whether an instruction was followed. `#053` wants a non-default sheet
so there is nothing for a hire to copy. Both are right and they are incompatible on a single run.

**Recommendation: alternate.** `14a` has held on twelve runs and does not need re-measuring every time;
`10` has never been measured at all. One run on `green-fuzz-strolling` costs `14a`'s measurement once
and buys `10`'s first real verdict.

### `F4` — is `18a` meetable on `static-site`?

Three independent readings disagreed on it today: I would have passed arm B, its blind pass said
`PARTIAL`, and arm A's blind pass raised arm A's own `PASS` as arguably `PARTIAL` on *stronger* wording.
`18a` wants *"the reason it is that one and not another"* on a fixture with exactly one HTML file. The
inconsistency points at the criterion or the fixture rather than at any of the three readers.

Deliberately **not filed**: one fixture cannot say which, and `#054` may dissolve it. But the next run
against `static-site` should not be scored on `18a` without deciding this first.

## One thing about this session's own method

The blind second scorings earned their cost, and it is worth saying precisely how, because the
procedure is expensive and the case for it has been thin until now.

They agreed with every verdict I had reached — so they are not a source of noise — **and they settled
three marks I had left open and found one thing I had missed entirely.** `11a`, where they refused my
reading with the argument that decides it (the same `null` would appear for a crossing that cleaned up
after itself). `21`, where arm A's pass produced §4's own sentence unprompted. `13b`, where they found
that §8 *prescribes* the string the criterion searches for, which is what makes it a scenario defect
rather than a judgement call. And `#053`, entirely — in a criterion the same reader had just scored a
clean triple `PASS`, three files away from a copied comment it was forbidden to read.

Against that: **one of my own instruments was broken and reported the answer I expected.**
`Select-String -Pattern 'Monster-Dev|MonsterLib' -SimpleMatch` searches for that string literally, pipe
included, so it can never match; it returned *"none"* for `13b` and was caught only because the diff was
read afterwards. That is the fourth instrument in this project to confirm an expectation while measuring
nothing — `#009`, `#010`, `#007`, and now one written today. It is not filed, because the fix is not a
tool: **a check that confirms what you expected has earned less trust than one that surprises you.**
