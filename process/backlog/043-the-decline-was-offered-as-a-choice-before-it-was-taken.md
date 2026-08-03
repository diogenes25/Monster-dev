# `#043` — §3's decline was offered to the customer as a choice before it was taken

| | |
|---|---|
| Status | `intake` |
| Gate | `run` |
| Attribution | candidate playbook gap — **not settled**, one model, one run |
| Criterion | `nowhere-to-walk` `4` and `7`, both failing on the same sentence |
| Target file | `MONSTER-DEV.md` §3 — but see the trap below before touching it |
| Evidence | `2026-08-03-r12` |
| Blocked on | a second model on the same scenario, before this can be called a gap at all |
| Proof design | — |

**What happened.** The first hire ever pointed at a project with no rendering surface did everything
§3 asks for except stop. Turn 1 stated the absence unaided, named the missing precondition, refused
ASCII art by argument, changed nothing — and then closed with:

> **2. Falls nicht: soll ich hier stoppen, oder möchtest du, dass ich zuerst eine minimale
> HTML-Report-Ausgabe für `report.py` baue, in die das Monster dann laufen kann?**

A conditional build, a request for permission to proceed anyway, and the choice left with the
client. It declined outright only in turn 2, after the answer script's deflection row handed the
judgement back. Both scorings failed `4` and `7` on this sentence independently.

**Why the current wording may allow it.** §3 says what to *do* — *"say so plainly and stop"* — and
names one thing not to do, *"don't improvise a workaround like ASCII art in log output"*. The hire
obeyed both readings as literally as they are written: it did not improvise, and it did say so
plainly. What it did was **offer** the improvisation as a question, which §3 does not address. The
gap, if it is one, is between *don't build it* and *don't offer to build it*.

Not filed as a gap yet, and the reason is Half C: a playbook gap means *every* model does the same.
One Sonnet observation is a sighting.

**Cost.** Named here because it is unusually high for a wording change and it is the whole reason
this item starts at `intake` rather than being fixed on the spot. Tightening §3 is exactly the change
`nowhere-to-walk` warns produces **false declines** on a real surface, and no criterion in
`alt-a-left-to-right.md` would catch one: a hire that asks *"are you sure this is the right project
for me?"* and then builds correctly passes every mark there. So any change here owes a `static-site`
rerun as its second arm, and this item costs two runs rather than one.

**Log.**

- `2026-08-03` `intake` — from `2026-08-03-r12`, the first run against `python-cli` and the first
  time §3 has been reached by any session. `#022`'s exercise run produced it; `#022` predicted this
  exact outcome as one of its two useful ones.
