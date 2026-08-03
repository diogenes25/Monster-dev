# `#034` — a scrub failure takes the worktree copy and `base.txt` with it, which are the two things the capture block exists to guarantee

| | |
|---|---|
| Status | `formulated` |
| Gate | `none` |
| Attribution | harness artefact |
| Criterion | — |
| Target file | `process/tools/hire.ps1` (the capture block, around `:236`) |
| Evidence | code review of `main...HEAD`, `2026-08-02`; read, not reproduced |
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

**Cost.**

- **A partial capture is a new state to reason about.** The mitigation is that it names itself in
  the record; the risk is that somebody later reads the folder as complete. `#012` already left
  nine half-records that each say so, so the convention exists and this follows it.
- **This is read, not reproduced.** The reviewer read the control flow; nobody has made the
  scrubber throw on purpose. That should happen as part of the fix rather than be assumed, and it
  is cheap: the scrubber's own refusal condition is a string it looks for.

**Log.**

- `2026-08-03` `formulated` — from the same review as `#032` and `#033`. Filed separately because
  it is about what a run leaves behind rather than about an error path, which puts it next to
  `#013` and `#029` rather than next to the tool bugs.
