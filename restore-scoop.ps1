$tmp = Join-Path $env:TEMP 'scoop.txt'

Invoke-WebRequest 'https://raw.githubusercontent.com/serosme/scoop-setup/main/scoop.txt' -OutFile $tmp -UseBasicParsing -ErrorAction Stop

Get-Content $tmp -Encoding UTF8 | Where-Object { $_.Trim() -and -not $_.Trim().StartsWith('#') } | ForEach-Object {
    Write-Host "Execute '$_'? [Y/n] " -NoNewline
    $key = [Console]::ReadKey($true)
    if ($key.Key -eq 'N') {
        Write-Host "n"
        return
    }
    Write-Host "y"

    try { Invoke-Expression $_ } catch { Write-Warning "Command failed: $_" }
}
