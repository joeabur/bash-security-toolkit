# bash-security-toolkit

A beginner-to-intermediate Bash portfolio project for defensive Linux security automation. It demonstrates hardening, security auditing, privilege review, network diagnostics, monitoring, and basic incident-response triage using familiar Linux tools.

> **Learning project:** This toolkit is educational and is not a replacement for a SIEM, EDR, vulnerability scanner, compliance platform, or configuration-management system. Test on disposable hosts and review every finding with platform context.

## Learning objectives

- Read Linux identity, service, filesystem, process, network, and authentication state safely.
- Practice Bash strict mode, functions, validation, traps, quoting, and exit codes.
- Understand least privilege, SSH exposure, firewall posture, SUID/SGID risk, password aging, and log-based indicators.
- Build a small repeatable triage archive without modifying the host.

## Security concepts demonstrated

Least privilege; defense in depth; secure defaults; configuration backups; change confirmation; exposed network services; UID 0 and sudo membership; failed authentication and brute-force indicators; suspicious process executables; filesystem permissions; and transparent scoring.

## Repository structure

- `toolkit.sh`: allowlisted CLI dispatcher.
- `lib/`: colors, logging, validation, and runtime helpers.
- `config/toolkit.conf`: thresholds and paths.
- `hardening/`: SSH, firewall, password, permissions, and system checks.
- `auditing/`: users, sudo, services, cron, and security score.
- `monitoring/`: authentication, processes, disks, failed logins, and health.
- `network/`: interfaces, ports, connections, DNS, and firewall review.
- `incident_response/`: triage archive, logs, and process collection.
- `tests/`: lightweight validation tests. `reports/` is intentionally kept empty.

## Installation

```bash
git clone https://github.com/YOUR-USER/bash-security-toolkit.git
cd bash-security-toolkit
chmod +x toolkit.sh hardening/*.sh auditing/*.sh monitoring/*.sh network/*.sh incident_response/*.sh tests/*.sh
./toolkit.sh --help
```

No package manager is required. Use a supported Linux distribution and run in a test VM before applying changes.

## Dependencies

Bash 4+, coreutils, `awk`, `sed`, `grep`, `find`, `ps`, `df`, `du`, `last`, `lastlog`, `getent`, `ip`, `ss`, and `systemctl`. `ufw`, `nft`, `journalctl`, `dig`, `chage`, and `hostnamectl` are detected when available. Some commands show more data as root.

## Usage

```bash
./toolkit.sh audit system
./toolkit.sh audit users
./toolkit.sh audit sudo
./toolkit.sh harden ssh --check
./toolkit.sh harden firewall --check
./toolkit.sh harden ssh --apply
./toolkit.sh network ports
./toolkit.sh network connections
./toolkit.sh network dns example.org
./toolkit.sh monitor auth
./toolkit.sh monitor processes
./toolkit.sh monitor failed-logins
./toolkit.sh ir collect
```

Use `./toolkit.sh --help` for the complete command list. Commands return zero when collection succeeds; audit findings may produce a non-zero status where appropriate.

## Script guide

**Hardening:** `ssh_hardening.sh` checks safe SSH defaults and can apply three conservative settings; `firewall_hardening.sh` reports UFW/nftables and can enable UFW without rewriting rules; `password_policy.sh` reads login defaults and aging metadata; `file_permissions.sh` finds SUID/SGID and world-writable files; `system_hardening.sh` combines a read-only baseline.

**Auditing:** `user_audit.sh` finds UID 0 and interactive accounts; `sudo_audit.sh` reviews privileged groups and sudoers paths; `service_audit.sh` inventories enabled/running services and review candidates; `cron_audit.sh` inventories scheduled jobs; `security_audit.sh` samples controls and prints an educational score out of 100.

**Monitoring:** `auth_monitor.sh` searches recent authentication events; `failed_logins.sh` summarizes failed login activity; `process_monitor.sh` reports resource-heavy, root-owned, and deleted-executable processes; `disk_monitor.sh` reports full filesystems and large directories; `system_health.sh` snapshots uptime, memory, disk, and failed units.

**Network:** `network_audit.sh` combines interfaces, routes, DNS, and firewall state; `listening_ports.sh` uses `ss` and flags non-loopback listeners; `connection_monitor.sh` shows active sockets; `dns_check.sh` tests a validated hostname.

**Incident response:** `collect_triage.sh` creates a mode-restricted timestamped `tar.gz` containing host, process, network, user, sudo, cron, service, and recent log data; `collect_logs.sh` collects recent logs; `suspicious_processes.sh` runs the process triage view.

## Hardening vs auditing

Audits are read-only by default. Hardening scripts accept `--check` for inspection and require `--apply` for a supported change. Apply mode previews the change, requires typing `APPLY`, backs up configuration, and validates where possible. SSH changes never restart SSH automatically; keep an existing administrative session open and validate a second session before restarting manually. Firewall changes can affect connectivity and should be tested from console access.

## Logging and errors

Shared helpers provide UTC timestamps, `INFO`/`WARN`/`ERROR`/`OK` levels, strict mode (`set -Eeuo pipefail`), dependency checks, and an error trap. Set `LOG_FILE` to capture output, but do not use a path writable by untrusted users. Reports and triage archives should be treated as sensitive.

## Testing

```bash
find . -type f -name '*.sh' -print0 | xargs -0 -n1 bash -n
bash tests/test_validation.sh
```

The tests avoid host modification. Run them in CI and on the Linux distributions you support.

## Example output

```text
== Listening ports ==
Netid State  Local Address:Port  Process
TCP   LISTEN 0.0.0.0:22          users:("sshd",pid=812,fd=3)

-- Potentially exposed non-loopback listeners --
TCP   LISTEN 0.0.0.0:22          users:("sshd",pid=812,fd=3)
```

## Limitations

Output depends on distribution, init system, permissions, log format, and installed tools. A listener is not automatically vulnerable, and a missing finding is not proof of safety. The score is a teaching aid, not a benchmark. The toolkit does not perform vulnerability exploitation, continuous collection, alert delivery, remediation orchestration, or forensic preservation.

## Future roadmap

- Add distribution-aware policy profiles and JSON output.
- Add shellcheck and CI across Ubuntu, Debian, Fedora, and Arch.
- Add opt-in baseline comparison and signed report metadata.
- Expand unit tests with mocked command output.
- Integrate with professional monitoring and configuration-management workflows without replacing them.

## License

MIT. See `LICENSE`.
