#!/usr/bin/env bash
# backup.sh - Incremental backup using rsync with optional GPG encryption
# Usage: ./backup.sh /path/to/source /path/to/dest [--encrypt passphrase] [--dry-run]
set -euo pipefail
src="${1:-/etc}"
dest="${2:-/mnt/backups/$(hostname)-$(date +%F)}"
shift 2 || true
ENCRYPT_PASS=""
DRY_RUN=0
while (( "$#" )); do
  case "$1" in
    --encrypt) ENCRYPT_PASS="$2"; shift 2;;
    --dry-run) DRY_RUN=1; shift;;
    *) shift;;
  esac
done

mkdir -p "$dest"
# use rsync incremental via --link-dest to previous backup if exists
prev=$(ls -1dt "$(dirname "$dest")"/* 2>/dev/null | grep -v "$(basename "$dest")" | head -n1 || true)
rsync_opts=(--archive --delete --verbose --one-file-system --hard-links --delete-excluded)
if [ "$DRY_RUN" -eq 1 ]; then rsync_opts+=(--dry-run); fi
if [ -n "$prev" ]; then
  rsync --link-dest="$prev" "${rsync_opts[@]}" "$src"/ "$dest"/
else
  rsync "${rsync_opts[@]}" "$src"/ "$dest"/
fi

# Optionally encrypt the backup directory into a single tar.gpg
if [ -n "$ENCRYPT_PASS" ]; then
  tar -C "$(dirname "$dest")" -cf - "$(basename "$dest")" | gpg --symmetric --batch --passphrase "$ENCRYPT_PASS" -o "${dest}.tar.gpg"
  echo "Encrypted backup created at ${dest}.tar.gpg"
fi

echo "Backup finished: $dest"
