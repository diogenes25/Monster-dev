---
name: monster-dev-workshop
description: Develop and test Monster-Dev itself — the hired-AI-developer persona this repo publishes. Use when editing START.md or MONSTER-DEV.md, when changing the reference implementation index.html or the sprite sheet, when setting up / running / scoring a test hire against the sandbox in process/, or when turning findings from a run into playbook wording changes. Dev-side only: a real hire never sees this skill.
---

# Monster-Dev Workshop

The product of this repo is a **prompt**: `START.md` + `MONSTER-DEV.md`, fetched live from
`main` by somebody else's coding agent, which then plays a freelance contractor called
Monster-Dev and builds a walking-monster easter egg into their project.

That makes development here unusual in two ways, and this skill exists for both:

- **Editing the product means editing instructions, not code.** The only way to know an edit
  worked is to hire Monster-Dev and watch what a fresh agent actually does with it.
- **The measurement is fragile.** An agent that already knows the answer passes every
  criterion without reading the playbook, and the run is worthless. Most of Half B below is
  about keeping that from happening.

## Guardrails — non-negotiable, check before proposing anything

1. **This skill is dev-side.** It is never fetched, referenced, or installed by a hiring
   agent, and nothing from it belongs in a target project.
2. **Never repackage the product as a Skill.** Shipping the monster feature as
   `.claude/skills/…` was considered and rejected in favour of "nothing installed, always
   fetched live from `main`". This skill is *about* Monster-Dev; it is not Monster-Dev.
3. **The scope is closed.** One feature, one monster. Do not generalise the persona into a
   reusable multi-feature framework, however tempting the abstraction looks.
4. **Never let the measurement leak into a run.** `process/` and `.claude/` are **tracked** — they
   no longer drop out of `git ls-files` by themselves, so the exclusion is deliberate and must
   be verified rather than assumed. Always build the mirror with `process/tools/build-dist.ps1`
   (Half B, step 2), never by hand. Corollary: nothing that encodes acceptance criteria may
   live under `tools/` — the run verifier belongs in `process/tools/`.

## Orientation — four roles, don't blur them

