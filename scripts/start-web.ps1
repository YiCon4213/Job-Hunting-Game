$ErrorActionPreference = "Stop"

$projectRoot = Split-Path -Parent $PSScriptRoot
$logDirectory = Join-Path $projectRoot "tmp"
$stdoutLog = Join-Path $logDirectory "dev-server.log"
$stderrLog = Join-Path $logDirectory "dev-server-error.log"
$portFile = Join-Path $logDirectory "dev-server-port.txt"

function Test-WebServer([string] $targetUrl) {
    try {
        $response = Invoke-WebRequest -Uri $targetUrl -UseBasicParsing -TimeoutSec 1
        return $response.StatusCode -ge 200 -and $response.StatusCode -lt 500
    }
    catch {
        return $false
    }
}

function Test-PortAvailable([int] $candidatePort) {
    $listener = $null
    try {
        $listener = [System.Net.Sockets.TcpListener]::new(
            [System.Net.IPAddress]::Loopback,
            $candidatePort
        )
        $listener.Start()
        return $true
    }
    catch {
        return $false
    }
    finally {
        if ($null -ne $listener) {
            $listener.Stop()
        }
    }
}

function Find-AvailablePort {
    for ($candidatePort = 3000; $candidatePort -le 3099; $candidatePort++) {
        if (Test-PortAvailable $candidatePort) {
            return $candidatePort
        }
    }

    throw "No available port was found between 3000 and 3099."
}

function Show-ErrorMessage([string] $message) {
    Add-Type -AssemblyName PresentationFramework
    [System.Windows.MessageBox]::Show(
        $message,
        "Web app startup failed",
        [System.Windows.MessageBoxButton]::OK,
        [System.Windows.MessageBoxImage]::Error
    ) | Out-Null
}

try {
    if (Test-Path $portFile) {
        $savedPort = 0
        if ([int]::TryParse((Get-Content $portFile -Raw).Trim(), [ref] $savedPort)) {
            $savedUrl = "http://localhost:$savedPort"
            if (Test-WebServer $savedUrl) {
                Start-Process $savedUrl
                exit 0
            }
        }
    }

    $npm = Get-Command npm.cmd -ErrorAction Stop
    New-Item -ItemType Directory -Path $logDirectory -Force | Out-Null
    $port = Find-AvailablePort
    $url = "http://localhost:$port"

    Start-Process `
        -FilePath $npm.Source `
        -ArgumentList @("run", "dev", "--", "--port", $port) `
        -WorkingDirectory $projectRoot `
        -WindowStyle Hidden `
        -RedirectStandardOutput $stdoutLog `
        -RedirectStandardError $stderrLog

    for ($attempt = 0; $attempt -lt 60; $attempt++) {
        Start-Sleep -Milliseconds 500
        if (Test-WebServer $url) {
            Set-Content -LiteralPath $portFile -Value $port -Encoding Ascii
            Start-Process $url
            exit 0
        }
    }

    throw "The server did not start within 30 seconds.`n`nSee the error log:`n$stderrLog"
}
catch {
    Show-ErrorMessage $_.Exception.Message
    exit 1
}
