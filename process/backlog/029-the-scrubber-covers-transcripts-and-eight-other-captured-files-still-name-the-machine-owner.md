# `#029` — the scrubber covers transcripts, and eight other captured files still name the machine owner

| | |
|---|---|
| Status | `formulated` |
| Gate | `none` |
| Attribution | harness artefact |
| Criterion | — |
| Target file | `process/tools/hire.ps1`, `process/tools/scrub-transcript.ps1`, `process/runs/*/hire.json`, `process/runs/*/brief.txt` |
| Evidence | `git grep` over tracked files, `2026-08-02`, while verifying Wave 2 |
| Proof design | — |

**What happened.** `#013` established the rule and built the instrument: `process/` is tracked and
this repository is pushed, so a transcript is scrubbed on the way in and `scrub-transcript.ps1`
refuses to write a file it could not fully anonymise. The rule was applied to exactly one of the
files a capture produces.

Tracked, today, in the working tree:

```
process/runs/2026-08-01-index-sonnet/brief.txt        process/runs/2026-08-01-index-sonnet/hire.json
process/runs/2026-08-01-plan-opus/brief.txt           process/runs/2026-08-01-plan-opus/hire.json
process/runs/2026-08-01-plan-sonnet/brief.txt         process/runs/2026-08-01-plan-sonnet/hire.json
process/runs/2026-08-01-sonnet-base2/brief.txt        process/runs/2026-08-01-sonnet-base2/hire.json
```

Twenty-three occurrences of the account name across the eight, in three shapes. `hire.json` holds
it in `target`, `dist` and the turn-1 `prompt`, JSON-escaped:

> `"target": "C:\\Users\\<user>\\source\\repos\\priv\\monster-dev-testruns\\2026-08-01-index-sonnet"`

and `brief.txt` holds it plainly, because for the mirror-based runs the brief *is* a filesystem
path — the substitute for the `raw.githubusercontent.com` URL that cannot be used until the push:

> `Deine Einweisung steht hier: C:\Users\<user>\source\repos\priv\monster-dev-testruns\2026-08-01-index-sonnet.dist\START.md`

Five further occurrences sit in `#012` and `#013` themselves, quoting the paths while describing
this exact problem. Those are a citation rather than a capture, and they are the reason the scan
that finds this is a two-minute job that nobody ran: `git grep` returns them mixed in with the
real ones, and the eye slides off a hit inside an item about the string.

**Why the current wording allows it.** `hire.ps1` writes the envelope first and scrubs second, and
what it scrubs is named one file at a time:

> `& scrub-transcript.ps1 -In $hits[0].FullName -Out (Join-Path $runDir 'transcript.jsonl') …`

`process/README.md` describes the guarantee in terms of the transcript too — *"The transcript is
scrubbed on the way in"* — so the file that states the rule states it narrowly enough to be
satisfied by what exists. Nothing anywhere says *"nothing captured into `process/runs/` may name a
path outside it"*, which is the rule that was actually intended.

The envelope is the worse of the two, because it is machine-written on every turn and will keep
arriving. `brief.txt` is written by hand from the scenario and is only a problem while runs are
handed a filesystem path instead of a URL.

**Proposed change.**

> **The scrubber stops being transcript-shaped.** `scrub-transcript.ps1` already holds the whole
> path vocabulary — five path forms, the 8.3 short home, the `AzureAD+<account>` file-owner form,
> the CLI's project slug — and the JSONL record filter is the only part of it that is about
> transcripts. Split the rewrite out as a function over text, and have `hire.ps1` put `hire.json`
> and `brief.txt` through it as well as the transcript.
>
> **Then the check that makes it stick, because a rule applied to three files today is a rule
> applied to three files.** `check-index.ps1` fails if any tracked file under `process/runs/`
> matches the same *"is any home directory still named"* pattern the scrubber ends on. It is the
> identical shape as the citation backstop that already lives there, and it is keyed inside the
> repository for the same reason.
>
> The eight files on record are rewritten in place. They are an archive nothing re-runs, so a
> rewrite costs nothing but has to be done by the same code path, not by hand.

The check has to be built to fail on the current tree, then the rewrite run, then the check seen
green. Building it after the rewrite proves only that it compiles.

**Proof design.** *`Gate: none`.* Half C: fix the harness, rerun, record nothing against the
product. Nothing about the playbook changes and no criterion is affected — this is about what a
push makes public, not about what a hire sees.

**Cost.**

- **The two board items keep the string**, and should. Redacting `#012` and `#013` would make them
  unreadable as accounts of a problem whose whole subject is that string. So the check has to
  exempt `process/backlog/`, and an exemption is how a check stops checking — the mitigation is
  that it is one directory, named, and the directory is prose rather than capture output.
