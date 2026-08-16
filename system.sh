#!/usr/bin/env bash
#
# system.sh - one power-management wrapper for both systemd and OpenRC/elogind
# machines. Dispatches to systemctl when systemd is PID 1, otherwise loginctl,
# otherwise the classic sysvinit binaries.

set -uo pipefail

PROGNAME=${0##*/}

die() {
	printf '%s: %s\n' "$PROGNAME" "$*" >&2
	exit 1
}

usage() {
cat <<EOF
Usage: $PROGNAME <action>

Actions:
  poweroff | off | shutdown | halt   power off the machine
  reboot   | restart                 reboot the machine
  suspend  | sleep                   suspend to RAM
  hibernate                          suspend to disk
  hybrid-sleep                       suspend to RAM and disk
  suspend-then-hibernate             suspend now, hibernate after a delay
  status                             report which backend would be used
EOF
}

# The mere presence of a systemctl binary does not mean systemd is running -
# plenty of distros ship the binary, and it is also present inside containers.
# This directory only exists when systemd is actually PID 1.
using_systemd() {
	[ -d /run/systemd/system ]
}

# Try the command as-is; if it fails and we are not root, retry under sudo.
# logind/elogind + polkit usually allow an active local session to do this
# without escalation, so the sudo path is only a fallback.
run() {
	if "$@"; then
		return 0
	fi
	if [ "$(id -u)" -ne 0 ] && command -v sudo >/dev/null 2>&1; then
		printf '%s: "%s" failed, retrying with sudo\n' "$PROGNAME" "$*" >&2
		sudo "$@"
	else
		return 1
	fi
}

[ $# -le 1 ] || die "too many arguments (expected one action)"

action=${1:-}

case $action in
	poweroff|off|shutdown|halt) action=poweroff ;;
	reboot|restart)             action=reboot ;;
	suspend|sleep)              action=suspend ;;
	hibernate)                  action=hibernate ;;
	hybrid-sleep)               action=hybrid-sleep ;;
	suspend-then-hibernate)     action=suspend-then-hibernate ;;
	status)
		if using_systemd; then
			printf 'backend: systemctl (systemd is PID 1)\n'
		elif command -v loginctl >/dev/null 2>&1; then
			printf 'backend: loginctl (%s)\n' "$(command -v loginctl)"
		else
			printf 'backend: sysvinit binaries\n'
		fi
		exit 0
		;;
	-h|--help|help) usage; exit 0 ;;
	'') usage >&2; exit 1 ;;
	*) die "unknown action: $action (try --help)" ;;
esac

if using_systemd && command -v systemctl >/dev/null 2>&1; then
	run systemctl "$action"
elif command -v loginctl >/dev/null 2>&1; then
	run loginctl "$action"
else
	# Last resort: classic sysvinit / OpenRC binaries. These have no
	# equivalent for the sleep states.
	case $action in
		poweroff) run poweroff ;;
		reboot)   run reboot ;;
		*) die "no available backend supports '$action' on this system" ;;
	esac
fi