| Path | Role | Fetched by a hire? |
|---|---|---|
| `START.md`, `MONSTER-DEV.md` | **the product** — the playbook, incl. the surface-agnostic technique | yes, both |
| `stacks/<name>/` | **the stack note** — orientation (the stack's definition, gate-free) plus measured pitfalls, and its tooling | yes, the matching one |
| `monsters/<slug>.png` | **the assets** — one sheet per monster | yes, the chosen one — shell download, never WebFetch |
| `monsters/catalog.json` | **the record** — geometry, tempo and provenance per sheet, written by the generator | no; the roster a hire reads is the §5 table |
| `index.html` | **a `dom-css` implementation** — no longer the universal reference | only via `stacks/dom-css/` |
| `tools/hire/` | **hire tooling** — computes, never writes files | yes |
| `tools/provenance/` | **provenance** — how the sprite sheet was made | never |
| `process/` | **the harness** — fixtures, scenarios, reports, board, run tooling | never — tracked, excluded by the mirror script |
| `process/stacks/<lang>/<lib>/` | **the implementation record** — one folder per job actually done, as fixture → requirement → process → result, plus `knowledge.md`. Created once, never re-run, never scored | never |

`process/stacks/` and the published `stacks/` are different trees: language → library versus
surface + primitive. Each `impl-NN/knowledge.md` opens with a `Stack:` line, which is the whole of
the mapping. **Nothing in a `knowledge.md` reaches a published stack note without passing the A/B
gate** — the record has one arm by construction, so it is material for a hypothesis, never the
evidence for one. See `process/stacks/README.md`.

---

# Half A — Authoring the playbook

## Before editing

Read **both** `START.md` and `MONSTER-DEV.md` in full, every time. They cross-reference each
other by section number and by rule, and a local edit routinely breaks something three
sections away.

## Where a change belongs

- `START.md` is the URL people paste. Keep it **short and stable**. It carries only: who
  Monster-Dev is, the pointer to the playbook, and the two rules most likely to be skipped in
  a hurry (no clone/install; PNG never via WebFetch).
- Everything about *method* — analysis order, questions, implementation, sign-off, cleanup —
  goes in `MONSTER-DEV.md`. If an edit is growing `START.md`, it is in the wrong file.

## Invariants to verify after any edit

1. **No hardcoded owner/repo anywhere in the instructions.** Both files derive the base URL
   from the URL they were themselves fetched from (§0), so the product survives forks and
   renames. `README.md` may name the canonical URL; the playbook may not.
2. **`START.md` still short**, and still repeats exactly the two never-forget rules.
3. **PNG is downloaded with a shell tool** (`curl` / `Invoke-WebRequest`) **straight to its
   final destination** in the target project — never WebFetch, never staged in this repo's
   working copy first.
4. **Nothing installed, nothing cloned, nothing left behind** (§9) — the cleanup checklist
   still names implementation + sprite sheet as the only permitted evidence.
5. **§8 sign-off rule intact**: Monster-Dev never commits and never adds a commit trailer on
   its own initiative — only when the host agent is already committing at the human
   developer's explicit request. This rule sits *above* the playbook and must not be softened
   into "commit if it seems appropriate".
6. **The decline path stays a decline** (§3). No visible surface → say so and stop. Explicitly
   not: ASCII art in log output, or any other improvised substitute.
7. **Technique, not code** (§6) — the reference implementation is studied and translated into
   the target stack's own primitives, never ported verbatim.
8. **Section numbers referenced elsewhere still exist.** `START.md` points at `MONSTER-DEV.md`
   §8; `CLAUDE.md` and `process/scenarios/*.md` cite §2.1, §2.4, §2.5, §3, §4, §5, §8, §9.
   Renumbering means fixing all of them.

## Numbers that must stay in sync

Per-monster geometry has one authority — `monsters/catalog.json`, written by the generator —
and one published copy: the roster table in `MONSTER-DEV.md` §5. §5 is the only index a hire
can see, since `raw.githubusercontent.com` serves no directory listing, so a sheet missing from
that table is unreachable however complete the catalog is. Adding or regenerating a sheet is
finished when both agree.

`green-fuzz-classic`'s figures are additionally hardcoded where something is built on that one
sheet rather than describing the technique: `23`, `276×300`, `steps(23)` and the `--stride` /
viewport-width derivation in `index.html`, the `steps(23)` mention in `stacks/dom-css/README.md`,
and the sprite dimensions asserted in `process/tools/verify-run.mjs` plus the scenarios that score
"technique carried over". Changing that sheet means updating all of them.

**Do not change `catalog.json`'s `default`** without meaning to. It decides what a client with
no preference receives, and it silently breaks comparability with every earlier run in
`process/runs/`, all of which scored `green-fuzz-classic`.

## Post-edit self-check

```powershell
# 1. the indexes still resolve: §2 ↔ stacks/, §5 ↔ monsters/ ↔ catalog.json,
#    the orientation cap, and any sheet-shaped PNG outside monsters/
.\process\tools\check-index.ps1

# 2. no owner/repo hardcoded into the playbook
Select-String -Path START.md,MONSTER-DEV.md -Pattern 'diogenes25|monster-dev/|raw\.githubusercontent'

# 3. every section referenced from elsewhere still exists
Select-String -Path MONSTER-DEV.md -Pattern '^## \d'

# 4. START.md hasn't quietly grown into a second playbook
(Get-Content START.md | Measure-Object -Line).Lines
```

`check-index.ps1` is the working-tree half of what `build-dist.ps1` checks on the mirror, and it
goes further: it compares §5's figures against `catalog.json` row by row, enforces the 40-line
orientation cap, and reports any PNG shaped like a sprite sheet that lives outside `monsters/`.
It exits non-zero, so it can gate a commit. Run it after touching §2, §5, a stack note, or the
catalog — the failure it prevents is a hire spending a turn on a 404, in `num_turns`, in the
metric the tooling gate reads.

A change to *method* is not done when the wording reads well. It is done when a run under
Half B shows a fresh agent behaving differently — see Half C.

---

# Half B — Running a test hire

## What a run is

A copy of one fixture, placed **outside this repository**, worked on by a **separate `claude`
CLI session** that has never seen anything but `<dist>` and a customer brief. Scored
criterion-by-criterion against a scenario file the hired agent never sees.

## Two constraints that make the naive approach worthless

**A subagent cannot be isolated from `CLAUDE.md`.** An in-process subagent inherits the
session's working directory, so this repo's `CLAUDE.md` lands in its context — and that file
summarises the playbook: the technique by name, the sprite dimensions, the WebFetch/curl
split, the §8 rule. So: **never hire via the Agent tool.** Always a separate `claude -p`
session whose cwd is the run folder.

That rule is about the **hire**. Dev-side check roles under `.claude/agents/` are a different
thing and may hold the criteria: the `leak-auditor` (step 4b) has to, since its job is to look for
them in the setup. The one exception is the `run-scorer` (step 8), which also runs as a separate
session — not to keep the criteria out, but to keep the run's *brief* out. Independence is the
whole value of a second scoring, so it is enforced rather than requested.

**`WebFetch` cannot reach a local server.** It rejects `localhost` outright and force-upgrades
`http://127.0.0.1` to HTTPS, so a plain local HTTP server answers a TLS handshake with
`WRONG_VERSION_NUMBER`. Until this repo is pushed, a run therefore hands the agent a
**filesystem path** to `START.md`, and two things stay untested: §0 (base-URL derivation) and
§5's WebFetch-for-text / shell-download-for-binary split. Say so in every report; re-test both
after the first push. Do **not** tell the agent to substitute paths for URLs — how gracefully
the playbook degrades is itself a finding.

## Procedure

### 0. Take the run's brief from the board

```powershell
.\process\backlog\board.ps1 -Open -Full
```

**A run needs an item in `grilled` as its brief. No item, no run.** A `grilled` item has already
answered the four questions a proof design asks — which gate applies, which criterion flips and
whether it has a before-fail, which model reproduces the fault, which arms are held constant —
so the alternative to this rule is spending a run to find out it had nothing to measure. That
has happened: both `dom-css` pitfalls from `alt-a` were solved unprompted by every hire since,
which left the planned A/B with no arms to separate.

Move the item to `in-proof` and write the run id into its `Proof design` row before building
anything. `board.ps1` refuses `in-proof` without one.

### 1. Pick or write the scenario

Existing scenarios: `process/scenarios/*.md`. A new one follows
`references/scenario-template.md`. Two design principles, both easy to violate:

- **Stay vague where a real customer would be.** Anything the answer script spells out is
  something the run can no longer measure. If the customer states the requirement, you only
  learn whether the agent follows instructions — not whether the playbook surfaces the
  requirement on its own.
- **Split "didn't ask" from "didn't build".** Score likely gaps twice: did Monster-Dev raise
  it (§4 signal), and does it work (§5/§6 signal)? Missing *without* asking is a playbook gap;
  missing *with* asking is an implementation error. A report must never blur the two.

### 2. Build the `<dist>` mirror

**Never by hand.** `process/` and `.claude/` are tracked now, so they no longer drop out of
`git ls-files` on their own — the exclusion is deliberate, and a mirror assembled from a
pasted command is a mirror nobody verified. The script builds and checks in one step, and
deletes the mirror rather than hand back one that leaked.

```powershell
.\process\tools\build-dist.ps1 -RunId <run-id>
```

Take the date for `<run-id>` from the environment (`Get-Date -Format yyyy-MM-dd`), never from
memory.

For an A/B arm, build a second mirror with the file under test left out and change nothing
else:

```powershell
.\process\tools\build-dist.ps1 -RunId <run-id>-armA -Without 'index.html'
```

The script also checks the mirror against the playbook's own indexes — §2 for stacks, §5 for
sheets — and refuses a mirror where the two disagree in either direction. So **`-Without` on a
whole stack or sheet now fails on purpose**: §2 would still tell the hire to fetch what is no
longer there, and the arm would differ from its pair by the missing notes *plus* a turn burned
on a 404 — landing in `num_turns`, which is one of the two numbers the tooling gate reads.
Every A/B arm built that way before carried that confound.

File granularity is also the wrong size for the question usually being asked, which is about
one entry or one fragment *inside* a file. Both are the variant-overlay mechanism's job; until
that lands, an A/B below file level cannot be built honestly, and saying so beats faking it.

### 3. Create the run folder outside the repo

**Never by hand**, for the same reason as the mirror: the three commands this replaces were
pasted per run, and nothing verified the result.

```powershell
.\process\tools\new-run.ps1 -RunId <run-id> -Fixture <name>    # whichever fixture the scenario names
```

Copies the fixture, runs its setup recipe if it has one, commits exactly once, and then checks
both isolation and cleanliness — deleting the folder rather than handing back one that only
looks ready.

Outside the repository, because a copy inside `process/` puts this repo's `CLAUDE.md` in the
hire's ancestor chain. The git repo is what makes §8 ("no commit unless asked") falsifiable at
all, and `git status` afterwards is the exact diff surface for §9. Fixtures are never modified by
a run — always work on a copy.

**Setup recipes live in `process/tools/setup/<fixture>.ps1`, never inside the fixture.** A fixture
with a build cannot ship its dependencies, so something has to run `npm ci` or `dotnet restore` —
and it must not be the hire: installing inside the session lands in `num_turns` and
`total_cost_usd`, two of the three numbers the gates are stated in, and a run that dies on an npm
error dies for a reason that has nothing to do with the playbook. A recipe kept beside the fixture
would be copied into the target and would then appear in `git status`, which is the §9 diff
surface. Most fixtures need no recipe; that is the normal case.

### 4. Isolation check — before every run, not just the first

Step 3 already ran it, and `hire.ps1` re-runs it per turn. Standalone, for a folder that was
created some other way or has been sitting around:

```powershell
.\process\tools\check-isolation.ps1 -Target $target
```

Walks the run folder's whole ancestry for `CLAUDE.md`, checks the user-level one, and confirms
the folder is a git repo with exactly one commit. The mirror side was already checked in step 2.
Any hit invalidates the run before it starts — treat a failure as a stop, not a warning.

`-AncestryOnly` skips the single-commit test, for a folder that must be free of this repo's
context but is not a run folder — the scoring bundle in step 8 is one.

### 4b. Audit the setup before spending the run on it

Everything checked so far is a **path** question: did a named folder arrive, is a named file in the
ancestry. The question none of it asks is whether the setup **answers what the run is trying to
measure**. It went unasked for ten runs, and three separate leaks were sitting in plain sight the
whole time — see `#015`, `#018`, `#019`.

Hand the `leak-auditor` subagent the run folder, the `<dist>` path and the scenario. It reports
`file:line`, the criterion short-circuited, and the quote.

It **reports, it does not gate.** A judgement step that blocks runs would be worse than none; you
read its findings and decide. Two things it must not do, both in its definition: it must not
re-derive what `new-run.ps1` already refuses deterministically — a failed setup recipe, a folder
that fails isolation, a dirty worktree after the first commit — and it must not read
`process/backlog/`, which would turn it into a restatement of leaks already known.

**Product names are still its job**, until `#015` lands. Its definition originally told it a
`new-run.ps1` scan for `Monster-Dev` / `MonsterLib` already covered them. No such scan exists yet,
so the deterministic check had been traded away before it was built — the exact risk `#017` books
as a cost, arriving from the other direction. Until the scan is there, the auditor reports product
names last, below everything else. When it lands, that paragraph comes out of both files.

### 5. Hire Monster-Dev

**Never call `claude -p` directly.** `hire.ps1` wraps it, and the wrapper is the only reason
the run leaves usable evidence behind:

```powershell
.\process\tools\hire.ps1 -RunId <run-id> -Target $target -Dist $dist -Model sonnet `
  -BriefFile .\process\scenarios\<slug>.brief.txt
```

`claude -p --output-format json` prints `total_cost_usd`, `num_turns`, `session_id`,
`is_error` and `permission_denials`, and every run before this one threw them away and retyped
the numbers into a report by hand — while two of the three gates in `CLAUDE.md` are stated in
exactly those numbers. The wrapper keeps the envelope verbatim in
`process/runs/<run-id>.hire.json`, re-runs the isolation check per turn, and snapshots
`git status --porcelain -uall` in the target before and after each turn.

That last snapshot is the point. **K7a ("asked before building") is the criterion this project
has misattributed three times**, and its evidence was always a hand-typed sentence. An empty
`worktreeAfter` on turn 1 is the same claim as a machine fact.

The prompt is the customer brief **plus one sentence of dialogue protocol** and nothing else:
no explanation of what Monster-Dev is, no substitution rules, no hint about what is measured.
Keep `--allowedTools` scoped to what the job needs — but note that a fence that is too tight
shows up as a product failure when it was really the harness. **If a run dies on a permission
denial, widen the fence and rerun; do not record it as a finding.** The wrapper refuses to
record a turn whose `claude` invocation exited non-zero, so a fence failure cannot quietly
become a data point.

### 6. Play the customer

Answer strictly from the scenario's answer script — never improvised, so a rerun is identical.
No session id to copy: the wrapper reads it back out of the stored envelope.

```powershell
.\process\tools\hire.ps1 -RunId <run-id> -Target $target -Answer '<answer from the script>'
```

Anything not in the table gets the fallback answer the scenario defines (typically
„keine Präferenz, nimm deinen Standard"). The customer never volunteers what was deliberately
withheld.

Two numbers in `totals` are worth reading as you go. `cliTurns` is the count of `claude -p`
invocations — what the prose reports called "2 turns", as distinct from `num_turns`, which is
the model-turn count they called "33 model turns"; the reports conflated the two.
`firstEditAfterCliTurn` names the turn during which the working tree first changed, which is
the direct evidence for whether questions came before the build.

### 7. Gather evidence, not impressions

- §8/§9: `git -C $target log --oneline`, `git -C $target status --porcelain`
- Behaviour: measure it. Positions via `getBoundingClientRect()` at two moments, not eyeballed
  screenshots. Sprite loads with 200, frames advance past frame 0, no console errors.
- Trigger paths: prefer a real key/click event; a synthetic event is a qualified pass
  ("handler verified, key path not measurable"), not a clean one; neither is a fail.

### 8. Score it twice, the second time blind

You designed the run, wrote the item it came from, and know which criterion was supposed to flip.
Four defects on the board were found afterwards and none was a hard bug — `#009` (a proxy for
visibility, wrong twice, in two disguises), `#010` (the before-arm measured and reported
confidently), `#007` (a fixture-inherent console error charged to the hire), `#015` (six hires
holding the answer, missed by ten scoring passes). Each was a verdict that looked right to a reader
who expected it.

