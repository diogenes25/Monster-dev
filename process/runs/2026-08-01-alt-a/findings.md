# Findings — run `2026-08-01-alt-a`

Proposed wording changes to the playbook. Each finding names what was observed, where the evidence is, and what it would take to close it. Ranked by how much they cost a real hire.

> ## Status after the later runs — read this first
>
> Two later runs ([`phase1`](../2026-08-01-phase1/report.md), [`sonnet-base`](../2026-08-01-sonnet-base/report.md)) changed what several of these findings mean. Corrections belong next to the claim they correct, not buried in a newer file.
>
> | | Status |
> |---|---|
> | **F1** | **Misattributed.** Called a playbook gap below; it isn't. Sonnet, on the same wording, asked and built nothing. Opus built first in both its runs. That is **model disposition**, a category this file's attribution scheme lacked. Wording kept anyway — it makes the expectation explicit instead of leaving it to a model's temperament — but it can only be *proven* against Opus, where the failure reproduces. |
> | **F2** | **Confirmed, and the only one confirmable.** Three runs, two models, K4a fails every time: nobody asks what a second trigger should do. Applied to §4. |
> | **F3, F4** | **Deferred, not rejected.** Both were solved unprompted in all three runs, on both models — K3 and K4b were already PASS everywhere, so no A/B can separate an arm with these notes from one without. Under the agreed rule (no measurable difference → the lines go) they have no case yet. `stacks/dom-css/` stays a signpost and says so honestly. Revisit when a run actually falls into one of these pits. |
> | **F5** | Applied to `README.md`. |
> | **F6** | Applied to §8 — but with no headroom: language fidelity already passed in every run. |
> | **F7** | Applied to §9, with the scaffolding proviso. Also no headroom: all three hires verified their own work unprompted and built the scaffolding outside the project. What the run *can* show is the risk — if K13 regresses, the instruction caused scaffolding to be left behind. |
>
> The lasting lesson is methodological: **the quality bar and the diagnostic model are not the same.** Sonnet is the bar — the playbook must suffice for it. Proving a fix needs a model that exhibits the fault without it.

---

## F1 — §4 has an order but no way to enforce it (criterion 7, FAIL)

**Observed.** Monster-Dev implemented the whole feature and *then* presented the five §4 questions as „Das sind Defaults, die ich gesetzt habe — sag Bescheid, wenn eine davon anders soll". The working tree already showed all three changes while turn 1 was still running.

**Why it happened.** §4 sits before §6 in reading order, and §1's suggested greeting even promises *"I'll ask you a couple of quick questions before I build anything"* — but nothing says what to do when the medium gives no chance to pause. A one-shot session reasonably concludes it must deliver something.

**Caveat.** Partly an artefact of the test medium. An interactive hire may well ask first. **Re-test interactively before treating this as settled** — but note the prompt did offer a stop-and-ask protocol and it went unused.

**Proposed — add to `MONSTER-DEV.md` §4, after the bullet list:**

> Ask before you build, not after. If you are running somewhere that can't wait for an answer — a one-shot or headless invocation — then stop after the questions and deliver nothing rather than shipping an implementation with the answers assumed. A built-then-asked feature puts the client in the position of reviewing your defaults instead of stating their preferences, which is the opposite of what this step is for.

Same root cause as the §1 introduction never appearing: with no turn before the work, there is nowhere to knock on the door. Covered by the same sentence.

---

## F2 — §4 never asks what a second trigger does (criterion 4a, FAIL)

**Observed.** The customer asked for an Alt+A trigger and said only „einmal pro Tastendruck". Monster-Dev asked „Einmal oder Dauerschleife?" — the §4 loop question — but never *"what should a second press do?"*. It happened to build a working answer anyway.

**Why it matters.** §4 asks whether the walk loops, and separately whether it should react to a click or hover. Those two combine into a third question that isn't on the list: once there *is* a trigger, "one-time crossing" is ambiguous between *once ever* and *once per trigger*. Guess wrong and the easter egg fires exactly once per page load.

**Proposed — add a bullet to `MONSTER-DEV.md` §4:**

> - If it's triggered by something rather than always running: what should happen if the trigger fires again — restart, ignore until it's finished, or stack a second one?

---

## F3 — §5 doesn't mention that the reference animation only runs once (latent gap)

**Observed.** `index.html` uses `animation: move-across var(--crossing) linear 1 forwards`, which runs at page load and never again. A trigger-driven version needs either an element created per trigger or an explicit animation restart. §5 describes the frame geometry, the `steps(23)` cycle and the stride-derived duration — but not this.

