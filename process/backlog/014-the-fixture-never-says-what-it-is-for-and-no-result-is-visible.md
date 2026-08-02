# `#014` — the fixture page never says what it is for, and no result a run produced is visible to anyone who did not run it

| | |
|---|---|
| Status | `formulated` |
| Gate | `none` |
| Attribution | owner decision |
| Criterion | — |
| Target file | `README.md` (root), `process/fixtures/<name>/`, a new `gh-pages` branch |
| Evidence | owner request `2026-08-02`; ten results on record, none of them reachable from this repository |
| Blocked on | `#018` — see B1 below; and `#013`, whose run capture produces the demos |
| Proof design | — |

**What happened.** Two absences that one change closes, and they are not equally cheap.

*The fixture is an arbitrary page.* `process/fixtures/static-site/index.html` is Acme Kite Co. — a
kite shop with three products, an about section and a smooth-scroll nav. Nothing on it says why it
exists. Opened by anyone who did not build the harness, it is a page about kites.

*And nothing a run produced can be looked at.* Ten hires implemented the same easter egg into that
page. What survives inside the repository is `runs/<id>.report.md` — a verdict — and, for exactly
one of them, `process/stacks/html/css/impl-01/step-4-result/`. Everything else sits in
`../monster-dev-testruns/`, outside the repository, which is `#013`'s subject. The root `README.md`
describes the product in prose, shows a still image of the monster, and links to no working example.
A visitor who wants to know what *"a walking-monster easter egg"* actually looks like has to hire an
agent to find out.

This is the one stack where fixing that costs nothing: plain HTML/CSS/JS, no build step, no
dependency. A `step-4-result/` **is** a runnable demo — it needs a static file server and nothing
else, and GitHub Pages is a static file server.

Worth recording while it is in view: `index.html` at the repository root is already a working
`dom-css` implementation. If Pages were ever switched on from the root it would already be live at
`https://diogenes25.github.io/Monster-dev/`, unlinked and unmentioned by anything.

**Why the current wording allows it.** No rule is broken and nothing is stale. The fixture's job is
stated as *"target-project templates; a run never modifies one"* and it does that job. Results were
never meant for an audience, because until `#008` there was nowhere to keep them at all. The root
README's *"Monster-Dev gets better by being tested"* section points at `process/runs/` for the
reports — verdicts, not artifacts.

**Proposed change — two halves, and only one of them is free.**

*Half 1 — publish the results. No fork here.*

> `demos/<run-id>/` holds a copy of each result that is a static site, taken from the run capture
> `#013` produces. The root `README.md` gains a **See it running** section listing them, each
> line naming the run id, the model and one sentence on what that run was for — rendered from
> `process/runs/<id>/`, never hand-written (**B7**).
>
> **The demos live on a `gh-pages` branch and are absent from `main` (answer B3).** Ten finished
> implementations of the precise job are the answer sheet; a hire could copy one wholesale. The
> first draft of this item contained them with a mirror exclusion, and that does not hold: a run
> over real `raw.githubusercontent.com` URLs — `2026-08-01-live` was one — never reads a mirror at
> all, and once Pages is on, `docs/demos/<run-id>/` is world-readable at a guessable URL no matter
> what `build-dist.ps1` says. The base URL a hire derives in §0 points at `main`. Keep the demos off
> `main` and the exposure closes structurally, for both run classes at once.
>
> **What that deletes from this item:** the `docs/` exclusion glob, the matching backstop entry, the
> `docs/*` filter in `check-index.ps1`'s stray-sheet scan, and the mirror inspection that would have
> had to follow. Four hand-written strings that are not written. The publish step becomes a
> branch push instead of a copy into the working tree.

*Half 2 — the description. This is a fork, and it is the owner's.*

The requirement text proposed on `2026-08-02` — *"Dies ist eine Beispiel-HTML-Seite, in der ein
Easter-Egg einprogrammiert werden soll: ein Monster, das von links nach rechts läuft, wenn Alt+A
gedrückt wird"* — is what makes a demo self-explanatory. Land on the page, read what was asked,
press Alt+A, watch it happen. Where that text lives decides what it costs.

- **(a) In the published demo only**, injected by the publish step as a banner above the result.
  Costs nothing measurable: the fixture does not change, no comparability is lost, no hire ever sees
  it. The price is that `docs/demos/<id>/` is then not byte-identical to what the hire handed back —
  a claim `step-4-result/` makes and needs to keep, and one a demo page never made.
