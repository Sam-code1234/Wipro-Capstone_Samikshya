#!/usr/bin/env bash
# update_cleanup.sh - update system packages and clean package cache
set -euo pipefail
DRY_RUN=0
if [ "${1:-}" = "--dry-run" ]; then DRY_RUN=1; fi

# Detect package manager
if command -v apt >/dev/null; then
  PKG=apt
  if [ "$DRY_RUN" -eq 1 ]; then
    sudo apt update && sudo apt --simulate upgrade
  else
    sudo apt update && sudo apt -y upgrade && sudo apt -y autoremove && sudo apt -y autoclean
  fi
elif command -v dnf >/dev/null; then
  PKG=dnf
  if [ "$DRY_RUN" -eq 1 ]; then
    sudo dnf check-update
  else
    sudo dnf -y upgrade && sudo dnf -y autoremove
  fi
elif command -v yum >/dev/null; then
  PKG=yum
  if [ "$DRY_RUN" -eq 1 ]; then
    sudo yum check-update
  else
    sudo yum -y update && sudo yum -y autoremove
  fi
else
  echo "Unsupported package manager. Please run updates manually."
  exit 2
fi

echo "Update and cleanup complete using $PKG"
