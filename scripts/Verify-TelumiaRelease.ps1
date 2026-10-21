[CmdletBinding()]
param(
    [ValidatePattern('^v[0-9]+\.[0-9]+\.[0-9]+(?:-alpha\.[0-9]+)?$')][string]$Tag = 'v1.0.0',
    [ValidatePattern('^[a-z0-9-]+\.json$')][string]$OutputName = 'telumia-release-verification.json',
    [ValidateSet('all','main')][string]$Scope = 'all'
)
$ErrorActionPreference = 'Stop'
$workspace = Split-Path $PSScriptRoot -Parent
$directory = Join-Path $workspace "artifacts/releases/$Tag"
$manifest = Get-Content -LiteralPath (Join-Path $directory 'release-manifest.json') -Raw | ConvertFrom-Json
$version = $Tag.Substring(1)
$rootAssets = @($manifest.assets | ForEach-Object name) + @('release-manifest.json','SHA256SUMS.txt')
$tvApks = @($manifest.assets | Where-Object { $_.name -like 'Telumia-TV-*.apk' } | ForEach-Object name)
$definitions = @(
    @{repository='Pepeu2010/telumia';requiredNames=$rootAssets;allowAdditionalApks=$false},
    @{repository='Pepeu2010/telumia-desktop';requiredNames=@('Telumia-Windows-x64.msi','Telumia-desktop-source.zip','release-manifest.json','SHA256SUMS.txt');allowAdditionalApks=$false},
    @{repository='Pepeu2010/telumia-tv';requiredNames=$tvApks+@("Telumia-Windows-x64-$version.msi",'Telumia-tv-source.zip');allowAdditionalApks=$true}
)
if ($Scope -eq 'main') { $definitions = @($definitions | Where-Object repository -eq 'Pepeu2010/telumia') }
$records = foreach ($definition in $definitions) {
    $raw = gh api "repos/$($definition.repository)/releases/tags/$Tag"
    if ($LASTEXITCODE -ne 0) { throw "Release unavailable: $($definition.repository)" }
    $release = $raw | ConvertFrom-Json
    $expectedPrerelease = $Tag.Contains('-')
    if ($release.draft -or $release.prerelease -ne $expectedPrerelease) {
        throw "Unexpected release state or asset count: $($definition.repository)"
    }
    if (@($release.assets | Where-Object state -ne 'uploaded').Count) {
        throw "Release has an unfinished asset upload: $($definition.repository)"
    }
    $remoteNames = @($release.assets | ForEach-Object name)
    foreach ($requiredName in $definition.requiredNames) {
        if ($requiredName -notin $remoteNames) { throw "Required release asset missing: $($definition.repository)/$requiredName" }
    }
    $extraNames = @($remoteNames | Where-Object { $_ -notin $definition.requiredNames })
    $allowedAdditionalNames = @('release-manifest.json','SHA256SUMS.txt')
    if ($extraNames.Count -and (-not $definition.allowAdditionalApks -or @($extraNames | Where-Object { $_ -notlike 'Telumia-TV-*.apk' -and $_ -notin $allowedAdditionalNames }).Count)) {
        throw "Unexpected additional release asset: $($definition.repository)"
    }
    if ($definition.repository -eq 'Pepeu2010/telumia') {
        $assetNames = @($release.assets | ForEach-Object name)
        if ('Telumia-Windows-x64.msi' -notin $assetNames -or
            @($assetNames | Where-Object { $_ -like '*.apk' }).Count -lt 1) {
            throw 'The main Telumia release must contain both the Windows PC MSI and Android TV APKs.'
        }
    }
    if (-not $expectedPrerelease) {
        $latest = gh api "repos/$($definition.repository)/releases/latest" | ConvertFrom-Json
        if ($LASTEXITCODE -ne 0 -or $latest.id -ne $release.id -or $latest.tag_name -ne $Tag) {
            throw "Regular release is not the current Latest: $($definition.repository)"
        }
    }
    $assets = foreach ($assetName in $definition.requiredNames) {
        $asset = $release.assets | Where-Object name -eq $assetName | Select-Object -First 1
        if ($asset.state -ne 'uploaded') { throw "Release asset upload incomplete: $($definition.repository)/$assetName" }
        $localName = if ($assetName -eq "Telumia-Windows-x64-$version.msi") { 'Telumia-Windows-x64.msi' } else { $assetName }
        $local = Join-Path $directory $localName
        if (-not (Test-Path -LiteralPath $local)) { throw "Unexpected remote asset: $($asset.name)" }
        $file = Get-Item -LiteralPath $local
        $hash = (Get-FileHash -LiteralPath $local -Algorithm SHA256).Hash.ToLowerInvariant()
        if ($asset.state -ne 'uploaded' -or $asset.size -ne $file.Length -or $asset.digest -ne "sha256:$hash") {
            throw "Remote checksum/state mismatch: $($asset.name)"
        }
        [ordered]@{name=$asset.name;bytes=$asset.size;sha256=$hash;remoteDigestVerified=$true;url=$asset.browser_download_url}
    }
    $ref = gh api "repos/$($definition.repository)/git/ref/tags/$Tag" | ConvertFrom-Json
    if ($LASTEXITCODE -ne 0) { throw 'Tag verification failed' }
    $tagCommit = $ref.object.sha
    if ($ref.object.type -eq 'tag') {
        $tag = gh api "repos/$($definition.repository)/git/tags/$tagCommit" | ConvertFrom-Json
        if ($LASTEXITCODE -ne 0 -or $tag.object.type -ne 'commit') { throw 'Tag does not resolve to a source commit.' }
        $tagCommit = $tag.object.sha
    }
    $expectedCommit = switch ($definition.repository) {
        'Pepeu2010/telumia-desktop' { $manifest.sourceCommits.desktop }
        'Pepeu2010/telumia-tv' { $manifest.sourceCommits.tv }
        default { $null }
    }
    if ($expectedCommit -and $tagCommit -ne $expectedCommit) { throw 'Published client tag differs from the packaged source commit.' }
    [ordered]@{repository=$definition.repository;url=$release.html_url;tag=$Tag;tagObject=$ref.object.sha;tagCommit=$tagCommit;sourceCommitVerified=[bool]$expectedCommit;prerelease=$release.prerelease;latestRegularReleaseVerified=(-not $expectedPrerelease);additionalUploadedAssets=$extraNames;assets=@($assets)}
}
[ordered]@{verifiedAtUtc=[DateTime]::UtcNow.ToString('o');scope='Required release packages compared with local SHA-256; additional uploaded TV APKs and TV metadata are listed but not compared with the central artifact set; not runtime or device QA';releases=@($records)} |
    ConvertTo-Json -Depth 9 | Set-Content (Join-Path $workspace "docs/$OutputName") -Encoding utf8
Write-Output "Verified $($definitions.Count) published release(s) ($Tag), including APK + PC packages in the main repository, against required assets and local SHA-256 digests."
