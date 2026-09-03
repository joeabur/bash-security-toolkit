#!/usr/bin/env bash
# Purpose: Run a read-only baseline of kernel, service, firewall, and file controls.
# Usage: system_hardening.sh [--check]
# Required privileges: Root recommended. Dependencies: systemctl, find, ss.
# Inputs/options: --check only. Expected output: Baseline findings.
# Exit codes: 0 when collection completes, 1 on missing dependencies. Security considerations: No changes are made.
set -Eeuo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"
[[ ${1:---check} == --check ]] || exit 2
require_commands systemctl find ss; header 'System hardening baseline'; printf 'Host: '; hostname; printf 'Kernel: '; uname -sr; section 'Security-relevant services'; systemctl list-unit-files --type=service --state=enabled --no-pager 2>/dev/null | grep -Ei 'ssh|telnet|ftp|rsh|xinetd|avahi|cups' || true; section 'Kernel controls'; for file in /proc/sys/net/ipv4/ip_forward /proc/sys/kernel/randomize_va_space; do [[ -r "$file" ]] && printf '%s=%s\n' "$file" "$(<"$file")"; done; section 'Firewall'; "$TOOLKIT_ROOT/hardening/firewall_hardening.sh" --check || true
