#!/usr/bin/env bash
# Purpose: Centralized terminal colors.
# Usage: source lib/colors.sh
# Required privileges: None. Dependencies: Bash.
# Inputs/options: COLOR=0 disables colors. Expected output: Shell variables.
# Exit codes: 0. Security considerations: No user input is executed.

set -Eeuo pipefail
if [[ "${COLOR:-1}" == 1 && -t 1 ]]; then
  readonly RED=$'\033[31m' GREEN=$'\033[32m' YELLOW=$'\033[33m' BLUE=$'\033[34m' RESET=$'\033[0m'
else
  readonly RED='' GREEN='' YELLOW='' BLUE='' RESET=''
fi
