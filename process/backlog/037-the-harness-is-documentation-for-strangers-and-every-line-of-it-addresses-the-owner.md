# `#037` — `process/` is documentation for strangers now, and every line of it addresses the owner

| | |
|---|---|
| Status | `formulated` |
| Gate | `none` |
| Attribution | harness artefact |
| Criterion | — |
| Target file | `process/README.md`, `process/backlog/README.md`, `process/stacks/README.md`, `process/fixtures/*.md`, the root `README.md` |
| Evidence | owner statement of the contribution model, `2026-08-03`, recorded in `#031` |
| Blocked on | nothing |
| Proof design | — |

**What happened.** The contribution model is: somebody clones this repository, poses their own
requirement against their own stack, runs a hire, and pushes the result back as another test. That
is why nothing here is secret and why `process/` is public on `main` — `#031` carries the whole
argument.

It follows that `process/` is no longer the owner's workshop. It is **the instructions a
contributor follows**, and it is the only ones there are. Read with that in mind, it addresses one
person throughout, and that person already knows everything the text leaves out.

Concretely, and none of these is a wording nit:

- **The procedure starts at step 0 and assumes the board.** *"A run's brief comes from an item in
  `grilled`; no item, no run."* A contributor has no item, no board history, and no way to grill
  one against evidence they were not there for. Their brief is *"I want this in my Vue app"*. The
  gate that protects the measurement is also the gate that stops the contribution.
- **Every path is relative to one machine's layout.** `..\monster-dev-testruns\` is a sibling of
  the repository by convention that exists nowhere but in prose, and `new-run.ps1` assumes it.
- **The tooling is documented as *"never fetched by a hire"***, which is true and, for a
  contributor, beside the point — they clone it and need to *run* it. `build-dist.ps1` in
  particular is described by what it keeps out rather than by what a contributor uses it for.
- **The bar is stated as a Sonnet-class hire** and the gates are stated in `total_cost_usd` and
  `num_turns`. Both presume the contributor is paying for the same model on the same plan, and
  neither says what to do when they are not.
- **Nothing says what a good contribution looks like.** A new stack note, a new fixture, a run
  record — the shapes exist and are documented as records of jobs already done, not as things to
  submit.

**Why the current wording allows it.** It was written when there was one reader, and it is
accurate for that reader. This is not staleness of the `#003` kind — no sentence has become false.
The audience widened underneath a document that never claimed to have one.

**Proposed change.** Not a rewrite. The cheap version first, because the expensive version is a
guess about contributors who do not exist yet:

> A `CONTRIBUTING.md` at the root that says what a contribution *is* in this project — a run
> against a surface that has none, its record, and what it turned up — and names the three things
> a contributor must not have to reverse-engineer: where the run folder goes, that the mirror is a
> blindfold rather than a secret (link `#031`), and what the board is for and when they can skip
> it.
>
> **The board question is the real one and this item does not settle it.** Either the `grilled`
> gate applies only to runs that will produce a *measured claim* about the playbook — leaving a
> contributor free to run against a new surface and submit the record without one — or every
> contribution needs an item and the barrier is deliberate. Both are defensible; the first is
> almost certainly right, because a first run on a new surface has nothing to A/B against and
> `#005`, `#006`, `#011` and `#022` are all stuck in exactly that position already.

**Proof design.** *`Gate: none`.* Nothing to measure — no contributor exists yet, which is also
the honest reason not to build more than the cheap version.

**Cost.**

- **Writing for an audience that does not exist yet is how documentation goes stale before it is
  read.** Mitigated by keeping it to what is already decided and linking out for the rest.
- **A `CONTRIBUTING.md` is a promise.** It says contributions are wanted, and the first one will
  arrive with a stack, a fixture and a record that do not match any convention here exactly. That
  is the point, and it will still be work.
- **The board gate genuinely protects something.** Loosening it for contributors risks the thing
  `README.md` calls absolute. Naming the fork rather than resolving it is deliberate.

**Log.**

- `2026-08-03` `formulated` — opened by the owner's statement of the contribution model while
  `#031` was being re-read. `#031` closed on that statement; this is the part of it that is not
  about the mirror.
