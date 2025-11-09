#!/usr/bin/env bash
# installer.sh - Installs scripts to /usr/local/bin and sets permissions
set -euo pipefail
DEST=/usr/local/bin
sudo cp backup.sh update_cleanup.sh log_monitor.sh maintenance_menu.sh "$DEST/"
sudo chmod +x "$DEST/"*.sh
echo "Scripts installed to $DEST. You can run 'maintenance_menu.sh' from anywhere."
