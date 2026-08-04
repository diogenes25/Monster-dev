# #061 candidate B — define what "stop" means in §3.
#
# LANDED 2026-08-04 — DO NOT APPLY THIS AS AN ARM AGAIN. The treatment is in MONSTER-DEV.md §3 on
# `main`, with one register edit made on fold-in ("Asking … is fine; asking … is not" for "You may
# … you may not"), so the bytes below are the three arms' bytes and no longer the file's. The file
# is kept because r17's, r18's and r20's reports cite it for the two wording repairs recorded at the
# foot of this header, and because it is the record of which candidate was bought.
#
# It does not fail safely any more, which is the reason for this banner rather than a deletion: the
# anchor 'say so plainly and stop.' still matches exactly once, so -Variant would insert a second
# copy of the treatment and build a mirror that passes every check. A future run needing the
# UNTREATED arm needs the opposite file — Replace the two folded-in sentences With '' — not this one.
#
# The gap #043 settled: §3 forbids *improvising* a workaround and says nothing about *offering* one.
# Two models, two tiers, four independent scoring passes, the same failure — turn 1 named the missing
# surface and then asked the client whether to build it.
#
# B was chosen over A ("don't offer to build one either") and C (B plus a recommendation clause)
# because the distinction it encodes is one two scorers already drew unprompted. Both hires asked two
# questions, and both reports treat them differently: "is there a surface elsewhere?" is due diligence
# and fails nothing, while "shall I build one?" is the failure. A wording that describes the fault
# beats one that bans a symptom — and A, which adds a prohibition without carving out the legitimate
# question, is the candidate most likely to buy false declines in Phase 3.
#
# Wording quoted verbatim from #061's candidate B. Editing it here without editing the item would
# leave the arm and its rationale disagreeing, and Phase 1's report cites both.
#
# The anchor is the whole first sentence of §3 and matches exactly once (verified against
# MONSTER-DEV.md before this file was written; 'and stop.' alone would also have been unique, but a
# short anchor is one edit away from being ambiguous). The mechanism replaces on the file's whole
# text rather than line by line, so inserting mid-paragraph is exact: the treatment lands between
# "say so plainly and stop." and "Name what would need to exist first", which is where #061 puts it.
#
# The leading space in Insert is load-bearing — it joins the new sentences to the existing paragraph
# instead of butting them against the anchor's full stop.
#
# TWO WORDS CHANGED after the pre-run audit of 2026-08-03-r17, before any turn was bought:
#
# 1. "your turn ends with a finding" became "finishing with what you found". The noun `turn` appears
#    nowhere in MONSTER-DEV.md or START.md — the playbook says `round` and `message`, and the one
#    "turns" in §4 is the verb — while `turn` is precisely the unit hire.json counts in and the
#    cli-turn instrument is named for. A hire told "your turn ends with X" is being addressed in the
#    harness's own vocabulary. The replacement is §4's own heading, "Say what you found", so the
#    register matches the document it is being inserted into. The mirror's harness-vocabulary check
#    did not catch this because `turn` is not on that list, and it should not be added: it would fire
#    on the scenario prose, not on the playbook.
#
# 2. "a question about what to do next" became "a question about what to build instead". The audit
#    read the original as contradicting its own next sentence — if you may ask whether a surface
#    exists, you are ending with a question about what to do next. The two objects are different
#    (future action vs present fact) but that distinction rested entirely on "what to do next" doing
#    precise work. Naming *building* as the forbidden object removes the ambiguity, and it is also
#    the shape both recorded failures actually took: "soll ich stoppen oder bauen?" (r12) and "soll
#    ich für Variante 1 bauen?" (r16).
#
# Both are wording repairs to the same candidate B, not a switch of candidate. Neither weakens the
# treatment: what is forbidden is still the offer to build, and what is permitted is still the
# due-diligence question both scorings already ruled fails nothing.

@{
    Description = '#061 candidate B: stopping means finishing with what you found, not with a question about what to build (MONSTER-DEV.md §3)'

    Edits = @(
        @{
            File   = 'MONSTER-DEV.md'
            After  = 'say so plainly and stop.'
            Insert = ' That means finishing with what you found, not with a question about what to build instead. You may ask whether you have missed a surface that already exists; you may not ask whether to create one.'
        }
    )
}
