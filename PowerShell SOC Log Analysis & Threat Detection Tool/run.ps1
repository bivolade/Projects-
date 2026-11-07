
param(
    [string]$LogPath = ".\ProjectDataset",
    [string]$ReportFile = "investigation_report.txt"
)

Write-Host ""
Write-Host "=== Security Investigation Tool ===" 
Write-Host ""
Write-Host "Analyzing logs in: $LogPath" 
Write-Host ""

# Set threshold for brute force detection
$authThreshold = 5

# Store all findings
$findings = @()

# 1. Check auth.log for brute force attempts

Write-Host "[1] Checking auth.log for brute force attempts..."

$authLog = Join-Path $LogPath "auth.log"

if (Test-Path $authLog) {
    $failedAttempts = @{}
    $lines = Get-Content $authLog
    
    foreach ($line in $lines) {
        # Look for failed password messages
        if ($line -like "*Failed password*from*") {
            # Extract IP
            $parts = $line -split " "
            foreach ($part in $parts) {
                if ($part -match "^(\d+\.\d+\.\d+\.\d+)$") {
                    $ip = $part
                    if ($failedAttempts.ContainsKey($ip)) {
                        $failedAttempts[$ip]++
                    } else {
                        $failedAttempts[$ip] = 1
                    }
                    break
                }
            }
        }
        
        # Look for maximum attempts exceeded messages
        if ($line -like "*maximum authentication attempts exceeded*from*") {
            $parts = $line -split " "
            foreach ($part in $parts) {
                if ($part -match "^(\d+\.\d+\.\d+\.\d+)$") {
                    $ip = $part
                    if ($failedAttempts.ContainsKey($ip)) {
                        $failedAttempts[$ip]++
                    } else {
                        $failedAttempts[$ip] = 1
                    }
                    break
                }
            }
        }
    }
    
    $bruteIPs = @()
    foreach ($ip in $failedAttempts.Keys) {
        if ($failedAttempts[$ip] -ge $authThreshold) {
            $bruteIPs += $ip
            $findings += "BRUTE FORCE | HIGH | auth.log | IP: $ip | $($failedAttempts[$ip]) failed attempts"
            Write-Host "Brute force from $ip ($($failedAttempts[$ip]) attempts)" 
        }
    }
    
    if ($bruteIPs.Count -eq 0) {
        Write-Host "  No brute force attempts found" 
    }
} else {
    Write-Host "  auth.log not found" 
}

# 2. Check powershell_log.txt for suspicious commands

Write-Host ""
Write-Host "[2] Checking PowerShell logs for suspicious commands..."

$psLog = Join-Path $LogPath "powershell_log.txt"

if (Test-Path $psLog) {
    $psLines = Get-Content $psLog
    $suspiciousCount = 0
    
    foreach ($line in $psLines) {
        if ($line.Trim().StartsWith("#")) { continue }
        
        if ($line -like "*EncodedCommand*") {
            $suspiciousCount++
            $findings += "SUSPICIOUS PS | HIGH | powershell_log.txt | Pattern: EncodedCommand"
            Write-Host "Suspicious PowerShell: EncodedCommand" 
        }
        elseif ($line -like "*ExecutionPolicy Bypass*") {
            $suspiciousCount++
            $findings += "SUSPICIOUS PS | HIGH | powershell_log.txt | Pattern: ExecutionPolicy Bypass"
            Write-Host "Suspicious PowerShell: ExecutionPolicy Bypass" 
        }
        elseif ($line -like "*Invoke-WebRequest*") {
            $suspiciousCount++
            $findings += "SUSPICIOUS PS | MEDIUM | powershell_log.txt | Pattern: Invoke-WebRequest"
            Write-Host "Suspicious PowerShell: Invoke-WebRequest" 
        }
        elseif ($line -like "*whoami*") {
            $suspiciousCount++
            $findings += "SUSPICIOUS PS | MEDIUM | powershell_log.txt | Pattern: whoami"
            Write-Host "Suspicious PowerShell: whoami" 
        }
        elseif ($line -like "*ipconfig*") {
            $suspiciousCount++
            $findings += "SUSPICIOUS PS | MEDIUM | powershell_log.txt | Pattern: ipconfig"
            Write-Host "Suspicious PowerShell: ipconfig" 
        }
        elseif ($line -like "*net user*") {
            $suspiciousCount++
            $findings += "SUSPICIOUS PS | MEDIUM | powershell_log.txt | Pattern: net user"
            Write-Host "Suspicious PowerShell: net user" 
        }
    }
    
    # Check for data exfiltration pattern
    $hasArchive = $false
    $hasUpload = $false
    
    foreach ($line in $psLines) {
        if ($line -like "*Compress-Archive*") { $hasArchive = $true }
        if ($line -like "*Invoke-WebRequest*Upload*") { $hasUpload = $true }
    }
    
    if ($hasArchive -and $hasUpload) {
        $findings += "DATA EXFILTRATION | CRITICAL | powershell_log.txt | Archive + Upload pattern detected"
        Write-Host "CRITICAL: Data exfiltration detected (archive + upload)" 
    }
    
    if ($suspiciousCount -eq 0) {
        Write-Host "  No suspicious PowerShell commands found" 
    }
} else {
    Write-Host "  powershell_log.txt not found" 
}

