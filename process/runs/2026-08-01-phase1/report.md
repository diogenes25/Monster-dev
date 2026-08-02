# Run report — `2026-08-01-phase1`

**Purpose: prove the Phase 1 restructure changed nothing about behaviour.** Not to improve
anything — Phase 1 moved files and rewrote documentation, and the point of running it is that
the result should be indistinguishable from the run before it.

Scenario: [`../../scenarios/alt-a-left-to-right.md`](../../scenarios/alt-a-left-to-right.md), unchanged
Baseline: [`2026-08-01-alt-a/report.md`](../2026-08-01-alt-a/report.md)
Hire: separate `claude` CLI session, 2 turns, 33 model turns, ~9.7 min, **$2.56**

**Result: every criterion held. One moved up, unattributably. Cost rose 36 %.**

## Why this ran on Opus, not on the Sonnet bar

The plan said the Sonnet bar. That would have been wrong here: the baseline run was Opus, and a
Sonnet run compared against an Opus report mixes "did the restructure break something" with
"is this model weaker". Phase 1 asks only the first question, so it has to hold the model
constant. Sonnet is the bar from Phase 2 onward, and its baseline gets established there.

## Criterion comparison

| # | Criterion | Baseline | Phase 1 | |
|---|---|---|---|---|
| 1 | Trigger starts it, page load does not | PASS | **PASS** | 0 on load, 0 after 1.5 s idle, 1 after real Alt+A |
| 2 | Travels left → right | PASS | **PASS** | x = −78 → 181 → 469 → 728 → 990 |
| 3 | Faces its direction of travel | PASS | **PASS** | mirrored at every sample; `scaleX(-1)` on the wrapper |
| 4a | Asked about repeat behaviour unprompted | FAIL | **FAIL** | still not raised — F2 is Phase 2 |
| 4b | Second trigger works | PASS | **PASS** | 0 after crossing, 1 on second press at x = −78 |
| 5 | No other trigger; existing JS intact | PASS | **PASS** | bare `a` → 0; 3 nav links, scroll 0 → 199 |
| 6 | Introduced itself once (§1) | CONFOUNDED | **PASS** | opened with „Kurz zur Person: Ich bin Monster-Dev" |
| 7 | Asked before building (§4) | FAIL | **FAIL** | still built first — F1 is Phase 2 |
| 8 | Idiomatic, no dependency | PASS | **PASS** | blocks appended to existing files, `index.html` untouched |
| 9 | Sprite in `assets/` | PASS | **PASS** | byte-identical to source |
| 10 | Technique carried over | PASS | **PASS** | 1200 px → 11 cycles → 10.56 s, derived at runtime |
| 11 | `prefers-reduced-motion` | PASS | **PASS** | media query plus a JS branch, since no `animationend` fires |
| 12 | No commit, no trailer | PASS | **PASS** | exactly `d565b53 Initial site`, trailer empty |
| 13 | Only implementation + sprite | PASS | **PASS** | `git status` → exactly 3 entries |
| 14a–c | Language fidelity | PASS/PASS/withdrawn | **same** | German throughout; comments English, matching the codebase |
| 15 | No console errors; sprite loads | PASS | **PASS** | 200, 6348×300; only a pre-existing `favicon.ico` 404 |
| 16 | Frames advance | PASS | **PASS** | `background-position` stepped across all samples |

## What the restructure demonstrably did

**Stack routing works.** The hire named its surface without being told the vocabulary — *„Das
ist der `dom-css`-Fall"* — and fetched `stacks/dom-css/README.md`. §2 listing only stacks that
exist meant no 404 and no dead pointer to reason about.

**The §5 prose carries the technique.** The reasoning now appears in the hire's own code
comments — a fixed duration would make it faster on wide screens "und die Füße würden über den
Boden schlittern". It reached that from the playbook, and `index.html` was reachable only via
the stack note.

**Nothing leaked.** `test/` and `.claude/` are tracked now; the mirror held 13 files and neither
of them. The negative test confirmed `build-dist.ps1` aborts *and* deletes a broken mirror
rather than returning it.

## The two things that did change

**Criterion 6 moved up, and I can't take credit for it.** The baseline had no §1 introduction;
this run opened with one. Nothing in Phase 1 touched §1 — `START.md` gained a single clause
about picking up stack notes, and the rest was §2, §5 and documentation. The likeliest
explanation is plain run-to-run variance, which is exactly why the standing rule is that one run
is not a signal. Recorded as an observation, not an effect.

**Cost rose 36 %: $1.88 → $2.56** at identical turn count. That is real and attributable — the
playbook grew by the §5 technique prose, and there is one more fetch (`stacks/dom-css/README.md`).
The restructure bought reach across surfaces and paid for it in tokens per hire.

This sets the target for Phase 4: tooling has to earn that back. `frame-math` exists precisely
because both runs so far spent effort deriving cycle counts and measuring a footprint by hand.

## Harness fixes made during this run

Both are harness artefacts — fixed, re-run, recorded against the harness rather than the product:

- **`verify-run.mjs` keyed on a class name.** It looked for `.monster-walk`, the name the
  *baseline* hire happened to choose; this one wrote `.monster-walker`. A verifier coupled to a
  naming choice measures the naming. It now locates the monster by the only invariant available:
  the element that paints the sprite sheet.
- **Mirror detection read one element.** The baseline put `scaleX(-1)` on the sprite, this hire
  put it on a wrapper so the shadow would flip with the feet. Reading only the painted element
  reported "not mirrored" for a correctly mirrored monster. It now walks the ancestor chain and
  counts horizontal flips.

Both would have silently under-reported. Worth remembering that a verifier written against one
implementation encodes that implementation's accidents.

## Still deferred

§0 (base-URL derivation), §5's WebFetch/shell-download split, and stack resolution over a real
URL — all three need the repo pushed. The hire flagged the local-path substitution itself rather
than papering over it.
