# GhostLogin - Automated SSH Exposure and Attack

## Overview
**GhostLogin** is a fully automated framework designed to identify exposed SSH services, validate access controls under controlled conditions, and execute predefined verification tasks without manual interaction. Built with Bash, this tool streamlines the process of network security assessments, removing the need for repetitive authentication testing.

## Features
* **Network Targeting & Discovery:** Scans specific IPs or ranges to identify active SSH services (Port 22) using `nmap`.
* **Automated Credential Testing:** Performs dictionary-based brute-force attacks to verify authorization controls.
* **Post-Exploitation Automation:** Automatically executes non-interactive commands upon successful login (e.g., planting a `.shalev_proof` persistence file).
* **Detailed Auditing:** Generates comprehensive real-time logs (`shalev_audit.log`) tracking failed attempts, successful breaches, and planted files.

## Prerequisites
To run this script, ensure you have the following packages installed on your Linux environment (e.g., Kali Linux):
* `nmap` (for port scanning)
* `sshpass` (for non-interactive SSH password authentication)

## Usage
1. Clone the repository to your local machine.
2. Grant execution permissions to the script:
   ```bash
   chmod +x GhostLogin.sh