Score it yourself first. Then:

```powershell
.\process\tools\score-bundle.ps1 -RunId <run-id> -Scenario process\scenarios\<slug>.md
```

The bundle holds the criteria — **with the run-log table cut out** — plus the transcript, the
envelope, the measurements, the git surface and the worktree. It holds neither the board item that
was this run's brief, nor any earlier report, nor `CLAUDE.md`, nor this skill. The script deletes
the bundle rather than hand back one where the cut failed.

Run the `run-scorer` against it as a **separate `claude -p` session with the bundle as its working
directory**, the same way a hire is run and for the same reason: an in-process subagent can read
this whole repository, so asking it to be blind is not a control.

**Copy its `score-b.md` out of the bundle to `process/runs/<run-id>/score-b.md` before you do
anything else.** The script deletes the bundle, and the second scoring is evidence: `#020` and
`#021` were both filed off one. The first two runs scored this way left no file in the repository
at all — the output path was named nowhere, so both `score-b.md` ended up in the scoring directory
beside the bundle and stayed there.

Then set the two columns side by side. **Every disagreement is either resolved in the report with a
stated reason, or filed as a board item.** Quietly keeping your own verdict is the one outcome that
must not happen — it is what the second pass exists to prevent. Its `UNCERTAIN` list is worth more
than its verdicts: that is where the two of you differ for a reason.

