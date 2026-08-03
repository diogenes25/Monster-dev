# Arm B of #002 — bound the build to the change set announced in step 4.
#
# The paragraph is quoted verbatim from the item's "Proposed change" section and must stay that
# way: the item argues at length about the wording, and in particular about its last sentence,
# which exists to stop the treatment reading as "do less checking". Editing it here without
# editing the item would leave the arm and its rationale disagreeing, and the report cites both.
#
# The anchor is the tail of §6's paragraph rather than the sentence #002 names. The item says
# "after 'Match the surrounding code's naming, formatting, and structure conventions'", but that
# sentence continues — "— this should look like it was written by whoever else works on this
# codebase, not bolted on." — so anchoring on it would insert a paragraph into the middle of a
# sentence. Anchoring on the paragraph's end puts the new text exactly where the item intends it.

@{
    Description = 'Arm B of #002: the change set named in step 4 bounds the build (MONSTER-DEV.md §6)'

    Edits = @(
        @{
            File  = 'MONSTER-DEV.md'
            After = 'this should look like it was written by whoever else works on this codebase, not bolted on.'
            Insert = @'


The change set you named in step 4 is the scope of this step. Build that, and stop. If building it shows the set was wrong, say so and change it — but don't widen it quietly, and don't add hardening, refactors or fixes to things you happened to open. Checking that what you built works is part of building it, not something extra.
'@
        }
    )
}
