#!/usr/bin/env bash
#
# pbc-update.sh — install/update proxmox-backup-client (static build) from
# Proxmox's apt repo on a non-Debian system. No apt, no dpkg required.
#
# How it works:
#   1. Fetches the Packages.gz index for the configured suite/arch.
#   2. Finds the newest version of proxmox-backup-client-static.
#   3. Compares to whatever's currently installed; skips if up to date.
#   4. Downloads the .deb, verifies its SHA256 against the index.
#   5. Extracts data.tar.* and copies every binary in usr/{,s}bin/ to
#      $INSTALL_DIR (default /usr/local/bin).
#
# Usage:
#   ./pbc-update.sh                  # default: trixie, auto-detected arch
#   SUITE=bookworm ./pbc-update.sh
#   INSTALL_DIR=/opt/bin ./pbc-update.sh
#   FORCE=1 ./pbc-update.sh          # reinstall even if version matches
#
# Re-runnable. Sudo is used only for the final install step, only if not root.

set -euo pipefail

SUITE="${SUITE:-trixie}"
INSTALL_DIR="${INSTALL_DIR:-/usr/local/bin}"
REPO_BASE="${REPO_BASE:-http://download.proxmox.com/debian/pbs-client}"
PKG="${PKG:-proxmox-backup-client-static}"
FORCE="${FORCE:-0}"

case "$(uname -m)" in
    x86_64)  ARCH=amd64 ;;
    aarch64) ARCH=arm64 ;;
    *) echo "ERROR: unsupported arch $(uname -m)" >&2; exit 1 ;;
esac

need() { command -v "$1" >/dev/null 2>&1 || { echo "ERROR: missing tool: $1" >&2; exit 1; }; }
for t in curl ar tar gunzip sha256sum awk install; do need "$t"; done

INDEX_URL="$REPO_BASE/dists/$SUITE/main/binary-$ARCH/Packages.gz"

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

echo "==> Fetching package index"
echo "    $INDEX_URL"
curl -fsSL "$INDEX_URL" | gunzip > "$tmp/Packages"

# Parse the index. Debian Packages files are stanzas separated by blank lines.
# Pick the highest Version of our package, then read its Filename + SHA256.
read -r VERSION FILENAME SHA256 < <(
    awk -v pkg="$PKG" '
        BEGIN { RS=""; FS="\n" }
        {
            p=""; v=""; f=""; s=""
            for (i=1; i<=NF; i++) {
                if ($i ~ /^Package: /)  p = substr($i, 10)
                if ($i ~ /^Version: /)  v = substr($i, 10)
                if ($i ~ /^Filename: /) f = substr($i, 11)
                if ($i ~ /^SHA256: /)   s = substr($i, 9)
            }
            if (p == pkg && v != "" && f != "" && s != "") print v, f, s
        }
    ' "$tmp/Packages" | sort -V -k1,1 | tail -1
)

if [ -z "${VERSION:-}" ]; then
    echo "ERROR: package '$PKG' not found in $SUITE/$ARCH" >&2
    exit 1
fi

echo "    available: $VERSION"

# Best-effort installed-version check. The binary prints something like
# "proxmox-backup-client 4.0.14" on `version`. We match loosely.
installed_ver=""
if [ -x "$INSTALL_DIR/proxmox-backup-client" ]; then
    installed_ver=$("$INSTALL_DIR/proxmox-backup-client" version 2>/dev/null \
                    | awk '/[0-9]+\.[0-9]+/ {for(i=1;i<=NF;i++) if($i~/^[0-9]+\./){print $i; exit}}')
    echo "    installed: ${installed_ver:-(unknown)}"
fi

# Strip Debian -N suffix for the comparison; the binary doesn't print it.
upstream="${VERSION%-*}"
if [ "$FORCE" != "1" ] && [ -n "$installed_ver" ] && [ "$installed_ver" = "$upstream" ]; then
    echo "==> Already up to date."
    exit 0
fi

DEB_URL="$REPO_BASE/$FILENAME"
echo "==> Downloading"
echo "    $DEB_URL"
curl -fL --progress-bar -o "$tmp/pkg.deb" "$DEB_URL"

echo "==> Verifying SHA256"
echo "$SHA256  $tmp/pkg.deb" | sha256sum -c - >/dev/null
echo "    ok"

echo "==> Extracting"
( cd "$tmp" && ar x pkg.deb )
for f in "$tmp"/data.tar.*; do
    case "$f" in
        *.zst) tar --zstd -xf "$f" -C "$tmp" ;;
        *.xz)  tar -xJf "$f" -C "$tmp" ;;
        *.gz)  tar -xzf "$f" -C "$tmp" ;;
        *.bz2) tar -xjf "$f" -C "$tmp" ;;
        *)     tar -xf  "$f" -C "$tmp" ;;
    esac
done

# Gather executables from usr/bin and usr/sbin
mapfile -t bins < <(find "$tmp/usr" -type f \( -path '*/bin/*' -o -path '*/sbin/*' \) -perm -u+x 2>/dev/null | sort)
if [ "${#bins[@]}" -eq 0 ]; then
    echo "ERROR: no binaries found in the package payload" >&2
    echo "       contents under $tmp/usr:" >&2
    find "$tmp/usr" -maxdepth 4 -type f >&2 || true
    exit 1
fi

SUDO=""
[ "$(id -u)" -ne 0 ] && SUDO="sudo"

echo "==> Installing to $INSTALL_DIR"
$SUDO install -d "$INSTALL_DIR"
for bin in "${bins[@]}"; do
    name=$(basename "$bin")
    $SUDO install -m755 "$bin" "$INSTALL_DIR/$name"
    echo "    + $INSTALL_DIR/$name"
done

echo "==> Done."
"$INSTALL_DIR/proxmox-backup-client" version 2>/dev/null || true