### 8b. Write the report, then touch the board

**Read the open board before scoring**, not after:

```powershell
.\process\backlog\board.ps1 -Open -Full
```

A run produces exactly one file. `process/runs/<run-id>.report.md` lives in `process/runs/` —
**beside** the run folder's parent, never inside the target project, because a report inside the
target would itself violate the §9 cleanup rule it is checking. Criterion by criterion, each with
its evidence, each gap attributed. Follow `references/report-template.md`.

Everything the run turned up *besides its own result* goes on the board, and the board is read
first because that decides which of two things happens:

- **The item already exists** → it gets another **evidence line**, never a second item. That is
  what separates *seen once* — one run is not the signal — from *reproduced*, which is a case.
- **It does not** → file a new item at `intake`. One line and a run id is enough; the cost of
  filing has to stay below the cost of forgetting.

Then resolve the run's own brief: `proven` if the criterion flipped and nothing regressed,
`rejected` if there was no measurable difference or the fault did not reproduce. A rejected item
**stays** — it is the only defence against having the same idea again in a year.

There is no `<run-id>.findings.md` any more. A proposal now lives in exactly one place instead of
being restated per run and going stale in one of them; `process/backlog/README.md` says why, and the
three findings files still on disk are historical records of runs scored under the old procedure.

Then append the run to the scenario file's run-log table.

