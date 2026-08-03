# `#031` — the mirror is a blindfold, not a vault: the harness is public by design, and one run class is not blindfolded

*Filed under the opposite title and re-read the next day. The original heading — "the mirror
exclusion buys nothing against a real-URL run, because the whole harness is public on `main`" —
treated the public harness as the defect. It is the design. What is left is a narrower and real
thing: one run class wears no blindfold, so its validity is checked rather than assumed.*

| | |
|---|---|
| Status | `proven` |
| Gate | `none` |
| Attribution | harness artefact |
| Criterion | every criterion, for one run class — the setup answers them all |
| Target file | `CLAUDE.md` (new section), `SKILL.md` (the standing transcript audit) — the branch layout was **not** changed, see the log |
| Evidence | measured `2026-08-02` against the live repository, unauthenticated; `2026-08-01-live`'s captured transcript |
| Blocked on | nothing |
| Proof design | — |

**What happened.** `CLAUDE.md` calls the mirror exclusions *"the one invariant that silently
invalidates everything"*, and `build-dist.ps1` enforces four of them by name plus two path-free
checks. All of that protects exactly one run class. The other class — a hire fetching over real
`raw.githubusercontent.com` URLs, which is the class `2026-08-01-live` belongs to — never reads a
mirror at all. It reads `main`. And `process/`, `.claude/` and `CLAUDE.md` are all *tracked*,
which is stated everywhere in this repository as a reason for care, and all three are therefore
on `main`.

`main` is public. Measured today with no credentials:

```
process/backlog/README.md                 HTTP 200
process/scenarios/alt-a-left-to-right.md  HTTP 200
process/README.md                         HTTP 200
CLAUDE.md                                 HTTP 200
.claude/agents/run-scorer.md              HTTP 200
```

The scenario file is the one document this project says a hire must never see. It is at a URL,
served to anybody, on the branch §0 resolves to.

**The reasoning that was supposed to prevent this, and where it fails.** Two sentences in
`CLAUDE.md` carry the whole argument that an unpointed file is unreachable:

> `raw.githubusercontent.com` serves no directory index, so an unlisted stack is unreachable

True, and irrelevant. `raw.githubusercontent.com` is not the only public endpoint on this
repository:

- `https://github.com/diogenes25/Monster-dev/tree/main/process/scenarios` — HTTP 200, an HTML
  directory listing, fetchable by the same `WebFetch` the playbook already tells a hire to use.
- `https://api.github.com/repos/diogenes25/Monster-dev/git/trees/main?recursive=1` — HTTP 200,
  unauthenticated, and it returned **397 paths in a single request**. Every file in the
  repository, named, in one call.

So the protection is not "no index exists". The protection is "the hire has no reason to look",
which is a different and much weaker claim, and it is not written down anywhere as the thing being
relied on.

**The sharpest part is `CLAUDE.md` itself.** It is not merely one more exposed file — it is the
*index* to all the others. It names `process/backlog/` as full of acceptance criteria,
`process/scenarios/`, the two check agents, the proof gates, the bar model, and the fact that a
hire is a measured subject. And it sits at the single most guessable path in any repository, on a
public branch, while a Claude-based hire has a strong prior to look for exactly that filename.
One `WebFetch` of a conventional name hands over the entire map. The mirror excludes `CLAUDE.md`
by hand, in two places, verified by a backstop — and that exclusion buys nothing at all here.

**What the one measurement on record says.** `2026-08-01-live` is the only run in the real-URL
class, and `#012` captured its transcript, so this is measurable rather than arguable. It fetched
five URLs and no others:

```
main/START.md   main/MONSTER-DEV.md   main/stacks/dom-css/README.md
main/index.html   main/monsters/green-fuzz-classic.png
```

Every one is pointed at by the playbook. It never fetched `CLAUDE.md` and never touched
`process/`. The single occurrence of the string `CLAUDE.md` in that transcript is the hire's own
system prompt listing the `/init` command, not a fetch.

That is a real and reassuring data point, and it is **n = 1**. It says the exposure has not been
exercised. It does not say it is contained, and one clean run is exactly the evidence this project
refuses to accept in the other direction — `#018` was a leak that survived ten runs before anybody
looked.

