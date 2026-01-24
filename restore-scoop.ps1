$ErrorActionPreference = "Stop"

$BaseUrl = "https://raw.githubusercontent.com/serosme/scoop-setup/main"
$TempFile = Join-Path $env:TEMP "scoop-backup.json"

$Backups = @(
    "scoop-base.json",
    "scoop-dev.json"
)

try {
    Write-Host "Available scoop backups:`n"

    for ($i = 0; $i -lt $Backups.Count; $i++) {
        Write-Host "[$($i + 1)] $($Backups[$i])"
    }

    $choice = Read-Host "`nSelect a backup to import"

    if (-not ($choice -as [int]) -or
        $choice -lt 1 -or
        $choice -gt $Backups.Count) {
        throw "Invalid selection."
    }

    $SelectedBackup = $Backups[$choice - 1]
    $BackupUrl = "$BaseUrl/$SelectedBackup"

    Write-Host "`nDownloading scoop backup..."
    Invoke-WebRequest $BackupUrl -OutFile $TempFile

    Write-Host "Importing scoop backup..."
    scoop import $TempFile

    Write-Host "Cleaning up..."
    Remove-Item $TempFile -Force

    Write-Host "Scoop restore completed successfully."
}
catch {
    Write-Error "Restore failed: $_"
    if (Test-Path $TempFile) {
        Remove-Item $TempFile -Force
    }
    exit 1
}
