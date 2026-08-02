# `#011` — §7's second sentence has never been exercised, because every fixture so far ships assets by copying them

| | |
|---|---|
| Status | `formulated` |
| Gate | `run` |
| Attribution | scenario defect |
| Criterion | `9` — its §7 half only |
| Target file | `process/fixtures/` (a fixture with a build), `MONSTER-DEV.md` §7 |
| Evidence | every run on record: `2026-08-01-alt-a`, `phase1`, `phase2`, `phase2b`, `sonnet-base`, `sonnet-base2`, `plan-sonnet`, `plan-opus`, `live`, `index-sonnet`, and the `ph0-smoke` smoke test |
| Blocked on | a fixture with a real build — ecosystem undecided |
| Proof design | — |

**What happened.** Nothing did, and that is the item. §7 says:

> Exactly where step 2.5 said, and nowhere else. **If the project has a manifest/bundler that needs
> to know about new assets (e.g. an asset pipeline config, a resource list), update that too,
> following how existing assets are already registered there.**

The bolded half has never run. Every hire on record worked on `process/fixtures/static-site`, where
an asset is delivered by dropping a file into `assets/` and referencing it from CSS — there is no
manifest, so there is nothing to update and nothing to get wrong. Criterion 9 scores the *location*
of the sprite and has passed in every run; the registration clause inside the same section has
neither passed nor failed, because no arm ever reached it.

`gsap-site`, the other web fixture, does not close this either: it loads GSAP from
`cdn.jsdelivr.net` and its `package.json` declares a dependency nothing installs. It is a fixture
about *style conformance*, not about a build.

**Why the current wording allows it.** Not a wording fault, and not the same shortage as `#005`.
`#005` is about §2 having one row to choose from; this is about a whole clause of §6/§7 sitting
outside the reach of the fixture set. Both are coverage, and both are invisible in a report, which
is why neither surfaces until someone reads the playbook against the fixture table.

**Proposed change.** None to the playbook. What is missing is a fixture whose ecosystem *requires*
registration — a project where dropping a file into a folder is not enough and the build has to be
told, and where getting it wrong produces a broken page rather than a stylistic complaint.

**Proof design.** Worth naming plainly, because this item does not close the way an A/B does. There
is no treatment and no before-fail: the clause has never been measured, so the first run against a
build-pipeline fixture **exercises** it rather than proves anything about a change. Two outcomes,
both useful — the hire registers the asset and criterion 9's §7 half finally has a result, or it
does not and that failure becomes an item of its own with a real attribution behind it. What must
not happen is recording it as a pass on the strength of a fixture that could not have failed it,
which is exactly the mistake `#005` exists to prevent for §2.

The run needs no new machinery: `new-run.ps1` already installs dependencies before the hire starts,
via `process/tools/setup/<fixture>.ps1`, so the install does not land in `num_turns`.

**Cost.** A fixture with a real build is the most expensive kind to keep: it dates, its lockfile
ages, and its setup recipe is one more thing that can break a run for reasons unrelated to the
playbook. Against that, it is the only way to reach a clause the playbook already commits to — and
an untested clause in a published playbook is a claim, not a rule.

**Log.**

- `2026-08-02` `intake` — found by reading §7 against the fixture table rather than from a run;
  no hire has been in a position to fail it.
- `2026-08-02` `formulated` — attributed to the fixture set, not the playbook. Blocked on a
  decision about which ecosystem, not on another run.
- `2026-08-02` — evidence count corrected during the PM pass: `#012`'s inventory counts eleven
  sessions, not ten; `ph0-smoke` was missing here. Also noted, because `#015` claimed otherwise:
  `gsap-site` does not unblock this item, and `#015` has been corrected to say so.
- `2026-08-02` — `Blocked on` added, answer **A3**. It names the ecosystem decision as well as the
  fixture, because the item's own log says it is blocked on the decision and not on a run.
