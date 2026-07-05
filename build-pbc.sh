#!/usr/bin/env bash
#
# build-pbc.sh — build proxmox-backup-client from source on a non-Debian system
#
# What it does:
#   1. Clones the sibling Proxmox repos next to your proxmox-backup checkout
#      (or fetches updates if they're already there).
#   2. Disables the .cargo/config.toml that points at Debian's vendor dir.
#   3. Uncomments path = "../..." workspace deps in Cargo.toml, but ONLY for
#      crates whose target directory actually exists — anything missing falls
#      back to crates.io.
#   4. Runs `cargo build --release --bin proxmox-backup-client`.
#
# Usage:
#   ./build-pbc.sh                       # run from inside proxmox-backup/
#   ./build-pbc.sh /path/to/proxmox-backup
#
# Env vars:
#   INCLUDE_FUSE=0   skip proxmox-fuse (no `mount`/`map` subcommands)
#   PBS_GIT_BASE     override the git base URL (default: https://git.proxmox.com/git)
#
# Re-running is safe: clones become fetches, the cargo config move is a no-op
# if already moved, and the Cargo.toml patcher only acts on still-commented lines.

set -euo pipefail

GIT_BASE="${PBS_GIT_BASE:-https://git.proxmox.com/git}"
INCLUDE_FUSE="${INCLUDE_FUSE:-1}"

REPOS=(proxmox pathpatterns pxar)
[ "$INCLUDE_FUSE" = "1" ] && REPOS+=(proxmox-fuse)

# --- Locate proxmox-backup ---
PBS_DIR="${1:-$(pwd)}"
if [ ! -f "$PBS_DIR/Cargo.toml" ] || ! grep -q '"pbs-client"' "$PBS_DIR/Cargo.toml" 2>/dev/null; then
    echo "ERROR: '$PBS_DIR' does not look like a proxmox-backup checkout." >&2
    echo "       Pass the path as the first argument, or run from inside it." >&2
    exit 1
fi
PBS_DIR="$(cd "$PBS_DIR" && pwd)"
PARENT="$(dirname "$PBS_DIR")"

echo "==> proxmox-backup: $PBS_DIR"
echo "==> siblings will live in: $PARENT"

# --- Clone or update sibling repos ---
for repo in "${REPOS[@]}"; do
    dest="$PARENT/$repo"
    if [ -d "$dest/.git" ]; then
        echo "    $repo: present, fetching..."
        git -C "$dest" fetch --quiet --all --tags || echo "      (fetch failed, using existing checkout)"
    else
        echo "    $repo: cloning..."
        git clone --quiet "$GIT_BASE/${repo}.git" "$dest"
    fi
done

cd "$PBS_DIR"

# --- Disable Debian vendor pointer ---
if [ -f .cargo/config.toml ]; then
    echo "==> Disabling .cargo/config.toml (points at Debian's vendor dir)"
    mv .cargo/config.toml .cargo/config.toml.disabled
fi

# --- Patch Cargo.toml: uncomment path deps whose target exists ---
echo "==> Patching Cargo.toml"
cp -f Cargo.toml Cargo.toml.bak

python3 - "$PBS_DIR" <<'PY'
import re, sys
from pathlib import Path

pbs = Path(sys.argv[1])
cargo = pbs / 'Cargo.toml'
lines = cargo.read_text().splitlines()
out, enabled, skipped = [], [], []

# Matches lines like:  #crate-name = { path = "../somewhere" }
pat = re.compile(r'^(\s*)#\s*([\w-]+)\s*=\s*\{\s*path\s*=\s*"([^"]+)"')

for line in lines:
    m = pat.match(line)
    if m:
        indent, crate, p = m.groups()
        target = (pbs / p).resolve()
        if target.is_dir():
            line = indent + line.lstrip().lstrip('#').lstrip()
            enabled.append((crate, p))
        else:
            skipped.append((crate, p))
    out.append(line)

cargo.write_text('\n'.join(out) + '\n')

print(f"    enabled {len(enabled)} local path dep(s):")
for c, p in enabled:
    print(f"      + {c}  ({p})")
if skipped:
    print(f"    left {len(skipped)} commented (target dir missing → crates.io):")
    for c, p in skipped:
        print(f"      - {c}  ({p})")
PY

# --- Build ---
echo "==> Building proxmox-backup-client (release)..."
cargo build --release -p proxmox-backup-client --bin proxmox-backup-client

BIN="$PBS_DIR/target/release/proxmox-backup-client"
echo
echo "==> Done."
echo "    $(ls -lh "$BIN" | awk '{print $5, $NF}')"
echo
echo "Install:"
echo "  sudo install -m755 '$BIN' /usr/local/bin/"
