# Negative test: anchor that does not exist — 0 matches. Must throw.
@{ Description = 'anchor that does not exist'
   Edits = @( @{ File = 'MONSTER-DEV.md'; After = 'this sentence is not in the playbook at all'; Insert = 'X' } ) }
