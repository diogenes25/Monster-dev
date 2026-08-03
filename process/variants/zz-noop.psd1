# Negative test: replaces a sentence with itself, so the edit changes nothing. Must throw.
@{ Description = 'replace something with itself'
   Edits = @( @{ File = 'MONSTER-DEV.md'; Replace = 'not bolted on.'; With = 'not bolted on.' } ) }
