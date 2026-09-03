#!/usr/bin/env bash
# Purpose: Inventory interfaces, addresses, routes, DNS, and firewall state.
# Usage: network_audit.sh
# Required privileges: None. Dependencies: ip, ss.
# Inputs/options: None. Expected output: Network posture snapshot.
# Exit codes: 0. Security considerations: Network topology is sensitive.
set -Eeuo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"
require_commands ip ss; header 'Network audit'; ip -brief address; ip route; section 'DNS'; [[ -r /etc/resolv.conf ]] && sed -n '1,80p' /etc/resolv.conf; section 'Firewall'; "$TOOLKIT_ROOT/hardening/firewall_hardening.sh" --check || true