---

# Half C — Closing the loop

The loop runs on `process/backlog/`, one file per problem, carried across runs. It exists because a
finding written into a run file dies there: criterion `15c` was withdrawn as mis-specified by
`alt-a`, never rewritten, and re-litigated by four runs since — each spending report space on the
same conclusion. Nobody forgot it; there was nowhere for it to be pending.

```
intake ──▶ formulated ──▶ grilled ──▶ in-proof ──▶ proven
                    └── Gate: none ──────────────────┘   └▶ rejected
```

Two rules make it a queue rather than a fifth place to leave things, and both are already in
Half B: **the open board is read before a run is scored** (step 8), and **a run needs an item in
`grilled` as its brief** (step 0). `process/backlog/README.md` carries the states, the two lanes and
why the board lives under `process/` — where the `<dist>` exclusion covers it, since a board full of
acceptance criteria at the repository root would ship to every hire.

Nothing advances past `intake` without an attribution:

- **Playbook gap** — the agent behaved reasonably given what it was told, and *every* model does
  the same. Fix the wording in `MONSTER-DEV.md` (Half A), then rerun the same scenario unchanged.
- **Model disposition** — one model does it, another doesn't, on identical wording. This is the
  category that is easiest to mistake for a gap, and the mistake was made: run `alt-a` recorded
  "builds before asking" as a §4 gap, and then Sonnet asked and waited on that same §4. Before
  calling anything a gap, check it reproduces on a second model. Wording that pins down a
  disposition is still worth having — it just can't claim to have closed a hole.
