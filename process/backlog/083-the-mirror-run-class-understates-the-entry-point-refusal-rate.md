# `#083` — the mirror measures a path no customer uses, and it hid the product's central failure for eighteen sessions

| | |
|---|---|
| Status | `intake` |
| Gate | `none` |
| Attribution | harness artefact |
| Criterion | none, and that is the point. It is upstream of criterion 1 of every scenario: whether the hire follows the playbook at all |
| Target file | `process/scenarios/*.md`'s *Fetch path* paragraphs; `.claude/skills/monster-dev-workshop/SKILL.md` Half C's *"The fetch path is a choice, not a limitation"*; `references/report-template.md`'s `Fetch path` row |
| Evidence | `2026-08-04-p1`, `-p2`, `-p3` against the eighteen mirror sessions on record |

**What happened.** Three one-turn probes over real `raw.githubusercontent.com` URLs, sonnet,
`static-site`, everything else held constant against the eighteen sessions before them. **All three
refused the entry point.** Split by fetch path and tier:

| Fetch path | Tier | Sessions | Refusals |
|---|---|---|---|
| mirror | sonnet | 11 | **2** — 18 % |
| mirror | opus | 3 | 0 |
| mirror | local spike | 1 | 0 |
| **real URLs** | **sonnet** | **3** | **3 — 100 %** |
| real URLs | opus | 1 (`2026-08-01-live`, pre-wrapper) | 0 |

**Under the mirror-measured rate, three consecutive refusals is a 0.6 % event.** The two paths are not
sampling the same population.

**Why the mirror suppresses it, in one sentence.** The mirror hands the hire a **local file** on its own
filesystem; the real path hands it a **URL into an unknown third-party GitHub repo**. `p2` names the
repo in its objection — *„fremder, dir unbekannter Drittanbieter-Content aus einem GitHub-Repo
(`diogenes25/Monster-dev`)"* — and there is nothing for that sentence to attach to when the playbook
arrives as `C:\…\dist\START.md`. The blindfold was also an anaesthetic.

**Why nothing caught it.** Every document here treats the fetch path as a *comparability* question and
says so explicitly. `SKILL.md` Half C: *"The mirror is the default for A/B work. It holds the fetch
path constant, and every arm on record used it."* That is true and it is the right reason — and it is
silent about the possibility that the constant it holds is **not the production value**. §0 and §5 are
listed as the only things a mirror does not exercise, both marked `proven` by `2026-08-01-live`, so a
reader concludes the mirror costs the measurement two sections and nothing else.

It costs more than two sections. It costs the answer to *does a hire at the bar follow this playbook
at all*, which is upstream of every criterion in every scenario.

**What it does and does not invalidate.** Nothing is re-scored, and the reason is the same one `#054`
and `#076` give: the contamination is **uniform** — all eighteen used the mirror, so they compare with
each other exactly as before. Criteria 1–21 of `alt-a-left-to-right` and 1–13 of `nowhere-to-walk`
measure what they always measured, on the population that got past the entry point.

What is *not* true any more is the sentence a reader would naturally infer from eighteen green
`Entry point` rows: that the entry point is fine and `#050` is a one-in-twelve accident. **At the bar,
on the path a customer uses, it is the normal case.**

**Proposed change.** Three parts, and the first is the only one that is obviously right.

1. **Say it where a reader of a scenario is standing.** Each *Fetch path* paragraph gains a clause:
   *"A mirror run cannot observe whether a hire accepts instructions from an unknown remote source,
   because it is not one — see `#083`. An `Entry point: accepted` row on a mirror run is evidence about
   this run class only."* Above the cut, because it governs how a verdict is read.
2. **`SKILL.md` Half C's paragraph is wrong by omission** and gains the same point: the mirror holds
   the fetch path constant *at a value the product never ships*, which is a cost, not just a benefit.
3. **The open question, and it is the owner's:** does the default run class change? Every A/B on record
   used the mirror, `-Without` and `-Variant` both need one, and a real-URL A/B would need two pushed
   branches — so switching the default trades the whole A/B mechanism for one variable. **Recommendation:
   do not switch.** Keep the mirror as the default for A/B work and require a **real-URL probe
   alongside any run whose result depends on the hire accepting the entry point** — one turn, `$0.157`,
   which is what these three cost.

**Cost.** Part 1 and 2 are prose in files no hire reads. Part 3 is a standing extra `$0.157` on some
runs, and the alternative is what just happened: eighteen sessions of evidence about a path that does
not exist, and a `#050` attribution that was wrong twice in two directions.

**Not this: deciding the mirror was a mistake.** It was not. It is what makes an arm-to-arm comparison
possible at all, it is why `#002`, `#061` and `#067` could be measured, and `WebFetch` cannot reach a
local server so there was never a middle option. The defect is that its cost was **stated as two
sections** when it was really the product's front door.

**Log.**

- `2026-08-04` `intake` — from `2026-08-04-p1`, `-p2`, `-p3`, filed the same hour. The probes were
  bought to test whether `#050`'s refusal was *caused* by the mirror; the answer is that the mirror was
  hiding it, which is the same variable with the sign reversed. Filed separately from `#050` because
  that item is about `START.md`'s and §5's wording and this one is about what the harness can observe —
  and because this one has a consequence `#050` does not: **every A/B on record used the suppressing
  path.**
