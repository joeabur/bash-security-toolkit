#!/usr/bin/env bash
# Purpose: Combine core audits and produce a simple transparent security score.
# Usage: security_audit.sh
# Required privileges: None. Dependencies: Bash and common Linux tools.
# Inputs/options: None. Expected output: Findings and score out of 100.
# Exit codes: 0 collection completed. Security considerations: Score is educational, not a risk rating.
set -Eeuo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"
header 'System security audit'; score=100; checks=0
check() { local label=$1 command_line=$2; checks=$((checks + 1)); if eval "$command_line" >/dev/null 2>&1; then log_ok "$label"; else log_warn "$label"; score=$((score - 15)); fi; }
check 'SSH daemon configuration is readable' '[[ -r "${SSH_CONFIG:-/etc/ssh/sshd_config}" ]]'; check 'A firewall tool is installed' 'command -v ufw || command -v nft'; check 'ASLR is enabled' '[[ -r /proc/sys/kernel/randomize_va_space && $(< /proc/sys/kernel/randomize_va_space) -ge 1 ]]'; check 'No unexpected UID 0 account' '[[ $(getent passwd | awk -F: "$3 == 0 {n++} END {print n+0}") -le 1 ]]'; printf '\nSecurity score: %d/100 (%d controls sampled)\n' "$score" "$checks"