**Why the current wording allows it.** This is not new reasoning; it is `B3` finished. The
discussion of `2026-08-02` asked it in as many words — *"Does the real-URL run class survive
publication at all, and if so what contains the answer sheet for it?"* — and recommended
publishing from a branch that is not `main`. That recommendation was applied to the **demos** and
closed as part of `#014`. Nobody carried the same sentence back to `process/`, which was already
on `main` while the question was being asked about a folder that did not exist yet.

The gap is therefore structural and predictable: B3 was filed under `#014`, so it was answered by
`#014`'s author, about `#014`'s subject.

> **Superseded `2026-08-03`, before any of it was acted on.** The three options below were written
> on the assumption that public readability is an exposure to be reduced. It is not — it is the
> project's design, and two of the three would have broken the thing this repository exists to do.
> They are kept because they were offered and because the reasoning that killed them is the item's
> actual content. **Read the log first.**

**Proposed change.** Three options, and the choice is the owner's because it moves the shape of
the repository.

- **(a) The harness leaves `main`.** `process/`, `.claude/` and `CLAUDE.md` live on a `dev` branch;
  `main` carries only what a hire may see. This is exactly what was decided for the demos, applied
  to the thing the demos were an instance of, and it closes both run classes at once by making the
  files absent rather than unmentioned. It is also the most disruptive: day-to-day work happens on
  the harness, so `dev` becomes the working branch and `main` becomes an export — and an export
  that somebody has to remember to update is the failure mode this project has already had twice.
- **(b) Two repositories.** The product is public, the harness is a private repo. Cleanest
  separation, and the one that cannot be undone by a careless merge. Costs the single-tree
  convenience that makes `check-index.ps1` possible at all: it verifies §2 and §5 against
  `catalog.json` and the stack notes in one working tree.
- **(c) Make the repository private until the product is ready to publish.** Nothing moves, one
  setting changes, and every exposure in this item closes immediately — including `#029`'s. It
  costs the real-URL run class, because §0's derivation needs a public raw URL. That class is
  currently one run out of eleven, and it is the only way to test §0, §5's download split and stack
  resolution, so this is a real loss and not a free one.

**Recommendation: (c) now, (a) or (b) as the considered answer.** (c) is reversible, takes one
click, and buys the time to decide (a) versus (b) without the criteria being readable while the
decision is made. Nothing on the board needs a real-URL run before that decision — `#002` is the
only `grilled` item and its proof design is explicitly *"mirror both sides"*.

**Cost.**

- **(c) hides the product too.** A visitor cannot read `START.md`, and the hire flow this project
  exists to package stops working for anybody but the owner. That is acceptable only because it is
  reversible and because the product is not announced anywhere yet.
- **Whatever is chosen, the history is already public.** Making the repo private does not unpublish
  what has been fetched or cached, and this item should not be written up as though it did. That is
  the same correction `#029` just took.
- **(a) and (b) both break a claim that is currently load-bearing.** `process/stacks/**` cites runs
  by bare id *because* a path would become a live URL after the push. Under (b) it stops being a
  live URL and the rule loses its reason — the rule should stay anyway, but it needs a new one
  written down, or the next person deletes it as obsolete.
- **This item makes the mirror checks look pointless. They are not.** They are the only defence for
  the mirror class, which is ten of eleven runs on record. Nothing here argues for weakening them;
  it argues that they were never the whole answer and were documented as though they were.

**Log.**

- `2026-08-02` `formulated` — found while checking whether `#029`'s account-name exposure was
  actually public. It is, and it turned out to be much the smaller of the two things that are:
  the commit metadata on every public commit already carries the owner's name and two email
  addresses, deliberately and normally, so the marginal disclosure from a `C:\Users\…` path is a
  directory layout. The acceptance criteria being readable at a URL is the finding; the account
  name is how it was found.
- `2026-08-02` — the enumeration figure is measured, not estimated: one unauthenticated request to
  the trees API returned 397 paths. Recorded because *"serves no directory index"* appears in
  `CLAUDE.md` as a load-bearing sentence and is true only of the one endpoint it names.
