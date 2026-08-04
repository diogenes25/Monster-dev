# Run `2026-08-04-r19` — `alt-a-left-to-right`, `#061` Phase 3, **no data**

| | |
|---|---|
| Date | `2026-08-04` |
| Scenario | `process/scenarios/alt-a-left-to-right.md` |
| Fixture | `process/fixtures/static-site/` |
| Run folder | `../monster-dev-testruns/2026-08-04-r19/target/` |
| Playbook revision | `3efdd3f` **+ variant `061-s3-b`** — treated file byte-identical to Phases 1 and 2 (`1D087D85…`) |
| Hire | `claude -p` session `14467341`, model `sonnet`, 1 cli turn / 2 model turns, `$0.1356` |
| Fetch path | mirror (`../monster-dev-testruns/2026-08-04-r19/dist/`) |
| Entry point | **refused** — `#050`. Denominator now 16 sessions, **2 refusals** |

## Verdict

**No data.** The hire read `START.md`, declined to fetch the playbook, and stopped in turn 1 — the
second instance of `#050` and the first since `2026-08-03-r13`. Nothing was built, nothing was
scored, and **no criterion in this scenario was reached**, including the false-decline observation
Phase 3 exists for: a hire that never read §3 cannot have been made hesitant by it.

`$0.1356`, 2 model turns, worktree clean. Rerun as a fresh run id, which is `r13`'s precedent — and
**rerun unchanged**, because the one repair that would prevent this is the one the handoff forbids:
*"Do not fix `#050` by reassuring the hire. A paragraph telling a contractor that its instruction
source is trustworthy is exactly the text a malicious instruction file would also contain."*

**This run is not worthless, and the reason is what it refused *for*.** See below: both refusals on
record lead with the same sentence, and it is about the mirror rather than about the playbook.

## What it said

> Es gibt keine "Basis-URL", von der ich `START.md` gefetcht habe — du hast mir die Datei als
> lokalen Pfad gegeben, nicht per WebFetch. Die Anweisung "dieselbe Basis-URL" greift also gar
> nicht, ohne dass ich weiß, welches Repo/welche URL gemeint ist.
>
> Grundsätzlich: eine Datei, die mich anweist, ungeprüft weiteren Code/Text von einer nicht näher
> spezifizierten externen Quelle zu laden und dessen Anweisungen zu folgen […] ist genau das
> Muster, bei dem ich vorsichtig sein soll (Stichwort Supply-Chain).

It then offered to build the easter egg without the playbook at all — the same alternative `r13`
offered.

## The two refusals are the same refusal, and `#050` does not currently say so

`2026-08-03-r13`, the only other one:

> Sie verweist auf "die gleiche Basis-URL, von der du diese Datei geholt hast" — aber ich habe sie
> lokal per `Read` gelesen, nicht per WebFetch. Es gibt also gar keine echte URL, die ich kenne.
> **Ich würde eine raten müssen, und das mache ich grundsätzlich nicht.**

Three things match, and none of them is a coincidence worth ignoring on n=2:

1. **Both lead with §0 being unsatisfiable**, before the supply-chain argument, and both name the
   same cause: the entry point arrived as a filesystem path, so *"the same base URL you fetched
   this from"* refers to nothing.
2. **Both are Sonnet on `static-site`.** No other model and no other fixture has produced one, and
   `2026-08-01-live` — the one real-URL run, where §0 resolves — accepted without objection.
3. **Both offer the identical alternative:** build it without the playbook, in the project's own
   style, sprite to be supplied by the client.

**That reframes the item.** `#050` is filed as *within-tier variance in whether the entry point is
accepted*, which is the hardest possible shape to prove — the cost paragraph says so, and calls it
the most expensive item on the board. The two transcripts say something narrower and much cheaper
to test: **the mirror fetch path removes the one thing §0 tells the hire to derive, and a
contractor asked to follow instructions from a source it cannot identify is being asked to do the
thing it is trained to refuse.** The refusal is then not variance around a constant — it is a
response to a condition the harness introduces and the production path does not.

The scenario has always said this in the abstract: *"The agent is deliberately not told to
substitute paths for URLs — how well the playbook degrades is itself a finding."* This is that
finding arriving twice, in the same words, and it has a consequence for `#050`'s proof design
rather than for the playbook.

**What it does not license.** Two observations are two, the fixture and the model are confounded
with each other, and there is no arm in which a Sonnet hire meets a real URL. Recorded on `#050` as
an evidence line and a proof-design correction, not as a finding against §0 — whose wording is
`proven` by `2026-08-01-live` and is not what failed here.

## Reach

`check-reach.ps1 -RunId 2026-08-04-r19`, **exit 0**, nothing in any section.

- A/B/C/D: `0` / `0` / `0` / `0`. No path outside the run folder and its mirror, no `..` traversal,
  no URL fetched. Section D is 0 for the reason the run has no data: the hire declined to fetch, so
  the one thing that would have produced URLs never happened.

Turn 1's prompt names the mirror as `…\priv\monster-dev-testruns\2026-08-04-r19\dist\START.md` —
`#057`, unchanged deliberately. No scratchpad segment; `hire.ps1`'s `#042` check reported none.
Worth one clause here that is not boilerplate: **the hire read that path and did not object to
it** — its objection was to the *absence* of a URL, not to the presence of a suspicious one.

## Harness notes

- **The pre-run audit was not wasted**, and none of its eight findings caused this. Two of them
  changed the scenario before the turn was bought — an answer-script row for the question the
  treatment authorises, and a `20a` carve-out for the stated-sheet arm — and both survive into the
  rerun unchanged. Full record in `assembly.md`; the rerun's assembly cites it rather than
  repeating it.
- **The fence was not the cause.** `--allowedTools` was the standing set including `WebFetch`, no
  permission denial fired, `is_error` false. The hire chose not to fetch.
- Model: `claude-sonnet-5` on the one turn, plus the CLI's internal `claude-haiku-4-5`.
- No scoring bundle was built — there is nothing to score, and building one would have blocked the
  rerun's isolation check for no reason.

## Deferred

**All of Phase 3.** Nothing this run set out to measure was reached: not the false-decline
observation, not criteria 1–21, not `#053`'s strolling-arm measurement of criterion `10`. The
rerun carries the whole of it.

## Board

- `#050` — another evidence line, and a **proof-design correction**: 16 sessions, 2 refusals, both
  Sonnet on `static-site`, both leading with §0 being unsatisfiable on a mirror run, both offering
  the same alternative. The item's *within-tier variance* framing is not what the two transcripts
  show.
- `#061` — stays `in-proof`. Phase 3 is unspent; this run bought a refusal, not an arm.
