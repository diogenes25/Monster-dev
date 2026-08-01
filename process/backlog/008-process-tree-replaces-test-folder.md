# `#008` — `test/` is named after a method the second feature no longer only uses, and the record it keeps is a score with no trace behind it

| | |
|---|---|
| Status | `proven` |
| Gate | `none` |
| Attribution | owner decision |
| Criterion | — |
| Target file | harness |
| Evidence | owner proposal 2026-08-02 (no run) |
| Proof design | — |

**What happened.** Filed from the owner's proposal, quoted verbatim so the intent survives the
restructure:

> Ich würde den Test-Ordner lieber in "Prozess" umbenennen.
> Darin die Stacks in der Aufteilung Programmiersprache -> Library.
> Beispiel:
> prozess
> - C#
>   - MAUI
>   - Razor
> - HTML
>   - CSS
> - JavaScript
>   - Plain
> - TypeScript
>   - Plain
>   - Angular
>
> Jeder Stack hat einen Prozess der von einen oder mehre durchgeführte Implementierungen:
> Fixture -> Anforderung -> Prozess -> Result
> Beispiel:
> - HTML
>   - CSS
>     - Impl_01
>       - Step1_Fixture
>          - index.html
>       - Step2_Anforderung
>          - target_wish.md
>          - Dialog01.md
>       - Step3_Prozess
>           - Step_01_DidThis.md
>           - Step_02_DidThat.md
>       - Step4_Result
>           - index.html
>
> Diese Daten werden einmalig erstellt. Es sind also keine Tests. Die Ergebnisse dienen der
> Dokumentation und des Trainings des Monster-Dev.
> In den jeweiligen Ordnern steht eine knowledge.md Datei mit Erkenntnissen aus der
> Implementierung.

The gap it names is real and already on this board. `runs/` stores *verdicts* — criterion met or
not — and never the course of the work. `#006` is stuck for exactly that reason: the only stack
note is pure orientation, so a hire that read it and a hire that did not produce identical work,
and there is nothing for a verifier to key on. There is no raw trace anywhere in the repository
from which a gate-able hypothesis could be drawn.

**Why the current wording allows it.** Nothing is wrong with the playbook; this is a change to the
developer-side half. Two of its own rules do collide with the proposal as written, and both were
resolved by the owner before this item was filed:

- `CLAUDE.md` keys stacks by *rendering surface + animation primitive*, explicitly **not** by
  language — *"a TypeScript React app and a plain HTML page can be the same job"*. Language →
  library is a second key, not a replacement for the first.
- The gates say *"none of them grows on a hunch"*. Material created once has no second arm, so it
  cannot be published under a gate that requires one.

**Proposed change.** Two trees with one direction of flow between them. `process/stacks/` is
keyed by language → library and is never fetched; `stacks/` stays at the repository root, keyed by
surface + primitive, and remains the only thing `MONSTER-DEV.md` §2 points at. Each
`impl-NN/knowledge.md` opens with a `Stack: <name>` line, which is the whole of the mapping
between the two keys.

> ```
> process/
>   README.md  backlog/  tools/  fixtures/  scenarios/  runs/
>   stacks/<language>/<library>/
>     knowledge.md
>     impl-01/
>       knowledge.md            first line: Stack: <published stack name>
>       step-1-fixture/         the starting state, frozen
>       step-2-requirement/     target-wish.md, dialog-01.md — the customer's side only
>       step-3-process/         step-01-….md, step-02-….md — what actually happened
>       step-4-result/          the end state
> ```
>
> `process/stacks/` is raw material and documentation, not a second route to publication. Nothing
> in a `knowledge.md` reaches a published stack note without passing its gate.

Language and library folders come into existence with their first implementation. An empty one is
a pointer to nothing — the same failure `check-index.ps1` already reports as `DEAD POINTER`.

**Proof design.** *`Gate: none`.* A restructure of the developer-side half has no criterion to
flip and no run worth spending. It is worth saying plainly rather than leaving implied: this item
reaches `proven` by being *applied*, not by being *shown to help*. Whether the tree improves
anything is not measured, and no measurement is planned.

**Cost.** Four places break on the rename, and the two that matter break **silently in the unsafe
direction**:

| File | Line | Consequence without the fix |
|---|---|---|
| `tools/build-dist.ps1` | 66 | `'test/*'` matches nothing, so the board, the scenarios and the acceptance criteria ship in every hire's mirror |
| `tools/build-dist.ps1` | 79 | the backstop looks for a directory named `test`, finds none, and reports clean — both layers of the guard fail together |
| `tools/check-index.ps1` | 162 | the stray-sprite-sheet scan stops skipping this tree |
| `tools/hire.ps1` | 75, 85 | file-not-found; loud, therefore harmless |

`check-index.ps1:162` gains a second reason to matter: it flags any PNG outside `monsters/` whose
aspect ratio is ≥ 5, and a `step-4-result/` of an HTML/CSS implementation contains exactly such a
file. Renaming the exclusion is not enough — it has to be exercised once with a real
`step-4-result/` in place, or the check is red from the first implementation onward and gets
switched off instead of repaired.

Beyond the scripts: ~50 documentation references across `CLAUDE.md`, the `monster-dev-workshop`
skill and its templates. `START.md`, `MONSTER-DEV.md`, `.gitignore` and `.vscode/` contain none and
stay untouched. Run reports keep their old paths — they are evidence, not signposts.

One rule is bent rather than kept. `Evidence` is mandatory because *"an item with no run behind it
is a hunch"*, and this item has no run. An owner decision is not a hunch from a report, so the
field names the decision and its date. The alternative — a second `DECISIONS.md` beside the board
doing the same job — costs more than the stretch does.

**Log.**

- `2026-08-02` `intake` — owner proposal, no run behind it.
- `2026-08-02` `formulated` — attributed as an owner decision. Two collisions with existing rules
  resolved before filing: two trees rather than one, and `knowledge.md` as raw material that never
  bypasses a gate. Naming settled as English kebab-case, so `process/` and not `prozess/`.
- `2026-08-02` `proven` — applied. `git mv test process`, all four script sites fixed, ~50
  documentation references pulled across, and `process/stacks/html/css/impl-01/` built from run
  `2026-08-01-plan-sonnet` — real fixture, real dialogue, real output, not a reconstruction.

  The `check-index.ps1:162` hazard predicted above turned out to be live, not theoretical. The
  implementation's own `step-4-result/assets/monster-sprite.png` is tracked at 6348×300, ratio
  **21.2** — the highest of any PNG in the repository and far past the ratio-5 threshold. With the
  exclusion still reading `test/*` it would have been reported as a `STRAY SHEET` from the moment
  the record was committed. The renamed line is genuinely load-bearing rather than cosmetic.

  Verified: mirror built and inspected (19 files, no `process/`, no `.claude/`, no `CLAUDE.md`,
  `index.html` and `stacks/dom-css/README.md` present), `check-index.ps1` clean, board clean,
  `Test-SheetLoop.ps1` unchanged.