# 3. Check for IOC matches
Write-Host ""
Write-Host "[3] Checking for Indicators of Compromise (IOCs)..."

$iocFile = Join-Path $LogPath "ioc.txt"

if (Test-Path $iocFile) {
    $maliciousIPs = @()
    $maliciousPaths = @()
    
    $iocLines = Get-Content $iocFile
    foreach ($line in $iocLines) {
        $line = $line.Trim()
        if ($line -eq "" -or $line.StartsWith("#")) { continue }
        
        if ($line -match "^\d+\.\d+\.\d+\.\d+$") {
            $maliciousIPs += $line
        } else {
            $maliciousPaths += $line
        }
    }
    
    Write-Host "  Loaded $($maliciousIPs.Count) malicious IPs and $($maliciousPaths.Count) malicious paths" 
    
    # Check auth.log for malicious IPs
    if (Test-Path $authLog) {
        $authLines = Get-Content $authLog
        foreach ($ip in $maliciousIPs) {
            foreach ($line in $authLines) {
                if ($line -like "*$ip*") {
                    $findings += "IOC MATCH | CRITICAL | auth.log | Malicious IP: $ip"
                    Write-Host "Malicious IP $ip found in auth.log" 
                    break
                }
            }
        }
    }
    
    # Check PowerShell logs for malicious indicators
    if (Test-Path $psLog) {
        $psLines = Get-Content $psLog
        foreach ($ioc in ($maliciousIPs + $maliciousPaths)) {
            foreach ($line in $psLines) {
                if ($line -like "*$ioc*") {
                    $findings += "IOC MATCH | CRITICAL | powershell_log.txt | Malicious indicator: $ioc"
                    Write-Host "Malicious indicator '$ioc' found in PowerShell logs" 
                    break
                }
            }
        }
    }
    
    # Check access.log for malicious paths
    $accessLog = Join-Path $LogPath "access.log"
    if (Test-Path $accessLog) {
        $accessLines = Get-Content $accessLog
        foreach ($path in $maliciousPaths) {
            foreach ($line in $accessLines) {
                if ($line -like "*$path*") {
                    # Extract IP
                    if ($line -match "^(\d+\.\d+\.\d+\.\d+)") {
                        $ip = $Matches[1]
                        $findings += "IOC MATCH | HIGH | access.log | IP: $ip accessed malicious path: $path"
                        Write-Host "Malicious path '$path' accessed from $ip" 
                    }
                    break
                }
            }
        }
    }
} else {
    Write-Host "  ioc.txt not found" 
}

# 4. Check access.log for web attacks

Write-Host ""
Write-Host "[4] Checking access.log for web attacks..."

$accessLog = Join-Path $LogPath "access.log"

