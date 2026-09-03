#!/usr/bin/env bash
# Purpose: Audit local users, UID 0 accounts, shells, and inactive accounts.
# Usage: user_audit.sh
# Required privileges: None. Dependencies: getent, awk, lastlog.
# Inputs/options: None. Expected output: User account findings.
# Exit codes: 0. Security considerations: Does not print password fields.
set -Eeuo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"
require_commands getent awk; header 'User account audit'; section 'UID 0 accounts'; getent passwd | awk -F: '$3 == 0 {print $1 ":" $7}'; section 'Interactive accounts'; getent passwd | awk -F: '$7 !~ /(nologin|false)$/ {print $1 ":" $3 ":" $7}'; section 'Last login metadata'; run_optional lastlog -b "${INACTIVE_DAYS:-90}" 2>/dev/null | head -100
