# `#006` — §2 stack resolution is unproven because the only stack note leaves no fingerprint

| | |
|---|---|
| Status | `formulated` |
| Gate | `run` |
| Attribution | harness artefact |
| Criterion | §2 stack resolution |
| Target file | — |
| Evidence | `2026-08-01-live`, `2026-08-01-phase2b` |
| Blocked on | a gated pitfall in any published stack note |
| Proof design | — |

**Nothing here changes a file, and that is the item.** It used to name
`stacks/dom-css/README.md` as its target while its own text said *"Nothing is wrong with the
product"* and its proposed change was *none, on principle*. The target row is empty now: what this
item carries is the caveat every report has to repeat — §2 resolution is **unproven, not passed** —
and the condition under which that stops being true.

**What happened.** `2026-08-01-live` proved §0 and §5 over real URLs but had to record §2 as
**unproven rather than passed**. `stacks/dom-css/README.md` is 35 lines of orientation with
nothing below the `---` rule, so a hire that read it and a hire that did not produce identical
work. There is no behaviour for the verifier to key on.

The only trace a run has ever produced is `phase2b`'s *"Das entspricht dem Stack `dom-css`, für
den es Notizen aus früheren Jobs gibt (gelesen)."* — which is a hire reporting that a file was
read. That is bookkeeping from this side of the fence, it tells the client nothing, and criterion
21 now scores it as a **failure**. So the one observable trace of stack resolution is the one
thing the playbook has since been changed to suppress.

**Why the current wording allows it.** Nothing is wrong with the product. The note being pure
orientation is the honest state of the measurement — both `dom-css` pitfalls from `alt-a` were
solved unprompted by every hire since, on both models, which left them with no arms to separate
and removed them from the note. An empty pitfall section is what "nothing measured yet" looks
like; it is not a gap waiting to be filled with plausible advice.

**Proposed change.** None. Filling the note to make it measurable would be writing untested
content to satisfy a measurement, which is the exact failure the gates exist to prevent.

**Proof design.** Not designable now, and saying so is the point. §2 resolution becomes
observable the first time a stack note carries a **gated pitfall** — then the A/B arm without the
note fails something, and resolution is proven as a side effect of proving the pitfall. Until
then §2 stays *unproven* in every report and is never upgraded to *passed*. Related: `#005`,
whose second row is the other route to a fingerprint.

**Cost.** None to leave open. The cost of closing it wrongly is a report claiming the hire
resolved the stack when nothing in the evidence distinguishes that from a hire that skipped it.

**Log.**

- `2026-08-01` `intake` — from `2026-08-01-live`, recorded there as unproven rather than passed.
- `2026-08-01` `formulated` — attributed as a harness artefact: the product is fine, the
  measurement has no signal.
- `2026-08-02` — re-filed, answer **A4**. The item had been sitting against three of its own
  statements. Target file dropped: it named a published product file while the body said nothing
  was wrong with the product and proposed no change. `Blocked on` added, so `Gate: run` +
  `harness artefact` is now coherent — the lane says a run will prove it, the attribution says the
  instrument is what is at fault, and the new field says why neither can happen yet.
- `2026-08-02` — **B4**: `#013` had claimed its run capture would supply *"the exact trace this item
  is short of"*, and `#012` had said the opposite. `#012` wins and `#013`'s sentence is withdrawn.
  What the capture gives this item is an instrument — once a second published note exists, the
  transcript will show which one was fetched — and nothing before then. `Blocked on` is unchanged.