Monster-Dev solved it unaided by creating the element on keydown and removing it on `animationend`, so criterion 4b passed. **The gap is latent, not disproven:** a hire that ported the reference markup more literally would have shipped a monster that walks once per page load and then goes dead.

**Proposed — add a bullet to `MONSTER-DEV.md` §5, after the `index.html` bullet:**

> - Note what the reference *doesn't* cover: its walk runs once, at page load. If the client wants it triggered by something, a one-shot animation won't replay — build the walker when the trigger fires and tear it down when it finishes, or restart the animation explicitly. Whatever you create on trigger, make sure it also goes away, and decide what a trigger during an active walk does.

---

## F4 — the reference's shadow is silently direction-specific

**Observed.** `index.html` places the shadow with `right: 8%` and the comment *"The monster walks right → left, so it belongs on the right-hand side."* The rule is stated, but the dependency on direction is easy to miss when translating. Mirroring the sprite for a left→right walk invalidates the placement — the shadow ends up under the tail.

Monster-Dev caught this: it measured the footprint across four frames, found it sits at 31–85 % of the mirrored frame, and moved the shadow to `left: 34%`. Nothing asked it to.

**Proposed — extend the `.shadow` comment in `index.html`:**

> ```
> /* The shadow sits under the leading foot, not under the tail. The monster walks
>    right → left, so it belongs on the right-hand side — flip this together with
>    the sprite if you reverse the direction of travel. */
> ```

**And add to `MONSTER-DEV.md` §5, in the `index.html` bullet:** after "Study the technique, not just the markup", note that two things in the reference are tied to its right→left direction — the sprite's facing (`scaleX(-1)`, currently commented out) and the shadow's horizontal placement — and both flip together if the client wants the other direction.

---

## F5 — `README.md` hardcodes the exact URL §0 forbids hardcoding

**Observed.** Monster-Dev tried `https://raw.githubusercontent.com/diogenes25/monster-dev/main/` and got a 404. It did not derive that URL — it was handed a filesystem path — it read it from `README.md` line 12, which is in the published surface.

**Why it matters.** §0 opens with *"Don't hardcode an owner/repo name anywhere below — this repo gets forked and renamed."* The playbook honours that. The README does not. In a fork, the README still points at the upstream repo, so anyone pasting the URL from **their own fork's README** hires the upstream copy — exactly the failure §0 exists to prevent. It stays invisible while there's only one copy of the repo.

**Proposed — add one line under the paste URL in `README.md`:**

> If you forked this repo, change the owner and repo name in that URL to your own. Everything after that point is derived from it, so it's the only place a fork needs editing.

---

## F6 — which language a hire works in is unregulated

**Observed.** An English playbook, a German customer. Monster-Dev conducted both turns and wrote its handover in German, unprompted — and wrote code comments in English, matching every pre-existing comment in the target project.

That split is almost certainly the right call, which is why acceptance criterion 14c was withdrawn rather than failed: §6 requires matching the surrounding code's conventions, and the surrounding comments are English. But the playbook says nothing about either half, so it happened by good judgement rather than by instruction — and the reference implementation is itself inconsistent (`index.html` has `lang="de"` with English comments).

**Proposed — add to `MONSTER-DEV.md` §8, with the handover note:**

> Write the handover in whatever language the client has been speaking to you. Code comments are different — those follow the codebase, not the conversation.

---

## F7 — nothing asks a hire to check its own work (optional)

**Observed.** §9's checklist says *"The monster actually renders in the surface identified in step 2.1"* but offers no method, so it reads as a self-assessment. Monster-Dev went further on its own: it drove headless Chrome, confirmed 0 monsters before the keypress and 1 after, measured the sprite travelling 85 → 294 px, and reported the numbers. Independent re-measurement confirmed every claim.

Worth deciding whether that's expected behaviour or a happy accident. A sentence in §9 would make it the former — but it also risks pushing a hire toward building test scaffolding in a client's project, which §9 otherwise forbids leaving behind.

**Suggested wording if you want it — `MONSTER-DEV.md` §9:**

> Check it renders and behaves as agreed before you sign off, and say how you checked. Keep any scaffolding you build for that outside the client's project, and remove it.

---

## Not a finding

For the record, these held up and need no change: asset placement (§2.5/§7), idiom conformance (§2.4/§6 — plain CSS/JS, no dependency, `index.html` untouched), the reduced-motion carry-over, and the §8 commit rule, which was never even approached — no commit, no trailer, no prompting needed.
