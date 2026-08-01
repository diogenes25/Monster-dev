# Step 02 — State the findings and ask, in the same message

Findings and questions arrived together. Not *"here is my plan"* followed by *"and here are my
questions"* — one message, one reply, then the build. Full text in
[`../step-2-requirement/dialog-01.md`](../step-2-requirement/dialog-01.md).

## The five questions

1. Which monster? (with the alternative named, and its numbers)
2. One crossing per key press, or a loop?
3. What should a second Alt+A do **while it is still walking**?
4. Size and speed?
5. Where on the screen?

Question 3 is the one the customer never thought of. The brief says *"press Alt+A, monster walks
across"* and stops there; every implementation still has to decide what a second press does, and
the choice is invisible until someone presses twice. Asking made it a decision instead of an
accident.

## What came back

Three of the five were *"keine Präferenz, nimm deinen Standard"*. Only two carried information:
one crossing per press, and along the bottom edge.

That ratio is the normal case, not a failure of the questions. A question answered *"no
preference"* still did its work: it converted a silent assumption into a stated default that the
customer had the chance to veto.

## Cost of this round

11 model turns, $0.37. The whole reading-and-planning half of the job.
