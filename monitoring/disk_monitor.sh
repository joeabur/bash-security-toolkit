#!/usr/bin/env bash
# Purpose: Report filesystem and large-directory disk usage.
# Usage: disk_monitor.sh
# Required privileges: None. Dependencies: df, du, sort.
# Inputs/options: None. Expected output: Usage percentages and largest directories.
# Exit codes: 0. Security considerations: Read-only; permission errors are suppressed.
set -Eeuo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"
require_commands df du; header 'Disk monitor'; df -hP | awk 'NR == 1 || $5+0 >= 80 {print}'; section 'Largest top-level directories'; du -xhd1 / 2>/dev/null | sort -h -r | head -12
