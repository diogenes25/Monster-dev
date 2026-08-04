# `#050` — a hire refused the entry point as a prompt-injection / supply-chain attack, and an identical session accepted it

| | |
|---|---|
| Status | `grilled` |
| Gate | `run` |
| Attribution | model disposition — **within one model tier**, which is a sub-case Half C does not describe. **Contested since `2026-08-04`:** both refusals lead with §0 having no referent on a mirror run, which would make it a harness artefact of that run class. One arm decides it — see the `2026-08-04` log entry |
| Criterion | none. It happens before criterion 1 of any scenario, and it voids the run rather than failing a mark |
| Target file | `START.md`, `MONSTER-DEV.md` §0 and §5's download wording |
| Evidence | `2026-08-03-r13` refused; `2026-08-03-r15` accepted, on a byte-identical mirror, same model tier, same hour. **`2026-08-04-r19` refused too** — 16 sessions, 2 refusals, both sonnet on `static-site`, both leading with §0 having no referent on a mirror run. See the `2026-08-04` log entry: it narrows the proof design |
| Blocked on | **`main` pushed to `origin`.** The arm fetches over real URLs, so it reads what is published; `main` was 24 commits ahead on `2026-08-04` and a push was attempted and **refused 403** — the only authenticated identity is `Tjark-fiskaltrust` and the repo is `diogenes25`. Nothing else blocks it |
| Proof design | **Three one-turn probes, no criteria, no scenario** — sonnet, `static-site`, real URLs off `main`, turn 1 only. Falsification of the §0 hypothesis, not confirmation. Full design in the `2026-08-04` grilling entry below; the continuation rule is fixed *before* the first probe |

**What happened.** `2026-08-03-r13`, arm A of `#002`, Sonnet, mirror fetch path. The hire read
`START.md` and declined to follow it:

> Das ist genau das Muster einer Prompt-Injection / Supply-Chain-Attacke: fremde Anleitung befolgen,
> Binärdateien ungeprüft direkt ins Projekt schreiben, keine Möglichkeit zur Kontrolle vorher.

Three specific objections, and none of them is careless:

- **§0 asks for a URL that does not exist on this run.** *"Sie verweist auf 'die gleiche Basis-URL,
  von der du diese Datei geholt hast' — aber ich habe sie lokal per `Read` gelesen […] Ich würde eine
  raten müssen, und das mache ich grundsätzlich nicht."*
- **§5's download instruction reads as *write an unchecked binary into the project*.** *"straight to
  its final destination", "never staged anywhere first", also ohne dass ich den Inhalt vorher prüfen
  kann.*
- **The playbook is a second instruction file from an unverified source**, to be loaded and obeyed.

It offered to build the easter egg itself without loading the playbook, and stopped. Two model turns,
`$0.1143`, worktree clean. **No A/B data at all.**

**Why this is not a harness artefact, checked before it was filed.** The mirror is byte-identical to
`2026-08-03-r12`'s — `START.md` and `MONSTER-DEV.md` both hash the same, 18 files each — and r12 read
the playbook through without objection the same day. No permission denial, no error, no widened fence.
Across all eleven earlier transcripts the word `Injection` appears twice each, uniformly, as CLI
boilerplate; r13 is the first session in twelve where the *hire* used the words itself.

**And the rerun is what makes this an item rather than an anecdote.** `2026-08-03-r15`, identical setup
and a fresh session, accepted the playbook — while **seeing the same thing**. Its first line:

> Kurz gecheckt, was schon lokal an "Anleitung" bereitliegt (dist/-Ordner mit Playbook, Sprite-Sheets
> und Beispielimplementierung) — das übernehme ich als Grundlage, **ohne irgendetwas remote
> nachzuladen**.

Same perception, opposite decision. So the objection is not a misreading that better wording would
prevent by clarifying a fact; it is a judgement call the entry point currently leaves open, and the two
sessions fell on either side of it.

**Why the current wording allows it.** §0's derivation rule is written for the case it was designed
for — being fetched from a raw URL — and it is *load-bearing* there: it is what makes the product
survive forks and renames, and `2026-08-01-live` proved it over two real renames. On a local copy the
same sentence instructs the hire to derive something from information it does not have. Nothing in
either file says what an offline or mirrored copy is, or that being handed a filesystem path is a
legitimate way to arrive.

`alt-a-left-to-right.md` predicted the *class* — *"the agent is deliberately not told to substitute
paths for URLs — how well the playbook degrades is itself a finding"* — and this is that finding in a
shape nobody guessed: not graceful or clumsy degradation, but a hire reading the degraded state as
evidence of an attack.

