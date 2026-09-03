#!/usr/bin/env bash
# Purpose: Find risky SUID/SGID and world-writable files on selected local paths.
# Usage: file_permissions.sh [paths...]
# Required privileges: Root recommended. Dependencies: find, stat.
# Inputs/options: Paths default to /usr/bin /usr/sbin /etc. Expected output: File lists.
# Exit codes: 0. Security considerations: Does not alter permissions; paths are passed as arguments.
set -Eeuo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"
require_commands find; if [[ $# -gt 0 ]]; then paths=("$@"); else paths=(/usr/bin /usr/sbin /etc); fi; header 'File permission audit'
for path in "${paths[@]}"; do [[ -d "$path" ]] || { log_warn "Skipping missing path: $path"; continue; }; section "SUID/SGID under $path"; find "$path" -xdev -type f \( -perm -4000 -o -perm -2000 \) -print 2>/dev/null | head -200 || true; section "World-writable files under $path"; find "$path" -xdev -type f -perm -0002 -print 2>/dev/null | head -200 || true; done
