#!/usr/bin/env bash
# Purpose: Identify high-resource, root-owned, and deleted-executable processes.
# Usage: process_monitor.sh
# Required privileges: None; root improves visibility. Dependencies: ps, awk, find.
# Inputs/options: None. Expected output: Process risk indicators.
# Exit codes: 0. Security considerations: Process names/arguments may contain sensitive data.
set -Eeuo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"
require_commands ps; header 'Process monitor'; section 'Top CPU/memory'; ps -eo user,pid,ppid,pcpu,pmem,comm --sort=-pcpu | head -16; section 'Root-owned processes'; ps -eo user,pid,ppid,comm,args --no-headers | awk '$1 == "root" {print}' | head -100; section 'Deleted executables'; for proc in /proc/[0-9]*; do [[ -e "$proc/exe" ]] || continue; target=$(readlink "$proc/exe" 2>/dev/null || true); [[ "$target" == *' (deleted)'* ]] && printf '%s %s\n' "${proc##*/}" "$target"; done
