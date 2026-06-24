#!/usr/bin/env bash
#
# services/sync-in/start.sh — start a Sync-in server inside the devcontainer
#
# Binary resolution order (hybrid A+B+C+D):
#   1. Feature install (A) — /usr/local/bin/sync-in-server if the
#      .devcontainer/features/sync-in-server feature ran at build time.
#   2. postCreateCommand install (B) — ~/.local/bin/sync-in-server if the
#      devcontainer.json postCreateCommand ran the install helper.
#   3. PATH search — any sync-in-server or sync-in binary already on PATH.
#   4. Self-install (D) — downloads the latest release from
#      github.com/Sync-in/server. Used in bare VMs, CI runners, or containers
#      where A/B didn't run.
#
# Environment variables (all optional):
#   SYNC_IN_PORT         — port to listen on (default: 3284)
#   SYNC_IN_DATA_DIR     — data directory (default: ~/.local/share/sync-in)
#   SYNC_IN_ADMIN_TOKEN  — admin API token; generated and persisted if absent
#   SYNC_IN_LOG_LEVEL    — debug|info|warn|error (default: info)
#   SYNC_IN_VERSION      — version to self-install if binary absent (default: latest)

set -uo pipefail

PORT="${SYNC_IN_PORT:-3284}"
DATA_DIR="${SYNC_IN_DATA_DIR:-${HOME}/.local/share/sync-in}"
LOG_LEVEL="${SYNC_IN_LOG_LEVEL:-info}"
INSTALL_VERSION="${SYNC_IN_VERSION:-latest}"
SELF_INSTALL_DIR="${HOME}/.local/bin"

log()  { echo "[sync-in] $*" >&2; }
warn() { echo "[sync-in][warn] $*" >&2; }

# ── Binary resolution ─────────────────────────────────────────────────────────
_find_binary() {
  for candidate in \
      "/usr/local/bin/sync-in-server" \
      "${SELF_INSTALL_DIR}/sync-in-server" \
      "$(command -v sync-in-server 2>/dev/null || true)" \
      "$(command -v sync-in 2>/dev/null || true)"; do
    [[ -x "$candidate" ]] && { echo "$candidate"; return 0; }
  done
  return 1
}

_self_install() {
  log "Binary not found — attempting self-install (version: ${INSTALL_VERSION})..."

  local arch arch_label
  arch=$(uname -m)
  case "$arch" in
    x86_64)  arch_label="amd64" ;;
    aarch64) arch_label="arm64" ;;
    armv7l)  arch_label="armv7" ;;
    *)       arch_label="amd64" ;;
  esac

  local tag="$INSTALL_VERSION"
  if [[ "$tag" == "latest" ]]; then
    tag=$(curl -sf "https://api.github.com/repos/Sync-in/server/releases/latest" \
      | python3 -c "import json,sys; print(json.load(sys.stdin).get('tag_name',''))" 2>/dev/null || echo "")
    if [[ -z "$tag" ]]; then
      warn "Could not resolve latest release tag from GitHub API."
      return 1
    fi
  fi

  local ver="${tag#v}"
  mkdir -p "$SELF_INSTALL_DIR"
  local tmp installed=false
  tmp=$(mktemp /tmp/sync-in.XXXXXX)

  for asset_name in \
      "sync-in-server_${ver}_linux_${arch_label}.tar.gz" \
      "sync-in-server-linux-${arch_label}.tar.gz" \
      "sync-in_${ver}_linux_${arch_label}.tar.gz" \
      "server-linux-${arch_label}" \
      "sync-in-server-linux-${arch_label}"; do

    local url="https://github.com/Sync-in/server/releases/download/${tag}/${asset_name}"
    if curl -fsSL "$url" -o "$tmp" 2>/dev/null; then
      if file "$tmp" 2>/dev/null | grep -q "gzip\|tar"; then
        local extract_dir bin
        extract_dir=$(mktemp -d /tmp/sync-in-extract.XXXXXX)
        tar -xzf "$tmp" -C "$extract_dir" 2>/dev/null || true
        bin=$(find "$extract_dir" -type f \( -name "sync-in-server" -o -name "sync-in" \) 2>/dev/null | head -1)
        if [[ -n "$bin" ]]; then
          install -m 0755 "$bin" "${SELF_INSTALL_DIR}/sync-in-server"
          rm -rf "$extract_dir"
          installed=true
          break
        fi
        rm -rf "$extract_dir"
      else
        install -m 0755 "$tmp" "${SELF_INSTALL_DIR}/sync-in-server"
        installed=true
        break
      fi
    fi
  done

  rm -f "$tmp"

  if [[ "$installed" == "true" ]]; then
    log "Self-installed sync-in-server ${tag} → ${SELF_INSTALL_DIR}/sync-in-server"
    return 0
  else
    warn "Self-install failed: no matching release asset for ${tag}/${arch_label}."
    warn "Install manually from https://github.com/Sync-in/server/releases"
    return 1
  fi
}

# ── Locate or install binary ──────────────────────────────────────────────────
SYNC_IN_BIN=""
if SYNC_IN_BIN=$(_find_binary); then
  log "Found binary: ${SYNC_IN_BIN}"
else
  if _self_install; then
    SYNC_IN_BIN="${SELF_INSTALL_DIR}/sync-in-server"
  else
    log "sync-in-server unavailable — service will not start."
    log "Run the 'Install Sync-in Server' automation task to install it manually."
    exit 1
  fi
fi

# ── Ensure data directory ─────────────────────────────────────────────────────
mkdir -p "${DATA_DIR}"

# ── Admin token ───────────────────────────────────────────────────────────────
TOKEN_FILE="${DATA_DIR}/.admin_token"
if [[ -n "${SYNC_IN_ADMIN_TOKEN:-}" ]]; then
  echo "$SYNC_IN_ADMIN_TOKEN" > "$TOKEN_FILE"
  chmod 600 "$TOKEN_FILE"
elif [[ -f "$TOKEN_FILE" ]]; then
  SYNC_IN_ADMIN_TOKEN=$(cat "$TOKEN_FILE")
else
  SYNC_IN_ADMIN_TOKEN=$(python3 -c "import secrets; print(secrets.token_hex(32))" 2>/dev/null \
    || openssl rand -hex 32 2>/dev/null \
    || head -c 32 /dev/urandom | base64 | tr -dc 'a-zA-Z0-9' | head -c 32)
  echo "$SYNC_IN_ADMIN_TOKEN" > "$TOKEN_FILE"
  chmod 600 "$TOKEN_FILE"
  log "Generated admin token → ${TOKEN_FILE}"
fi

log "Starting on port ${PORT} (data: ${DATA_DIR})"
log "Admin token: ${SYNC_IN_ADMIN_TOKEN}"
log "Server URL:  http://localhost:${PORT}"

# ── Start server ──────────────────────────────────────────────────────────────
exec "$SYNC_IN_BIN" \
  --port "${PORT}" \
  --data-dir "${DATA_DIR}" \
  --admin-token "${SYNC_IN_ADMIN_TOKEN}" \
  --log-level "${LOG_LEVEL}"
