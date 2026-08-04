# Negative test: inserts text the playbook already contains — the shape an arm takes once its
# treatment has been folded in. Must throw. The anchor still matches exactly once, which is the
# whole point: this is the one failure mode the match count cannot see (#079).
@{ Description = 'insert a sentence that is already in the file'
   Edits = @( @{ File = 'MONSTER-DEV.md'; After = 'Follow it in order.'; Insert = ' One knock on the door is enough.' } ) }
