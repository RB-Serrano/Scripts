# Set your script paths
$localScript = "C:\Scripts\MyScript.ps1"
$remoteScriptUrl = "https://raw.githubusercontent.com/yourusername/repo/main/MyScript.ps1"
$tempDownload = "$env:TEMP\MyScript_new.ps1"

# Download the remote version temporarily
Invoke-WebRequest -Uri $remoteScriptUrl -OutFile $tempDownload -UseBasicParsing

# Compare file hashes (change to your versioning method if needed)
$localHash = if (Test-Path $localScript) { Get-FileHash $localScript -Algorithm SHA256 }.Hash else { "" }
$remoteHash = Get-FileHash $tempDownload -Algorithm SHA256

if ($localHash -ne $remoteHash.Hash) {
    Write-Host "Updating script..."
    Copy-Item $tempDownload -Destination $localScript -Force
} else {
    Write-Host "Script is up to date."
}

# Clean up
Remove-Item $tempDownload

# Optionally run the script
Start-Process "powershell.exe" -ArgumentList "-ExecutionPolicy Bypass -File `"$localScript`""