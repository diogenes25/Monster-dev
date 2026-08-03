# `#038` — the bundle explains a missing verifier in one scenario's criterion numbers, and the next run has no verifier by design

| | |
|---|---|
| Status | `proven` |
| Gate | `none` |
| Attribution | harness artefact |
| Criterion | none — it corrupts the *second* scoring of whatever criteria a run has |
| Target file | `process/tools/score-bundle.ps1` (the `$missing` strings, `:126-142` and `:186-190`) |
| Evidence | found `2026-08-03` while writing `nowhere-to-walk.md`; no run has hit it, because every run so far had a `measurements.json` |
| Blocked on | nothing |
| Proof design | — |

**What happened.** `score-bundle.ps1` handles an absent `measurements.json`, `midwalk.png` or
transcript gracefully — it writes a `MISSING.md` into the bundle telling the blind scorer what it
cannot settle. That design is right and it is the reason the defect is worth filing rather than
shrugging at: the sentences it writes are **hardcoded to `alt-a-left-to-right.md`**.

```
'No `measurements.json`. The whole of section D is measured from it and cannot be'
'scored from what is here. Record those criteria as NOT SCORABLE, not as failures.'
```

```
'criteria 6, 7, 14a, 15a, 15b and the whole of section E — cannot be scored from what is here.'
```

Section letters and criterion numbers are **scenario-local** — `process/backlog/README.md` says so
of the board and the scenarios say so of themselves — and the script states them as if there were
one scenario. There has been one, which is why nothing has hit it.

**`nowhere-to-walk` hits all three at once.** It is a decline run: `verify-run.mjs` drives a page
and there is no page, so `measurements.json` and `midwalk.png` are absent **by design and not by
accident**. The bundle would then tell a blind scorer, in the file whose whole job is to say what
is missing:

- that *"the whole of section D"* is unscorable — section D there is language fidelity, one
  criterion, settled entirely from the transcript;
- to score the visual marks *"from `measurements.json` alone"*, a file that is not in the bundle
  and never will be;
- and, if the transcript ever fails to resolve, that criteria `6`, `7`, `14a`, `15a` and `15b`
  are lost — numbers that mean something else in that scenario, and `14a` does not exist in it.

A second reader who is deliberately given no context has no way to notice that the note is about a
different run. **The bundle would be internally consistent and wrong**, which is worse than a
bundle that is obviously incomplete, and it corrupts the one control this project has against a
single unopposed reader.

**Why the current wording allows it.** The same reason as `#027`, one layer out. The script was
written while one scenario existed, and it names what it happens to know instead of asking the
scenario. `criteria.md` is already in the bundle and already carries the section letters — the
script copies it and then contradicts it.

**Proposed change.** Stop naming criteria. The script does not know them and does not need to:

> Say what artifact is absent and what class of question it settles — *"no `measurements.json`:
> anything a headless browser would have measured cannot be settled from this bundle"* — and let
> the scorer map that onto the criteria in `criteria.md`, which it reads in full first anyway
> (`run-scorer.md`: *"Read `criteria.md` in full before opening anything else"*). That is the
> instrument-naming rule from `#027` applied in the other direction: a criterion names its
> artifact, so an absent artifact does not have to name its criteria.
>
> One sentence more, and it is the one that matters here: **absent is not the same as missing.**
> Where a scenario says an artifact is not produced by that run at all, the note should not read
> as damage. Cheapest honest version is a `-NoVerifier` switch that swaps the wording, set by
> whoever builds the bundle; deriving it from the scenario text would be guessing.

**Proof design.** *`Gate: none`.* A harness artefact — fix it, and the demonstration is a bundle
built for a run with no `measurements.json` whose `MISSING.md` names no criterion. It cannot be
demonstrated properly until `#022` produces such a run, so the fix and its check may land apart;
say which happened.

**Cost.** Small, and one trap: it is tempting to make the script parse the scenario for section
letters. That is a second index of the criteria, drifting against the first, and
`process/backlog/README.md` already argues the general case — *"there is no index that can drift
out of step"* is a property worth keeping.

**Log.**

- `2026-08-03` `formulated` — found by checking whether `score-bundle.ps1` could build a bundle for
  `nowhere-to-walk` before that scenario's run is scheduled, rather than after. It can; what it
  writes into it is the defect. Related to `#027` (a criterion names its instrument) as its mirror
  image, and in the path of `#022`'s scoring.
- `2026-08-03` `proven` — applied **before** `2026-08-03-r12`'s bundle was built, so the defect never
  reached a blind scorer. All three `$missing` blocks now name the absent artifact and the class of
  question that went with it, and name no criterion and no section; `-NoVerifier` swaps the wording
  from *missing* to *by design*, set by whoever builds the bundle as this item asked.

  The demonstration is that bundle's `MISSING.md`, in full — a run with no `measurements.json` and no
  `midwalk.png`, and not a criterion named:

  > No `measurements.json`, and **this run produced none by design.** There was no page for a headless
  > browser to drive, so the verifier was never meant to run: its absence is not damage and not a gap
  > in the evidence. Score every criterion off the instrument it names.

  The blind scorer's opening paragraph is the other half of the evidence: it read `MISSING.md` and
  `criteria.md`, noted that *"the two agree, so no criterion is lost to the absence"*, and scored
  section D — one criterion, language fidelity, settled from the transcript — normally. Under the old
  wording it would have been told the whole of section D was unscorable.

  The trap this item named was not walked into: nothing parses the scenario for section letters, so
  there is still no second index of the criteria to drift.

  One related defect surfaced in the same file while this was being used and is `#044`, not folded in
  here: `git.txt` shipped `git log --oneline` where a criterion names `--format=%B` as well. Same
  script, same class — *the bundle promises an instrument it does not ship* — different mechanism.
