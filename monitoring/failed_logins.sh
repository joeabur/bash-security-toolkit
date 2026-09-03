#!/usr/bin/env bash
# Purpose: Count failed logins and identify repeated SSH failure sources.
# Usage: failed_logins.sh
# Required privileges: None. Dependencies: lastb or journalctl, awk, sort.
# Inputs/options: None. Expected output: Failure counts and IP indicators.
# Exit codes: 0. Security considerations: IP addresses are sensitive operational data.
set -Eeuo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"
require_commands awk sort; header 'Failed login monitor'; if command -v lastb >/dev/null 2>&1; then lastb -Fi 2>/dev/null | head -200 || true; else journalctl --no-pager --since '7 days ago' 2>/dev/null | grep -Ei 'failed password|authentication failure' | awk '{for (i=1;i<=NF;i++) if ($i == "from") print $(i+1)}' | sort | uniq -c | sort -nr | head -20 || true; fi
