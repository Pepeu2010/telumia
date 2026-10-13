[CmdletBinding()]
param(
    [Parameter(Mandatory)][ValidatePattern('^[a-z0-9-]+$')][string]$DesktopBuildLabel,
    [Parameter(Mandatory)][ValidatePattern('^[a-z0-9-]+$')][string]$TvBuildLabel,
    [ValidatePattern('^[a-z0-9-]+\.json$')][string]$OutputName='telumia-v100-upgrade-inspection.json'
)
$ErrorActionPreference='Stop'
$workspace=Split-Path $PSScriptRoot -Parent
function PreservedPackage($label,$name) {
    $binding=Get-Content -LiteralPath (Join-Path $workspace "docs/$label-build-binding.json") -Raw | ConvertFrom-Json
    if($binding.buildStatus -ne 'passed') { throw 'Upgrade inspection requires passed build bindings.' }
    $package=@($binding.packages | Where-Object file -eq $name)
    if($package.Count -ne 1) { throw 'Expected exactly one preserved package.' }
    $path=Join-Path $workspace $package[0].path
    if((Get-FileHash -LiteralPath $path).Hash.ToLowerInvariant() -ne $package[0].sha256) { throw 'Preserved package hash changed.' }
    return $path
}
function MsiProperties($path) {
    $installer=New-Object -ComObject WindowsInstaller.Installer
    $database=$installer.OpenDatabase($path,0)
    $properties=[ordered]@{}
    foreach($key in @('ProductName','ProductCode','UpgradeCode','ProductVersion')) {
        $view=$database.OpenView("SELECT Value FROM Property WHERE Property = '$key'")
        $null=$view.Execute();$row=$view.Fetch();$properties[$key]=$row.StringData(1);$null=$view.Close()
    }
    return $properties
}
$oldMsi=PreservedPackage 'telumia-v022-desktop-r1' 'Telumia-Windows-x64-0.2.2-alpha.1.msi'
$newMsi=PreservedPackage $DesktopBuildLabel 'Telumia-Windows-x64-1.0.0.msi'
$oldProperties=MsiProperties $oldMsi
$newProperties=MsiProperties $newMsi
if($newProperties.ProductName -ne 'Telumia' -or $newProperties.UpgradeCode -ne $oldProperties.UpgradeCode -or
    $newProperties.ProductCode -eq $oldProperties.ProductCode -or [Version]$newProperties.ProductVersion -le [Version]$oldProperties.ProductVersion) {
    throw 'Windows installer identity/version does not support a monotonic upgrade.'
}
$buildTools=Join-Path $env:LOCALAPPDATA 'Android/Sdk/build-tools/35.0.0'
$jdk=Get-ChildItem (Join-Path $env:USERPROFILE '.gradle/jdks') -Directory | Where-Object Name -Match '-17-' | Select-Object -First 1
if(-not $jdk) { throw 'JDK 17 unavailable.' }
$priorJavaHome=$env:JAVA_HOME
try {
    $env:JAVA_HOME=$jdk.FullName
    function ApkIdentity($path) {
        $badging=@(& (Join-Path $buildTools 'aapt2.exe') dump badging $path)
        if($LASTEXITCODE -ne 0) { throw 'APK badging failed.' }
        $package=$badging | Where-Object { $_.StartsWith('package:') } | Select-Object -First 1
        $certificates=@(& (Join-Path $buildTools 'apksigner.bat') verify --print-certs $path)
        if($LASTEXITCODE -ne 0) { throw 'APK signature verification failed.' }
        $digests=@($certificates | Where-Object { $_ -match '^Signer #[0-9]+ certificate SHA-256 digest:' } | ForEach-Object { ($_ -split ':',2)[1].Trim().ToLowerInvariant() })
        if($digests.Count -ne 1) { throw 'Expected one APK signing identity.' }
        [ordered]@{applicationId=[regex]::Match($package,"name='([^']+)'").Groups[1].Value;
            versionName=[regex]::Match($package,"versionName='([^']+)'").Groups[1].Value;
            versionCode=[int][regex]::Match($package,"versionCode='([^']+)'").Groups[1].Value;
            signingCertificateSha256=$digests[0]}
    }
    $oldApk=ApkIdentity (PreservedPackage 'telumia-v022-tv-r1' 'app-full-universal-debug.apk')
    $apkRecords=foreach($abi in @('universal','arm64-v8a','armeabi-v7a','x86','x86_64')) {
        $identity=ApkIdentity (PreservedPackage $TvBuildLabel "app-full-$abi-debug.apk")
        if($identity.applicationId -ne $oldApk.applicationId -or $identity.signingCertificateSha256 -ne $oldApk.signingCertificateSha256 -or
            $identity.versionCode -le $oldApk.versionCode -or $identity.versionName -ne '1.0.0') { throw 'APK upgrade identity, certificate or version mismatch.' }
        [ordered]@{abi=$abi;identity=$identity}
    }
} finally { $env:JAVA_HOME=$priorJavaHome }
[ordered]@{status='passed';inspectedAtUtc=[DateTime]::UtcNow.ToString('o');
    buildLabels=@{desktop=$DesktopBuildLabel;tv=$TvBuildLabel};
    scope='Package metadata and public signing certificate checks. Does not prove migration of installed user data or a real MSI upgrade installation.';
    windows=@{previous=$oldProperties;current=$newProperties;monotonicVersion=$true;upgradeIdentityPreserved=$true};
    android=@{previous=$oldApk;current=@($apkRecords);packageAndSigningIdentityPreserved=$true}} |
    ConvertTo-Json -Depth 8 | Set-Content -LiteralPath (Join-Path $workspace "docs/$OutputName") -Encoding utf8
Write-Output 'Windows upgrade identity/version and five Android signing/version identities passed inspection.'
