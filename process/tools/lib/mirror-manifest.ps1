# The mirror's own fingerprint, written when it is built and checked after every turn.
#
# --- what this is for, and why the mirror needed it -------------------------------------------
#
# #075. On 2026-08-04 a hire ran `rm -f "<dist>/monsters/README.md"` in its cleanup phase — by its
# own description, *"accidentally also tried removing unrelated dist file"* — then tried to confirm
# what it had done, was blocked by the fence, and led its final message with the mistake anyway.
# `build-dist.ps1` had written 18 files and the mirror held 17.
#
# It cost that run nothing, and that is luck about which file it was. Three checks look at a run and
# none of them looks here:
#
#   build-dist.ps1        the mirror       BEFORE the hire
#   check-isolation.ps1   ancestry, two sideways levels, bundles   before each turn
#   check-reach.ps1       paths and URLs the hire touched          after
#   13a / git status      the TARGET worktree                      after
#
# A write *inside* the mirror is by definition not a reach, so check-reach.ps1 cannot see it. The
# sequence "hire corrupts the playbook it is being measured against, then reports normally" produced
# a report that said clean. Had the deleted file been MONSTER-DEV.md the run would have been
# unmeasurable and nothing would have said so; on an A/B it is worse, because the two arms then
# differ by the treatment *plus* a missing file, with the second difference nowhere on paper.
#
# --- what this is not ------------------------------------------------------------------------
#
# Not a product finding, and §9 is not widened for it. In production <dist> is a
# raw.githubusercontent.com URL and cannot be written to; the mirror is a *run class artefact* that
# introduces a writable copy of the instructions inside the hire's own --allowedTools fence, which
# the thing it stands in for does not have. Telling a hire "don't delete the folder your
# instructions came from" would be advice for a situation that only exists in our harness.
#
# Not read-only either. That would work, and it would change what the hire's tools can do inside a
# run — a new variable in every arm, introduced to prevent something that has happened once and cost
# nothing. Detection first; if it recurs, reconsider.
#
# Not a gate. A mismatch is a validity finding for the report and never an automatic void: the honest
# verdict depends on which file changed and when, and that is a reader's call. What must not happen
# is the reader never being told.
#
# --- where the manifest lives, which is not where #075 proposed ------------------------------
#
# That item said "beside the mirror, not inside it — a file inside dist/ is a file the hire can
# read". The first half does not follow from the second. `<runs root>\<id>\` is one `ls ..` from the
# hire's working directory, and check-isolation.ps1 ignores *files* there by design, so a
# `dist-manifest.json` sitting next to `dist/` would be visible and would say, to a hire that
# already called this folder *"Testrig-Scaffolding"*, that the instructions it was handed are a
# verified copy of something. That is the #018 class of leak arriving by a new road for the sake of
# a convenience.
#
# So it goes in the run's record folder under process/, which is excluded from the mirror, is where
# every other captured artefact already lives, and is committed with the run. The manifest is
# harness furniture: paths and hashes, no criteria, nothing about what is measured.

$script:MonsterDevMirrorRepoRoot = [System.IO.Path]::GetFullPath(
    (Split-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) -Parent))

function Get-MonsterDevMirrorManifestPath {
    <#
    .SYNOPSIS
    Where a run's mirror manifest lives: process/runs/<RunId>/dist-manifest.json.
    #>
    param([Parameter(Mandatory)][string]$RunId)
    Join-Path $script:MonsterDevMirrorRepoRoot "process\runs\$RunId\dist-manifest.json"
}