- **A second scrubber pass per turn**, on two small files. Immeasurable next to the hire.
- **`brief.txt` becomes unrunnable as written** once its path is `<run>`. It already is: the run
  folder it points into is gone for six of the ten runs. Recording that the brief *was* a path is
  the honest thing; reproducing it needs the run folder anyway.
- **Redaction is not deletion.** These files are in git history and this rewrites the working tree
  only. ~~The repository has never been pushed, so the history is still local and still fixable —
  but that is true today and not necessarily next week, and it is the reason this is not a
  tidy-up-later item.~~ **Struck `2026-08-02`: false, and false when written.** The repository has
  been pushed since before `2026-08-01-live`; the branch holding these files went up the same day
  this item was filed. There is no local-only window to spend. Working-tree redaction is cosmetic
  on its own, and the real fork — rewrite and force-push, or accept — is in the log below.

**Log.**

- `2026-08-02` `intake` — found while verifying Wave 2, by grepping the tree for the account name
  to confirm the transcripts were clean. They were. Nothing else was.
- `2026-08-02` `formulated` — counted rather than estimated: eight capture files, 23 occurrences,
  three path shapes, plus five citations in `#012` and `#013` that are not the same thing. The
  narrow sentence in `process/README.md` located as the reason the gap reads as covered.
- `2026-08-02` — **the premise above is wrong, and it was wrong when it was written.** The cost
  section reads *"the repository has never been pushed, so the history is still local and still
  fixable — but that is true today and not necessarily next week."* The repository **is** pushed
  and has been since before `2026-08-01-live`, which is on record precisely because it ran over
  real `raw.githubusercontent.com` URLs. `origin` is `https://github.com/diogenes25/Monster-dev`,
  and the branch carrying these eight files was pushed on `2026-08-02` at 23:36.

  The window this item books as its reason for urgency never existed. That does not weaken the
  item — it removes the part that made it feel optional. What remains is a live choice with no
  free option in it: rewrite the history across `main` and `script-the-run-folder` and force-push,
  or decide to accept 23 occurrences of the account name in a published history and stop adding
  to them. **Redaction in the working tree alone is now cosmetic** and should not be described as
  a fix.

  Written down because the error is instructive rather than embarrassing: the item was drafted
  against `CLAUDE.md`'s *"not yet pushed as of this writing"*, which `#003` was already filed
  about and had been since `2026-08-01`. A stale sentence in the orientation file propagated into
  the risk assessment of an unrelated item one day later. That is the cost `#003` was carrying
  and the reason it stopped being a tidy-up.
- `2026-08-02` — one scope correction from the same pass: the eight files are already **committed
  and pushed**, so they are not something a future commit introduces. The `Target file` row lists
  them as though the working tree were the object; the object is the history.
- `2026-08-03` — **and the frame is wrong too, in the opposite direction from the last entry.**
  This item reads as though something confidential had escaped. Nothing did, and nothing in this
  repository is supposed to be confidential: it is open source, and the trust it asks for — a
  stranger's AI developer inside your codebase — is paid for in being readable. `#031` carries
  that argument.

  So the account name is not a **secret**, it is **noise**. Every public commit already carries
  the owner's name and two email addresses in its author metadata, deliberately and by ordinary
  git practice. What twenty-three occurrences of `C:\Users\<user>\source\repos\priv\…` add is one
  person's directory layout, in files that exist to record what a run did.

  That does not make the item wrong, it makes it **cheap and non-urgent**, and it changes what it
  is for. The reason to normalise those paths is that they are *irrelevant to the reader* — a
  capture is evidence about a run, and which folder it happened in on one laptop tells nobody
  anything. That reason survives whether or not the repo is public, which the old one did not.
- `2026-08-03` — two consequences of that, so the item can be planned rather than dreaded. **No
  history rewrite.** A force-push against a username that every commit publishes anyway is
  theatre, and it would break every clone for the contributors this project wants. **The scrubber
  is the real deliverable**, not the eight files: it should normalise machine-specific paths on
  the way in, so the count stops growing. Rewriting the eight on record is then optional tidying,
  and can wait for a pass that touches them anyway.
- `2026-08-03` — another file in the same class, found while scoring `2026-08-03-r12`, and it is not
  one of the eight: **`score-bundle.ps1` copies the CLI's own transcript out of
  `~/.claude/projects/`, not the scrubbed capture in `process/runs/<id>/`.** So every blind-scoring
  bundle carries unnormalised paths — 159,687 bytes against the capture's 146,904 for this run.

  Untracked and deleted with the bundle, so it adds nothing to the count and no urgency. It belongs
  here because it is the same root cause the entry above names as the real deliverable: one path
  through the harness knows about the scrubber and the others do not. A bundle built from the
  tracked capture would also be the *same* artifact the first scoring read, which is worth a little
  on its own — `score-b.md`'s record numbers do not line up with the report's for exactly this
  reason.
