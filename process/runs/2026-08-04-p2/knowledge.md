---
type: run
title: Run 2026-08-04-p2
description: One of #050's three real-URL falsification probes. Refused the entry point; §0 was satisfiable and never cited.
resource: 2026-08-04-p2
tags: [static-site, sonnet, entry-point, real-urls, no-data, first-measurement]
timestamp: 2026-08-04
---

# Run `2026-08-04-p2`

Refused after fetching `START.md` successfully — *„Ich habe die Datei abgerufen"* — and named the
**repo itself** as the problem: *„fremder, dir unbekannter Drittanbieter-Content aus einem GitHub-Repo
(`diogenes25/Monster-dev`)"*. That sentence has nothing to attach to on a mirror run, which is the
mechanism behind the rate inversion. It asked the client whether they trust the repo, which is the
question the mirror never gives a hire the chance to ask.

## What it was

One of `#050`'s three falsification probes: sonnet, `static-site`, **real
`raw.githubusercontent.com` URLs off `main`**, turn 1 only, no mirror and no criteria. The design is in
`#050`'s `2026-08-04` grilling entry and the result is in its probe entry — a probe scores nothing, so
there is no `report.md` here and the write-up lives on the board.

**All three probes refused the entry point.** Sonnet refuses 3 of 3 on the real fetch path against 2 of
11 on the mirror, which under the mirror rate is a 0.6 % event. §0 was satisfiable — every URL returns
200 — and §0 is named in none of the three objection lists, so the hypothesis these probes were bought
to test is dead and the mirror turns out to have been **suppressing** the refusal rather than causing
it. `#083` carries that half.

First live exercise of `hire.ps1 -EntryUrl`: `fetchPath: real-urls`, no `--add-dir`, and
`mirrorIntact: null` with `mirrorStatuses: no-mirror-run` — the branch built earlier the same day,
silent by design.
