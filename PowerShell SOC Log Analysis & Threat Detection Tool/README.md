# PowerShell SOC Log Analysis & Threat Detection Tool

## Project Overview

This project involved developing an automated security log analysis tool using PowerShell as part of the Advanced Scripting for Cybersecurity module at Technological University Dublin.

The tool is designed to assist Security Operations Centre (SOC) analysts with identifying potentially malicious activity across multiple security logs.

Instead of manually reviewing thousands of log entries, the tool performs several detection checks and automatically generates a structured investigation report containing security findings, severity levels and relevant evidence.

The project demonstrates how scripting can support threat detection, security monitoring and incident response investigations.

## Project Objectives

- Automate the investigation of security log files.
- Identify potential brute-force authentication attacks.
- Detect suspicious PowerShell commands.
- Match known Indicators of Compromise (IOCs).
- Identify common web application attack patterns.
- Detect potentially suspicious web scanning activity.
- Generate a structured investigation report.
- Reduce repetitive manual analysis during initial security investigations.

## Technologies Used

| Technology | Purpose |
|---|---|
| PowerShell | Security analysis and automation |
| Windows PowerShell | Script execution |
| Authentication logs | Failed login detection |
| PowerShell activity logs | Suspicious command detection |
| Apache-style access logs | Web attack analysis |
| IOC files | Matching suspicious IPs and URL paths |
| Regular expressions | Extracting information from log entries |
| Text-based reporting | Recording investigation findings |

## Project Structure

```text
SOC-Log-Analysis-Tool/
│
├── README.md
├── run.ps1
├── investigation_report.txt
├── B00174326_project_report.pdf
│
└── ProjectDataset/
    ├── auth.log
    ├── access.log
    ├── powershell_log.txt
    └── ioc.txt
```

## Detection Features

### 1. Brute-Force Attack Detection

The tool examines `auth.log` to identify repeated authentication failures.

It searches for failed password messages, extracts the associated IP addresses and counts unsuccessful login attempts.

IP addresses exceeding the configured threshold of five failed attempts are flagged as potential brute-force activity.

This helps identify suspicious authentication behaviour that may indicate password-guessing attacks.

### 2. Suspicious PowerShell Activity

The tool analyses `powershell_log.txt` for commands commonly associated with reconnaissance, defence evasion or potentially malicious activity.

Detection patterns include:

| Command | Potential Security Concern |
|---|---|
| `EncodedCommand` | Obfuscated PowerShell execution |
| `ExecutionPolicy Bypass` | Bypassing execution policy restrictions |
| `Invoke-WebRequest` | Network requests or downloads |
| `whoami` | User account discovery |
| `ipconfig` | Network configuration discovery |
| `net user` | User account enumeration |
| `Compress-Archive` | File archiving |

The tool also checks for archive creation combined with upload activity.

When this combination is detected, it generates a CRITICAL alert indicating possible data exfiltration.

These detections indicate suspicious patterns requiring further investigation rather than confirmed malicious activity.

### 3. Indicator of Compromise Detection

The tool reads known suspicious indicators from `ioc.txt`.

These indicators include:

- Suspicious IP addresses.
- Known suspicious web paths.

The script compares these indicators against authentication, PowerShell and web access logs.

Matches are recorded in the investigation report with relevant source information and severity classifications.

### 4. Web Application Attack Detection

The tool examines `access.log` for patterns associated with common web attacks.

**Directory Traversal**

Detects requests containing patterns associated with attempts to access files outside intended web directories.

**SQL Injection**

Identifies requests containing common SQL injection patterns and keywords.

**Administrative Page Discovery**

Detects requests targeting administrative locations such as:

- `/admin`
- `/wp-admin`
- `/phpmyadmin`

**Suspicious User Agents**

Flags selected HTTP user-agent patterns associated with potentially suspicious activity.

### 5. Web Scanning Detection

The tool analyses HTTP error responses to identify potentially automated scanning activity.

It examines HTTP 403 and 404 responses and calculates error rates for individual IP addresses.

IP addresses generating more than ten requests with an error rate exceeding 30% are flagged for further investigation.

This can help identify reconnaissance activity directed at web applications.

## How to Run

### Requirements

- Windows operating system
- Windows PowerShell
- Project log files
- Permission to execute the script

### Execution

Open PowerShell and navigate to the project directory.

Run:

