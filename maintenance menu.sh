#!/usr/bin/env bash
# maintenance_menu.sh - Simple TUI to run maintenance scripts
set -euo pipefail
SCRIPTDIR="$(dirname "$0")"
while true; do
  cat <<EOF
================== Maintenance Suite ==================
1) Run incremental backup (ask for source & dest)
2) Run system update & cleanup
3) Start log monitor (background)
4) Install systemd timer (daily backup)
5) Run all checks (health)
6) Exit
======================================================
EOF
  read -rp "Choose an option: " opt
  case "$opt" in
    1)
      read -rp "Source (default /etc): " src
      src=${src:-/etc}
      read -rp "Dest (default /mnt/backups/\$(hostname)-\$(date +%F)): " dest
      dest=${dest:-/mnt/backups/$(hostname)-$(date +%F)}
      bash "$SCRIPTDIR/backup.sh" "$src" "$dest"
      ;;
    2)
      bash "$SCRIPTDIR/update_cleanup.sh"
      ;;
    3)
      read -rp "Log file to watch (default /var/log/syslog): " lf
      lf=${lf:-/var/log/syslog}
      read -rp "Patterns (default 'error|fail|panic'): " pats
      pats=${pats:-'error|fail|panic'}
      nohup bash "$SCRIPTDIR/log_monitor.sh" "$lf" "$pats" >/var/log/maintenance_monitor.out 2>&1 &
      echo "Log monitor started in background. Output /var/log/maintenance_monitor.out"
      ;;
    4)
      sudo cp "$SCRIPTDIR/maintenance-backup.timer" /etc/systemd/system/
      sudo cp "$SCRIPTDIR/maintenance-backup.service" /etc/systemd/system/
      sudo systemctl daemon-reload
      sudo systemctl enable --now maintenance-backup.timer
      echo "Installed systemd timer for daily backups"
      ;;
    5)
      echo "Health checks: disk, memory, top processes"
      df -h | sed -n '1,6p'
      free -h
      ps aux --sort=-%mem | head -n 8
      ;;
    6) exit 0;;
    *) echo "Invalid option";;
  esac
done
