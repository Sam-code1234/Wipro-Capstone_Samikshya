# Bash Scripting Suite for System Maintenance
**Project:** Assignment 5 (LinuxOS and LSP) - Maintenance Suite for Wipro Submission

## Objective
A suite of Bash scripts to automate system maintenance: incremental backups, updates & cleanup, log monitoring, and an interactive menu. Includes extra features to differentiate the project: encrypted backups, incremental hardlink-based backups, systemd timer integration, dry-run mode, and a simple installer.

## Structure
- `code/scripts/backup.sh` - Incremental rsync backup with optional GPG encryption
- `code/scripts/update_cleanup.sh` - Detects package manager and updates & cleans
- `code/scripts/log_monitor.sh` - Monitors logs for patterns and writes alerts
- `code/scripts/maintenance_menu.sh` - Interactive menu to run tasks
- `code/scripts/installer.sh` - Installs scripts to /usr/local/bin
- `code/systemd/` - Sample systemd service & timer for scheduled backups
- `docs/screenshots/` - Sample screenshot(s)
- `docs/` - This documentation

## Extra Features (to stand out)
1. **Incremental backups using rsync + hard links** to save space and keep historical backups efficiently.
2. **Optional GPG symmetric encryption** of backups for secure off-site archives.
3. **Systemd timer** sample for scheduling daily backups reliably.
4. **Dry-run modes** in scripts for safe testing.
5. **Installer script** to deploy tools to `/usr/local/bin`.
6. **Log monitor** that writes alerts to `/var/log/maintenance_alerts.log` and can email admins (if mail is configured).
7. **Maintenance menu** for novice users to trigger tasks without remembering commands.

## How to use (short)
1. Inspect scripts in `code/scripts/`.
2. Optional: run `sudo bash code/scripts/installer.sh` to install.
3. Run `maintenance_menu.sh` to use the TUI.
4. Configure a passphrase and use `--encrypt "pass"` to create encrypted backups.

## Screenshots
See `docs/screenshots/` for example screenshot(s).

## Submission Notes
- All scripts include comments and basic error handling.
- Replace `"CHANGE_ME"` in the systemd service with a secure passphrase or modify to use key-based encryption.
- Test on a VM before deploying to production.

--- 
Generated for Wipro assignment submission.