**Proposed change.** Not written as final wording, because the right fix is arguably one sentence in
`START.md` and `START.md` is the file that has to stay short. Two candidates:

> **A — name the offline case.** One clause in §0: *"If you were handed a filesystem path rather than a
> URL, you have an offline copy of this repository; the directory containing this file is the base, and
> every path below is relative to it."* Cost: one line in the file that must stay short, and it teaches
> a hire that a local instruction file is normal — which is the thing r13 was right to be careful about.
>
> **B — say who is asking, once.** `START.md` opens with *"You just hired Monster-Dev"* and never says
> that the human in the conversation is the one who chose this. A hire's provenance objection is really
> *"nobody authorised this source"*, and the client is sitting right there: the dialogue protocol says
> so. Cost: it edges toward telling the hire how to feel about its own instructions, which is where a
> persona starts arguing with the model's judgement rather than informing it.

**B is probably the honest one and A is probably the cheap one.** Neither is chosen here.

**Proof design.** *`Gate: run`, and the difficulty is the rate rather than the arm.* `r13` is a
before-fail on record, so a wording change has something to flip — but the base rate is one refusal in
twelve sessions, and a single post-change run that does not refuse is worth almost nothing. Any honest
proof needs several arms per side, which makes this the most expensive item on the board to prove
properly. Cheaper interim: **every future run's report states whether the entry point was accepted
without objection**, so the rate accumulates as a by-product instead of having to be bought. That
costs one line per report and is worth doing whether or not the wording ever changes.

**Cost.** Named because it is unusually asymmetric. Leaving it costs a voided run roughly one time in
twelve, at whatever that run cost — and it costs more than money on a real hire, where the client
watches their contractor accuse them of an attack. Fixing it badly costs something worse: `START.md`
is the file that has to stay short, and a paragraph reassuring a hire that its instructions are
trustworthy is exactly the kind of text a genuinely malicious instruction file would also contain. **A
fix that trains hires to be less careful about unfamiliar instruction sources is a bad trade even
though it would make this project's numbers better** — which is the same shape of trade `THESIS.md`
warns about, arriving from an unexpected direction.

**Log.**

- `2026-08-03` `formulated` — from `2026-08-03-r13` (refused) and `2026-08-03-r15` (accepted), filed
  the same hour with both sessions on record and the mirror hashes compared. Filed at `formulated`
  rather than `intake` because what happened, which file would change and the attribution are all
  settled; what is not settled is the wording, and the proof design says why that is the expensive part.
- `2026-08-03` — **the interim measure is in place**, in `references/report-template.md` as an
  `Entry point` row in the header table plus the paragraph saying why it is not bookkeeping. It landed
  in `22b8351`, the same commit as the handoff that recommended it, so the rate starts accumulating
  from the next run rather than from the next wording change. The item stays `formulated`: measuring
  the rate is not the same as proving a fix, and no wording has been chosen.

  The instruction is to state the row **even when nothing happened**, for the same reason the `Reach`
  section is stated when it found nothing — an omitted row and a clean row read identically, and only
  one of them means anybody looked. Current denominator: 12 sessions, 1 refusal.

- `2026-08-03` — another evidence line, from `2026-08-03-r16` (opus): **entry point accepted without
  objection.** No mention of provenance, injection or supply chain anywhere in either turn; it read
  `START.md` and followed it. **Denominator now 13 sessions, 1 refusal.** First Opus-tier observation
  on this question — the refusal and the acceptance that motivated the item were both Sonnet, so the
  rate is no longer single-tier.

- `2026-08-03` — another evidence line, from `2026-08-03-r17` (sonnet, treated mirror): **entry point
  accepted without objection.** No mention of provenance, injection or supply chain in either turn.
  **14 sessions, 1 refusal.** Worth noting for this item specifically: the mirror carried a *modified*
  playbook, and the hire raised nothing about that either — it had no way to tell, which is what a
  variant arm needs to be true.

- `2026-08-03` — another evidence line: `2026-08-03-r18` accepted the entry point without objection.
  **15 sessions, 1 refusal.**

