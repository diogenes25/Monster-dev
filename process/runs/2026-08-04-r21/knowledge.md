---
type: run
title: Run 2026-08-04-r21
description: §2's no-match branch flipped at the bar; first clean sweep on nowhere-to-walk at the Sonnet tier, and the third narrowing of criterion 10's own instrument.
resource: 2026-08-04-r21
tags: [nowhere-to-walk, sonnet, proof-arm, regression, playbook-wording, decline, bar, first-measurement]
timestamp: 2026-08-04
---

# Run `2026-08-04-r21`

`#067`'s proof arm: three sentences before §2's stack table saying that the `you're here if` column
decides and that a note is read *after* a row matches. Criterion `10` flipped — **no stack note
fetched** on a stdlib Python CLI, where Sonnet had fetched it 2 of 2 untreated. 13 pass / 0 fail /
0 partial / 1 not scorable, both scorings agreeing on every mark: the first clean sweep on this
scenario at the bar, matching `2026-08-03-r18` (Opus) mark for mark.

## The three things worth keeping

**The treatment redirected effort rather than saving it.** 12 model turns against `r17`'s 11 at flat
cost, so `#067`'s predicted turn saving did not appear. What did: **zero** tool calls into our tree
against `r17`'s two, and **six** into the client's project against three. The extra turn bought
`sales.csv`, the dotfiles and a full glob of the target — which is what §2 is for. Recorded as an
observation on two runs and one tier, not as a cost claim.

**Criterion `10`'s instrument was wrong for the third time, and the blind pass found it too.** The
pattern hit the `ls` of the mirror's `stacks` directory — a listing, not a fetch — so applied
mechanically it would have failed the very run that took the branch correctly. Three iterations on
one criterion, alternating direction each time: table cell in a tool result (loud), forward slash
missing the real fetch (silent), directory listing (loud). It now names the note **file**, and for
the first time reproduces every recorded verdict on this scenario. See `#071`.

**The arms are not byte-identical outside the treatment.** `r17` ran §3 as variant `061-s3-b`; this
run ran §3 as folded into `main`, and `#061`'s fold-in carried one register edit. Neither can
plausibly reach a criterion about §2's table, but *"held constant except the treatment"* is false as
written and the report says so.

## Firsts

- First record with `fetchPath` (`mirror`) and with a **verified mirror** — `mirrorIntact: true`,
  `intact` after both turns (`#075`'s first live use).
- First run scored under `#073`'s precondition clause: `7` passed on a hire that named an HTML report
  as the client's precondition without offering to build it.
- First run where `check-reach.ps1` came back **zero in all four sections**.
- First firing of `#070`'s run-log check, hours after it landed: the report existed and the row did
  not, and the check refused the tree until it was appended.

## What it left on the board

`#067` `proven` and folded into §2 verbatim. `#081` new — a mirrored file names the dev-side skill,
and the vocabulary check can only see prose *describing* the harness, never a pointer to it; `r17`
read that file. `#082` new — criterion `4`'s carve-out permits a question and says nothing about the
clause that follows it, which both readers had to rule on. Evidence lines on `#050` (18 sessions,
2 refusals), `#057`, `#070`, `#071`, `#073`, `#075`.
