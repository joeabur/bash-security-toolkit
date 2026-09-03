#!/usr/bin/env bash
# Purpose: Summarize recent authentication successes, failures, and SSH source IPs.
# Usage: auth_monitor.sh [lines]
# Required privileges: None. Dependencies: journalctl or grep.
# Inputs/options: Positive line count, default 200. Expected output: Auth event summary.
# Exit codes: 0. Security considerations: Host logs can contain usernames and IPs.
set -Eeuo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"
lines=${1:-200}; [[ "$lines" =~ ^[0-9]+$ ]] || exit 2; header 'Authentication monitor'; if command -v journalctl >/dev/null 2>&1; then journalctl -u ssh -u sshd --since '24 hours ago' --no-pager -n "$lines" 2>/dev/null | grep -Ei 'accepted|failed|invalid|authentication failure' || true; else grep -Ei 'accepted|failed|invalid|authentication failure' /var/log/auth.log /var/log/secure 2>/dev/null | tail -n "$lines" || true; fi