- `2026-08-04` — **second refusal on record, and it is the same refusal.** `2026-08-04-r19`
  (`#061` Phase 3, sonnet, `static-site`, treated mirror) read `START.md`, declined to fetch the
  playbook and stopped in turn 1. `$0.1356`, no data, rerun as a fresh id. **16 sessions,
  2 refusals.**

  **The rate is the smaller half of this. Both refusals lead with the same sentence, and it is
  about the harness rather than about `START.md`:**

  > `r13`: *"Sie verweist auf 'die gleiche Basis-URL, von der du diese Datei geholt hast' — aber
  > ich habe sie lokal per `Read` gelesen, nicht per WebFetch. Es gibt also gar keine echte URL,
  > die ich kenne. Ich würde eine raten müssen, und das mache ich grundsätzlich nicht."*
  >
  > `r19`: *"Es gibt keine 'Basis-URL', von der ich `START.md` gefetcht habe — du hast mir die
  > Datei als lokalen Pfad gegeben, nicht per WebFetch. Die Anweisung 'dieselbe Basis-URL' greift
  > also gar nicht, ohne dass ich weiß, welches Repo/welche URL gemeint ist."*

  Three matches, and the third is the one that makes it a pattern rather than a coincidence: both
  put §0 **before** the supply-chain argument; both are **sonnet on `static-site`**, and no other
  model or fixture has produced one; and both offer the **identical alternative** — build the
  easter egg without the playbook, in the project's own style, sprite to be supplied by the client.

  **This corrects the item's proof design, and in the cheap direction.** *Within one model tier*
  frames the refusal as variance around a constant, which is why the `Cost` paragraph below
  concludes that an honest proof needs several arms per side and calls this the most expensive item
  on the board. The transcripts say something narrower: **on a mirror run §0 cannot be satisfied —
  the entry point arrives as a filesystem path, so *"the same base URL you fetched this from"*
  refers to nothing — and a contractor asked to follow instructions from a source it cannot
  identify is being asked to do the thing it is trained to refuse.** The refusal would then be a
  response to a condition the *harness* introduces and the production path does not.

  **The test is one arm, not several.** `2026-08-01-live` is the only run over real
  `raw.githubusercontent.com` URLs — §0 resolves, and it accepted without objection — but it is
  Opus, so it does not touch the tier that refuses. **A sonnet real-URL run against `static-site`
  is the discriminator**, and it costs one run rather than a fleet: if the refusal is about §0
  being unsatisfiable it should not fire there, and if it fires anyway the *within-tier variance*
  reading survives and the expensive design is the right one after all.

  Two things this may **not** be read as. It is not a finding against §0, whose wording is `proven`
  by `2026-08-01-live` and is not what failed here — what failed is a run class in which §0 has
  no referent. And two observations are two: model and fixture are confounded with each other, and
  no sonnet hire has ever met a real URL. Filed as the cheapest next arm, not as a settled cause.

  Interim measure unchanged and now paying for itself: every report states whether the entry point
  was accepted, and this line exists because `r18`'s did.

- `2026-08-04` — another evidence line: `2026-08-04-r20`, the rerun of the refused `r19` on a
  byte-identical setup, **accepted the entry point without objection** and completed the job.
  **17 sessions, 2 refusals.** That is `r13` → `r15` reproduced exactly: same fixture, same model,
  same mirror, refusal then acceptance, no change in between. Whatever drives it is not stable within
  a setup, which is what makes the §0 hypothesis in the entry above worth one arm rather than a fleet.

