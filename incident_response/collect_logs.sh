#!/usr/bin/env bash
# Purpose: Collect recent authentication and kernel logs into a report directory.
# Usage: collect_logs.sh OUTPUT_DIR
# Required privileges: Root recommended. Dependencies: journalctl or grep.
# Inputs/options: Existing output directory. Expected output: Redacted-by-permissions log files.
# Exit codes: 0. Security considerations: Restrict report permissions; logs may contain sensitive data.
set -Eeuo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"
out=${1:?output directory required}; mkdir -p -- "$out"; chmod 700 -- "$out"; if command -v journalctl >/dev/null 2>&1; then journalctl --since '24 hours ago' --no-pager > "$out/journal.txt" 2>/dev/null || true; else cat /var/log/auth.log /var/log/secure > "$out/auth.log" 2>/dev/null || true; fi
