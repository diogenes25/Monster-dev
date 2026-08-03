# Negative test: anchor that occurs many times. Must throw.
@{ Description = 'anchor that occurs many times'
   Edits = @( @{ File = 'MONSTER-DEV.md'; After = 'the'; Insert = 'X' } ) }
