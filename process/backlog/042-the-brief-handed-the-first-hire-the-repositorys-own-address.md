# `#042` — the brief handed the first hire the repository's own address, in the CLI's slug spelling

| | |
|---|---|
| Status | `proven` |
| Gate | `none` |
| Attribution | harness artefact |
| Criterion | none directly. It bears on the standing of `2026-08-01-alt-a`, which is where the criteria the whole series is scored against were established |
| Target file | `process/runs/2026-08-01-alt-a/report.md` and `knowledge.md` — a caveat, not a rewrite. Nothing in `process/tools/` is defective |
| Evidence | found `2026-08-03` by the first sweep of `check-reach.ps1` over all eleven captured transcripts; every claim below re-read out of the transcript by hand |
| Blocked on | nothing |
| Proof design | — |

**What happened.** `2026-08-01-alt-a`'s turn-1 brief ended with the hire's entry point written as an
absolute path:

```
<home>\AppData\Local\Temp\claude\<repo>\9748…\scratchpad\monster-dev\START.md
```

That middle segment is a **CLI project slug**, and a slug is the session's working directory with
every separator turned into a dash — which is why `scrub-transcript.ps1` has a rule for exactly that
form. The session it belongs to is not the hire's; it is a session whose working directory was this
repository. So the path spells out `C:\Users\…\source\repos\priv\MonsterLib` in full, in the one
string turn 1 could not avoid reading.

The hire decoded it. Three commands, with its own descriptions quoted:

```
line 16  cd "<repo>" && git remote -v; cat ".../scratchpad/monster-dev/README.md"
                                        "Find MonsterLib remote URL and read scratchpad README"
line 36  ls -d "<repo>"; ls -la "<home>/source/repos/priv/"      "Check MonsterLib repo location"
line 39  cd "<repo>" && git remote -v; ls -la                    "Check MonsterLib git remote"
line 53  Copy-Item "<repo>\monster-walk.png" -Destination <run>\assets\monster-walk.png
```

**Bounded honestly, and the bound matters.**

- The working directory *was* the run folder. `cwd` on every record says so, and the report's
  isolation section is accurate about the thing it checked. This is not an ancestry leak, and
  `check-isolation.ps1` would not have caught it then and would not now: nothing was above the run
  folder. The address arrived **in the prompt**.
- Line 40's result listed the repository root and named `CLAUDE.md`, 5013 bytes, among fifteen
  entries. **There is no evidence the hire read it** — no `Read` of it, no quotation of its content.
  What is on record is that it saw the name and moved on.
- The `README.md` it did read came from the scratchpad copy, not from a mirror. That copy is not a
  `build-dist.ps1` product: it contains the root `README.md`, which a real mirror excludes. So this
  run's "mirror" was a working-tree copy in a scratchpad, and `#018`'s leak reached it by that route
  rather than through a mirror exclusion that failed.
- The sprite came out of the repository directly, not from the copy it was pointed at.
- `test/` — `process/`'s name until the `2026-08-02` rename — is not in the visible part of either
  listing, and nothing in the transcript reads a scenario or a criteria file. **No claim is made that
  this hire saw the acceptance criteria.** What it had was reach plus the repository's name.

**Why this is a new class rather than a restatement.** Three items already cover neighbouring
ground and none of them covers this:

- `#018` is the root `README.md` reaching hires *through the mirror*. Here it arrived through a
  scratchpad copy that was never a mirror.
- `#019` is a previous run folder sitting one `ls ..` away. This hire never ran `..` at all.
- `#041` is the runs root being a sibling of the working copy, reachable by walking up, and it says
  in as many words that *"none is known to have walked up three levels."* That remains true. This
  hire did not walk. **It was handed the address**, and no amount of moving the runs root would have
  changed that, because the leak was in the brief.

So the reusable form is narrower and sharper than "keep the tree clean": **anything handed to a hire
in its prompt is part of the mirror surface, including the shape of a path.** A path is not inert —
a slug is a path in disguise, and this project already knew that, because the scrubber has a rule for
decoding one.

**What this costs `2026-08-01-alt-a`.** It is *the first run*: `knowledge.md` calls it "the first
measurement" and says it "established the criteria the whole series is scored against". Its verdicts
are not thereby void — the criteria it produced have been re-derived and re-applied nine times since,
and nothing here touches the §4 ordering failure it found, which is a behavioural observation about
the playbook. What it does mean is that **its isolation section overstates what was verified**, and
any future citation of it as a clean-room measurement needs the caveat. That belongs in its own two
files and is this item's target rather than something to fold in silently.

**Cost.**

- **One run affected on the evidence, and it is the earliest and most-cited one.** The other ten
  transcripts came out clean of `<repo>` reaches in the same sweep; `2026-08-01-sonnet-base2` is the
  only other reach and it is `#019`'s, already on record.
- **The pattern could recur and is not currently prevented.** `hire.ps1` composes turn 1 from
  `-Brief`/`-BriefFile` plus the mirror path, and nothing inspects the assembled prompt for a path
  that names the repository. A check is cheap — the assembled prompt is right there — and is not
  filed here because this item is the measurement, not the fix.
- **`check-reach.ps1` found it on its first sweep, which is the argument for the sweep being a step
  rather than a habit.** It was built for `#041`, to measure a reach nobody could prevent, and its
  first real output was a different leak in the oldest run on the board.

**Log.**

- `2026-08-03` `proven` — found by `check-reach.ps1`'s first pass over all eleven transcripts. Not
  by looking for this: the sweep was validation that the detector could fire at all, having just
  reproduced `#019`'s finding on `sonnet-base2`. `alt-a` came back with four `<repo>` reaches, which
  no item predicted.
- `2026-08-03` — two wrong readings were entertained before the right one, and both are recorded
  because the standing correction from `#032`, `#033` and `#035` is that this project's readers
  overstate blast radius. First: *"the hire read the repository's README, so `alt-a` is void."* It
  read a scratchpad copy, and reading the root README is `#018`, already counted. Second: *"the
  captured transcript is the developer's session, misattributed by the `#012` backfill"* — the
  `PowerShell` tool and the `<repo>` slug both pointed that way, and `#035` is precisely a
  misattributed artefact. `cwd` on line 1 settled it: the run folder, and a customer brief in
  German. The transcript is the hire's. Checking the cheapest discriminating fact first would have
  skipped both.
