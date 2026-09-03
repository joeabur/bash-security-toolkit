#!/usr/bin/env bash
# Purpose: Main CLI for bash-security-toolkit.
# Usage: ./toolkit.sh GROUP COMMAND [OPTIONS]
# Required privileges: Depends on selected command. Dependencies: Bash and command-specific tools.
# Inputs/options: audit, harden, network, monitor, ir, --help. Expected output: Selected module output.
# Exit codes: 0 success, 1 command/findings failure, 2 invalid usage. Security considerations: Dispatch uses fixed allowlists.
set -Eeuo pipefail
ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
usage() { cat <<'EOF'
bash-security-toolkit - Linux security learning toolkit

Usage: toolkit.sh GROUP COMMAND [OPTIONS]

Groups:
  audit system|users|sudo|services|cron
  harden ssh|firewall|passwords|permissions|system [--check|--apply]
  network audit|ports|connections|dns [HOSTNAME]
  monitor auth|processes|disk|failed-logins|health
  ir collect|logs|processes

Examples:
  ./toolkit.sh audit system
  ./toolkit.sh harden ssh --check
  ./toolkit.sh network ports
  ./toolkit.sh ir collect
EOF
}
[[ $# -gt 0 ]] || { usage; exit 2; }
[[ $1 == --help || $1 == -h ]] && { usage; exit 0; }
group=$1; command_name=${2:-}; shift 2 || true
case "$group:$command_name" in
 audit:system) exec "$ROOT/auditing/security_audit.sh" "$@";; audit:users) exec "$ROOT/auditing/user_audit.sh" "$@";; audit:sudo) exec "$ROOT/auditing/sudo_audit.sh" "$@";; audit:services) exec "$ROOT/auditing/service_audit.sh" "$@";; audit:cron) exec "$ROOT/auditing/cron_audit.sh" "$@";;
 harden:ssh) exec "$ROOT/hardening/ssh_hardening.sh" "${1:---check}";; harden:firewall) exec "$ROOT/hardening/firewall_hardening.sh" "${1:---check}";; harden:passwords) exec "$ROOT/hardening/password_policy.sh" "$@";; harden:permissions) exec "$ROOT/hardening/file_permissions.sh" "$@";; harden:system) exec "$ROOT/hardening/system_hardening.sh" "$@";;
 network:audit) exec "$ROOT/network/network_audit.sh" "$@";; network:ports) exec "$ROOT/network/listening_ports.sh" "$@";; network:connections) exec "$ROOT/network/connection_monitor.sh" "$@";; network:dns) exec "$ROOT/network/dns_check.sh" "$@";;
 monitor:auth) exec "$ROOT/monitoring/auth_monitor.sh" "$@";; monitor:processes) exec "$ROOT/monitoring/process_monitor.sh" "$@";; monitor:disk) exec "$ROOT/monitoring/disk_monitor.sh" "$@";; monitor:failed-logins) exec "$ROOT/monitoring/failed_logins.sh" "$@";; monitor:health) exec "$ROOT/monitoring/system_health.sh" "$@";;
 ir:collect) exec "$ROOT/incident_response/collect_triage.sh" "$@";; ir:logs) exec "$ROOT/incident_response/collect_logs.sh" "$@";; ir:processes) exec "$ROOT/incident_response/suspicious_processes.sh" "$@";; *) usage; exit 2;; esac
