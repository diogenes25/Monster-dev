# Run `2026-08-01-index-sonnet` — `alt-a-left-to-right`

| | |
|---|---|
| Date | `2026-08-01` |
| Scenario | `test/scenarios/alt-a-left-to-right.md`, unchanged since `plan-sonnet` |
| Fixture | `test/fixtures/static-site/` |
| Change under test | §2's stack list rewritten as a table, plus the first-match rule. **Nothing else** — §4 and §6 carry the Phase 2 wording unchanged |
| Compared against | `2026-08-01-plan-sonnet` — same model, same scenario, same mirror mechanism |
| Hire | Sonnet, session `d6c89f41`, 2 cli-turns / 42 model turns, $2.32 |

## Verdict

**Neutral, as intended: every criterion that `plan-sonnet` passed, this run passed identically.**
The four behaviour arms are indistinguishable to the verifier.

Two things this run turned up that the change did not cause. **Criterion 20a took its first
failure** — the hire announced a container in `index.html`, then built without one and never
flagged the substitution as such. And the turn overrun from Phase 2 **reproduced**, which is the
opposite of what I expected and forces a correction to the Phase 2 report.

Counts: 21 pass / 2 qualified / 1 fail / 2 not exercised.

## Was it neutral?

| | `sonnet-base2` | `plan-sonnet` | `index-sonnet` | `plan-opus` |
|---|---|---|---|---|
| load / idle / bare / trigger / after / 2nd | 0/0/0/1/0/1 | 0/0/0/1/0/1 | **0/0/0/1/0/1** | 0/0/0/1/0/1 |
| sprite HTTP | 200 | 200 | **200** | 200 |
| travel | −76 → 984 | −76 → 982 | **−75 → 984** | −78 → 979 |
| mirrored | yes | yes | **yes** | yes |
| smooth-scroll after | 199 | 199 | **199** | 199 |
| console errors | 1 (favicon) | 1 | **1** | 1 |
| commits | 1 | 1 | **1** | 1 |
| 18a / 18b / 18c / 18d | ✗✓✗✗ | ✓✓✓✓ | **✓✓✓✓** | ✓✓✓✓ |
| 19 one round | pass | pass | **pass** | pass |
| 21 no notes bookkeeping | pass | pass | **pass** | pass |

Criterion 18 held at 4/4 on the bar model across a second, independent run. That was not what
this run was for, but it is the more valuable half of its result: Phase 2's flip was one sample,
and a second Sonnet hire producing all four marks makes it a behaviour rather than a coincidence.

**This is a neutrality result and is reported as one.** Nothing here improved. With exactly one
row in the table, the first-match rule cannot be observed at all — it is written now so it is
already in place when the second stack arrives and a project can match two rows. That moment is
the first time an unwritten rule would silently cost every earlier run its comparability.

## 20a — first failure, and it is an implementation error

**Announced**, turn 1:

> Geht rein in `style.css` (Sprite-Keyframes) und `script.js` (Alt+A-Listener + Lauf-Logik),
> plus **ein kleiner neuer Container in `index.html`**.

**Built**: `git status` shows ` M script.js`, ` M style.css`, `?? assets/monster.png`.
`index.html` is untouched — the hire switched to creating the element from JavaScript.

The switch is defensible and matches what `sonnet-base2` did unprompted. The problem is that it
was announced and then not done. Under the scenario's own rule — *fail 20a **with** 18 = an
implementation error, **without** 18 = a playbook gap* — this is an implementation error: §4 was
followed, all four marks landed, and §6 says in as many words that a departure gets named.

**20b, qualified rather than failed.** The handover does contain the line
*"`index.html` bleibt unverändert"* — the fact is on the page. What is missing is that it is a
*change*: `plan-opus`, on the same wording, wrote *"Eine Abweichung von dem, was ich angekündigt
hatte: kein Schatten"* and then the reason. A reader of this run's handover can only find the
departure by re-reading turn 1 and diffing it themselves.

**Not yet a finding.** Half C wants two runs failing the same criterion the same way; this is
one, on a criterion that is three runs old. Recorded, watched, not acted on. If a second hire
substitutes silently, the §6 sentence needs to say *"say that it changed"*, not just *"name the
change"* — the two read the same until you watch a model choose between them.

## The turn overrun reproduced — Phase 2's hedge was wrong

| | before | plan | +§2 table | control |
|---|---|---|---|---|
| | `sonnet-base2` | `plan-sonnet` | `index-sonnet` | `plan-opus` |
| Model turns, total | **31** | 41 | **42** | 41 |
| — turn 1, the plan | 12 | 11 | 14 | 13 |
| — turn 2, the build | **19** | 30 | 28 | 28 |
| Cost, total | $1.66 | $1.84 | $2.32 | $2.72 |
| — turn 1 | $0.61 | $0.37 | $0.59 | $0.51 |

The Phase 2 report offered two hedges. **Both fail on this data.**

*"41 may be the day rather than the change."* It was not. Two consecutive Sonnet runs carrying
the plan step land at 41 and 42 against a before-arm at 31, and the §2 table — a change that
cannot plausibly cost anything — moved the total by one turn. The ~10-turn rise tracks the §4
change.

*"Turn 1 got shorter and 39 % cheaper."* That was one sample of a noisy number and I reported it
as a result. Across both plan-step runs turn 1 is 11 and 14 turns at $0.37 and $0.59, against 12
turns at $0.61 before. **Turn 1 is flat.** The Phase 2 report has been corrected.

What survives is narrower and still worth saying: the rise is in the **build**, 19 → 30/28/28,
not in the turn that now carries a plan. A plausible mechanism is that a hire which has
committed to a change set in public then goes and verifies it — `index-sonnet` spent part of
that budget finding and fixing a real bug in its own work (*"Der Test hat dabei einen echten Bug
gefunden"*, an unnecessary `requestAnimationFrame` hop that delayed the start). That is a
mechanism, not a measurement, and separating it needs an arm this phase does not have.

**The gate is regression, and nothing regressed.** The plan step stands. But it is now on record
as costing roughly a third more turns on the bar model, twice measured, rather than as a
suspicious single number.

## Harness notes

`test/tools/check-index.ps1` is new and ran clean before the run. Its first version flagged every
tracked PNG outside `monsters/` and reported `monster.png` as a stray sheet — a false positive:
it is the README's banner image. That would have had to be silenced with an exception, and an
exception is how a check quietly stops checking, so the rule now tests **geometry** instead. A
sprite sheet is one horizontal row of cells and is therefore extremely wide: the two real sheets
sit at aspect ratio 21.2 and 16.9, the banner at 1.5, and the threshold is 5. This also corrects
a claim made when the stray was first noticed — it was described as unreferenced left-over from
the `monsters/` rename, and it is neither.

All five failure branches of the checker were exercised against temporary mutations of
`MONSTER-DEV.md` (frames desync, cycle desync, sheet row removed, default delisted, phantom
stack) and the file was hash-verified identical afterwards. The first attempt at that test
reported every branch as dead, which was the test's fault, not the checker's: `throw` is
terminating, so the `FAIL` lines never reached `Out-String`. The branches are checked from a
child process now.

Each arm gets its own HTTP port, per the Phase 2 note. The favicon 404 is unchanged and still
belongs on the Phase 4 allowlist.

## Not exercised

§0 and §5's WebFetch/curl split — this run used the mirror on purpose, so the comparison against
`plan-sonnet` varies only §2. Both are proven by `2026-08-01-live`, not deferred.

The first-match rule itself. One row cannot demonstrate it. It becomes measurable with the second
stack in Phase 5, and the `gsap-site` fixture is the case that will match two rows.