if (Test-Path $accessLog) {
    $accessLines = Get-Content $accessLog
    $totalRequests = 0
    $errorRequests = 0
    $traversalCount = 0
    $sqlCount = 0
    
    $ipErrors = @{}
    $ipTotal = @{}
    
    foreach ($line in $accessLines) {
        $totalRequests++
        
        # Extract IP
        if ($line -match "^(\d+\.\d+\.\d+\.\d+)") {
            $ip = $Matches[1]
        } else {
            $ip = ""
        }
        
        # Track totals per IP
        if ($ip -ne "") {
            if ($ipTotal.ContainsKey($ip)) {
                $ipTotal[$ip]++
            } else {
                $ipTotal[$ip] = 1
            }
        }
        
        # Check for 403 or 404 errors
        if ($line -like "* 403 *" -or $line -like "* 404 *") {
            $errorRequests++
            if ($ip -ne "") {
                if ($ipErrors.ContainsKey($ip)) {
                    $ipErrors[$ip]++
                } else {
                    $ipErrors[$ip] = 1
                }
            }
        }
        
        # Check for directory traversal
        if ($line -like "*../*" -or $line -like "*..%2F*") {
            $traversalCount++
            $findings += "DIRECTORY TRAVERSAL | HIGH | access.log | IP: $ip"
            Write-Host "Directory traversal attempt from $ip" 
        }
        
        # Check for SQL injection patterns
        if ($line -like "*%27*" -or $line -like "*'*" -or $line -like "*--*" -or $line -like "*UNION*") {
            $sqlCount++
            $findings += "SQL INJECTION | HIGH | access.log | IP: $ip"
            Write-Host "SQL injection attempt from $ip" 
        }
        
        # Check for admin path access
        if ($line -like "*/admin*" -or $line -like "*/wp-admin*" -or $line -like "*/phpmyadmin*") {
            $findings += "ADMIN PATH ACCESS | MEDIUM | access.log | IP: $ip"
            Write-Host "Admin path access from $ip" 
        }
        
        # Check for suspicious user agents
        if ($line -like "*User-Agent: sqlmap*" -or $line -like "*User-Agent: nmap*" -or $line -like "*User-Agent: curl*") {
            $findings += "SUSPICIOUS USER-AGENT | MEDIUM | access.log"
            Write-Host "Suspicious user-agent detected" 
        }
    }
    
    # Check for scanning behavior
    foreach ($ip in $ipErrors.Keys) {
        if ($ipTotal[$ip] -gt 10) {
            $errorRate = ($ipErrors[$ip] / $ipTotal[$ip]) * 100
            if ($errorRate -gt 30) {
                $findings += "SCAN DETECTION | MEDIUM | access.log | IP: $ip | $([math]::Round($errorRate,1))% error rate"
                Write-Host "Possible scanning from $ip ($([math]::Round($errorRate,1))% errors)" -ForegroundColor Yellow
            }
        }
    }
    
    Write-Host "  Total requests: $totalRequests, Errors: $errorRequests" 
    Write-Host "  Directory traversal attempts: $traversalCount" 
    Write-Host "  SQL injection attempts: $sqlCount" 
    
    if ($traversalCount -eq 0 -and $sqlCount -eq 0) {
        Write-Host "  No web attacks detected" 
    }
} else {
    Write-Host "  access.log not found" 
}

# Generate Report

Write-Host ""
Write-Host "Generating report..."

$report = ""
$report += "`nSECURITY INVESTIGATION REPORT"
$report += "`nGenerated: $(Get-Date)"
$report += "`n"
$report += "`nSUMMARY"
$report += "`nTotal Alerts Found: $($findings.Count)"
$report += "`n"
$report += "`nDETAILED FINDINGS"
$report += "`n"

$counter = 1
foreach ($finding in $findings) {
    $report += "`n[$counter] $finding"
    $counter++
}

$report += "`n"
$report += "`nRECOMMENDATIONS"
$report += "`n"
$report += "`n1. Block all IPs identified in brute force attacks"
$report += "`n2. Investigate all PowerShell suspicious activities"
$report += "`n3. Check if any IOC indicators led to successful compromise"
$report += "`n4. Review web logs for successful exploitation of admin paths"
$report += "`n5. Implement IP blocking for repeat offenders"
$report += "`n"
$report += "`nEND OF REPORT"

$report | Out-File -FilePath $ReportFile -Encoding UTF8
Write-Host "  Report saved to: $ReportFile" 

Write-Host ""
Write-Host "INVESTIGATION COMPLETE!" 
Write-Host "Total alerts found: $($findings.Count)" 