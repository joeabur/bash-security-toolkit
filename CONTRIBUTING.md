# Contributing

Thanks for helping improve the toolkit. Contributions should remain defensive, transparent, and suitable for a Linux learning environment.

## Development

1. Fork the repository and create a focused branch.
2. Keep scripts Bash-only with `set -Eeuo pipefail`.
3. Reuse `lib/common.sh`, validate inputs, quote variables, and avoid secrets in output.
4. Keep auditing read-only. Any hardening change must require `--apply`, show a preview, confirm, and create a backup.
5. Run `bash -n` on every script and `bash tests/test_validation.sh`.
6. Document behavior, privileges, dependencies, and limitations.

Please include a clear description of host impact and test platform in pull requests. Never submit credentials, malware, offensive automation, or destructive behavior.