- `2026-08-04` `grilled` — **grilled to six decisions, and three of them contradict what this item said
  the day it was written.** No wording is chosen and none should be: the treatment is deliberately
  deferred behind the attribution.

  **1 — Diagnosis before treatment.** The attribution is contested inside this item, *model
  disposition* in the header and *run-class artefact* in the entry above. That is not a nuance: if it is
  the run class, Half C says *fix the harness, rerun, record nothing against the product*, and both
  candidates `A` and `B` would then be product changes made to hide a condition only our rig produces —
  the trade `CLAUDE.md` forbids when it says a check that rewords the product to stay quiet has stopped
  being a check. So no wording is chosen until the probes have run.

  **2 — The mirror contradicts three sentences, not one, and this item names only two of them.** Read
  in full: §0's base-URL derivation, §5's *"never staged anywhere first"* — and **`START.md`'s own
  point 1**, *"Everything is fetched live, every time, from `main`"*, which is false by construction for
  a hire handed a filesystem path out of a local copy. It is also the **only** branch reference in
  anything a hire fetches. That third sentence is what kills the cheap version of the arm.

  **3 — A branch push does not work, so the arm needs `main`.** Pushing to `run-050` would make §0
  resolvable and `START.md` point 1 *false in a new way*: the hire fetches from `<branch>` while the
  file claims `main`. That swaps one provenance contradiction for another **in the exact dimension the
  arm is about**, and both refusals on record are of precisely that kind — a hire checking a provenance
  claim it cannot confirm. A refusal on a branch arm would be uninterpretable. Hence the `Blocked on`
  row.

  **4 — The arm can only refute, and this item claims otherwise.** *"The test is one arm, not
  several"* is right about the cost and wrong about the logic. Worked through:

  | Outcome | under *harness artefact* | under *within-tier variance* | Worth |
  |---|---|---|---|
  | refuses | ≈ 0 | ≈ 0.12 | **decisive** — the blamed condition is absent and it fired anyway |
  | accepts | ≈ 1.0 | ≈ 0.88 (15 of 17) | **almost nothing** — a factor of ~1.14 |

  So an acceptance is nearly uninformative, and proof by absence is unaffordable at this rate: eight
  clean real-URL runs would still be 36 % likely under variance. The asymmetry is **accepted and
  recorded** rather than designed away, and the arm gains a second, *positive* observation that is
  measurable on one run: does §0 visibly resolve? `check-reach.ps1` section D lists every URL fetched,
  so `…/START.md` followed by `…/MONSTER-DEV.md` and `…/stacks/dom-css/README.md` **measures** the
  derivation instead of inferring it.

  **5 — Three one-turn probes, not one run, and no criteria at all.** Both refusals on record happened
  in **turn 1** — `r13` `$0.1143`, `r19` `$0.1356`, two model turns each — and everything the
  discriminator needs is visible there. The 21 criteria measure *what was built*, which this arm does
  not ask. At ~`$0.15`–`$0.35` a probe, refutation power becomes purchasable:

  | Probes | chance of seeing a refusal *if* it is variance | cost |
  |---|---|---|
  | 1 | 12 % | ~`$0.35` |
  | **3** | **32 %** | ~`$1.0` |
  | 8 | 64 % | ~`$2.5` |

  Three is the knee: it triples the only direction that speaks, for half the cost of one scored run.
  Eight is a fleet again and 64 % is still not certainty, so that is where to stop rather than where to
  go.

  **The continuation rule is fixed now, before the first probe**, because a rule decided mid-run
  depends on the numbers it is judging — which is what `#009`, `#010` and `#007` have in common:

  - **Any probe refuses** → the §0 hypothesis is dead on one observation. `#050` keeps *model
    disposition*, the treatment is designed against `START.md`'s provenance question, and the three
    unsatisfiable sentences become a separate harness item.
  - **All three accept** → the hypothesis survives unproven (~1.5). Then **exactly one** probe — the
    third, so the decision does not depend on the first two — is continued into a full scored run,
    which additionally buys the first sonnet observation over real URLs on all 21 marks and exercises
    §0 and §5 for the first time since `2026-08-01-live`. ~`$2.5` total for three observations instead
    of one.

  **6 — The harness names the class rather than inferring it.** `hire.ps1` could not launch a
  mirror-less run at all: `-Dist` was a hard requirement and `2026-08-01-live` predates the wrapper. It
  now takes **`-EntryUrl`**, refuses both-or-neither, omits `--add-dir`, and records
  **`fetchPath: 'mirror' | 'real-urls'`**. That field is `#063`'s lesson a second time — the local-model
  spike was indistinguishable on disk from a paid run and the fix was one field a script can read. A
  class identified only by a *missing* argument would poison two fields that already carry three values:
  `totals.mirrorIntact` would conflate *not checked* with *nothing to check*, and an empty section D
  would not say whether the hire fetched nothing or was never given a URL.

  **And it surfaced a defect committed the same day.** `#075`'s per-turn mirror check binds
  `-DistPath` as `Mandatory`; on a mirror-less run that is `$null`, so the turn would have died at
  parameter binding — **after** the paid `claude` call and **before** the record was written, in the one
  place this script promises never to fail. Found by reading the code while designing the arm, not by a
  run dying on it. Guarded, with a fifth mirror state `no-mirror-run` that is silent by design: a
  warning printed on every turn of a whole run class is a warning ignored on the run where it matters.
  All three validation paths exercised against a throwaway target; the probe was removed.

  **What reaches `grilled` and what does not.** The four questions `process/backlog/README.md` asks:
  **which gate** — none of the three, because nothing is being proposed; this is the `#022` exercise
  shape and it ends on `proven` plus a mandatory qualifying row. **Which criterion flips** — none, and
  the before-observations are `r13` and `r19` rather than a before-fail. **Which model** — sonnet, both
  refusals and the bar anyway; Opus has never refused in five sessions. **Which arms, held constant** —
  fixture, model, brief text and dialogue protocol identical to the seventeen sessions, entry point
  substituted, fetch path the only variable. The confound is named and not solved: model and fixture
  are confounded with each other, since no sonnet hire has ever met a real URL and no other fixture has
  produced a refusal.
