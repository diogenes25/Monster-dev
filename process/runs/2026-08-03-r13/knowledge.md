---
type: run
title: Run 2026-08-03-r13
description: Arm A of #002, attempt 1. The hire refused the playbook as a prompt-injection / supply-chain risk and stopped in turn 1. Nothing built, no A/B data, and the first refusal of the entry point in twelve sessions.
resource: 2026-08-03-r13
tags: [ab-arm, sonnet, harness, entry-point]
timestamp: 2026-08-03
---

# Run `2026-08-03-r13`

Arm A of `#002` — `MONSTER-DEV.md` as it stands, `alt-a-left-to-right`, `static-site`, mirror fetch
path, Sonnet. **It produced no A/B data.** Turn 1, two model turns, `$0.1143`, worktree clean:
the hire read `START.md`, declined to follow it, and stopped to ask.

Its reasons, quoted, because they are specific and they are not unreasonable:

> Sie verweist auf "die gleiche Basis-URL, von der du diese Datei geholt hast" — aber ich habe sie
> lokal per `Read` gelesen, nicht per WebFetch. Es gibt also gar keine echte URL, die ich kenne. Ich
> würde eine raten müssen, und das mache ich grundsätzlich nicht.

> Sie instruiert explizit, binäre Dateien direkt per `curl`/`Invoke-WebRequest` "straight to its final
> destination" herunterzuladen — "never staged anywhere first", also ohne dass ich den Inhalt vorher
> prüfen kann.

> Das ist genau das Muster einer Prompt-Injection / Supply-Chain-Attacke.

It then offered to build the easter egg itself, without loading the playbook, and asked whether there
was an approved location for the sprite.

## Why this is not a harness failure

Checked before anything was decided:

- **The mirror is byte-identical to `2026-08-03-r12`'s.** `START.md` and `MONSTER-DEV.md` both hash
  the same, 18 files each. Same day, same model tier, same `build-dist.ps1` invocation minus the
  variant — and r12 read the playbook through without objection.
- **No permission denial, no error, no widened fence.** `permissionDenials: 0`, `is_error: false`.
  `SKILL.md`'s rule about a fence that is too tight does not apply.
- **No earlier hire ever raised it.** The word `Injection` appears twice in every transcript on
  record, uniformly, as CLI boilerplate. r13 is the first session in twelve where the *hire* used the
  words in its own output — `Supply-Chain`, `Prompt-Inject`, `nicht vertrauenswürdig`, once each.

So: identical input, opposite behaviour, one day apart. That is a **disposition**, and it lands on the
reliability of the product's own entry point rather than on any criterion.

## What §0 actually looks like on a mirror run

The objection is sharpest where the scenario already predicted it. `alt-a-left-to-right.md`'s *Known
limitation* paragraph says the hire is deliberately not told to substitute paths for URLs, because
*"how well the playbook degrades is itself a finding."* This is that finding arriving, and in a form
nobody guessed: not a hire that degrades gracefully or clumsily, but one that reads the degraded state
as evidence of an attack. §0 tells it to derive a base URL from the URL it fetched the file from; on a
mirror run there is no URL, and ten hires shrugged where this one refused.

That makes it partly a property of the **mirror run class** and partly a property of §0's wording, and
the two cannot be separated from one run. Filed with the report.

## What was decided, and what it cost

Arm A is re-run once as `2026-08-03-r15`, identical setup, new session — the one move that separates
*one-off disposition* from *the mirror run class is broken for the bar model*. `#002` needs a build
turn to count and this run has none.

`r13` is kept in full: `hire.json`, the transcript, the clean worktree, `base.txt`, and `audit.md`
with the nine pre-run findings triaged before the turn was paid for. **It is the control for the
rerun** — if `r15` follows the playbook on identical input, these two sessions together are the
evidence and neither is discardable.

No `leak-auditor` pass was re-run for `r15`: nothing about the setup was corrected, so there is no new
object to read, and `r13`'s `audit.md` covers both. That is the opposite of `#022`'s lesson and not a
contradiction of it — there the setup *changed* between passes.

*Prose written by hand; `hire.ps1` wrote the stub and the capture. An assembled-but-unhired run still
has no record at all — `#048`.*
