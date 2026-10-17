[CmdletBinding()]
param(
    [ValidateRange(1,1000)][double]$MinimumFreeGiB = 40,
    [ValidateRange(1,1000)][double]$MaximumArtifactsGiB = 16,
    [ValidateRange(0,[long]::MaxValue)][long]$AdditionalBytes = 0
)
$ErrorActionPreference = 'Stop'
$workspace = [IO.Path]::GetFullPath((Split-Path $PSScriptRoot -Parent))
$drive = [IO.DriveInfo]::new([IO.Path]::GetPathRoot($workspace))
if (($drive.AvailableFreeSpace - $AdditionalBytes) -lt ($MinimumFreeGiB * 1GB)) {
    throw ('Storage budget: {0:N1} GiB free; this operation requires {1:N1} GiB plus {2:N1} GiB of reserve. No build/copy was started. See docs/STORAGE_POLICY.md.' -f ($drive.AvailableFreeSpace / 1GB), ($AdditionalBytes / 1GB), $MinimumFreeGiB)
}
$artifacts = Join-Path $workspace 'artifacts'
$bytes = 0L
if (Test-Path -LiteralPath $artifacts) {
    $options = [IO.EnumerationOptions]::new()
    $options.RecurseSubdirectories = $true
    $options.AttributesToSkip = [IO.FileAttributes]::ReparsePoint
    $options.IgnoreInaccessible = $false
    foreach ($path in [IO.Directory]::EnumerateFiles($artifacts, '*', $options)) {
        $bytes += [IO.FileInfo]::new($path).Length
        if (($bytes + $AdditionalBytes) -gt ($MaximumArtifactsGiB * 1GB)) {
            throw ('Storage budget: artifacts exceed the {0:N1} GiB budget including the requested copy. Keep sources/reports and remove obsolete generated packages before continuing. See docs/STORAGE_POLICY.md.' -f $MaximumArtifactsGiB)
        }
    }
}
Write-Output ('Storage budget passed: {0:N1} GiB free; {1:N1} GiB in artifacts.' -f ($drive.AvailableFreeSpace / 1GB), ($bytes / 1GB))
