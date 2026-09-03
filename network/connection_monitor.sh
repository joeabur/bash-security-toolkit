#!/usr/bin/env bash
# Purpose: Show active TCP/UDP connections and remote peers.
# Usage: connection_monitor.sh
# Required privileges: None. Dependencies: ss.
# Inputs/options: None. Expected output: Active connection inventory.
# Exit codes: 0. Security considerations: Remote addresses are sensitive.
set -Eeuo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"
require_commands ss; header 'Active connections'; ss -tunap 2>/dev/null || ss -tuna
