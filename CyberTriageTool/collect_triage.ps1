param(
    [string]$OutputPath = "..\sample_output"
)

# Ensure output directory exists
if (-not (Test-Path -Path $OutputPath)) {
    New-Item -Path $OutputPath -ItemType Directory | Out-Null
}

Write-Host "[+] Starting basic triage collection..."

function Get-ProcessInfo {
    <#
        Collect basic process info.
        Shows use of cmdlets, pipelines, Select-Object, and PSCustomObject.
    #>
    Get-Process | ForEach-Object {
        $path = $null
        try {
            $path = $_.Path
        } catch {}

        [PSCustomObject]@{
            Name       = $_.ProcessName
            Id         = $_.Id
            CPU        = $_.CPU
            WorkingSet = $_.WorkingSet
            Path       = $path
        }
    }
}

function Get-NetworkConnections {
    <#
        Simple network enumeration.
        Uses Get-NetTCPConnection to list TCP connections.
    #>
    Get-NetTCPConnection | Select-Object `
        LocalAddress, LocalPort, RemoteAddress, RemotePort, State, OwningProcess
}

# Collect data
$processes  = Get-ProcessInfo
$netconns   = Get-NetworkConnections

# Build a single object to export as JSON
$triageObject = [PSCustomObject]@{
    Timestamp  = (Get-Date)
    Processes  = $processes
    NetConns   = $netconns
}

$hostInfoPath = Join-Path $OutputPath "host_info.json"
$triageObject | ConvertTo-Json -Depth 4 | Out-File -FilePath $hostInfoPath -Encoding utf8

Write-Host "[+] Triage data written to $hostInfoPath"
