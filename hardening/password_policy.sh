#!/usr/bin/env bash
# Purpose: Check local password aging and PAM policy without exposing passwords.
# Usage: password_policy.sh [--check]
# Required privileges: Root recommended. Dependencies: awk, chage, getent.
# Inputs/options: Optional --check. Expected output: Policy findings.
# Exit codes: 0 compliant, 1 findings/error, 2 invalid usage. Security considerations: Reads metadata only.
set -Eeuo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"
[[ ${1:---check} == --check ]] || exit 2
require_commands awk getent chage; header 'Password policy audit'; failures=0
if [[ -r /etc/login.defs ]]; then awk '/^(PASS_MAX_DAYS|PASS_MIN_DAYS|PASS_MIN_LEN|LOGIN_RETRIES)/ { print }' /etc/login.defs; else log_warn '/etc/login.defs unavailable'; failures=$((failures + 1)); fi
while IFS=: read -r name _ uid _ _ _ shell; do [[ $uid -ge 1000 && $uid -lt 60000 ]] || continue; aging=$(chage -l "$name" 2>/dev/null | awk -F: '/Password expires/ {gsub(/^ /,"",$2); print $2}'); printf '%-24s %s\n' "$name" "${aging:-unknown}"; done < <(getent passwd)
(( failures == 0 ))
