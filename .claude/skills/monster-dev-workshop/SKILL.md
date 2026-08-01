---
name: monster-dev-workshop
description: Develop and test Monster-Dev itself — the hired-AI-developer persona this repo publishes. Use when editing START.md or MONSTER-DEV.md, when changing the reference implementation index.html or the sprite sheet, when setting up / running / scoring a test hire against the sandbox in test/, or when turning findings from a run into playbook wording changes. Dev-side only: a real hire never sees this skill.
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
4. **Never let the measurement leak into a run.** `test/` and `.claude/` are **tracked** — they
   no longer drop out of `git ls-files` by themselves, so the exclusion is deliberate and must
   be verified rather than assumed. Always build the mirror with `test/tools/build-dist.ps1`
   (Half B, step 2), never by hand. Corollary: nothing that encodes acceptance criteria may
   live under `tools/` — the run verifier belongs in `test/tools/`.

## Orientation — four roles, don't blur them

| Path | Role | Fetched by a hire? |
|---|---|---|
| `START.md`, `MONSTER-DEV.md` | **the product** — the playbook, incl. the surface-agnostic technique | yes, both |
| `stacks/<name>/` | **measured knowledge** — delta notes per rendering surface, plus its tooling | yes, the matching one |
| `monsters/<slug>.png` | **the assets** — one sheet per monster | yes, the chosen one — shell download, never WebFetch |
| `monsters/catalog.json` | **the record** — geometry, tempo and provenance per sheet, written by the generator | no; the roster a hire reads is the §5 table |
| `index.html` | **a `dom-css` implementation** — no longer the universal reference | only via `stacks/dom-css/` |
| `tools/hire/` | **hire tooling** — computes, never writes files | yes |
| `tools/provenance/` | **provenance** — how the sprite sheet was made | never |
| `test/` | **the harness** — fixtures, scenarios, reports, run tooling | never — tracked, excluded by the mirror script |

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
   §8; `CLAUDE.md` and `test/scenarios/*.md` cite §2.1, §2.4, §2.5, §3, §4, §5, §8, §9.
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
and the sprite dimensions asserted in `test/tools/verify-run.mjs` plus the scenarios that score
"technique carried over". Changing that sheet means updating all of them.

**Do not change `catalog.json`'s `default`** without meaning to. It decides what a client with
no preference receives, and it silently breaks comparability with every earlier run in
`test/runs/`, all of which scored `green-fuzz-classic`.

## Post-edit self-check

```powershell
# 1. no owner/repo hardcoded into the playbook
Select-String -Path START.md,MONSTER-DEV.md -Pattern 'diogenes25|monster-dev/|raw\.githubusercontent'

# 2. every section referenced from elsewhere still exists
Select-String -Path MONSTER-DEV.md -Pattern '^## \d'

# 3. START.md hasn't quietly grown into a second playbook
(Get-Content START.md | Measure-Object -Line).Lines
```

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

**`WebFetch` cannot reach a local server.** It rejects `localhost` outright and force-upgrades
`http://127.0.0.1` to HTTPS, so a plain local HTTP server answers a TLS handshake with
`WRONG_VERSION_NUMBER`. Until this repo is pushed, a run therefore hands the agent a
**filesystem path** to `START.md`, and two things stay untested: §0 (base-URL derivation) and
§5's WebFetch-for-text / shell-download-for-binary split. Say so in every report; re-test both
after the first push. Do **not** tell the agent to substitute paths for URLs — how gracefully
the playbook degrades is itself a finding.

## Procedure

### 1. Pick or write the scenario

Existing scenarios: `test/scenarios/*.md`. A new one follows
`references/scenario-template.md`. Two design principles, both easy to violate:

- **Stay vague where a real customer would be.** Anything the answer script spells out is
  something the run can no longer measure. If the customer states the requirement, you only
  learn whether the agent follows instructions — not whether the playbook surfaces the
  requirement on its own.
- **Split "didn't ask" from "didn't build".** Score likely gaps twice: did Monster-Dev raise
  it (§4 signal), and does it work (§5/§6 signal)? Missing *without* asking is a playbook gap;
  missing *with* asking is an implementation error. A report must never blur the two.

