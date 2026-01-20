$ErrorActionPreference = "Stop"

$BackupUrl = "https://script.seros.me/scoop"
$TempFile  = Join-Path $env:TEMP "scoop-backup.json"

try {
    Write-Host "Downloading scoop backup..."
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
