[CmdletBinding()]
param(
    [Parameter(Mandatory)][ValidatePattern('^v[0-9]+\.[0-9]+\.[0-9]+(?:-alpha\.[0-9]+)?$')][string]$Tag,
    [Parameter(Mandatory)][ValidatePattern('^[a-f0-9]{40}$')][string]$RootCommit,
    [Parameter(Mandatory)][ValidatePattern('^[a-z0-9-]+$')][string]$EvidenceLabel
)
$ErrorActionPreference = 'Stop'
$workspace = Split-Path $PSScriptRoot -Parent
$directory = Join-Path $workspace "artifacts/releases/$Tag"
$output = Join-Path $workspace "artifacts/$EvidenceLabel"
if (Test-Path -LiteralPath $output) { throw 'Publication evidence already exists; choose a fresh label.' }
New-Item -ItemType Directory -Path $output | Out-Null
$manifest = Get-Content -LiteralPath (Join-Path $directory 'release-manifest.json') -Raw | ConvertFrom-Json
if ($manifest.tag -ne $Tag) { throw 'Prepared manifest tag mismatch.' }
$manifestAssetNames = @($manifest.assets | ForEach-Object name)
if ('Telumia-Windows-x64.msi' -notin $manifestAssetNames -or
    @($manifestAssetNames | Where-Object { $_ -like '*.apk' }).Count -lt 1) {
    throw 'The main Telumia release requires the Windows PC MSI and at least one Android TV APK.'
}
$prerelease = $Tag.Contains('-')
if ($null -ne $manifest.prerelease -and $manifest.prerelease -ne $prerelease) { throw 'Prepared release channel mismatch.' }
$record = [ordered]@{status='preflight';tag=$Tag;prerelease=$prerelease;startedAtUtc=[DateTime]::UtcNow.ToString('o');releases=@()}
function Save-Record { $record | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath (Join-Path $output 'orchestration.json') -Encoding utf8 }
function Read-Release($repository, $id) {
    $raw = & gh api "repos/$repository/releases/$id"
    if ($LASTEXITCODE -ne 0) { throw 'Release read by ID failed.' }
    $raw | ConvertFrom-Json
}
try {
    foreach ($asset in $manifest.assets) {
        $file = Get-Item -LiteralPath (Join-Path $directory $asset.name)
        if ($file.Length -ne $asset.bytes -or (Get-FileHash -LiteralPath $file.FullName).Hash.ToLowerInvariant() -ne $asset.sha256) {
            throw 'A prepared release asset changed before publication.'
        }
    }
    $definitions = @(
        @{repo='Pepeu2010/telumia';commit=$RootCommit;notes='release-notes-root.md';names=@($manifest.assets.name)+@('release-manifest.json','SHA256SUMS.txt')},
        @{repo='Pepeu2010/telumia-desktop';commit=$manifest.sourceCommits.desktop;notes='release-notes-desktop.md';names=@('Telumia-Windows-x64.msi','Telumia-desktop-source.zip','release-manifest.json','SHA256SUMS.txt')},
        @{repo='Pepeu2010/telumia-tv';commit=$manifest.sourceCommits.tv;notes='release-notes-tv.md';names=@($manifest.assets.name | Where-Object { $_ -like 'Telumia-TV-*.apk' })+@('Telumia-tv-source.zip','release-manifest.json','SHA256SUMS.txt')}
    )
    # Check every repository before creating any draft. Never overwrite an existing release.
    foreach ($definition in $definitions) {
        $raw = & gh api "repos/$($definition.repo)/releases?per_page=100"
        if ($LASTEXITCODE -ne 0) { throw 'Release preflight listing failed.' }
        if (@(($raw | ConvertFrom-Json) | Where-Object tag_name -eq $Tag).Count) { throw 'This release already exists; existing assets are immutable.' }
        $rawRefs = & gh api "repos/$($definition.repo)/git/matching-refs/tags/$Tag"
        if ($LASTEXITCODE -ne 0) { throw 'Release tag preflight failed.' }
        $existingRef = @(($rawRefs | ConvertFrom-Json) | Where-Object ref -eq "refs/tags/$Tag")
        if ($existingRef.Count -and ($existingRef.Count -ne 1 -or $existingRef[0].object.type -ne 'commit' -or $existingRef[0].object.sha -ne $definition.commit)) {
            throw 'An existing release tag points elsewhere; tag replacement is refused.'
        }
        if (-not (Test-Path -LiteralPath (Join-Path $directory $definition.notes))) { throw 'Portuguese release notes are required.' }
    }
    foreach ($definition in $definitions) {
        $record.status="creating-draft-$($definition.repo)"; Save-Record
        $files = @($definition.names | ForEach-Object { Join-Path $directory $_ })
        $arguments = @('release','create',$Tag)+$files+@('--repo',$definition.repo,'--target',$definition.commit,'--title',"Telumia $($Tag.Substring(1))",'--notes-file',(Join-Path $directory $definition.notes),'--draft')
        if ($prerelease) { $arguments += '--prerelease' }
        & gh @arguments
        if ($LASTEXITCODE -ne 0) { throw 'Draft creation/upload failed; preserve any uploaded draft for inspection.' }
        $raw = & gh api "repos/$($definition.repo)/releases?per_page=100"
        if ($LASTEXITCODE -ne 0) { throw 'Draft listing failed.' }
        $matches = @(($raw | ConvertFrom-Json) | Where-Object tag_name -eq $Tag)
        if ($matches.Count -ne 1) { throw 'Expected exactly one newly created draft.' }
        $release = Read-Release $definition.repo $matches[0].id
        if (-not $release.draft -or $release.prerelease -ne $prerelease -or $release.target_commitish -ne $definition.commit -or $release.assets.Count -ne $definition.names.Count) {
            throw 'Draft source, state or asset count mismatch.'
        }
        foreach ($asset in $release.assets) {
            if ($asset.name -notin $definition.names) { throw 'Unexpected draft asset.' }
            $file = Get-Item -LiteralPath (Join-Path $directory $asset.name)
            $hash = (Get-FileHash -LiteralPath $file.FullName).Hash.ToLowerInvariant()
            if ($asset.state -ne 'uploaded' -or $asset.size -ne $file.Length -or $asset.digest -ne "sha256:$hash") { throw 'Draft asset digest or size mismatch.' }
        }
        $record.releases += @([ordered]@{repository=$definition.repo;id=$release.id;sourceCommit=$definition.commit;state='verified-draft';assetCount=$release.assets.Count})
        Save-Record
    }
    $record.status='publishing-verified-drafts'; Save-Record
    foreach ($release in $record.releases) {
        $publishArguments = @('api','--method','PATCH',"repos/$($release.repository)/releases/$($release.id)",'-F','draft=false','-F',"prerelease=$($prerelease.ToString().ToLowerInvariant())",'--silent')
        if (-not $prerelease) { $publishArguments += @('-f','make_latest=true') }
        & gh @publishArguments
        if ($LASTEXITCODE -ne 0) { throw 'Verified draft publication failed.' }
        $release.state='published'; Save-Record
    }
    & (Join-Path $PSScriptRoot 'Verify-TelumiaRelease.ps1') -Tag $Tag -OutputName "$EvidenceLabel-verification.json"
    $rootRef = & gh api "repos/Pepeu2010/telumia/git/ref/tags/$Tag" | ConvertFrom-Json
    if ($LASTEXITCODE -ne 0 -or $rootRef.object.type -ne 'commit' -or $rootRef.object.sha -ne $RootCommit) { throw 'Published root tag differs from the approved release source.' }
    $record.status='passed'
} catch { $record.status='failed'; $record['failure']=$_.Exception.Message; throw }
finally { $record['finishedAtUtc']=[DateTime]::UtcNow.ToString('o'); Save-Record }
