#!/usr/bin/env bash
# Purpose: Inspect resolver configuration and test DNS resolution.
# Usage: dns_check.sh [hostname]
# Required privileges: None. Dependencies: getent; dig optional.
# Inputs/options: Hostname default example.com. Expected output: Resolver result.
# Exit codes: 0 resolution succeeded, 1 failed, 2 invalid input. Security considerations: Uses a fixed-safe hostname argument.
set -Eeuo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"
host=${1:-example.com}; [[ "$host" =~ ^[A-Za-z0-9.-]+$ ]] || exit 2; require_commands getent; header 'DNS check'; cat /etc/resolv.conf 2>/dev/null || true; getent ahosts "$host"; run_optional dig +short "$host"
