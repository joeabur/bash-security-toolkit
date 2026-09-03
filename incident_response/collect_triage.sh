#!/usr/bin/env bash
# Purpose: Package a timestamped, read-only host triage collection.
# Usage: collect_triage.sh
# Required privileges: Root recommended. Dependencies: hostname, ps, ss, ip, tar.
# Inputs/options: No inputs. Expected output: reports/triage-TIMESTAMP.tar.gz.
# Exit codes: 0 success, 1 collection error. Security considerations: Archive contains sensitive host data and is mode 600.
set -Eeuo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"
require_commands hostname ps ss ip tar; stamp=$(date -u +%Y%m%dT%H%M%SZ); work=$(mktemp -d); archive="$REPORT_DIR/triage-$stamp.tar.gz"; chmod 700 "$work"; trap 'rm -rf -- "$work"' EXIT
hostnamectl 2>/dev/null > "$work/host.txt" || uname -a > "$work/host.txt"; ps auxww > "$work/processes.txt"; ss -tunap > "$work/connections.txt" 2>/dev/null || ss -tuna > "$work/connections.txt"; ss -tulpen > "$work/listening.txt" 2>/dev/null || true; ip addr > "$work/network.txt"; "$TOOLKIT_ROOT/incident_response/collect_logs.sh" "$work/logs"; "$TOOLKIT_ROOT/auditing/user_audit.sh" > "$work/users.txt"; "$TOOLKIT_ROOT/auditing/sudo_audit.sh" > "$work/sudo.txt"; "$TOOLKIT_ROOT/auditing/cron_audit.sh" > "$work/cron.txt"; "$TOOLKIT_ROOT/auditing/service_audit.sh" > "$work/services.txt"; tar -czf "$archive" -C "$work" .; chmod 600 "$archive"; log_ok "Triage archive: $archive"
