#!/usr/bin/env bash
# Purpose: Audit sudo/wheel membership and sudoers configuration paths.
# Usage: sudo_audit.sh
# Required privileges: None; root shows more detail. Dependencies: getent, find.
# Inputs/options: None. Expected output: Privileged group/member findings.
# Exit codes: 0. Security considerations: Configuration is read-only.
set -Eeuo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"
require_commands getent; header 'Sudo privilege audit'; for group in sudo wheel adm; do members=$(getent group "$group" | cut -d: -f4 || true); printf '%-8s %s\n' "$group" "${members:-none}"; done; section 'Sudoers files'; for path in /etc/sudoers /etc/sudoers.d; do [[ -e "$path" ]] && find "$path" -maxdepth 1 -type f -readable -print; done
