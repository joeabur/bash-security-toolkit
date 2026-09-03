#!/usr/bin/env bash
# Purpose: List enabled/running services and flag commonly unnecessary network daemons.
# Usage: service_audit.sh
# Required privileges: None. Dependencies: systemctl, grep.
# Inputs/options: None. Expected output: Service inventory.
# Exit codes: 0. Security considerations: No service state is changed.
set -Eeuo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"
require_commands systemctl; header 'Service audit'; section 'Running services'; systemctl list-units --type=service --state=running --no-pager --no-legend; section 'Enabled services'; systemctl list-unit-files --type=service --state=enabled --no-pager --no-legend; section 'Review candidates'; systemctl list-units --type=service --state=running --no-pager --no-legend | grep -Ei 'telnet|ftp|rsh|rexec|avahi|cups|vsftpd' || true