```powershell
.\run.ps1
```

The script performs the following tasks:

1. Loads the required log files.
2. Analyses authentication failures.
3. Checks PowerShell activity.
4. Searches for known Indicators of Compromise.
5. Investigates suspicious web requests.
6. Generates an investigation report.

The output is saved as:

```text
investigation_report.txt
```

## Investigation Report

The generated report provides a structured overview of detected security events.

Each finding includes information such as:

- Detection category.
- Severity level.
- Source log file.
- Associated IP address or suspicious activity.
- Description of the detected behaviour.

The tool uses three main severity classifications:

| Severity | Meaning |
|---|---|
| MEDIUM | Suspicious activity requiring review |
| HIGH | Potentially significant security threat |
| CRITICAL | Activity indicating a potentially serious compromise |

### Example Detection

```text
BRUTE FORCE | HIGH | auth.log |
IP: 122.190.143.18 | 7 failed attempts
```

This alert identifies an IP address associated with seven failed authentication attempts.

Such activity may indicate a brute-force attack and should be investigated alongside additional authentication evidence.

## Testing and Results

The tool was tested using supplied security log datasets containing suspicious authentication, PowerShell and web activity.

The investigation identified several categories of potential threats.

| Detection Category | Observed Result |
|---|---|
| Brute-force detection | Identified IP addresses with repeated failed logins |
| PowerShell analysis | Detected suspicious commands and possible exfiltration patterns |
| IOC matching | Identified suspicious IP and web path matches |
| Web attack analysis | Detected directory traversal and SQL injection patterns |
| Web scanning | Identified IP addresses with elevated HTTP error rates |
| Report generation | Successfully generated a structured investigation report |

The testing demonstrated that multiple security checks could be combined into a single automated investigation workflow.

## My Contribution

I developed the PowerShell-based log analysis tool and implemented its main security detection functions.

My contributions included:

- Writing the main PowerShell script.
- Implementing brute-force authentication detection.
- Creating suspicious PowerShell command checks.
- Developing IOC matching functionality.
- Implementing web attack and scanning detection.
- Configuring alert severity classifications.
- Automating investigation report generation.
- Testing the tool using sample log files.
- Documenting the methodology, results and limitations.

## Skills Demonstrated

- PowerShell scripting and automation
- Security Operations Centre fundamentals
- Security log analysis
- Threat detection and investigation
- Incident response fundamentals
- Indicator of Compromise analysis
- Web application attack detection
- Authentication security monitoring
- Security reporting
- Troubleshooting and testing

## Limitations

Although the tool successfully identifies several types of suspicious activity, there are limitations.

**Brute-Force Detection**

The tool counts failed login attempts without considering a specific time window. This may cause false positives when unsuccessful attempts occur over an extended period.

**Keyword-Based Detection**

PowerShell analysis relies on predefined keywords. Obfuscated or modified commands may avoid detection.

**False Positives**

Legitimate administrative commands and unusual but harmless web requests may trigger alerts.

**Limited Context**

The tool analyses individual log patterns without correlating all events into a complete security incident timeline.

## Future Improvements

Potential improvements include:

- Implementing time-based brute-force detection.
- Improving suspicious command detection using more advanced pattern matching.
- Adding support for additional security log formats.
- Introducing event correlation across multiple log sources.
- Exporting reports to JSON and CSV.
- Integrating detection results with SIEM platforms.
- Developing more detailed alert prioritisation.
- Improving false-positive reduction.

## Project Evidence

The repository includes:

- `run.ps1` — Main PowerShell analysis script.
- `ProjectDataset/` — Input files used for security analysis.
- `investigation_report.txt` — Generated investigation findings.
- `Powershell_SOC_Log_Analysis_&_Threat_Detection_Tool_report.pdf` — Original academic project report.

These files provide supporting evidence of the tool's implementation, testing and results.

## Conclusion

This project demonstrated how PowerShell automation can be used to support cybersecurity monitoring and initial incident investigation.

By combining authentication analysis, suspicious command detection, IOC matching and web attack identification, the tool provides a practical introduction to automated SOC workflows.

The project strengthened my understanding of security log analysis, threat detection, scripting and incident response.

---

*Developed as part of the Advanced Scripting for Cybersecurity module at Technological University Dublin, academic year 2025–2026.*

*This project is intended for educational purposes and authorised security analysis.*