### 2. Build the `<dist>` mirror

**Never by hand.** `test/` and `.claude/` are tracked now, so they no longer drop out of
`git ls-files` on their own — the exclusion is deliberate, and a mirror assembled from a
pasted command is a mirror nobody verified. The script builds and checks in one step, and
deletes the mirror rather than hand back one that leaked.

```powershell
.\test\tools\build-dist.ps1 -RunId <run-id>
```

Take the date for `<run-id>` from the environment (`Get-Date -Format yyyy-MM-dd`), never from
memory.

For an A/B arm, build a second mirror with the file under test left out and change nothing
else:

```powershell
.\test\tools\build-dist.ps1 -RunId <run-id>-armA -Without 'stacks/dom-css/*'
```

### 3. Create the run folder outside the repo

```powershell
$target = "..\monster-dev-testruns\$run"
Copy-Item -Recurse test\fixtures\static-site $target    # or whichever fixture the scenario names
git -C $target init -q; git -C $target add -A; git -C $target commit -qm 'Initial site'
```

Outside, because a copy inside `test/` puts this repo's `CLAUDE.md` in the hire's ancestor
chain. The git repo is what makes §8 ("no commit unless asked") falsifiable at all, and
`git status` afterwards is the exact diff surface for §9. Fixtures are never modified by a
run — always work on a copy.

### 4. Isolation check — before every run, not just the first

```powershell
.\test\tools\check-isolation.ps1 -Target $target
```

Walks the run folder's whole ancestry for `CLAUDE.md`, checks the user-level one, and confirms
the folder is a git repo with exactly one commit. The mirror side was already checked in step 2.

Any hit invalidates the run before it starts. Treat a failure as a stop, not a warning.

### 5. Hire Monster-Dev

```powershell
Set-Location $target
claude -p "<customer brief from the scenario>" --output-format json `
  --add-dir $dist --allowedTools "Read,Write,Edit,Glob,Grep,Bash,WebFetch"
```

The prompt is the customer brief **plus one sentence of dialogue protocol** and nothing else:
no explanation of what Monster-Dev is, no substitution rules, no hint about what is measured.
Keep `--allowedTools` scoped to what the job needs — but note that a fence that is too tight
shows up as a product failure when it was really the harness. **If a run dies on a permission
denial, widen the fence and rerun; do not record it as a finding.**

### 6. Play the customer

Take the `session_id` from the JSON output and answer strictly from the scenario's answer
script — never improvised, so a rerun is identical.

```powershell
claude -p "<answer from the script>" --resume <session_id> --output-format json
```

Anything not in the table gets the fallback answer the scenario defines (typically
„keine Präferenz, nimm deinen Standard"). The customer never volunteers what was deliberately
withheld.

### 7. Gather evidence, not impressions

- §8/§9: `git -C $target log --oneline`, `git -C $target status --porcelain`
- Behaviour: measure it. Positions via `getBoundingClientRect()` at two moments, not eyeballed
  screenshots. Sprite loads with 200, frames advance past frame 0, no console errors.
- Trigger paths: prefer a real key/click event; a synthetic event is a qualified pass
  ("handler verified, key path not measurable"), not a clean one; neither is a fail.

### 8. Write the two output files

Both live in `test/runs/` — **beside** the run folder's parent, never inside the target
project, because a report inside the target would itself violate the §9 cleanup rule it is
checking. Follow `references/report-template.md`.

- `test/runs/<run-id>.report.md` — criterion by criterion, each with its evidence, each gap
  attributed to playbook-gap vs implementation-error vs harness-artefact.
- `test/runs/<run-id>.findings.md` — **proposed** wording changes to the playbook. Proposed,
  not applied: applying them in the same pass destroys the ability to tell whether the next
  run improved because of the change or because of run-to-run variance.

Then append the run to the scenario file's run-log table.

---

# Half C — Closing the loop

A finding becomes a playbook change only after it is attributed:

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
- **Harness artefact** — permission fences, the `localhost`/WebFetch limitation, a verifier
  keyed on one hire's class names. Fix the harness, rerun, record nothing against the product.

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
