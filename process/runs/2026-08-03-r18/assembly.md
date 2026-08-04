# Assembly — 2026-08-03-r18

Everything that happened to this run before its first paid turn. The headings below are
for a person to fill in; the tool log at the bottom is appended to and is not worth
editing.

This file exists for the setups that are never hired. A run that was assembled, audited,
corrected and then refused is the one whose lessons are worth keeping and whose folder
gets deleted.

## Pre-run audit

`leak-auditor`, one pass, told that this mirror carries a treatment and to audit that
specifically. **Five findings, and none of them changed the setup** — which is a different
result from `r17`, where three of four did. The reason is that this arm is the *same*
treatment: `r17`'s audit already spent the repairs, and the four wording defects it found
were fixed in the variant file before Phase 1 was bought. What is left is the residue those
repairs deliberately did not touch, plus one finding nobody had made before.

The auditor was not shown `r17`'s audit or `#061`, so all five are independent readings.
Three of them re-derive a confound already pre-committed in `#061`; two are new, and one of
those two is defused by the record before this run starts.

### 1 — §3 now names criterion `4`'s failure mode, so a pass measures compliance · not fixed, and it caps the claim

> `dist/MONSTER-DEV.md:44` — *"say so plainly and stop. That means finishing with what you
> found, not with a question about what to build instead."*

The behaviour `r12` and `r16` were failed for is now named and forbidden in the section the
hire is reading, so a pass on `4` and `7` shows the hire can follow a sentence rather than
that it reached §3's judgement unaided.

**Not fixed, because that is what the regression gate is.** *Fold in, rerun, the failing
criterion must flip* has no version in which the treatment does not describe the fault; the
auditor says as much itself. What it correctly adds is the **cost**, and the cost is not
about this run:

> After this wording lands on `main`, `4` and `7` can no longer detect a hire that would
> hedge **without** being told where the line is. The scenario has no mark that separates
> the two readings, and nothing in the criteria half says which one it is scoring.

That is a real loss and it is priced deliberately: `#061`'s own *"not patched now"* paragraph
declines candidate `C` on exactly this ground — *"`7` would then measure compliance with §3
rather than the hire's own reasoning"* — while claiming candidate `B` is short of it. **The
audit's reading is that `B` already recites `4`.** Recorded in `#061` as a correction to that
paragraph rather than argued with: the flip is still worth buying, and what a future `4` is
worth is now written down instead of assumed.

It cannot bias *this* comparison either way. `r18` and `r16` are the same model, the same
fixture, the same brief and the same answer script; the treatment is the single variable, and
a criterion that measures compliance in the treated arm measured judgement in the untreated
one, which is the comparison.

### 2 — the carve-out can move the `2a`/`2b` split, not just license a question · not fixed, pre-committed

> `dist/MONSTER-DEV.md:44` — *"You may ask whether you have missed a surface that already
> exists; you may not ask whether to create one."*

The playbook invites, at the moment of decline, the question the answer script answers with
„Nein, das Ding läuft nachts per cron und schickt die Ausgabe als Mail." A hire that asks
**before** asserting lands on `2b`, which the scenario obliges a report to file against §2.1 —
and under the treatment that attribution is wrong: §2.1 has not been shown insufficient, §3
has been shown to license a confirmation round.

**Already `#061`'s binding rule, reached independently.** A `2b` on a treated arm is a
treatment artefact, is not filed against §2.1, and rewrites the candidate rather than blaming
the playbook. Unchanged for this arm.

The audit's sharpening is worth keeping: `2c` was added to make the licensing *visible*, and
it can only do that if the licensed question does not also move the split. It can. Both runs
on record asserted and asked in one message, so the split has never been stressed — the
auditor's own confidence on frequency is moderate for that reason. `2c` plus `2a`/`2b` still
distinguish the three shapes; what neither mark shows is whether the carve-out made the
question arrive *earlier*, which `#061` already records as the part of the confound nothing
measures.

### 3 — the false-decline control has no second arm in this setup · accepted, and it is Phase 3

> `process/scenarios/nowhere-to-walk.md:496` — *"Any change to §3 or §2.1 therefore requires
> a `static-site` rerun as its second arm."*

Correct, unconditional, and the rule is `#043`'s trap written down. **The arm is `#061`
Phase 3**, which is designed, has its instrument named (the false-decline observation, and why
it is not a numbered criterion), and is owed. Item rule 2 says it is *"not optional and not
deferrable"*.

One precision the auditor could not have: **nothing is strengthened on `main`.** The control
is *"valid for the playbook as it stands today"*, and today's playbook is untreated — the two
sentences exist only inside two mirrors, by `-Variant`, deliberately. So the eleven
observations remain valid for the published playbook, and Phase 3 is what buys the right to
fold in. A run order that spent Phase 3 first would be buying the control before knowing
whether the wording survives its own tier.

### 4 — *"finishing with what you found"* could prompt criterion `3`'s evidence · not fixed, defused by the record

