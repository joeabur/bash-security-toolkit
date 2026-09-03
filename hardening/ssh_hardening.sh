#!/usr/bin/env bash
# Purpose: Audit SSH settings and optionally apply conservative hardening.
# Usage: ssh_hardening.sh --check|--apply
# Required privileges: --check usually none; --apply root. Dependencies: awk, grep, sshd.
# Inputs/options: SSH_CONFIG or config file path. Expected output: Findings and changes.
# Exit codes: 0 pass, 1 findings/error, 2 invalid usage. Security considerations: validates config and backs up before edits.
set -Eeuo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"
source "$CONFIG_FILE" 2>/dev/null || true
mode=${1:---check}; [[ "$mode" == --check || "$mode" == --apply ]] || { printf 'Usage: %s --check|--apply\n' "$0" >&2; exit 2; }
config=${SSH_CONFIG:-/etc/ssh/sshd_config}; [[ -r "$config" ]] || { log_error "Cannot read $config"; exit 1; }
check_setting() { local key=$1 desired=$2 actual; actual=$(awk -v key="$key" '$1 == key { value=$2 } END { print value }' "$config"); if [[ "$actual" == "$desired" ]]; then log_ok "$key=$desired"; else log_warn "$key is ${actual:-unset}; recommended $desired"; return 1; fi; }
header "SSH hardening ($mode)"; failures=0
check_setting PermitRootLogin no || failures=$((failures + 1)); check_setting PasswordAuthentication no || failures=$((failures + 1)); check_setting MaxAuthTries 4 || failures=$((failures + 1))
if [[ "$mode" == --apply && $failures -gt 0 ]]; then require_root || exit 1; printf 'Planned changes to %s: disable root login/password auth and set MaxAuthTries 4.\n' "$config"; printf 'Validate an alternate administrative session before continuing.\n'; confirm_action || { log_warn 'Change cancelled.'; exit 1; }; backup_file "$config"; for setting in 'PermitRootLogin no' 'PasswordAuthentication no' 'MaxAuthTries 4'; do key=${setting%% *}; if grep -Eq "^[[:space:]]*#?[[:space:]]*$key[[:space:]]" "$config"; then sed -i -E "s|^[[:space:]]*#?[[:space:]]*$key[[:space:]].*|$setting|" "$config"; else printf '%s\n' "$setting" >> "$config"; fi; done; sshd -t -f "$config" || { log_error 'sshd rejected the new configuration; restore the backup before restarting.'; exit 1; }; log_ok 'SSH configuration updated and syntax-checked; restart was intentionally not performed.'; fi
(( failures == 0 ))
