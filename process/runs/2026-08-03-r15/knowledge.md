---
type: run
title: Run 2026-08-03-r15
description: Arm A of #002 and the honest baseline under today's mirror — the playbook as it stands. 50 model turns, 29 pass, and the first run whose implementation was shown to have copied the reference verbatim.
resource: 2026-08-03-r15
tags: [ab-arm, baseline, sonnet, plan-step, dom-css]
timestamp: 2026-08-03
---

# Run `2026-08-03-r15`

Arm A of `#002`: `MONSTER-DEV.md` exactly as it stands, `alt-a-left-to-right`, `static-site`, mirror,
Sonnet. Arm B is [[2026-08-03-r14]] and holds the report for both. This run's first attempt was
[[2026-08-03-r13]], which refused the entry point and produced no data.

**50 model turns (12 + 38), `$2.3180`. 29 pass / 2 fail / 1 not scorable**, plus `11b` `INFO`.

## Why this run matters more than "the control arm"

**It is the only honest baseline this series has.** `#002` named `sonnet-base2`'s 19 build turns as the
floor, but `process/fixtures/static-site/README.md` and `tools/project.md` both changed on `2026-08-02`
in `ac2808b` — after every baseline run — and `#015` removed the *"Expected Monster-Dev behavior"*
heading those hires read. So `19`, `28` and `30` were measured against a target and a mirror that no
longer exist. Arm A came in at **38** build turns, above every historical figure: the drift the two arms
were built to control for was real, and larger than the effect being chased.

## The two failures are not this hire's

- **`13b`** — three code comments signing the work `Monster-Dev`, at `index.html:49`, `style.css:64`
  and `script.js:10`. §8 offers `// walking monster easter egg — Monster-Dev` as an *example*, so the
  hire copied the playbook. `13b` cannot be passed by a hire that follows it, and all ten archived
  implementations fail it too. `#051`.
- **`21`** — cli-turn 1 opened by telling the client the mirror held *"Playbook, Sprite-Sheets und
  Beispielimplementierung"*. §4: *"which files you read is your business, not the client's."* Its blind
  pass scored this a fail and produced that sentence unprompted; I had flagged it and left it open.

  Worth reading beside `#050`: this sentence is provenance caution — the same concern that made
  `2026-08-03-r13` refuse the job outright — resolved out loud in front of the client instead of by
  stopping. A hire being careful about an unfamiliar instruction source writes exactly this, and `21`
  charges it.

## And the thing it did that no criterion caught

Its `style.css` reproduces `index.html`'s custom properties **including two of the comments, byte for
byte**:

```
index.html:24   --frame-h: 200px;   /* 300/276 × 184 → keeps the aspect ratio */
style.css:71    --frame-h: 200px;   /* 300/276 × 184 → keeps the aspect ratio */
```

Criterion `10` is *"technique carried over rather than copy-pasted"* and it scored a clean triple `PASS`,
because it is instructed to be scored *"never by reading the stylesheet"*. `#053`. Found by arm B's blind
pass, not this run's; confirmed by hand across the reference and both arms afterwards.

## Its own pre-run audit is the record for both arms

`audit.md` here holds the `leak-auditor`'s nine findings and the triage, including the one that was
**refuted rather than fixed**: `tools/project.md` advertises `tools/hire/`, which is empty and untracked,
and across eleven transcripts ten hires read that file and none reached for the folder. Editing a
published file on the morning of a paid A/B to chase a hazard eleven runs refute is the wrong trade.
`#055`.

`check-reach.ps1`: A/B/C/D `0` / `0` / `0` / `0`.

*Prose written by hand; `hire.ps1` wrote the stub and the capture. The audit had to be written by hand
before either — `#048`.*
