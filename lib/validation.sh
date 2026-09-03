#!/usr/bin/env bash
# Purpose: Validate dependencies, privileges, and safe command arguments.
# Usage: source lib/validation.sh; require_commands ss awk
# Required privileges: None. Dependencies: Bash.
# Inputs/options: Command names and paths. Expected output: Diagnostics on failure.
# Exit codes: 0 valid, 1 invalid. Security considerations: Rejects unsafe paths/values.

set -Eeuo pipefail
require_commands() { local command_name; for command_name in "$@"; do command -v "$command_name" >/dev/null 2>&1 || { printf 'Missing dependency: %s\n' "$command_name" >&2; return 1; }; done; }
require_root() { [[ ${EUID:-$(id -u)} -eq 0 ]] || { printf 'This operation requires root privileges.\n' >&2; return 1; }; }
valid_choice() { local value=$1; shift; local allowed; for allowed in "$@"; do [[ "$value" == "$allowed" ]] && return 0; done; return 1; }
valid_existing_file() { [[ -f "$1" && -r "$1" ]]; }
confirm_action() { [[ ${FORCE_CONFIRM:-0} == 1 ]] && return 0; local reply; read -r -p "Type APPLY to continue: " reply; [[ "$reply" == APPLY ]]; }
