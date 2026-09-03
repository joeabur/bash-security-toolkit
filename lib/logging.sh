#!/usr/bin/env bash
# Purpose: Consistent, timestamped toolkit logging.
# Usage: source lib/logging.sh; log_info "message"
# Required privileges: None. Dependencies: Bash.
# Inputs/options: LOG_FILE optionally selects a log file. Expected output: Log lines.
# Exit codes: Logging functions return 0. Security considerations: Never log secrets.

: "${LOG_FILE:=}"
log_write() { local level=$1 message=$2 line; line="$(date -u +%Y-%m-%dT%H:%M:%SZ) [$level] $message"; printf '%s\n' "$line"; [[ -n "$LOG_FILE" ]] && printf '%s\n' "$line" >> "$LOG_FILE" || true; }
log_info() { log_write INFO "$*"; }
log_warn() { log_write WARN "$*" >&2; }
log_error() { log_write ERROR "$*" >&2; }
log_ok() { log_write OK "$*"; }