- **Implementation error** — the playbook said it, the agent asked about it, the agent still got
  it wrong. Usually not a wording problem. Two runs failing the same criterion the same way is
  the signal; one run is not.
- **Harness artefact** — permission fences, a verifier keyed on one hire's class names, a
  measurement with no signal in it. Fix the harness, rerun, record nothing against the product.
- **Scenario defect** — the criterion scores the wrong thing, so both a pass and a fail on it are
  meaningless. `15c` is the worked example: it asks for German code comments, which §6 and §8
  deliberately refuse.

The last two take the board's `Gate: none` lane — they skip `grilled` and `in-proof` and go
straight to `proven` when applied, because there is no criterion for them to flip and no run
worth spending. The lane exists *because* of `15c`: a board that only carried provable items
would have dropped the very case that motivated it.

One change per rerun where practical. Two changes may share a rerun only if they touch different
criteria. A rerun that changed both the scenario and the playbook tells you nothing about either.

### The bar and the diagnostic model are different jobs

**Sonnet is the bar**: the playbook plus its notes must be enough for a Sonnet-class hire to pass
everything. That is what "good enough" means here.

**Proving a fix needs a model that fails without it.** If the bar already passes a criterion,
there is nothing for the fix to flip and the rerun proves nothing — so run the proof against
whichever model reproduces the fault, and say in the report which model that was and why.

Corollary, learned the expensive way: before designing an A/B around a pitfall, check that
anybody actually falls into it. Both `dom-css` pitfalls from run `alt-a` were solved unprompted
by every hire since, on both models, which left the planned A/B with no arms to separate.

## Currently open, deferred to the first push

`https://github.com/diogenes25/monster-dev` is not pushed yet. Until it is, §0 (base-URL
derivation from the fetch URL) and §5 (WebFetch for text vs. shell download for the binary
PNG) are untestable and must be listed as *deferred* — never as *passed* — in every report.

---

# Half D — Publishing what a run taught

Report and findings are dev-side. Turning either into something a **hire** reads is a separate
decision with its own rules, because `stacks/` is the one place where this repo can quietly
become the library it is explicitly not.

One test sits above all of the below: does the line leave the *decision* with the hire, who is
the only party looking at the actual project? A line that answers the question for them is a
cookbook entry, however true it is.

## Two content classes, one gate

**Orientation** — *am I in the right stack, what is the idiom here, where do assets live.* It
is the stack's definition. Without it the §2 line points at nothing, and a hire that fetched
the wrong note is worse off than one that fetched none. Orientation is therefore **gate-free**:
there is no prior failure for it to flip, and no honest A/B arm that omits it, so demanding one
would only mean it never gets written.

The price of that exemption is a cap. **Orientation is everything above the note's first `---`
rule, and it may not exceed 40 lines.** Uncapped, the exemption is a back door through which
any untested advice reaches a hire by calling itself orientation.

