#!/usr/bin/env bash
# Purpose: Smoke-test shared validation and utility functions.
# Usage: bash tests/test_validation.sh
# Required privileges: None. Dependencies: Bash, mktemp.
# Inputs/options: None. Expected output: PASS/FAIL assertions.
# Exit codes: 0 all tests pass, 1 failure. Security considerations: Uses temporary files only.
set -Eeuo pipefail
ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd); source "$ROOT/lib/common.sh"
pass=0; fail=0
assert_ok() { if "$@" >/dev/null 2>&1; then printf 'PASS: %s\n' "$1"; pass=$((pass + 1)); else printf 'FAIL: %s\n' "$1"; fail=$((fail + 1)); fi; }
assert_bad() { if "$@" >/dev/null 2>&1; then printf 'FAIL: %s\n' "$1"; fail=$((fail + 1)); else printf 'PASS: %s\n' "$1"; pass=$((pass + 1)); fi; }
assert_ok require_commands bash; assert_bad require_commands definitely-not-a-command; assert_ok valid_choice ssh ssh http; assert_bad valid_choice telnet ssh http; assert_ok valid_existing_file "$ROOT/lib/common.sh"; FORCE_CONFIRM=1 assert_ok confirm_action
printf 'Tests: %d passed, %d failed\n' "$pass" "$fail"; (( fail == 0 ))
