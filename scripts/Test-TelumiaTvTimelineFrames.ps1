[CmdletBinding()]
param(
    [Parameter(Mandatory)][ValidatePattern('^[a-z0-9-]+$')][string]$BuildLabel,
    [Parameter(Mandatory)][ValidatePattern('^[a-z0-9-]+$')][string]$EvidenceLabel,
    [ValidateSet('24','36')][string]$AndroidApi = '36',
    [ValidateRange(1,100)][int]$ExpectedTests = 5,
    [switch]$Install
)
$ErrorActionPreference = 'Stop'
$workspace = Split-Path $PSScriptRoot -Parent
$checkout = Join-Path $workspace 'repos/tv'
$adb = Join-Path $env:LOCALAPPDATA 'Android/Sdk/platform-tools/adb.exe'
$serial = if ($AndroidApi -eq '24') { 'emulator-5570' } else { 'emulator-5568' }
$expectedAvd = if ($AndroidApi -eq '24') { 'Telumia_API24_01a10441' } else { 'NuvioEnhanced_ATV_01a10441' }
$appId = 'io.github.pepeu2010.telumia.tv.debug'
$output = Join-Path $workspace "artifacts/$EvidenceLabel"
if (Test-Path -LiteralPath $output) { throw 'Choose fresh native evidence label.' }
$binding = Get-Content -LiteralPath (Join-Path $workspace "docs/$BuildLabel-build-binding.json") -Raw | ConvertFrom-Json
$head = (git -C $checkout rev-parse HEAD).Trim()
if ($binding.buildStatus -ne 'passed' -or $binding.sourceCommit -ne $head -or @(git -C $checkout status --porcelain).Count) { throw 'Expected clean source and passed build binding.' }
$state = @(& $adb -s $serial get-state 2>&1)
if ($LASTEXITCODE -ne 0 -or ($state -join '').Trim() -ne 'device') { throw 'Owned emulator must be running.' }
$avd = @(& $adb -s $serial emu avd name)
$api = (@(& $adb -s $serial shell getprop ro.build.version.sdk) -join '').Trim()
if ($avd[0] -ne $expectedAvd -or $api -ne $AndroidApi) { throw 'Unexpected emulator; refusing instrumentation.' }
New-Item -ItemType Directory -Path $output | Out-Null
$record = [ordered]@{status='running';startedAtUtc=[DateTime]::UtcNow.ToString('o');sourceCommit=$head;buildLabel=$BuildLabel;
    androidApi=$api;emulator=$expectedAvd;scope='Real Media3 AVC decoding, generated original red/blue video, timestamps, primary position isolation, source ownership, queued cancellation, failure recovery, filmstrip, authenticated localhost HTTP and an explicit native DataSource byte-range read. No active HTTP cancellation, product UI, D-pad, HDR or physical-device proof.'}
try {
    foreach ($fileName in @('app-full-universal-debug.apk','app-full-debug-androidTest.apk')) {
        $package = $binding.packages | Where-Object file -eq $fileName
        $path = Join-Path $workspace $package.path
        if ((Get-FileHash -LiteralPath $path).Hash.ToLowerInvariant() -ne $package.sha256) { throw 'Preserved package hash mismatch.' }
        if ($Install) {
            & $adb -s $serial install -r $path
            if ($LASTEXITCODE -ne 0) { throw 'Package installation failed.' }
        }
        $record[$(if ($fileName -eq 'app-full-universal-debug.apk') { 'apkSha256' } else { 'testApkSha256' })] = $package.sha256
    }
    $log = @(& $adb -s $serial shell am instrument -w -r -e class com.nuvio.tv.ui.screens.player.TimelineFramesTvTest "$appId.test/androidx.test.runner.AndroidJUnitRunner" 2>&1)
    $log | Set-Content -LiteralPath (Join-Path $output 'instrumentation.log') -Encoding utf8
    $report = $log -join "`n"
    if ($report -notmatch ("OK \(" + $ExpectedTests + " tests\)") -or $report -match 'INSTRUMENTATION_STATUS_CODE: -2|FAILURES!!!') { throw 'Every expected real frame-extraction case must pass; inspect preserved native log.' }
    $captures = @()
    foreach ($position in @(500,4500)) {
        $name = "telumia-timeline-frame-$position.png"
        $capture = Join-Path $output $name
        & $adb -s $serial pull "/sdcard/Android/data/$appId/files/$name" $capture
        if ($LASTEXITCODE -ne 0) { throw 'Cannot export actual decoded frame.' }
        $bytes = [IO.File]::ReadAllBytes($capture)
        if ($bytes.Length -lt 24 -or $bytes[0] -ne 137 -or $bytes[1] -ne 80) { throw 'Decoded frame is not PNG.' }
        $width = [int64]$bytes[16]*16777216 + [int64]$bytes[17]*65536 + [int64]$bytes[18]*256 + $bytes[19]
        $height = [int64]$bytes[20]*16777216 + [int64]$bytes[21]*65536 + [int64]$bytes[22]*256 + $bytes[23]
        if ($width -ne 320 -or $height -ne 180) { throw 'Decoded frame exceeds the bounded dimensions.' }
        $captures += @{file=$name;decodedMs=$position;pixels="${width}x${height}";sha256=(Get-FileHash -LiteralPath $capture).Hash.ToLowerInvariant()}
    }
    if ($head -ne (git -C $checkout rev-parse HEAD).Trim() -or @(git -C $checkout status --porcelain).Count) { throw 'Source changed during instrumentation.' }
    $record['captures']=$captures; $record['testsPassed']=$ExpectedTests; $record.status='passed'
    if ($ExpectedTests -eq 7) { $record.scope = 'Seven actual Media3 frame cases, including release before queued preparation and cancellation of a live HTTP body with observed peer connection closure and recovery. No product UI, D-pad, HDR or physical-device proof.' }
} catch { $record.status='failed';$record['failure']=$_.Exception.Message;throw }
finally {
    $record['finishedAtUtc']=[DateTime]::UtcNow.ToString('o')
    $record | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath (Join-Path $output 'qa.json') -Encoding utf8
}
Write-Output "$ExpectedTests real TV timeline frame cases passed on API $AndroidApi."
