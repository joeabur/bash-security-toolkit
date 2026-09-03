#!/usr/bin/env bash
# Purpose: Report firewall status and optionally enable an available firewall.
# Usage: firewall_hardening.sh --check|--apply
# Required privileges: --apply root. Dependencies: ufw or nft.
# Inputs/options: No positional inputs. Expected output: Firewall state.
# Exit codes: 0 active, 1 inactive/error, 2 invalid usage. Security considerations: Never flushes rules or changes ports.
set -Eeuo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"
mode=${1:---check}; [[ "$mode" == --check || "$mode" == --apply ]] || exit 2
header "Firewall hardening ($mode)"; active=1
if command -v ufw >/dev/null 2>&1; then status=$(ufw status 2>/dev/null || true); printf '%s\n' "$status"; grep -q 'Status: active' <<<"$status" || active=0; if [[ "$mode" == --apply && $active -eq 0 ]]; then require_root; printf 'Planned change: enable UFW without adding or deleting rules.\n'; confirm_action || exit 1; ufw --force enable; fi
elif command -v nft >/dev/null 2>&1; then nft list ruleset 2>/dev/null || true; [[ -s /proc/net/nf_tables ]] || active=0; log_info 'nftables detected; review the ruleset above.'
else log_warn 'Neither ufw nor nft is installed.'; active=0; fi
(( active == 1 ))
