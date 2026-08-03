# Variants — an A/B arm that is smaller than a file

`build-dist.ps1 -Variant <name>` applies `<name>.psd1` to the assembled mirror after the copy and
**before every check**, so an arm is verified exactly as hard as a plain mirror is.

It exists because `-Without` works at file granularity and an arm almost never does. `#002`'s
treatment is one paragraph inside `MONSTER-DEV.md` §6; a stack-note fragment's arm is that
fragment deleted. Until this landed, neither could be built honestly — the harness said so in two
places and the only item ever to reach `grilled` was blocked on a sentence nobody had turned into
an item.

## The file

```powershell
@{
    Description = 'Arm B of #002: the change set named in step 4 bounds the build'
    Edits = @(
        @{ File = 'MONSTER-DEV.md'; After = '<a sentence quoted from the file>'; Insert = "`n`n<the paragraph>" }
    )
}
```

`After` + `Insert` puts text straight after the anchor. `Replace` + `With` substitutes it, and
`With` omitted or empty **deletes** it — the arm a fragment needs, since `CLAUDE.md`'s rule is
that deleting a fragment must leave its entry true.

Read as data with `Import-PowerShellDataFile`, which evaluates no code, so a variant cannot reach
into the build. `process/` is excluded from the mirror already, so a variant never ships.

## Two rules, and why they are hard failures

**The anchor is a quoted sentence, not a patch.** A patch keys on line numbers and context and
rots the moment either moves. A sentence out of the file is also how the arm is described in the
item that asks for it, so the two cannot drift apart silently.

**It must match exactly once.** Zero means the anchor was edited or mistyped and the arm would be
built with no treatment in it. Two means the treatment lands in an arbitrary one of two places.
Neither announces itself afterwards: the mirror still builds, the run still runs, and the two arms
differ by an amount nobody can state — which is worse than no A/B, because it still produces a
number that looks like an answer.

The build prints `Variant` and `Edits` in its returned object for the same reason. `(none)` rather
than blank, so an arm built without a variant and an arm whose variant did nothing cannot print
the same thing.

## The `zz-` files are negative tests, not arms

Four fixtures, one per hard failure, kept so the failure paths stay re-runnable rather than
demonstrated once in a commit message. Each must throw:

| | fails on |
|---|---|
| `zz-nofile` | edits `CLAUDE.md`, which the mirror excludes |
| `zz-nomatch` | anchor that is not in the playbook — 0 matches |
| `zz-twice` | anchor `the` — many matches |
| `zz-noop` | replaces a sentence with itself, so the edit changes nothing |

```powershell
.\process\tools\build-dist.ps1 -RunId zz-check -Variant zz-nomatch   # must throw
```

A run that does *not* throw is the finding. Delete the scratch mirror afterwards; the build only
deletes one it built and then rejected.
