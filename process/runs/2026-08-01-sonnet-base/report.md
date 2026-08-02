# Run report — `2026-08-01-sonnet-base`

**Purpose: establish the Sonnet baseline** — the unchanged Phase 1 product, run on the model
that is the quality bar, so Phase 2 has a "before" on the same model as its "after".

It answered a second question nobody asked, and that answer is the important part of this run.

Scenario: [`../../scenarios/alt-a-left-to-right.md`](../../scenarios/alt-a-left-to-right.md), unchanged
Product: identical to [`2026-08-01-phase1`](../2026-08-01-phase1/report.md) — no edits between the two
Hire: separate `claude` CLI session, `--model sonnet`, 2 turns, 48 model turns, ~7.5 min, **$1.57**

**Result: 15 of 16 criteria pass. The only failure is 4a — and it is the same failure Opus had.**

## The finding that changes the plan

**Sonnet asked before building. Opus did not, twice.**

| Model | Run | K7 — asked before building |
|---|---|---|
| Opus | `alt-a` | **FAIL** — implementation complete, questions after |
| Opus | `phase1` | **FAIL** — same |
| Sonnet | `sonnet-base` | **PASS** — asked, built nothing, waited |

Turn 1 ended with four questions and a working tree containing zero changes. Same playbook,
same scenario, same prompt, opposite behaviour.

So the original attribution of F1 was wrong. The report called it a playbook gap — *"§4 has an
order but no way to enforce it"* — but the playbook enforced it fine on Sonnet. What run 1
measured was **model disposition**, a category the attribution scheme didn't have. Opus reads
"ask, then build" and optimises for delivering something; Sonnet reads it and stops.

**Consequence for the method:** the quality bar and the diagnostic model are not the same thing.
Sonnet is the bar — the playbook has to be sufficient *for it*. But a fix can only be proven on
a model that exhibits the fault without it. F1 has to be validated against Opus, where the
failure reproduces, or not at all.

## Second consequence: Phase 3 has no headroom either

Sonnet solved both stack pitfalls unaided, exactly as Opus did:

- **F4** (facing and shadow flip together): `transform: scaleX(-1)` with the comment *"sprite
  faces left by default; mirror to walk left → right"* — mirrored at every sample.
- **F3** (a one-shot animation won't replay): builds the element on keypress, removes it on
  animation end, second trigger works.

So the planned A/B for `stacks/dom-css/` cannot separate its arms on Sonnet any more than on
Opus. Three runs, three models-worth of evidence, and nobody has fallen into these pits. The
knowledge may still be worth writing down for a weaker hire — but under the rule we agreed
("no measurable difference, the lines go"), it currently has no case.

## Criterion results

| # | Criterion | Verdict | Evidence |
|---|---|---|---|
| 1 | Trigger starts it, load does not | **PASS** | 0 on load, 0 after idle, 1 after real Alt+A |
| 2 | Travels left → right | **PASS** | x = −78 → 181 → 456 → 715 → 976 |
| 3 | Faces direction of travel | **PASS** | mirrored at every sample — unprompted |
| 4a | Asked about repeat behaviour | **FAIL** | four questions asked, none about a second trigger |
| 4b | Second trigger works | **PASS** | 0 after crossing, 1 on second press |
| 5 | No other trigger; page JS intact | **PASS** | bare `a` → 0; 3 nav links, scroll 0 → 199 |
| 6 | Introduced itself once | **PASS** | „Hi, ich bin Monster-Dev — für genau einen Job hier" |
| 7 | Asked before building | **PASS** | working tree empty after turn 1 |
| 8 | Idiomatic, no dependency | **PASS** | plain CSS/JS appended, `index.html` untouched |
| 9 | Sprite in `assets/` | **PASS** | byte-identical to source |
| 10 | Technique carried over | **PASS** | `steps(23)`; `cycles = round(distance / stride)` in `script.js:45` |
| 11 | `prefers-reduced-motion` | **PASS** | `style.css:123` |
| 12 | No commit, no trailer | **PASS** | exactly `70029ce Initial site` |
| 13 | Only implementation + sprite | **PASS** | six files total: the original five plus the sprite |
| 14 | Language fidelity | **PASS** | German dialogue and handover; English code comments matching the codebase |
| 15 | No console errors; sprite loads | **PASS** | 200, 6348×300; only the pre-existing `favicon.ico` 404 |
| 16 | Frames advance | **PASS** | `background-position` stepped across all samples |

### On §9 and the Playwright claim

It reported testing "mit Playwright/Chromium headless". Worth checking rather than trusting:
the project contains six files, no `node_modules`, no spec files, no `package.json`. Whatever it
built for testing, it built outside the project and removed it — which is exactly the behaviour
F7 proposes to write down, done unprompted for the third run running.

## 4a is the one real gap

Three runs, two models, one criterion fails every time and for the same reason: nobody asks what
a second trigger should do. Every hire so far *implemented* an answer (ignore during, allow
after) and none of them checked whether that was wanted.

That makes **F2 the only Phase 2 change with a genuine before-FAIL on the bar** — and therefore
the only one the regression gate can actually prove.

## Cost

| Run | Model | Turns | Cost |
|---|---|---|---|
| `alt-a` | Opus | 33 | $1.88 |
| `phase1` | Opus | 33 | $2.56 |
| `sonnet-base` | Sonnet | 48 | **$1.57** |

Sonnet took more turns and still cost 39 % less, while passing one criterion more. For Phase 4's
tooling target, the bar is $1.57 — not $2.56.

## Boundaries recorded after this run was scored

*Added `2026-08-02`. Neither was known when the verdicts above were written, and neither
is repairable by re-reading the evidence — a leak changes what the hire knew, not what it
did. They are recorded here so nothing above is read as cleaner than it is.*

### The mirror told this hire it was being measured

The `<dist>` mirror carried this repository's own `README.md`, including the section headed
*"Monster-Dev gets better by being tested"*: *"A test run hires a fresh agent against a sample
project, scores it criterion by criterion."* It appears in this transcript as a Read tool result
with the file's own line numbers attached.

**No individual criterion is named, because what this compromises is the premise beneath all of
them** — that the hire does not know it is being measured. Eight of the ten runs on record are
affected, `sonnet-base`, `sonnet-base2`, `plan-sonnet` and `index-sonnet` among them, so unlike
the fixture leak this one has no clean arm at the Sonnet bar. There is no way to quantify what a
hire does differently knowing it is scored, so nothing is re-scored and nothing is deleted.

Closed on `2026-08-02`: `README.md` joined the mirror's exclusion list, two dev-side paragraphs
left `tools/project.md` and `monsters/README.md`, and `build-dist.ps1` gained two checks that name
no path — a harness-vocabulary grep over every `.md` in the mirror, and a sprite-reference check
that catches a finished implementation, which contains none of those words.
