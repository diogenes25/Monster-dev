---
type: run
title: Run 2026-08-03-local-floor
description: Floor spike — can a local open-weight model be hired at all? Not scored, not comparable.
resource: 2026-08-03-local-floor
tags: [local-model, ollama, spike]
timestamp: 2026-08-03
---

# Run `2026-08-03-local-floor`

**Not a scored run, and it may not be quoted as one.** No board item authorised it, so under
`process/backlog/README.md`'s *no item, no run* rule it is not a measurement. It answers one
question that had to be answered before an item could be written honestly: **can a local
open-weight model be hired through this harness at all, and if it fails, is the failure the
model's or the harness's?**

Scenario `alt-a-left-to-right`, fixture `static-site`, model `gemma4:e2b` served by Ollama 0.32.5.
Turn 1's prompt is byte-shaped like `2026-08-03-r15`'s, only the mirror path differs.

## What the harness needed in order to hire a local model: nothing

Ollama 0.32.5 serves an **Anthropic-shaped `/v1/messages`** of its own — the reply is a real
`msg_…` object with `content[].type` and `usage.input_tokens`. So no translating proxy is
involved, and no script in `process/tools/` was edited. The whole chain — `new-run.ps1`,
`build-dist.ps1`, `check-isolation.ps1`, `hire.ps1` — ran unmodified. Two environment variables
did the work:

```
ANTHROPIC_BASE_URL=http://localhost:11434
ANTHROPIC_AUTH_TOKEN=ollama          # any value; it is not checked
```

## The floor: the model, not the harness

Turn 1 — one `Read` of `START.md`, a summary of that document handed back to the customer, stop.
It never fetched `MONSTER-DEV.md`, which `START.md` instructs it to; never introduced itself as
Monster-Dev (§1); never asked an onboarding question (§4); left `worktreeAfter` empty. It answered
a German customer in English. It treated the entry point as **a document to summarise rather than
a role to adopt**.

**Attribution is clean, and that is the only reason this spike is worth its disk space:
`usage.input_tokens` was 47 646 against 65 536 allocated, so nothing was truncated.** The failure
is *model disposition*, not *harness artefact* — the distinction this project has got wrong three
times, and the one a context overflow would have destroyed.

A nudge separated *eager stop condition* from *ceiling*, and it is a ceiling. Given `Ja, bitte leg
los.` the model engaged and then **inverted the roles**: it searched a static HTML fixture for
`.cs` files, and asked the customer to supply the sprite-sheet URLs and the contents of the
project's own files so that it could proceed. It delegated the playbook's steps back to the person
who hired it. At 60 744 tokens it was also at the context ceiling.

**That nudge is not in the scenario's answer script**, and no criterion may be scored off the
turn it produced. It was a diagnostic, chosen because the alternative was to call a ceiling on one
turn's evidence.

**The nudge turn is also not in `hire.json`.** It was issued as a bare `claude -p --resume` while
diagnosing the resume defect below, so the captured record holds turn 1 only. Said here rather
than left for a reader to notice the arithmetic not adding up.

## `qwen2.5:14b-instruct` was ruled out without a run, and the reason is arithmetic

Claude Code's own system prompt measured **53 997 tokens** on a `hello.txt` errand. That model's
context is 32 768. Every turn would be silently truncated, so any failure would be
unattributable — the one thing this spike existed to avoid. It is structurally too small for this
harness regardless of how good it is, and no run was spent on it.

`gemma4:e2b` is the better local hire on every axis that matters here despite being the smaller
model: 131 072 context (65 536 actually allocated on a 6 GB RTX 4050), 100 % GPU resident at
1.8 GB, and 43 s against 195 s on the same errand.

## Two instrument defects this spike walked into

**1. `total_cost_usd` is fabricated for a local model.** This run reports `0.25863` for a turn
that cost nothing but electricity — Claude Code priced local tokens at Anthropic rates. `CLAUDE.md`
states the **tooling gate** in exactly that number. Any local-model A/B needs it replaced by
`duration_ms` and the token counts, which are real. `hire.json` also records `modelFlag` but not
`ANTHROPIC_BASE_URL`, so on disk a local run is indistinguishable from a paid one carrying a
strange model name and a plausible cost.

**2. `hire.ps1` does not re-pass the model on a follow-up turn, so turn 2+ runs on whatever the
launching environment's default is.** `hire.ps1:195` appends `--model` only when `-Model` was
passed, and `-Answer` turns never pass it. `--resume` does **not** restore the session's model: a
resumed *and* a fresh `claude -p` both selected `claude-opus-5[1m]` here, and
`~/.claude/settings.json` carries no `model` key. Against Ollama that is a hard 404 — which is how
it was found.

**The archived record was checked and is clean, and that is the finding rather than the
reassurance.** Every turn in every `hire.json` on disk reports the right model in
`envelope.modelUsage`: `r15`'s turn 2 is `claude-sonnet-5`, `r16`'s is `claude-opus-5`. Two
different correct answers cannot come from one default, so those runs were launched from
environments whose own model matched the `-Model` flag. **The record holds by coincidence, not by
construction** — the same shape as the three scripts that each derived `..` separately and agreed,
which `process/tools/lib/run-root.ps1` exists to have ended. A one-line fix at `hire.ps1:195`
turns the coincidence into a guarantee.

## What a real local-model item would have to settle

- The bar. `CLAUDE.md` sets it at Sonnet and says a Haiku failure is explicitly not a finding; a
  5 B local model is below Haiku, so the rule as written discards this class outright. The rule's
  own reason is that a failure may be incompetence rather than missing knowledge — which an A/B
  holding the model constant across both arms already controls for. What genuinely remains is a
  **floor condition**: the with-notes arm must be able to finish the job, or both arms are zero
  and nothing is measurable. On this evidence `gemma4:e2b` does not meet that floor unaided.
- The context budget, which is a constraint this project has never had. 54 k of system prompt
  against ~65 k of VRAM-bound context leaves ~11 k for the playbook, the files and every tool
  result together. Published knowledge aimed at a local hire has to **spend** that budget to save
  more of it than it costs — a tension that does not exist at Sonnet, where a stack note is merely
  convenient.
