#!/usr/bin/env bash
# log_monitor.sh - Monitor logs and alert on patterns. Keeps alerts in alert.log and can send email if configured.
# Usage: ./log_monitor.sh /var/log/syslog 'error|fail|panic' admin@example.com
set -euo pipefail
logfile="${1:-/var/log/syslog}"
pattern="${2:-ERROR|CRITICAL|panic|fail}"
notify_email="${3:-}"
alert_file="/var/log/maintenance_alerts.log"

touch "$alert_file"
echo "Starting log monitor on $logfile for pattern: $pattern"
tail -n0 -F "$logfile" | while read -r line; do
  if echo "$line" | grep -Eiq "$pattern"; then
    ts=$(date +'%F %T')
    echo "[$ts] $line" >> "$alert_file"
    # try to send mail if mail command is available and email provided
    if [ -n "$notify_email" ] && command -v mail >/dev/null 2>&1; then
      echo "$line" | mail -s "Log Alert on $(hostname)" "$notify_email"
    fi
  fi
done
