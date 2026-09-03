#!/usr/bin/env bash
# Purpose: Inventory system and user cron schedules for review.
# Usage: cron_audit.sh
# Required privileges: Root shows all users. Dependencies: find, awk.
# Inputs/options: None. Expected output: Cron paths and entries.
# Exit codes: 0. Security considerations: Read-only inventory; secrets in jobs may be visible to authorized users.
set -Eeuo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"
require_commands find; header 'Cron audit'; for path in /etc/crontab /etc/cron.d /etc/cron.daily /etc/cron.hourly /etc/cron.weekly /etc/cron.monthly; do [[ -e "$path" ]] && { printf '\n[%s]\n' "$path"; if [[ -f "$path" ]]; then sed -n '1,200p' "$path"; else find "$path" -maxdepth 1 -type f -print; fi; }; done; section 'User crontabs'; find /var/spool/cron /var/spool/cron/crontabs -maxdepth 1 -type f -readable -print 2>/dev/null || true
