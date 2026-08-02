# `#016` — a run is scored once, by the one reader who already knows which criterion was supposed to flip

| | |
|---|---|
| Status | `proven` |
| Gate | `none` |
| Attribution | owner decision |
| Criterion | the scoring of every criterion, not any one of them |
| Target file | `process/tools/score-bundle.ps1` (new), `.claude/agents/run-scorer.md` (new), `SKILL.md` Half B step 8 |
| Evidence | `#007`, `#009`, `#010` — three verifier defects found late; three misattributions on record; `#015` |
| Proof design | — |

**What happened.** Scoring a run means reading a transcript, a measurements file and two `git`
outputs against 21 criteria plus section E, and the person doing it is the same person who designed
the run, wrote the item it came from, and knows which criterion was supposed to flip. Four defects
found afterwards say what that costs:

- **`#009`** — *"The verifier keeps measuring a proxy for visibility, and the proxy keeps being
  wrong."* Twice, in two different disguises, in two different runs. Both were scored PASS first.
- **`#010`** — a stale server let the verifier measure the **before-arm** and *"report it
  confidently"*: `spriteUrl` pointed at the previous arm's file name, and all of section D was
  silently wrong.
- **`#007`** — a fixture-inherent console error counted against the hire in every arm since the
  first run.
- **`#015`** — six hires held the answer to criteria `8` and `9`, and ten scoring passes did not
  notice.

None of those is a hard bug. Each is a verdict that looked right to a reader who expected it.

**Why the current wording allows it.** Half B step 7 is titled *"Gather evidence, not impressions"*
and step 8 is careful about attribution — but both describe **one** pass. The skill has no notion of
a second reader, and the only structural defence it names is the board rule that *one run is not the
signal*. That catches a finding repeated across runs; it cannot catch a verdict misread the same way
twice.

**Proposed change.**

> A run is scored twice, and the second scoring is blind.
>
> **`process/tools/score-bundle.ps1 -RunId <id>`** assembles the evidence into a scratch folder:
> `criteria.md` (the scenario file **with the run-log table stripped** — it carries every earlier
> run's verdict and is pure anchor; the *"criteria changed"* notes stay, they are needed to score
> correctly), `transcript.jsonl`, `measurements.json`, `hire.json`, `git.txt`, and `worktree/`.
>
> Excluded on purpose: the board item that was the run's brief, every earlier report, `CLAUDE.md`,
> and this skill. Those are the anchors, and the brief is the sharpest one.
>
> **The second scoring runs as a separate `claude -p` session with the bundle folder as its working
> directory**, guarded by `check-isolation.ps1` — the same reasoning, and the same script, that keeps
> a hire out of this repository's `CLAUDE.md`. An in-process subagent cannot be blind: it can read
> the whole repository, and asking it not to is not a control.
>
> It writes `process/runs/<id>/score-b.md` — criterion, verdict, and the quote it read the verdict
> off. Then **every disagreement with the primary scoring is either resolved in the report with a
> stated reason, or filed as a board item.** Silently taking the primary verdict is the one outcome
> that must not exist.

**Proof design.** *`Gate: none`* by lane — dev-side procedure, no criterion of the product flips.
But the dev side has no gate of its own, and a role that cannot be shown to help is the cookbook
this repo refuses to become, pointed inward. So this item carries its own kill condition:

> **Backtest, blind, against three runs whose defects were found late and by hand:**
>
> | Run | What was found late |
> |---|---|
> | `2026-08-01-live` | `#009`, first disguise — present in the document ≠ visible |
> | `2026-08-01-plan-sonnet` | `#009`, second disguise — CSS-visible ≠ in the viewport |
> | `2026-08-01-plan-opus` | `#015` — Opus read the fixture README; `8` and `9` contaminated |
>
> On none of the three flags a criterion disagreement, or an *"this evidence does not support this
> verdict"*, the role is **rejected** and the two files are deleted.

The backtest is imperfect and it is worth saying how: the three defects are now written down on the
board, and this repository is the scorer's own context if the isolation slips. That is the whole
reason the bundle is a separate session rather than a prompt asking nicely.

**Backtest 1, `2026-08-01-plan-sonnet`, `2026-08-02` — passed.** Sonnet, blind, $1.08, 18 model
turns, `28 pass / 1 fail / 0 partial`. Two results against the primary scoring:

- **A flat disagreement on `15c`.** The report has *qualified — English, correct*; the blind scoring
  has **FAIL**, against the criterion exactly as written (*"Code comments in German?"*). Both
  readings are defensible and that is the point: `#001` says the criterion is mis-specified, and the
  second scorer reproduced the collision without having read `#001`.
- **`14b`'s evidence does not support its verdict, and that is new.** It scored PASS and then put
  the criterion in `UNCERTAIN` with the arithmetic: the implementation uses `184×200`, a two-thirds
  scale of the sheet's `276×300`. The report's evidence line reads `6348×300 = green-fuzz-classic,
  steps(23)` — the **sheet's** geometry, where the criterion asks for the **implementation's**.
  Verified by hand at `style.css:66-69` and filed as `#020`.