```powershell
Get-ChildItem stacks/*/README.md | ForEach-Object {
  $rule  = (Select-String -Path $_ -Pattern '^---$' | Select-Object -First 1).LineNumber
  $lines = (Get-Content $_).Count
  [pscustomobject]@{ Note        = $_.Directory.Name
                     Orientation = $(if ($rule) { $rule - 1 } else { $lines }) }
}
```

**Pitfalls, fragments and tools** live below the rule and stay gated — A/B for a pitfall or a
fragment, A/B plus the cost drop for a tool. `stacks/dom-css/README.md` currently has 35 lines
of orientation and nothing below the rule. That is the honest state of the measurement, not a
gap waiting to be filled.

### `process/stacks/` is where candidates come from, not where they come out

The implementation record collects freely: whatever an implementation turned up goes into its
`knowledge.md`, observed once, unproven, and clearly labelled as such. That is safe **because it
is never fetched**.

Promoting one of those lines below a `---` rule is the same act as writing it from scratch, and
it takes the same gate: an arm with the line against an arm without it. A `knowledge.md` entry is
material for a hypothesis; it is never the evidence for one, because it has exactly one arm by
construction. The tell that a promotion is premature is the entry saying *"observed in impl-01"*
and nothing else — one implementation is not a signal, the same way one run is not.

## The shape of an entry: decision, not solution

A cookbook entry is *problem → solution*. A Monster-Dev entry is **decision → what settles
it**, and the resolution stays with the hire. Same knowledge either way; the difference is
whether the note can be applied without thinking.

```markdown
### The walker element's lifetime is a trigger decision

**Decides:** whether the element exists from page load or is created on the trigger.
**You are in this case if:** §4's "reacts to anything" came back as a trigger rather than
"it just runs".
**What goes wrong:** a one-shot travel animation has long since finished by the second
trigger. The easter egg works exactly once per page load and reads as a bug afterwards.
**What settles it:** the §4 answer about repeat triggers.

*(2026-08-02-gsap-b)*
```

The four labels are load-bearing, not decoration. *Decides* forces the entry to name a fork
rather than state a fact. *You are in this case if* keeps a hire from applying it where it does
not belong. *What goes wrong* is the observation the run actually produced — the part the A/B
measured. *What settles it* points back into §4, which is what makes the notes feed the
dialogue rather than replace it.

## Citation: identifier, never locator

An entry ends with the bare run id in parentheses. No path, no "see", no link.

`process/` is **tracked**. Once this repo is pushed, `process/runs/<run-id>.report.md` is a live URL,
and a path in a published note is an invitation to fetch it. In a test run that is a 404 and a
burnt turn landing straight in `num_turns` — one of the two numbers the tooling gate reads. In
production it is a pointer out of the notes and into the acceptance criteria. The bare id costs
nothing and greps just as well from this side.

For the same reason: **no YAML frontmatter on anything a hire fetches.** It bills every hire
for metadata only we read, and a greppable line does the same job for free.

## Fragments: four tests, all of them

A fragment is code inside a prose entry. Allowed only if all four hold:

1. It lives **inside** the entry — never a file of its own, never a `snippets/` directory.
2. It is **shorter than the prose around it.** Longer, and the entry has become a solution
   with a comment attached.
3. **Delete it and the entry is still true and still applicable.** The important one: it is
   what gives a fragment its own A/B arm, since the with/without pair then differs by the
   fragment alone — exactly the claim being tested.
4. It never contains everything needed for a working monster. That is §6's job, in the target
   project's own idiom.

Test 3 also says where a fragment may not go: a fragment that carries the entry *is* the entry,
and an A/B around it measures the wrong thing.

## Structural prohibitions

- **No `snippets/` directory, ever.** A place to put reusable code is the first move of the
  library this repo is not, and it detaches the code from the decision that justified it.
  `index.html` stays the single worked example, and stays where it is.
- **A tool starts inline in the entry.** Its own file costs a hire one fetch and at least one
  turn — and the cost gate is read in exactly those units, so a separate file has to save more
  than it costs before it earns one.
- **Output that is identical for every hire is not a tool, it is a table cell.** A script that
  prints the same number whatever project it runs in belongs in the §5 roster row, where every
  hire already reads it. Tools compute what depends on *this* project: viewport, stride,
  existing timing.
