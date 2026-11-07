# CyberTriageTool — Digital Forensics & Incident Response

## Project Overview

CyberTriageTool is a Python and PowerShell-based security investigation tool developed to assist with initial host triage and incident response.

The project combines Windows system information collection with modular Python analysis plugins to investigate processes, network connections, authentication activity, file hashes and other potential security indicators.

The aim is to demonstrate how scripting and automation can support cybersecurity investigations and reduce repetitive manual analysis.

## Technologies Used

- Python 3
- Windows PowerShell
- Windows Registry
- VirusTotal API
- IP Geolocation API
- SHA-256 hashing
- TCP sockets
- Regular expressions
- JSON configuration and output

## Key Features

### 1. Windows Host Information Collection

The PowerShell script `collect_triage.ps1` gathers information about running processes and active TCP connections.

The collected information is exported to `host_info.json` for further analysis.

### 2. Modular Plugin System

The Python application automatically discovers and executes analysis plugins.

This allows different investigation functions to be organised into separate modules.

### 3. File Hash Analysis

Calculates the SHA-256 hash of a selected file and queries the VirusTotal API for existing detection information.

Requires a valid VirusTotal API key configured through an environment variable.

### 4. Brute-Force Log Analysis

Examines authentication logs for failed password attempts.

The plugin counts failures and identifies the most frequently occurring IP address and username.

### 5. TCP Port Scanning

Uses Python sockets to test selected TCP ports on a configured target.

The default target is localhost (`127.0.0.1`).

### 6. IP Geolocation

Extracts remote IP addresses from collected network connection data and performs geolocation lookups using an external API.

### 7. Windows Registry Analysis

Examines the current user's Windows Run registry key to identify programs configured to launch at login.

## How to Run

The project is designed for a Windows environment with Python and Windows PowerShell installed.

Install the required Python dependency:

```bash
pip install requests
```

From the project's `Python` directory, execute:

```bash
python main.py
```

The application reads its configuration, attempts to run the PowerShell collection script, executes the available plugins and prints a summary of the results.

Some features require additional input files, internet connectivity or API credentials.

## My Contribution

I developed and organised the Python and PowerShell components used for host triage and security analysis.

The project includes a configurable execution workflow, automated plugin loading, Windows information collection and multiple analysis functions.

It demonstrates my practical experience with Python scripting, PowerShell, security automation and incident response concepts.

## Skills Demonstrated

- Digital forensics fundamentals
- Incident response and host triage
- Python and PowerShell scripting
- Security automation
- Network connection analysis
- Windows Registry investigation
- File hashing and threat intelligence
- Log analysis
- Modular software development

## Limitations and Future Improvements

The current implementation is a prototype rather than a complete forensic investigation platform.

Potential improvements include:

- Adding structured JSON or CSV investigation reports.
- Implementing more advanced suspicious process detection.
- Improving brute-force detection using time-based thresholds.
- Adding automated testing and error handling.
- Supporting additional operating systems.
- Adding clearer severity classifications.
- Improving forensic evidence handling and documentation.

## Responsible Use

The tool is intended for educational purposes and authorised security investigations.

System information and investigation results should be reviewed for sensitive information before being shared publicly.
