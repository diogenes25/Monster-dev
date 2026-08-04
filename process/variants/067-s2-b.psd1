# #067 candidate B — say which of the two applicability tests decides, so the note is not fetched to
# make a decision §2's own table already made.
#
# LANDED 2026-08-04 — DO NOT APPLY THIS AS AN ARM AGAIN. Proven by `2026-08-04-r21` (criterion 10
# flipped at the bar, 13/0/0/1, both scorings agreeing) and folded into MONSTER-DEV.md §2 the same
# day, **verbatim** — unlike `061-s3-b`, whose fold-in carried one register edit and left main's
# bytes differing from the three arms'. So the Insert below IS the sentence on `main`, and a report
# citing this file cites what was measured.
#
# It fails safely, and by construction rather than by this banner: the Insert is now present in the
# file, so #079's check refuses it before the anchor count is even consulted. A future run needing
# the UNTREATED arm needs the opposite file — Replace these three sentences With '' — not this one.
#
# The gap: §2 tells a hire what to do when a row matches — "Take the first row that matches, and fetch
# that one only" — and what to do when none does, but the second is *permissive prose* ("that's the
# normal case rather than a problem") where the first is an imperative. A model reading the section as
# a checklist finds one action item and one reassurance. Sonnet fetched the note on a 34-line stdlib
# CLI in 2 of 2 runs; the one run that took the branch correctly is Opus, which is the asymmetry
# CLAUDE.md names when it says the bar is Sonnet because Opus solves known pitfalls unaided.
#
# B was chosen over A ("if no row matches, don't fetch any of them") and C ("do nothing, the criterion
# is scoring a non-problem"), and C was refuted by measurement rather than by argument: the Read of
# the note sits alone in its own assistant message in all three runs — a full model turn, 1 of r17's
# 11 — and what it buys is a restatement of the table cell the hire has already read. Everything else
# in those 35 lines presupposes that the row matched.
#
# The cause B names is structural. The applicability test exists TWICE in the product: §2's
# `you're here if` column, and the note's own opening paragraph ("You are here if … You are not here
# if …"). That duplication is required rather than accidental — CLAUDE.md's gate-free orientation
# exemption exists precisely so a stack note can answer "am I in the right stack". A hire facing two
# sources for one question opens the fuller one. So B says which of the two decides and leaves the
# note untouched; A would ban the symptom and leave the duplication in place.
#
# The last clause of the treatment folds A's imperative in as a *consequence* of the rule rather than
# as a prohibition. That is deliberate: §2 is read by every hire on every job, and #061's Phase 3
# bought the evidence that a prohibition in a section like this is the candidate most likely to
# produce a false decline elsewhere.
#
# The anchor is the last sentence before the stack table and matches exactly once (verified against
# MONSTER-DEV.md when this file was written). It puts the treatment BEFORE the table, which is the
# whole of B — the decision has to precede the fetch, so it cannot sit in the no-match paragraph
# underneath.
#
# The leading `\n\n` is load-bearing: the anchor ends a paragraph and the table follows, so the
# treatment is its own paragraph rather than a run-on before a Markdown table.
#
# Wording quoted verbatim from #067's grilling entry of 2026-08-04. Editing it here without editing
# the item would leave the arm and its rationale disagreeing.

@{
    Description = '#067 candidate B: the `you''re here if` column decides, and a note is what you read after a row matches (MONSTER-DEV.md §2)'

    Edits = @(
        @{
            File   = 'MONSTER-DEV.md'
            After  = 'Two sets of notes give you two answers to the same question and nothing that says which wins.'
            Insert = "`n`n**The ``you're here if`` column is what decides, and it is answerable from what step 2 already found — without opening anything.** A note tells you how earlier jobs on that surface went, not whether you are on it. So a note is what you read *after* a row matches; if none matches, there is nothing to open."
        }
    )
}