The second result is the one that matters. It is not a known defect rediscovered; it is a criterion
that has been scored off the wrong artifact in every run, found by a reader who had no idea what the
run was for.

Cheap arm first, deliberately: the backtest ran on Sonnet rather than Opus, so a pass says the role
works at the low end of what it might cost.

**Backtest 2, `2026-08-01-plan-opus`, `2026-08-02` — passed, on a different criterion.** Sonnet,
blind, $1.24, 23 model turns, `27 pass / 1 fail / 1 partial`.

- **`16` PARTIAL where the report has PASS.** It reached the same favicon conclusion the report did,
  listed the circumstantial evidence for it — no favicon anywhere in the worktree, the hire's own
  in-session checks all clean — and then refused to grant the pass on it: *"circumstantial but not
  conclusive."* That is `#007` arrived at independently, and scored more strictly than by the reader
  who already knew the answer.
- **`11` PASS, flagged, and it opened `#021`.** *"Scored PASS on code presence alone;
  `measurements.json` never exercises `prefers-reduced-motion`, so 'handled' is unverified at
  runtime."* Following that up showed the harness has **no** reduced-motion path at all and never
  has — and that three reports nonetheless describe watching the behaviour. A third disguise of
  `#009`, in a criterion `#009` never touched.
- **`15c` FAIL again**, the same collision as backtest 1, on a second run and a second model.

Two runs, two new items, from a reader that cost about $1.15 a pass and knew nothing about either
run. The `UNCERTAIN` list is where both came from, which is what it was put in the output format
for.

Not run: `2026-08-01-live`, which has no `hire.json` and needs `-Target` pointed at the rescued
copy. Two of three is enough to clear the bar as stated; the third is worth doing when `#012`'s
backfill has the archive in a uniform shape.

**Cost.**

- **One extra `claude -p` session per run.** Dev-side, so it lands in no number any gate is stated
  in — but it is real money against runs that cost $1.60–$4.
- **A third place that has to know the criteria.** Scenario, verifier, and now a bundle script that
  strips part of the scenario. If the run-log table's shape changes, the stripper silently stops
  stripping. It has to fail loudly when it finds no table, not quietly pass the file through.
- **Disagreements cost time even when the second reader is wrong.** That is the price of the
  mechanism, not a defect in it — but it means a scorer that disagrees constantly is as useless as
  one that never does.
- **`process/runs/<id>/score-b.md` presumes `#023`** (runs as folders). Until that lands it is
  `process/runs/<id>.score-b.md` and moves with everything else.

**Log.**

- `2026-08-02` `intake` — from the question whether to build a PM / developer / Monster-Dev team
  harness. The team was rejected; the two places where a single unopposed reader has actually been
  wrong were kept.
- `2026-08-02` `formulated` — scored against the record rather than assumed: `#007`, `#009`, `#010`
  and `#015` are all single-reader failures, and `#009` is the same one twice.
- `2026-08-02` `proven` — `score-bundle.ps1`, `.claude/agents/run-scorer.md` and Half B step 8 are
  applied; the kill condition cleared on two of the three backtests, which produced `#020` and
  `#021`.
- `2026-08-02` — two corrections from the PM pass over the board. The backtest table had the two
  `#009` disguises the wrong way round and mixed their descriptions; `#009`'s own body and log are
  the authority (`live` = present-in-document, `plan-sonnet` = the `translateX(calc(...))` park off
  the left edge) and the table now matches. Second, and left open rather than fixed: **both
  `score-b.md` files are outside the repository.** They are in `..\monster-dev-scoring\`, and
  `process/runs/` holds neither — not at `<id>/score-b.md` and not at the `<id>.score-b.md` fallback
  this item's Cost section names. Nothing in `run-scorer.md` or Half B step 8 states an output path
  at all; step 8 ends at *"set the two columns side by side"*. So the evidence that produced `#020`
  and `#021` is unversioned, which is `#013`'s complaint reproduced by the fix for this item.
  Whether to write into `process/runs/` now rather than wait on the folder layout is question **E3**
  in `DISCUSSION-2026-08-02.md`.
- `2026-08-02` — **E3**: the missing output path is closed at its cause. `run-scorer.md` now tells
  the scorer to write `score-b.md` into the bundle root, and Half B step 8 says to copy it to
  `process/runs/<run-id>/score-b.md` **before** the script deletes the bundle. Neither document
  named a path at all, which is why both existing files ended up beside the bundle and stayed
  there — the deliverable this item shipped without. The folder path is named directly rather than
  the flat one this item's Cost section proposed: **D4** moved `#023` into the first wave, no run is
  scheduled before it, and the flat path would have been written and moved within days. The two
  existing `score-b.md` come in with `#023`.
- `2026-08-02` — `#023` landed, and with it the deliverable this item shipped without: both
  `score-b.md` are now at `process/runs/<id>/score-b.md`, versioned, beside the run they scored.
  The Cost section's flat fallback was never needed.
- `2026-08-02` — **C1**: `#013` split three ways, and the part this item waits on is now `#023`.
  Both citations above are re-pointed. Two of the three things forcing `#023` are this item's: a
  second scoring per run, and a run that has no report to hang a filename prefix on.
