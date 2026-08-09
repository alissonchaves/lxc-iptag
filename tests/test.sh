#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INSTALLER="${ROOT_DIR}/lxc-iptag.sh"
GENERATED="$(mktemp)"
trap 'rm -f "${GENERATED}"' EXIT

bash -n "${INSTALLER}"

# Extract the heredoc that becomes /opt/lxc-iptag/lxc-iptag.
sed -n '/^cat <<'"'"'EOF'"'"' >"\$MAIN_FILE"$/,/^EOF$/p' "${INSTALLER}" \
  | sed '1d;$d' >"${GENERATED}"
bash -n "${GENERATED}"

if grep -qE '(^|[^A-Z_])STATUS_CHECK_INTERVAL([^A-Z_]|$)' "${GENERATED}"; then
  echo "Found stale STATUS_CHECK_INTERVAL reference" >&2
  exit 1
fi

grep -q 'LXC_STATUS_CHECK_INTERVAL' "${GENERATED}"
grep -q 'STATE_FILE="\${STATE_DIR}/state"' "${GENERATED}"
grep -q 'write_state' "${GENERATED}"

echo "All lxc-iptag shell checks passed."
