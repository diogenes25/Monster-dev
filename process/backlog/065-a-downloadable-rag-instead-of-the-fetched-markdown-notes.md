# `#065` — a downloadable RAG instead of the fetched Markdown notes

| | |
|---|---|
| Status | `rejected` |
| Gate | `none` |
| Attribution | owner decision |
| Criterion | — |
| Target file | none — nothing was changed. This item **is** the record |
| Evidence | owner decision `2026-08-03`; corpus measured the same day against the working tree |
| Blocked on | nothing |
| Proof design | — |

**What was proposed.** Replace the Markdown knowledge layers — `MONSTER-DEV.md`, the stack notes,
and eventually `process/stacks/**/knowledge.md` — with a retrieval index (embeddings over chunks)
that the **user downloads** and that Monster-Dev queries instead of fetching files. Motivation:
keep the hire's context small as the layers grow.

**The corpus, measured.** Everything a hire fetches today is **19,775 B**: `MONSTER-DEV.md`
16,142 B, `START.md` 1,718 B, `stacks/dom-css/README.md` 1,915 B. The whole unpublished record
behind it — ten `impl-NN/knowledge.md` plus the collected `process/stacks/html/css/knowledge.md` —
is a further **23,394 B**. Both together are under 10k tokens. Retrieval earns its keep when the
corpus does not fit or when finding beats reading; here *reading all of it* is a fraction of one
turn. The premise the proposal rests on is not true yet.

**Why it was declined.** Four reasons, and the size figure above is deliberately the weakest of
them:

1. **It is the rejected alternative under a new name.** A knowledge store the user downloads is
   categorically the locally-installed Claude Code Skill that `CLAUDE.md` already declines, in
   favour of *"nothing installed, always fetched live from `main`"*. It is worse than a Markdown
   file in one specific way: it freezes at download time, while all three layers grow with every
   run. A stale index reports success.
2. **It breaks all three proof gates, which is the expensive one.** Every gate is a difference
   measurement — regression (a criterion must flip), A/B (with the lines against without), A/B with
   cost. Both require that (a) an arm can be built in which *exactly one paragraph* is missing —
   today `build-dist.ps1 -Without` is a file filter — and (b) both arms see the same thing
   deterministically. Vector retrieval gives neither: the chunk set moves with the query wording,
   so the A/B stops measuring the paragraph and starts measuring the retriever. `THESIS.md` says
   the monster is a fixture and measurability is the product; this trades exactly that away.
3. **The blindfold is grep-shaped.** `build-dist.ps1` greps every `.md` in the assembled mirror for
   the harness vocabulary and for sprite-sheet references, and `check-index.ps1` enforces the
   40-line orientation cap. None of those run against a binary index — each would have to be
   rebuilt weaker. Chunking also cuts through the *decision-shaped, not solution-shaped* entry
   form, whose whole point is that the fork and what settles it arrive in one piece.
4. **Retrieval already exists and is better at this scale.** The hire is an agent with
   Grep/Glob/Read over a repository, and §2 and §5 are hand-maintained indexes. Agentic search
   beats vector search over ~20 files. The real constraint is not finding but reachability — an
   unlisted stack cannot be fetched at all, since `raw.githubusercontent.com` serves no directory
   index. That is an *index* problem.

**Cost of declining.** §2 and §5 stay hand-maintained, so they can drift from the tree;
`check-index.ps1` is the mitigation and already exists. `MONSTER-DEV.md` at 16 KB is fetched whole
by every hire, and `#046` shows a hire reading the entire playbook before looking at the project —
so playbook length is a live cost, just not one a RAG is the cheapest answer to.

**What would change the answer**, stated so this is a threshold and not a dogma. Either signal, on
evidence and not on a hunch:

- a hire cannot pick its stack note from §2 alone — realistically at dozens of surfaces, and
  visible as a run that fetches the wrong note or fetches several; or
- a single stack note grows past what is worth reading whole, and a run's turn count shows it.

And the next step at that point is **not** embeddings but a machine-readable manifest — the shape
`monsters/catalog.json` already has for sheets: one fetch, deterministic, greppable, diffable,
and therefore still A/B-able. Embeddings would come after that, and as something fetched against
`main` (an MCP server), never as a download.

**Log.**

- `2026-08-03` `rejected` — owner decision, argued in session. Filed so the proposal is not re-had
  without the threshold above being met. No run was spent; nothing on the product changed.
