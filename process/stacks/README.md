# The implementation record

One folder per implementation Monster-Dev has actually carried out, kept as the four steps the
job goes through: **fixture → requirement → process → result**. Created once, from a job that
really happened, and then left alone. These are records, not tests — nothing here is re-run and
nothing here is scored.

They exist because `runs/` keeps *verdicts* and throws away the *course*. A report says criterion
18a passed; it does not say what the injection point was, why that file, or what the monster's
stride turned out to be. `#006` is stuck on precisely that shortage: there is no raw trace in the
repository from which a gate-able hypothesis could be drawn.

**Never fetched.** This whole tree sits under `process/`, which `build-dist.ps1` excludes from
the mirror. See "Two trees" below for why that is the point rather than a limitation.

## Layout

```
<language>/<library>/
  knowledge.md              what holds across every impl on this surface
  impl-NN/
    knowledge.md            first line: Stack: <published stack name>
    step-1-fixture/         the project as it was handed over, frozen
    step-2-requirement/     target-wish.md, dialog-NN.md — the customer's side
    step-3-process/         step-01-….md, step-02-….md — what was actually done
    step-4-result/          the project as it was handed back
```

Language and library folders come into existence **with their first implementation**. An empty
`csharp/maui/` is a promise, and a promise in a directory tree is the same failure
`check-index.ps1` reports as `DEAD POINTER` when §2 lists a stack that is not there. The
convention is settled — `csharp/`, `html/`, `javascript/`, `typescript/`, then the library
(`maui`, `razor`, `css`, `plain`, `angular`) — but a folder appears when there is something to
put in it.

`step-1-fixture/` duplicates a folder from `fixtures/`, on purpose. `fixtures/` is the living
template and gets maintained; `step-1-fixture/` is the frozen state *this* implementation
actually started from. Without the copy, `step-4-result/` is in a year a diff against something
that no longer exists.

## Two trees, one direction of flow

This tree is keyed by **language → library**. The published `stacks/` at the repository root is
keyed by **rendering surface + animation primitive**, and those are not the same question: a
TypeScript Angular app and a plain HTML page can both be `dom-css`, while two C# projects can be
entirely different jobs.

Both keys are allowed to exist only because each `impl-NN/knowledge.md` opens with a `Stack:`
line. That line is the whole of the mapping, and without it nobody can say which published note
an observation belongs to.

The flow between them runs one way and passes through a gate:

```
impl-NN/knowledge.md  →  A/B gate  →  stacks/<name>/README.md  →  a hire
   (raw, never read)     (a run)      (published, measured)
```

Nothing skips the middle box. Material collected once has no second arm by definition, which is
exactly why it may be collected freely here and may not be published from here. Writing a
plausible line straight into a published note is the failure the gates exist to prevent, and this
tree makes that failure *easier*, not harder — so the rule is stated rather than assumed.

## How the files here are written, and why not the same way as `process/runs/`

Two conventions live under `process/`, and the boundary between them is a directory name:

| | `process/runs/*/knowledge.md` | `process/stacks/**/*.md` |
|---|---|---|
| Frontmatter | Open Knowledge Format, required `type` | **none** |
| First line | `---` | `Stack: <published stack name>` |
| Tags | free-form, lowercase-kebab | none |
| `[[wikilinks]]` | yes | yes |

That split is not tidiness deferred. OKF makes the first line `---` and has no field for a
published stack — `resource` is spent on the run id — and the `Stack:` line is the entire mapping
between this tree's key and the published one's. A metadata convention is not a good enough reason
to move a line the two-tree design rests on, so this tree keeps plain Markdown.

The honest consequence, recorded rather than absorbed: the tag layer covers `process/runs/` and
**not this tree**, which is the one the navigability complaint was actually about. What remains
reachable here is the `Stack:` line and wikilinks. A tag layer over `process/stacks/` needs its own
decision; the frontmatter route to it is closed and no other route has been designed.

**Wikilinks are body syntax and work in both trees.** `[[2026-08-01-plan-sonnet]]`,
`[[impl-01]]`, `[[name|label]]` — a target is the name of a record folder or the stem of a file in
the tree, and `check-index.ps1` fails on one that resolves to nothing, exactly as it fails on a
`DEAD POINTER`. A graph with no checker is index drift under a nicer name.

**Nothing writes into `step-1-fixture/` or `step-4-result/`.** They are byte copies by design; a
copy that has been edited is not a copy. `check-index.ps1` skips them rather than exempting them,
because an exemption is something the next convention argues with.

**And the sharpest cost of making this tree pleasant to read.** The one-way street above holds
partly because this is awkward prose nobody would think to ship. Remove that accidental friction
and only the gate is left holding the line — which is why `build-dist.ps1` refuses any mirror
containing a `.md` whose first line is `---`, or containing `[[` anywhere. A paragraph promoted
through the gate carries its syntax with it, and this is the tree paragraphs are promoted *from*.
