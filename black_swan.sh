#!/bin/bash

# ==============================================
# Project Black Swan - Linux Automation Toolkit
# Author: Benjamin "Charming"
# Version: 1.0
# Description: Performs system updates, cleanup,
#              and home directory backup with logging.
# ==============================================

LOG_FILE="/var/log/black_swan.log"
BACKUP_DIR="/home/$USER/black_swan_backups"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

# Ensure script runs with sudo
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (sudo ./black_swan.sh)"
  exit 1
fi

echo "========== Project Black Swan Run: $TIMESTAMP ==========" | tee -a "$LOG_FILE"

# 1️⃣ System Update & Upgrade
echo "[+] Updating and upgrading system packages..." | tee -a "$LOG_FILE"
apt update && apt upgrade -y >> "$LOG_FILE" 2>&1

# 2️⃣ Cleanup
echo "[+] Cleaning system cache and old packages..." | tee -a "$LOG_FILE"
apt autoremove -y && apt autoclean -y >> "$LOG_FILE" 2>&1

# 3️⃣ Backup
echo "[+] Creating backup of /home/$USER..." | tee -a "$LOG_FILE"
mkdir -p "$BACKUP_DIR"
tar -czf "$BACKUP_DIR/home_backup_$TIMESTAMP.tar.gz" /home/$USER >> "$LOG_FILE" 2>&1

# 4️⃣ Log completion
echo "[✓] Operation completed successfully at $TIMESTAMP" | tee -a "$LOG_FILE"
echo "Logs saved to $LOG_FILE"
echo "Backup stored at $BACKUP_DIR/home_backup_$TIMESTAMP.tar.gz"

exit 0