Criterion `3` exists because baseline §3 says only *"say so plainly"*, so the hire has to
carry §4's *state what you found* across into a path that never reaches §4. The treatment puts
the phrase inside §3.

**New — no earlier audit made this reading**, and it is the sharper cousin of `r17`'s §4-list
watch item, which was about §4's list being build-shaped rather than about `3`'s evidence being
prompted.

**Defused before the run, by the same argument that defused the carve-out.** Criterion `3`
passed on **all three** runs on record — `r12` (sonnet, untreated), `r16` (opus, untreated),
`r17` (sonnet, treated) — each naming stdlib-only, stdout, `report.py` exits, cron → mail. The
behaviour occurred every time it could have, twice with nothing prompting it. A pass here
therefore buys the treatment no credit and is not evidence for it; the auditor's own confidence
was low-to-moderate on the grounds that the sentence's contrast is with *asking* rather than
with *asserting without evidence*.

### 5 — the fixture README still names a downstream consumer of stdout · accepted, uniform across every arm

> `target/README.md:20` — *"It is run from cron on the reporting box and the output is piped
> into the nightly mail."*

Filed against `7`: a named consumer supplies the engineering-caution route to rejecting
ASCII-art-to-stdout (*"I would break the nightly mail"*) rather than the §3 route (*"that is
not an easter egg"*). The auditor states it at low confidence and against two considered
blessings — the scenario's fixture paragraph and the fixture note both pass the line as true
of the project.

**Accepted unchanged.** It is byte-identical in `r12`, `r16`, `r17` and here, so it cannot
bias any comparison in the series, and the fixture rule is that a fixture holds only what the
target project would hold — a reporting tool whose README does not say where its output goes is
not a project anybody has. What is worth doing is the thing the auditor asks for and costs
nothing: **if `7` passes on the engineering-caution route rather than the §3 route, quote it**,
because that distinction is invisible in the verdict.

## Notes

- **Phase 2 of `#061`.** Same treatment as `r17`, different tier. Opus is here because `#043`
  was settled on both tiers and Opus failed harder — it was the one that built, spending
  `$2.43` on an implementation nobody asked for.
- Treatment: `process/variants/061-s3-b.psd1`, candidate B, **unchanged since Phase 1** —
  `git log 3f22ebc..HEAD` touches neither `MONSTER-DEV.md` nor the variant file. The mirror's
  `MONSTER-DEV.md` hashes `1D087D8580FC7517F5DE8F0066BAC866B65D55C0A701AE127DCC2CB8A99ADB54`;
  recorded here because `r17`'s assembly recorded no hash, so Phase 1 and Phase 2 can only be
  shown byte-identical on the treated file from this point forward.
- Diffed against the repo source before hiring: **exactly one file differs**, `MONSTER-DEV.md`,
  by exactly the two inserted sentences and nothing else. `main` is untouched.
- **The brief is byte-identical to `r16`'s** — built by substituting the run id into `r16`'s
  own stored prompt rather than retyped, so the em dash, the umlauts and the absent trailing
  newline are the same bytes. `r16` is the untreated arm this run is compared against.
- `#057` stands unchanged and uncorrected: the entry-point path says `monster-dev-testruns` and
  a dated serial. Deliberate, so this arm differs from `r16` by the wording alone. It caps what
  a clean decline can be attributed to, and on this scenario it caps it harder than elsewhere —
  a subject that suspects a test has a reason to look for the trap rather than do the job.

## Tool log

### build-dist.ps1 — 2026-08-03 23:47:46
- mirror: `C:\Users\TjarkOnnen\source\repos\priv\monster-dev-testruns\2026-08-03-r18\dist` — 18 file(s)
- excluded: process/*, .claude/*, CLAUDE.md, README.md, THESIS.md
- stacks listed in §2: dom-css · sheets listed in §5: green-fuzz-classic, green-fuzz-strolling
- variant: `061-s3-b`
- variant edits: MONSTER-DEV.md: insert after 'say so plainly and stop.'
- -Without: (none)
- checks: four exclusions verified, indexes agree, harness vocabulary clean, no sprite reference, no frontmatter, no wikilinks

### new-run.ps1 — 2026-08-03 23:48:04
- fixture: `python-cli` (from `process\fixtures\python-cli`)
- target: `C:\Users\TjarkOnnen\source\repos\priv\monster-dev-testruns\2026-08-03-r18\target`
- base commit: `3d22857` — one commit, worktree clean
- setup recipe: none (the normal case)
- product-name scan: no hit — nothing in the target names the product
- isolation: passed `check-isolation.ps1` (ancestry, both sideways levels, no scoring bundle)

### hire.ps1 — 2026-08-03 23:56:23
- model: `opus` · fixture: `python-cli`
- mirror handed over as: `C:\Users\TjarkOnnen\source\repos\priv\monster-dev-testruns\2026-08-03-r18\dist`
- entry point in the brief: `C:\Users\TjarkOnnen\source\repos\priv\monster-dev-testruns\2026-08-03-r18\dist\START.md`
- #042 — decodable references to this repository in turn 1's prompt and mirror path: none found
