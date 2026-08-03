# Negative test: edits a file the mirror excludes. Must throw.
@{ Description = 'edits a file that is not in the mirror'
   Edits = @( @{ File = 'CLAUDE.md'; After = 'anything'; Insert = 'X' } ) }