- `2026-08-03` `proven` — **owner chose the fourth option: accept, deliberately.** (a), (b) and
  (c) are not rejected; they are unspent and stay written above, because the ground for accepting
  is a cost/benefit that will change the first time any of it changes. What was applied is the
  condition attached to that choice — the reasoning is now *written down* rather than resting on a
  sentence that does not carry it.

  `CLAUDE.md` gains a section under the mirror invariant saying plainly that the exclusions cover
  one run class, that the real-URL class is uncovered, that the only thing between a hire and the
  criteria is the absence of a pointer, and that the *"no directory index"* sentence must not be
  reached for — with the two endpoints that disprove it named and measured.
- `2026-08-03` — **the acceptance is conditional and the condition is now an instrument.** Half B
  of `SKILL.md` carries a standing step: after a real-URL run, list every URL the hire fetched out
  of the captured transcript and check it against the playbook's pointers, in the report. The
  command was run against `2026-08-01-live` before being written down — five URLs, all pointed at,
  which is the same five this item cites. An assumption with a cheap detector on it is a different
  object from an assumption; without the detector, "accept" would have meant "stop looking".
- `2026-08-03` — recorded because it cuts against this item: `#029`'s account-name exposure, which
  is how all of this was found, turns out to be the *smaller* of the two. Every public commit
  already carries the owner's name and two email addresses in its author metadata, deliberately
  and by normal git practice, so a `C:\Users\…` path adds a directory layout and not an identity.
  The recommendation to rewrite history was withdrawn on that ground before this item was written,
  and `#029` should be re-read with it.
- `2026-08-03` — **the framing above is wrong, and the owner said so.** Everything this item calls
  an *exposure* is the project's design. It is open source; the thing it distributes is a
  stranger's AI developer working inside somebody's codebase, which asks an unusual amount of
  trust and can only be paid for in legibility. A user who cannot read the acceptance criteria
  cannot judge the contractor. A contributor who cannot read them cannot do the thing this project
  wants contributors to do — clone it, pose their own requirement, push back another test.

  So options (a), (b) and (c) are **rejected, not deferred.** (b) and (c) do not merely cost more
  than the risk is worth; they abolish the contribution model, which is the point of the
  repository. (a) is milder but points the same way: a `main` that hides how the thing is measured
  is a `main` that asks for trust it has not earned. Nothing above should be reached for later as
  a mitigation in reserve.

  **What the item got right is the boundary, not the verdict.** A hire that reads its own criteria
  mid-run stops being a measurement — not because it learned a secret, but for the reason a
  subject is not told what is being scored while it is scored. The mirror is a **blindfold worn by
  one participant for the duration of an experiment**, and it says nothing about who else may
  look. Every measured thing in here survives that re-reading; only the words change:

  - the exclusions covering one run class is a **validity condition of the other class**, not a
    hole. The real-URL run stays uncontained on purpose and is checked instead.
  - the transcript audit measures **whether a run was contaminated**, not whether a secret
    escaped. Same command, correct name, and it is the reason the audit is the right instrument
    rather than a consolation prize.
  - `2026-08-01-live`'s five clean URLs are evidence about **that run**, and `n = 1` still means
    the next real-URL run has to be checked too — but a second one reaching for `CLAUDE.md`
    invalidates *the run*, not the repository.
  - the demos staying off `main` holds for the same reason and not a secrecy one: visitors and
    contributors **should** see ten finished results; a hire measured on the identical brief
    should not be able to copy one. `gh-pages` gets both at once.

  How the mistake happened, because it is the reusable part: the threat model was inferred from
  the harness's own internal language — *"the one document a hire must never see"* — instead of
  from what the project is for. Read only from the inside, "must not be seen by the subject" and
  "must not be public" look like the same sentence. They are not, and every question about the
  mirror answers itself once they are kept apart.
- `2026-08-03` — one thing this re-reading opens that is not this item's: if strangers contribute
  tests, `process/` stops being the owner's workshop and becomes **instructions for third
  parties**, and today every line of it addresses the owner. Filed as `#037`.
