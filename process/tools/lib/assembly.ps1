<#
The pre-turn record of a run, and the one place that writes it.

Until #048 the record of a run began at hire.ps1's first turn, because that is where
process/runs/<id>/ was created. So everything before the first paid turn had nowhere to live:
new-run.ps1 assembling the folder, what the setup recipe did, the mirror and its file count,
the isolation verdict, and the leak-auditor's findings. Three runs on 2026-08-03 wrote that by
hand — r12's knowledge.md, r13's knowledge.md, r15's audit.md — and a refused or abandoned
setup is exactly the run whose folder somebody deletes. #013 is the same failure one stage
later and its evidence line reads "a run whose folder no longer exists."

Two design points, both about not owning the file:

  * **Append-only, from the bottom.** The human sections are pinned above a `## Tool log`
    heading and every tool note goes underneath it, so build-dist.ps1 and new-run.ps1 may run
    in either order and neither has to be the one that creates the file. CLAUDE.md documents
    them build-first; nothing enforces that and nothing here needs to.
  * **It records only what a tool already knows** and currently prints to a console. Narration
    stays in knowledge.md, which is the one file in a run folder a person writes — the same
    reason hire.ps1 leaves that file alone after stubbing it and leaves its tags empty rather
    than guessing them. A machine-written line reads exactly like a written one.

No [[wikilinks]] in what this writes: check-index.ps1 resolves them across the record tree, and
a link to a run that was never scored would fail a check for a reason that is not a problem.
#>

function Add-MonsterDevAssemblyNote {
    [CmdletBinding()]
    param(
        # The run id. The note lands in process/runs/<RunId>/assembly.md, inside this repository
        # — never in the run folder, which is the hire's working copy and is scored as the §9
        # diff surface.
        [Parameter(Mandatory)][string]$RunId,

        # Which tool is speaking, e.g. 'new-run.ps1'. Becomes the heading of one log entry.
        [Parameter(Mandatory)][string]$Step,

        # One line each, rendered as a bullet list. Facts, not prose.
        [Parameter(Mandatory)][string[]]$Detail
    )

    $dir  = Join-Path 'process\runs' $RunId
    $file = Join-Path $dir 'assembly.md'
    New-Item -ItemType Directory -Force $dir | Out-Null

    if (-not (Test-Path $file)) {
        Set-Content -LiteralPath $file -Encoding utf8 -Value @(
            "# Assembly — $RunId"
            ''
            'Everything that happened to this run before its first paid turn. The headings below are'
            'for a person to fill in; the tool log at the bottom is appended to and is not worth'
            'editing.'
            ''
            'This file exists for the setups that are never hired. A run that was assembled, audited,'
            'corrected and then refused is the one whose lessons are worth keeping and whose folder'
            'gets deleted.'
            ''
            '## Pre-run audit'
            ''
            '*Empty until the `leak-auditor` has run. Its findings go here as `file:line`, the'
            'criterion each one short-circuits, and the quote — then, separately, what was done about'
            'each. A finding deliberately not acted on is a finding to write down rather than leave'
            'out: on `2026-08-03-r15` all nine were properties of the fixture, the stack note or the'
            'mirror, so all nine were identical in both arms and none could bias the comparison.'
            'That is a reason. An empty section under a finished run is not.*'
            ''
            '## Notes'
            ''
            '*Anything about this setup a tool does not know.*'
            ''
            '## Tool log'
        )
    }

    $stamp = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss')
    Add-Content -LiteralPath $file -Encoding utf8 -Value (
        @('', "### $Step — $stamp") + ($Detail | ForEach-Object { "- $_" })
    )

    $file
}

<#
#042, asked before the turn is paid for rather than out of the transcript afterwards.

`2026-08-01-alt-a` — the first run, and the one whose criteria the whole series is scored against —
was handed an entry-point path running through a session scratchpad. A scratchpad segment is a CLI
project slug: this repository's absolute path with the separators turned into dashes. The hire
decoded it and listed the repository root. It never walked up; it was handed the address. So a path
handed to a hire is part of the mirror surface, and what turn 1 *says* matters as much as where it
runs.

check-reach.ps1 finds this afterwards. This finds it before, which is the difference between a
contaminated run and a run not yet started — and it lives here, in a dot-sourced lib, so it can be
exercised against strings instead of against a paid turn. An instrument nothing has ever tested is
the failure mode this project has hit four times.

Returns the list of decodable references found, empty if none. It reports; the caller decides.
#>
function Test-MonsterDevEntryPointLeak {
    [CmdletBinding()]
    param(
        # Turn 1's prompt and the mirror path the hire is given — everything turn 1 states.
        [Parameter(Mandatory)][AllowEmptyString()][string]$Prompt,
        [Parameter(Mandatory)][AllowEmptyString()][string]$DistPath,
        # This repository's absolute path. Passed in rather than derived, so a test can pose one.
        [Parameter(Mandatory)][string]$RepoRoot
    )

    # The decodable form: the absolute path with `:` and the separators turned into dashes, which is
    # what a CLI project directory is named after.
    $slug = ($RepoRoot -replace '[:\\/]', '-')
    $haystack = "$Prompt $DistPath"

    $found = @()
    if ($haystack -like "*$RepoRoot*") { $found += "this repository's path ``$RepoRoot``" }
    if ($haystack -like "*$slug*")     { $found += "the repository slug ``$slug``" }
    # Not conditional on the slug matching. A scratchpad segment is a leak on its own: the slug it
    # encodes belongs to whichever project the session was started in, which need not be this one
    # and is somebody's absolute path either way.
    if ($haystack -match '(?i)scratchpad') { $found += 'a scratchpad segment' }

    # Comma operator, so a single finding does not unroll to a bare string in the caller's `if`.
    ,$found
}