function Get-MonsterDevMirrorFiles {
    <#
    .SYNOPSIS
    Every file in a mirror as relative path -> SHA-256, sorted.

    .DESCRIPTION
    Forward slashes and lowercase hashes on both sides of the comparison, so the manifest does not
    depend on which script wrote it. Both callers use this one function for exactly that reason:
    two hashers that agree by convention are two hashers that disagree after the next edit.
    #>
    param([Parameter(Mandatory)][string]$DistPath)

    $root = (Resolve-Path $DistPath).Path.TrimEnd('\')
    $map  = [ordered]@{}
    foreach ($f in (Get-ChildItem -LiteralPath $root -Recurse -File | Sort-Object FullName)) {
        $rel = $f.FullName.Substring($root.Length).TrimStart('\').Replace('\', '/')
        $map[$rel] = (Get-FileHash -LiteralPath $f.FullName -Algorithm SHA256).Hash.ToLower()
    }
    $map
}

function New-MonsterDevMirrorManifest {
    <#
    .SYNOPSIS
    Writes the manifest for a freshly built mirror and returns what it wrote.

    .DESCRIPTION
    Called by build-dist.ps1 past its failure gate, so a manifest only ever describes a mirror that
    exists and passed every check. One extra write per build — the script already enumerated and
    verified everything it copied.
    #>
    param(
        [Parameter(Mandatory)][string]$RunId,
        [Parameter(Mandatory)][string]$DistPath
    )

    $files = Get-MonsterDevMirrorFiles -DistPath $DistPath
    $out   = [pscustomobject]@{
        runId     = $RunId
        dist      = (Resolve-Path $DistPath).Path
        builtAt   = (Get-Date).ToUniversalTime().ToString('o')
        fileCount = $files.Count
        files     = [pscustomobject]$files
    }

    $path = Get-MonsterDevMirrorManifestPath -RunId $RunId
    New-Item -ItemType Directory -Force (Split-Path $path) | Out-Null
    $out | ConvertTo-Json -Depth 5 | Set-Content $path -Encoding utf8
    $out
}

function Test-MonsterDevMirror {
    <#
    .SYNOPSIS
    Compares a mirror against its manifest. Reports; never throws on a mismatch.

    .DESCRIPTION
    Returns a status of `intact`, `changed`, `no-manifest` or `no-mirror`, with the differences named
    per class — a deleted MONSTER-DEV.md and an added scratch file are not the same finding and must
    not share a word.

    `no-manifest` is not damage: every run before 2026-08-04 was built without one, and an archived
    run whose mirror is long gone reports `no-mirror`. Both are stated rather than blurred into a
    pass, for the reason score-bundle.ps1 gives about its own absent artefacts — a check that says
    nothing and a check that had nothing to say look identical afterwards.
    #>
    param(
        [Parameter(Mandatory)][string]$RunId,
        [Parameter(Mandatory)][string]$DistPath
    )

    $result = [ordered]@{
        status   = 'intact'
        missing  = @()
        modified = @()
        added    = @()
        checkedAt = (Get-Date).ToUniversalTime().ToString('o')
    }

    $path = Get-MonsterDevMirrorManifestPath -RunId $RunId
    if (-not (Test-Path $path)) {
        $result['status'] = 'no-manifest'
        return [pscustomobject]$result
    }
    if (-not (Test-Path $DistPath)) {
        $result['status'] = 'no-mirror'
        return [pscustomobject]$result
    }

    $manifest = Get-Content $path -Raw | ConvertFrom-Json
    $expected = @{}
    foreach ($p in $manifest.files.PSObject.Properties) { $expected[$p.Name] = $p.Value }
    $actual = Get-MonsterDevMirrorFiles -DistPath $DistPath

    foreach ($rel in $expected.Keys) {
        if (-not $actual.Contains($rel))        { $result['missing']  += $rel }
        elseif ($actual[$rel] -ne $expected[$rel]) { $result['modified'] += $rel }
    }
    foreach ($rel in $actual.Keys) {
        if (-not $expected.ContainsKey($rel)) { $result['added'] += $rel }
    }

    if ($result['missing'] -or $result['modified'] -or $result['added']) { $result['status'] = 'changed' }
    [pscustomobject]$result
}
