#!/usr/bin/env bash
# Purpose: Check uptime, load, memory, disk, and failed systemd units.
# Usage: system_health.sh
# Required privileges: None. Dependencies: uptime, free, df, systemctl.
# Inputs/options: None. Expected output: Basic health snapshot.
# Exit codes: 0 collection completed. Security considerations: Read-only diagnostics.
set -Eeuo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"
require_commands uptime free df systemctl; header 'System health'; uptime; free -h; df -hP; section 'Failed units'; systemctl --failed --no-pager || true
