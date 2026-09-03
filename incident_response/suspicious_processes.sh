#!/usr/bin/env bash
# Purpose: Triage root/high-resource processes and deleted executables.
# Usage: suspicious_processes.sh
# Required privileges: None. Dependencies: ps, readlink.
# Inputs/options: None. Expected output: Triage indicators.
# Exit codes: 0. Security considerations: Output can reveal command-line secrets; protect reports.
set -Eeuo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"
"$TOOLKIT_ROOT/monitoring/process_monitor.sh"
