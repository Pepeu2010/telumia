[CmdletBinding()]
param(
    [Parameter(Mandatory)][ValidatePattern('^[a-z0-9-]+$')][string]$LabelPrefix,
    [Parameter(Mandatory)][ValidatePattern('^[a-z0-9-]+$')][string]$DesktopBuildLabel,
    [Parameter(Mandatory)][ValidatePattern('^[a-z0-9-]+$')][string]$TvBuildLabel,
    [Parameter(Mandatory)][ValidatePattern('^[a-z0-9-]+$')][string]$TvStartupPrefix,
    [Parameter(Mandatory)][ValidatePattern('^[a-z0-9-]+$')][string]$RendererEvidenceLabel
)
$ErrorActionPreference='Stop'
$workspace=Split-Path $PSScriptRoot -Parent
$bindings=@{}
foreach($target in @('desktop','tv')) {
    $label=if($target -eq 'desktop'){$DesktopBuildLabel}else{$TvBuildLabel}
    $binding=Get-Content -LiteralPath (Join-Path $workspace "docs/$label-build-binding.json") -Raw | ConvertFrom-Json
    $checkout=Join-Path $workspace "repos/$target"
    if($binding.buildStatus -ne 'passed' -or $binding.sourceCommit -ne (git -C $checkout rev-parse HEAD).Trim() -or @(git -C $checkout status --porcelain).Count) { throw 'Runtime gates must match current clean source bindings.' }
    $bindings[$target]=$binding
}
$tvApk=($bindings.tv.packages | Where-Object file -eq 'app-full-universal-debug.apk').sha256
$tvTestApk=($bindings.tv.packages | Where-Object file -eq 'app-full-debug-androidTest.apk').sha256
$evidence=@()
function EvidenceRecord($name) {
    $path=Join-Path $workspace "docs/$name"
    [ordered]@{file=$name;sha256=(Get-FileHash -LiteralPath $path).Hash.ToLowerInvariant()}
}
foreach($api in @('24','36')) {
    $frameName="$TvBuildLabel-api$api-qa.json"
    $frame=Get-Content -LiteralPath (Join-Path $workspace "docs/$frameName") -Raw | ConvertFrom-Json
    if($frame.status -ne 'passed' -or $frame.sourceCommit -ne $bindings.tv.sourceCommit -or $frame.apkSha256 -ne $tvApk -or $frame.testApkSha256 -ne $tvTestApk -or $frame.testsPassed -ne 5 -or $frame.androidApi -ne $api -or $frame.captures.Count -ne 2 -or
        @($frame.captures | Where-Object { $_.pixels -ne '320x180' -or $_.decodedMs -notin @(500,4500) }).Count) { throw 'Native timeline proof is missing or mismatched.' }
    $evidence+=@(EvidenceRecord $frameName)
    $startupName="$TvStartupPrefix-api$api-qa.json"
    $startup=Get-Content -LiteralPath (Join-Path $workspace "docs/$startupName") -Raw | ConvertFrom-Json
    if($startup.status -ne 'passed' -or $startup.sourceCommit -ne $bindings.tv.sourceCommit -or $startup.apkSha256 -ne $tvApk -or $startup.androidApi -ne $api -or
        $startup.processAliveAfterSeconds -lt 30 -or -not $startup.mainActivityResumed -or $startup.appCrashRecorded -or $startup.appAnrRecorded) { throw 'Real TV startup proof is missing or mismatched.' }
    $evidence+=@(EvidenceRecord $startupName)
}
$renderer=Get-Content -LiteralPath (Join-Path $workspace "artifacts/$RendererEvidenceLabel/desktop/browser-qa/qa.json") -Raw | ConvertFrom-Json
if($renderer.status -ne 'passed' -or $renderer.sourceCommit -ne $bindings.desktop.sourceCommit -or $renderer.buildLabel -ne $DesktopBuildLabel -or $renderer.viewports.Count -ne 8) { throw 'Desktop renderer proof is missing or mismatched.' }
$checks=0
foreach($viewport in $renderer.viewports) {
    if($viewport.report.errors.Count -or $viewport.report.cases.Count -ne 9 -or $viewport.report.checks.Count -lt 1 -or @($viewport.report.checks | Where-Object {-not $_.passed}).Count) { throw 'Desktop renderer reported failures.' }
    $checks+=$viewport.report.checks.Count
}
$rendererName="$LabelPrefix-renderer-qa.json"
Copy-Item -LiteralPath (Join-Path $workspace "artifacts/$RendererEvidenceLabel/desktop/browser-qa/qa.json") -Destination (Join-Path $workspace "docs/$rendererName")
$evidence+=@(EvidenceRecord $rendererName)
$upgradeName="$LabelPrefix-upgrade-inspection.json"
$upgrade=Get-Content -LiteralPath (Join-Path $workspace "docs/$upgradeName") -Raw | ConvertFrom-Json
if($upgrade.status -ne 'passed' -or $upgrade.buildLabels.desktop -ne $DesktopBuildLabel -or $upgrade.buildLabels.tv -ne $TvBuildLabel) { throw 'Upgrade package inspection is missing or mismatched.' }
$evidence+=@(EvidenceRecord $upgradeName)
[ordered]@{status='passed';exportedAtUtc=[DateTime]::UtcNow.ToString('o');
    sourceCommits=@{desktop=$bindings.desktop.sourceCommit;tv=$bindings.tv.sourceCommit};
    evidence=@($evidence);desktopRendererChecks=$checks;nativeFrameCases=10;startupApis=@('24','36');
    scope='Selected native extraction, controlled renderer, 30-second startup and package-upgrade metadata gates. No full-product, real-account, installed-data migration, HDR, physical-device or Linux/macOS proof.'} |
    ConvertTo-Json -Depth 8 | Set-Content -LiteralPath (Join-Path $workspace "docs/$LabelPrefix-runtime-gates.json") -Encoding utf8
Write-Output 'Current-source runtime release gates and evidence hashes exported.'
