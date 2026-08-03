# `#044` — the bundle shipped `git log --oneline` where a criterion names `--format=%B` as well

| | |
|---|---|
| Status | `proven` |
| Gate | `none` |
| Attribution | harness artefact |
| Criterion | `nowhere-to-walk` `11` — and `alt-a-left-to-right`'s §8 trailer mark by the same route |
| Target file | `process/tools/score-bundle.ps1` (the `git.txt` block) |
| Evidence | `2026-08-03-r12`, found by the blind second scoring's own `UNCERTAIN` list |
| Proof design | — |

**What happened.** `nowhere-to-walk` `11` names two instruments: *"`git log --oneline` and
`git log --format=%B`"* — the first for whether anything was committed, the second for whether a
trailer was added to a message body, which `--oneline` truncates away. `git.txt` carried the first
only. The blind scorer passed `11` and said why in `UNCERTAIN`:

> I passed on the inference that a hire which never invoked `git` cannot have written a trailer, and
> that the single commit is the fixture's own. Strictly, the body of `6a9016c` is unread.

The inference is sound and the verdict is right. It is also not the instrument the criterion names,
and a blind reader that has to reason around a missing file is a blind reader one step closer to
scoring what it expects — which is the single failure mode the second pass exists to prevent.

**Why it happened.** `git.txt` was written to answer §9 (*what is in the diff surface*), where
`--oneline` plus `status` plus `diff --stat` is exactly right. §8's trailer rule is a different
question about the same object, and it needs the message body. Nothing was wrong with either
decision; the file was simply never re-read against a criterion that names both.

**Change applied.** A fourth section in `git.txt`:

```powershell
'=== git log --format=%B ==='
(git -C $targetPath log --format='%B%n---')
```

**Proof design.** *`Gate: none`.* Applied, and the demonstration is a bundle whose `git.txt` answers
both of `11`'s instruments. Not a claim that it changed a verdict: it did not, on this run.

**Cost.** Three lines, and one general point worth keeping: an instrument a criterion names is an
instrument the bundle ships. That is `#027`'s rule read from the tooling side.

**Log.**

- `2026-08-03` `proven` — found and fixed while scoring `2026-08-03-r12`. Found *by the blind pass*,
  which is the second time in two runs that the second reader has produced something the first
  reader's own procedure could not.
