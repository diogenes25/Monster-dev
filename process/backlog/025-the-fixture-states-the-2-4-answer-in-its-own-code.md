# `#025` — the fixture states the §2.4 answer in its own code, where no README rewrite reaches it

| | |
|---|---|
| Status | `formulated` |
| Gate | `none` |
| Attribution | harness artefact |
| Criterion | `8` — and §2.4, the judgement `gsap-site` exists to measure |
| Target file | `process/fixtures/static-site/script.js` |
| Evidence | found `2026-08-02` by the `leak-auditor` on its first pass, blind to the board; read against the file the same day |
| Proof design | — |

**What happened.** `process/fixtures/static-site/script.js:1-2`, the first two lines of the file:

```js
// Smooth-scroll to in-page sections. That's the only JS this site has —
// no animation library, no framework.
```

That is the §2.4 answer, stated in the project's own voice, in the first file a hire opens when it
goes looking for the animation primitive. §2.4 asks *which primitive does this project already
animate with* — and criterion `8` scores *idiomatic plain CSS/JS, no dependency, no new animation
library*. The comment answers both before the analysis starts.

**It is a different leak from `#015` and that item's fix does not reach it.** `#015` rewrites the
three fixture READMEs and adds a scan for the product names `Monster-Dev` and `MonsterLib` to
`new-run.ps1`. This comment is in neither class: it is not a README, and it contains neither product
name — nor any harness vocabulary, nor a playbook section number. A scan tuned to catch it would
have to catch *"no animation library"*, which is an ordinary sentence a real project could write.

**Why the current wording allows it.** The same root cause `#015` names, one layer deeper. The
fixture folder was never split into *the target project* and *our notes about the target project*,
so the notes are simply inside the project — and here they are inside its source, where the split
`#015` proposes cannot separate them. A comment is part of the code.

The uncomfortable half: **a real project might well carry this comment.** It reads like something a
developer writes to stop the next one reaching for a library. That is exactly what makes it hard —
`#015`'s rule *"a fixture contains only what the target project would contain"* does not exclude it,
because a target project would contain it.

**Proposed change.**

> The comment is rewritten to describe what the code does without ruling anything out:
>
> ```js
> // Smooth-scroll to in-page sections.
> ```
>
> The rest of the sentence is what a hire is supposed to *determine*. That the site has no animation
> library remains true and remains discoverable — from `package.json`, from the absence of any
> import, from the CSS. §2.4 is a search, and this comment ends it in one line.
>
> The general rule, stated so the next fixture does not repeat it: **a fixture may not assert the
> absence of something a hire is scored on finding.** Presence is fair — a real project's code says
> what it uses. Absence, stated in prose, is the answer sheet.

**Proof design.** *`Gate: none`.* Half C: *"fix the harness, rerun, record nothing against the
product."* No wording changes and nothing is claimed about hire quality.

Unlike `#015`, this leaves **no boundary to record on the runs on record**. Whether a hire read
`script.js:1` cannot be recovered the way the README string was: the file is small enough that
every hire read all of it, so the string is in every transcript that touched the file, and reading
`script.js` is a correct move a hire is supposed to make. There is no clean arm to compare against
and no contamination to date. What can be said is that criterion `8` passed in every run and now
has one more reason it might have.

**Cost.**

- **Criterion `8`'s evidence weakens further.** `#015` already took it from ten clean passes to
  four; this takes the remaining four down as well, because the split there was by model and this
  file is in every run folder. `8` is not thereby wrong — it is unproven, and saying so is the
  point of writing this down.
- **The rule proposed above is a judgement call, not a grep.** *"Do not assert the absence of what
  is being scored"* cannot be mechanised, so it has to be read and applied by whoever writes the
  next fixture. That is what the `leak-auditor` is for, and this is the first finding it produced
  that no deterministic check could have.

**Log.**

- `2026-08-02` `intake` — from the `leak-auditor`'s first pass, recorded in `#017` and never filed.
  Three findings were in that report; this is one. Filed as answer **E1**.
- `2026-08-02` `formulated` — read against the file before being written down. It is genuinely
  outside `#015`'s reach: no product name, no section number, no harness vocabulary.
