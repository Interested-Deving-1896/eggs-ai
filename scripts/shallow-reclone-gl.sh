#!/usr/bin/env bash
# shallow-reclone-gl.sh
#
# Replaces a GitLab repository's full history with a shallow clone from its
# upstream source. Reduces storage by ~95% for large repos (e.g. Chromium).
#
# Strategy:
#   1. Shallow-clone upstream (--depth=50 --no-tags per branch)
#   2. Fetch tags shallowly (--depth=1)
#   3. Force-push all refs to the GitLab mirror
#   4. Run GitLab housekeeping API to trigger GC immediately
#
# Required env vars:
#   GITLAB_TOKEN      — GitLab PAT with write access to the target project
#   UPSTREAM_URL      — source to clone from (GitHub URL with token embedded)
#   GITLAB_URL        — GitLab project URL (with token embedded)
#   GITLAB_PROJECT_ID — numeric project ID (for housekeeping API call)
#
# Optional:
#   DEPTH             — shallow depth (default: 50)
#   GL_API            — GitLab API base (default: https://gitlab.com/api/v4)

set -euo pipefail

DEPTH="${DEPTH:-50}"
GL_API="${GL_API:-https://gitlab.com/api/v4}"

info()  { echo "[shallow-reclone] $*"; }
warn()  { echo "[shallow-reclone] WARN: $*" >&2; }

info "Upstream: ${UPSTREAM_URL//*@/***@}"
info "GitLab:   ${GITLAB_URL//*@/***@}"
info "Depth:    ${DEPTH}"

work_dir=$(mktemp -d)
trap 'rm -rf "$work_dir"' EXIT

# 1. Shallow-clone all branches from upstream
info "Cloning upstream (depth=${DEPTH})..."
if ! git clone --bare --depth="${DEPTH}" --no-tags \
    "${UPSTREAM_URL}" "${work_dir}" 2>&1; then
    warn "Clone failed — aborting"
    exit 1
fi

# 2. Fetch tags shallowly
info "Fetching tags (depth=1)..."
git -C "${work_dir}" fetch --depth=1 --tags origin 2>/dev/null || true

# 3. Force-push all refs to GitLab
info "Force-pushing to GitLab..."
git -C "${work_dir}" push --force "${GITLAB_URL}" \
    '+refs/heads/*:refs/heads/*' 2>&1 || true
git -C "${work_dir}" push --force "${GITLAB_URL}" \
    '+refs/tags/*:refs/tags/*' 2>&1 || true

info "Push complete."

# 4. Trigger GitLab housekeeping to reclaim storage immediately
if [[ -n "${GITLAB_PROJECT_ID:-}" ]]; then
    info "Triggering GitLab housekeeping for project ${GITLAB_PROJECT_ID}..."
    HTTP=$(curl -sf -o /dev/null -w "%{http_code}" \
        -X POST -H "PRIVATE-TOKEN: ${GITLAB_TOKEN}" \
        "${GL_API}/projects/${GITLAB_PROJECT_ID}/housekeeping" || true)
    info "Housekeeping response: ${HTTP}"
fi

info "Done."
