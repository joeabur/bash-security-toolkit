#!/usr/bin/env bash
# Purpose: Shared runtime helpers for safe, read-only security tooling.
# Usage: source lib/common.sh
# Required privileges: Varies by command. Dependencies: Bash and coreutils.
# Inputs/options: TOOLKIT_ROOT, REPORT_DIR, LOG_FILE. Expected output: Helper functions.
# Exit codes: Helpers return meaningful command status. Security considerations: Uses quoted paths.

set -Eeuo pipefail
COMMON_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
TOOLKIT_ROOT=$(cd -- "$COMMON_DIR/.." && pwd)
# shellcheck source=colors.sh
source "$COMMON_DIR/colors.sh"
# shellcheck source=logging.sh
source "$COMMON_DIR/logging.sh"
# shellcheck source=validation.sh
source "$COMMON_DIR/validation.sh"
CONFIG_FILE=${CONFIG_FILE:-$TOOLKIT_ROOT/config/toolkit.conf}
REPORT_DIR=${REPORT_DIR:-$TOOLKIT_ROOT/reports}
mkdir -p -- "$REPORT_DIR"

on_error() { local code=$? line=$1; log_error "${BASH_SOURCE[1]##*/}: command failed at line $line (exit $code)"; return "$code"; }
trap 'on_error "$LINENO"' ERR
cleanup() { :; }
trap cleanup EXIT
header() { printf '\n%s== %s ==%s\n' "$BLUE" "$1" "$RESET"; }
section() { printf '\n-- %s --\n' "$1"; }
run_optional() { if command -v "$1" >/dev/null 2>&1; then "$@"; else log_warn "Optional dependency unavailable: $1"; return 0; fi; }
report_file() { local name=$1; printf '%s/%s-%s.txt' "$REPORT_DIR" "$name" "$(date -u +%Y%m%dT%H%M%SZ)"; }
backup_file() { local target=$1; cp -p -- "$target" "${target}.bak.$(date -u +%Y%m%dT%H%M%SZ)"; }