- **(b) In the fixture, phrased as a customer wish.** The demo needs no wrapper and the fixture
  stops being arbitrary. But the fixture is copied into the hire's working directory, so the
  requirement would then sit in the project *and* in the brief. §4 exists because a real customer is
  vague; a written spec inside the repo changes the pressure on `4a` (asked about repeat behaviour
  unprompted), `7` (asked **before** building) and `14a` (offered the monster choice at all) — three
  of the criteria this project's measurement leans on hardest. It also ends comparability with all
  ten runs on record, and the text becomes a live candidate for the hire to update or delete once
  the egg exists, landing in the §9 diff surface. If chosen, it belongs to a **new fixture and
  scenario pair**, never to `static-site`.
- **(c) Both** — (a) for the existing fixture, (b) as a new *"the spec is in the repo"* fixture,
  which poses a question worth a run on its own: does a hire still ask when the answer is written
  down next to it?

Recommendation: **(a) now**, because it is free and delivers the visitor experience in full, and
**(c) later** if that question turns out to be worth a run.

Whichever is chosen, the description states what the **customer wants** and never what Monster-Dev
should do. See `#015`: a paragraph of the second kind has been reaching hires since the first run.

**Proof design.** *`Gate: none`* for Half 1 and for option (a) — presentation, no criterion to flip,
reaches `proven` by being applied. Option (b) is a scenario change: it needs its own item, its own
fixture and its own run before any number out of it is compared with anything.

**Cost.**

- **A second branch is a second thing that goes stale.** `gh-pages` has no CI behind it, so a demo
  is published by whoever remembers to push it. Against that: it is the *only* mitigation that
  survives a real-URL run, and a stale demo is wrong about an old run rather than dangerous to a
  new one.
- **A setting outside the repository.** Pages has to be switched on and pointed at `gh-pages`.
  Nothing in the tree can enforce that, and a remembered step is the failure mode this project has
  already had twice. The mitigation is that the README link is visibly broken until it is done.
- **Each demo duplicates a 1.9 MB sprite** — on `gh-pages`, so `main`'s checkout does not grow at
  all. Cheaper than the first draft of this item, which put ten copies in every clone.
- **`index.html` at the repository root is already a live implementation.** If Pages is ever pointed
  at `main` instead of `gh-pages`, it serves at `https://diogenes25.github.io/Monster-dev/` — and
  more to the point, it is on `main` today and reachable by any hire that goes looking. That is not
  this item's to fix, but switching Pages on is the moment someone notices it.
- **A published demo makes `process/` look publishable.** That is `#013`'s sharpest cost arriving by
  a second road. The demos being *copies* on another branch, rather than the root README linking
  straight into `process/stacks/`, is the mitigation.

*Withdrawn by answer B3, recorded because they were booked:* the `docs/` exclusion glob and its
backstop entry, the resulting four hand-written strings in `build-dist.ps1`, and a `docs/*` filter
in `check-index.ps1:162` — that scan would have gone red on the first published demo, printing
*"reaches the mirror"* about a folder this item excluded from the mirror. None of it is needed once
the demos are off `main`.

**Log.**

- `2026-08-02` `intake` — owner: a fixture should state the problem it poses, results should be
  linked from the root README so a GitHub visitor sees examples, and for plain HTML/CSS/JS a live
  in-browser result needs nothing installed.
- `2026-08-02` `formulated` — split into a free half and a forked half once the fixture copy was
  actually measured. The description's *audience* turned out to be the whole question, and `#015`
  was found while establishing it.
- `2026-08-02` — one cost inverted during the PM pass. Publishing a demo does not load-test
  `check-index.ps1`'s stray-sheet scan; it **breaks** it, because `docs/` is in neither of the two
  filters at `:162`. A sub-deliverable now covers that. Three questions this item cannot settle
  alone are in `DISCUSSION-2026-08-02.md`: `#018` removes the root README from the mirror while
  this item writes ten run ids into it, so the two are compatible only in one order (**B1**);
  this item adds the hand-written path name that `#018` exists to abolish, and `#018`'s grep is
  `.md`-only so the demos would slip past it anyway (**B2**); and mirror exclusion is not
  containment for a real-URL run or for a published Pages site (**B3**).
- `2026-08-02` — all three answered, and **B3 reshaped Half 1**. The demos move to a `gh-pages`
  branch and leave `main` entirely, which closes the exposure for the real-URL run class as well as
  the mirror one, and deletes four hand-written strings, a `check-index.ps1` change and a mirror
  inspection from this item. **B1**: `#018` is now a recorded precondition, in both items — until
  `README.md` leaves the mirror, the *See it running* list is ten scored run ids in front of every
  hire. **B2**: the general guard against a published implementation lives in `#018`, keyed on the
  sprite rather than on a path. **B7**: the README lines are rendered from `process/runs/<id>/`,
  not hand-written, so they cannot drift from `#012`'s column.
- `2026-08-02` — **C1**: the two references to *"`#013` Part 1"* are re-pointed. The demos come from
  the run capture, which stays `#013`; the folder they are rendered from is `#023`. Both are now
  named by what they do rather than by a part number that has been renumbered once.
