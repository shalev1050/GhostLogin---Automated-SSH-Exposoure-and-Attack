# GhostLogin - Automated SSH Exposure and Attack

## Overview
**GhostLogin** is a fully automated framework designed to identify exposed SSH services, validate access controls under controlled conditions, and execute predefined verification tasks without manual interaction. Built with Bash, this tool streamlines the process of network security assessments, removing the need for repetitive manual authentication testing. The entire assessment process is automated from target input to final reporting.

## Features
* **Network Targeting & Discovery**: Prompts the user to define the target IP address or range, confirms the target is locked, and scans specifically for active SSH services on Port 22.
* **Automated Credential Testing**: Loads necessary exploit modules and brute-force credential dictionaries containing username and password lists to attempt brute-force logins on discovered hosts.
* **Post-Exploitation Automation**: Automatically executes a predefined command on the remote machine non-interactively upon successful login without opening an interactive shell, such as planting a hidden proof file named `.shalev_proof`.
* **Detailed Auditing**: Generates a local log file named `shalev_audit.log` to maintain a detailed real-time audit trail of the entire attack sequence, including failed attempts and successful system breaches.

## Prerequisites
To run this script, ensure you have the following utilities installed on your Linux system:
* `nmap` (used for active port scanning and service discovery)
* `sshpass` (used for automated non-interactive password handling)

## Usage
1. Clone the repository to your local machine.
2. Grant execution permissions to the script:
   ```bash
   chmod +x PERES25B.s18.NX201.sh

   Run the script: ./PERES25B.s18.NX201.sh

   Enter the target IP address when prompted (e.g., 127.0.0.1).

   Review the generated shalev_audit.log file to verify the full network intrusion log and brute-force attempt sequence.

## Disclaimer
   ⚠️ Educational Purposes Only: This project was developed as part of an academic cybersecurity training program under the unit code PERES25B and program code NX201. The tool is intended solely for authorized security assessments, educational evaluation, and authorized testing in controlled environments. Do not use this tool against any systems or network infrastructure without prior explicit authorization.
