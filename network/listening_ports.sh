#!/usr/bin/env bash
# Purpose: List TCP/UDP listening sockets and flag broadly exposed services.
# Usage: listening_ports.sh
# Required privileges: None; root improves process ownership visibility. Dependencies: ss, awk.
# Inputs/options: None. Expected output: Socket inventory and exposure review.
# Exit codes: 0. Security considerations: Does not connect to or modify services.
set -Eeuo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"
require_commands ss awk; header 'Listening ports'; ss -tulpen; section 'Potentially exposed non-loopback listeners'; ss -tulpenH | awk '$5 !~ /(127\.0\.0\.1|::1|localhost)/ {print}' || true
