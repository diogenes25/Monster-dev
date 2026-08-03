# `#050` — a hire refused the entry point as a prompt-injection / supply-chain attack, and an identical session accepted it

| | |
|---|---|
| Status | `formulated` |
| Gate | `run` |
| Attribution | model disposition — **within one model tier**, which is a sub-case Half C does not describe |
| Criterion | none. It happens before criterion 1 of any scenario, and it voids the run rather than failing a mark |
| Target file | `START.md`, `MONSTER-DEV.md` §0 and §5's download wording |
| Evidence | `2026-08-03-r13` refused; `2026-08-03-r15` accepted, on a byte-identical mirror, same model tier, same hour |
| Blocked on | nothing, but read the cost paragraph before designing the run — the rate is the hard part |
| Proof design | — |

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
