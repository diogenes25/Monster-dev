# `#034` — a scrub failure takes the worktree copy and `base.txt` with it, which are the two things the capture block exists to guarantee

| | |
|---|---|
| Status | `proven` |
| Gate | `none` |
| Attribution | harness artefact |
| Criterion | — |
| Target file | `process/tools/hire.ps1` (the capture block, around `:236`) |
| Evidence | code review of `main...HEAD`, `2026-08-02`; **reproduced `2026-08-03`** against a scrubber made to refuse, pre-fix and post-fix |
| Blocked on | nothing |
| Proof design | — |

**What happened.** `hire.ps1`'s capture block brings a run home after every turn. Its own comment
says why it runs *then* rather than at the end: `new-run.ps1 -Force` destroys the run folder, and
a session that is never formally finished otherwise leaves nothing behind — which is `#013`, the
item that produced the block.

`scrub-transcript.ps1` is called inside that block, and it is built to **throw** rather than write
a file it could not fully anonymise. That is correct on its own. But the throw aborts the whole
block, so the `worktree/` copy and `base.txt` are not written either — and neither of those
contains the account name the scrub was worried about. A failure in the most protective component
destroys the artefacts the block exists to protect.

The failure mode is worst exactly when it matters most: a transcript with an unanticipated shape
is the one worth having a worktree copy of.

**Why the current wording allows it.** Both halves are individually right. `scrub-transcript.ps1`
refusing to write is the correct behaviour for a file that will be pushed. The capture block being
one sequence is the natural way to write it. Nothing states that the three artefacts are
independent, because until the scrubber existed there was only one.

**Proposed change.**

> The three captures are independent and each is attempted regardless of the others. The scrub
> failure is reported loudly and the run's `knowledge.md` records that the transcript is missing
> and why — `#012` established that a half-record which says so is worth more than a gap.
>
> A transcript that fails to scrub is **not** written unscrubbed, and not written to a
> `.unscrubbed` sidecar either: `process/` is tracked and pushed, and a sidecar is a file somebody
> commits by accident. What is kept is the *reason*, in the record.

**Proof design.** *`Gate: none`.* Demonstrate against a synthetic transcript the scrubber refuses,
and check that `worktree/` and `base.txt` are on disk afterwards and that the run record says the
transcript is absent.

**What was applied.** The capture block is now three independent units, each attempted whatever
the others did, and `CAPTURE-FAILED.txt` reports per artefact instead of as one outcome.

Demonstrated against a scrubber made to refuse, both before and after. `hire.ps1` has no dry run
and its paid turn sits above the capture, so the block was **extracted verbatim** — 92 lines,
one substitution, `$HOME` → a fake home, because PowerShell will not let a read-only variable be
redirected — and run with the surrounding state stubbed. The pre-fix arm is the same extraction
from `HEAD`.

| | pre-fix | after |
|---|---|---|
| `worktree/` | **absent** | present, holds the built file, `.git` stripped |
| `base.txt` | **absent** | present |
| `knowledge.md` stub | **absent** | present |
| the report | *"the transcript and/or the worktree are not in this folder"* | `FAILED transcript.jsonl — <the scrubber's own reason>`, `ok worktree/`, `ok base.txt` |

The refusal itself behaves as the item requires: no transcript is written, and no `.unscrubbed`
sidecar appears — checked for by name, not assumed.

**One departure from the proposed change, deliberate.** The proposal says the run's
`knowledge.md` should record that the transcript is missing and why. It does not, and nothing
writes into that file automatically. `hire.ps1` already states the rule and the reason: it is
created once and then left alone, because it is the one file in the folder a person writes, and
an automatically inserted line reads exactly like a written one — the same reason its `tags` are
left empty rather than guessed. `CAPTURE-FAILED.txt` is rewritten every turn and is the honest
home for a machine fact. `#012`'s point — that a half-record which says so beats a gap — is met
by the per-artefact report, not by editing the record.

**Cost.**

- **A partial capture is a new state to reason about.** The mitigation is that it names itself in
  the record; the risk is that somebody later reads the folder as complete. `#012` already left
  nine half-records that each say so, so the convention exists and this follows it.
- ~~**This is read, not reproduced.**~~ **Cleared `2026-08-03`** — reproduced both ways against a
  refusing scrubber. It was cheap, as predicted, but not in the predicted way: what made it cheap
  was extracting the block rather than running a hire.
- **The demonstration exercises an extraction, not `hire.ps1` itself.** 92 verbatim lines with the
  surroundings stubbed is much stronger than reading, and it is not the same as a real run: the
  stubs could disagree with what `hire.ps1` actually passes. The next real run is what closes
  that, and it costs nothing extra to look in the run folder afterwards.

**Log.**

- `2026-08-03` `formulated` — from the same review as `#032` and `#033`. Filed separately because
  it is about what a run leaves behind rather than about an error path, which puts it next to
  `#013` and `#029` rather than next to the tool bugs.
- `2026-08-03` `proven` — applied and reproduced. Picked up ahead of its queue position because it
  sits in the per-turn capture block, which means it is in the path of **every** turn of whichever
  run happens next — `#002` and `#022` are both blocked behind it and both are two commands away
  from starting.
- `2026-08-03` — this is the one item from that review whose stated consequence was **exactly
  right**. `#032`'s `board` finding was latent, `#033`'s stale-branch worry was unspent, `#035`'s
  missing screenshot was never missing. This one said a scrub failure destroys the worktree copy
  and `base.txt`, and it destroys the worktree copy and `base.txt`. Worth recording alongside the
  other three: the pattern was that a reader overstates *blast radius*, not that a reader is
  unreliable, and here there was no radius to overstate — the control flow was the whole claim.
