# SOC Log Analysis & Threat Detection Tool

## Project Overview

This project involved developing a PowerShell-based security log analysis tool designed to help Security Operations Centre (SOC) analysts identify suspicious activity across multiple log files.

The tool automates the investigation of authentication logs, PowerShell activity, web server access logs and known Indicators of Compromise (IOCs).

Instead of manually examining thousands of log entries, an analyst can run a single PowerShell script to identify potential security threats and generate a structured investigation report.

## Project Objectives

- Automate the analysis of security logs.
- Detect potential brute-force authentication attacks.
- Identify suspicious PowerShell commands.
- Compare log entries against known Indicators of Compromise.
- Detect common web application attack patterns.
- Generate a security investigation report with alert severity levels.
- Reduce the amount of manual log analysis required during initial investigations.

## Technologies Used

| Technology | Purpose |
|---|---|
| PowerShell | Main scripting language |
| Windows PowerShell | Script execution environment |
| Authentication logs | Detecting failed login attempts |
| PowerShell logs | Identifying suspicious commands |
| Web access logs | Detecting web attacks and scanning |
| IOC text files | Matching known suspicious IPs and paths |
| Text-based reporting | Generating investigation findings |

## Implementation

### 1. Brute-Force Attack Detection

The tool analyses `auth.log` to identify repeated failed login attempts.

It searches for authentication failure messages, extracts the associated IP addresses and counts failed attempts.

An IP address is flagged when it reaches five or more failed login attempts.

This helps identify potential password-guessing and brute-force activity.

### 2. Suspicious PowerShell Command Detection

The tool examines PowerShell logs for commands that may indicate suspicious activity.

Examples include:

- `EncodedCommand` — potentially obscured commands.
- `ExecutionPolicy Bypass` — attempts to bypass execution policy restrictions.
- `Invoke-WebRequest` — network requests or downloads.
- `whoami` — user account discovery.
- `ipconfig` — network configuration discovery.
- `net user` — user account enumeration.
- `Compress-Archive` — file compression.

The tool also checks for a combination of archive creation and upload activity, which may indicate possible data exfiltration.

These detections are indicators requiring investigation rather than proof of malicious activity.

### 3. Indicator of Compromise Detection

The tool loads known suspicious indicators from `ioc.txt`.

These include:

- Suspicious IP addresses.
- Known malicious or suspicious website paths.

It searches the available logs for matching indicators and includes detected matches in the investigation report.

### 4. Web Attack Detection

The tool examines `access.log` for suspicious HTTP requests.

It checks for:

**Directory traversal:** Requests containing patterns such as `../` or encoded traversal sequences.

**SQL injection:** Requests containing common SQL-related patterns such as `UNION`, `SELECT` and encoded quotation marks.

**Administrative page discovery:** Requests targeting locations such as `/admin`, `/wp-admin` and `/phpmyadmin`.

**Potential scanning:** IP addresses generating more than 10 requests with an error rate exceeding 30%, based on HTTP 403 and 404 responses.

These checks help identify activity that may warrant further investigation.

## How the Tool Works

The tool is executed through a PowerShell script named `run.ps1`.

```powershell
.\run.ps1
```

The script:

1. Locates the required log files.
2. Performs the four security detection checks.
3. Collects suspicious findings.
4. Assigns alert severity levels.
5. Generates a text-based investigation report.

The resulting file is named:

```text
investigation_report.txt
```

## Testing and Results

Testing demonstrated that the tool could identify multiple categories of suspicious activity.

| Detection | Observed result |
|---|---|
| Brute-force attempts | Identified IP addresses with 5–7 failed login attempts |
| PowerShell activity | Detected suspicious commands and an archive/upload pattern |
| IOC matching | Loaded 2 suspicious IPs and 5 paths, identifying matching activity |
| Web attack detection | Identified directory traversal patterns and high HTTP error rates |
| Report generation | Produced a structured investigation report |

### Example Alert

```text
[1] BRUTE FORCE | HIGH | auth.log |
IP: 122.190.143.18 | 7 failed attempts
```

The report includes:

- Alert type.
- Severity level.
- Source log file.
- Associated IP address or activity.
- Description of the finding.
- Suggested investigation or response action.

Alert severity levels include MEDIUM, HIGH and CRITICAL.

## My Contribution

I developed the PowerShell log analysis tool and documented its detection methods, execution process and investigation results.

My work included implementing authentication failure counting, suspicious command matching, IOC comparisons, web attack pattern detection and automated report generation.

I also tested the tool against sample log data, examined its findings and identified limitations that could affect detection accuracy.

## Limitations

The project identified several areas for improvement.

**Brute-force detection:** Failed login attempts are counted without a defined time window, which could result in false positives.

**Keyword-based detection:** Suspicious PowerShell commands are detected using predefined keywords, meaning modified or obfuscated commands may be missed.

**False positives:** Legitimate administrative activities may trigger alerts because the tool does not fully understand the context of each command.

These limitations demonstrate the importance of contextual analysis and human review in security monitoring.

## Skills Demonstrated

- PowerShell scripting
- Security log analysis
- SOC investigation workflows
- Brute-force detection
- Indicator of Compromise analysis
- Web attack identification
- Automated security reporting
- Threat detection logic
- Troubleshooting and testing
- Understanding false positives and detection limitations

## Project Evidence

The project report documents the tool's design, methodology, testing results and identified limitations.

The PowerShell script, sample log files and generated investigation report can also be included as supporting evidence.

## Future Improvements

- Introduce time-based thresholds for brute-force detection.
- Improve detection of obfuscated PowerShell commands.
- Reduce false positives through additional contextual checks.
- Support additional log formats.
- Export findings to CSV or JSON.
- Integrate the tool with a SIEM platform for centralised security monitoring.

---

*Academic cybersecurity scripting project completed as part of my studies at TU Dublin.*
