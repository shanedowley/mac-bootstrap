#!/usr/bin/env bash
set -euo pipefail

DRY_RUN=false

PROJECTS_ROOT="${PROJECTS_ROOT:-$HOME/Projects}"
NVIM_CONFIG_PATH="${NVIM_CONFIG_PATH:-$HOME/.config/nvim}"

NEOVIM_AIDE_DIR="$PROJECTS_ROOT/neovim-codex"
NEOVIM_AIDE_URL="git@github.com:shanedowley/neovim-aide.git"

log() {
  printf '\n==> %s\n' "$1"
}

fail() {
  printf '\n[error] %s\n' "$1" >&2
  exit 1
}

usage() {
  cat <<'EOF'
Usage:
  clone-projects.sh [--dry-run]

Options:
  --dry-run   Show what would happen without making changes.
  -h, --help  Show this help.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      fail "Unknown argument: $1"
      ;;
  esac
done

ensure_git() {
  command -v git >/dev/null 2>&1 || fail "Git is not available."
}

ensure_github_access() {
  local output

  output="$(ssh -T git@github.com 2>&1 || true)"

  if grep -q "successfully authenticated" <<<"$output"; then
    log "GitHub SSH authentication is working"
    return
  fi

  fail "GitHub SSH authentication is not working. Complete SSH and GitHub setup first."
}

ensure_projects_root() {
  if [[ -d "$PROJECTS_ROOT" ]]; then
    return
  fi

  if [[ "$DRY_RUN" == true ]]; then
    log "Dry run: projects directory would be created at $PROJECTS_ROOT"
    return
  fi

  mkdir -p "$PROJECTS_ROOT"
}

existing_repo_valid() {
  local path="$1"
  local expected_remote="$2"

  [[ -e "$path" ]] || return 1

  [[ -d "$path/.git" ]] \
    || fail "$path exists but is not a Git repository."

  local remote
  remote="$(git -C "$path" remote get-url origin 2>/dev/null || true)"

  [[ "$remote" == "$expected_remote" ]] \
    || fail "Existing repository at $path has unexpected origin: ${remote:-<none>}"

  return 0
}

ensure_project() {
  local path="$1"
  local remote="$2"
  local name="$3"

  if existing_repo_valid "$path" "$remote"; then
    log "$name repository already exists"
    return
  fi

  log "$name repository not found"

  if [[ "$DRY_RUN" == true ]]; then
    log "Dry run: $remote would be cloned to $path"
    return
  fi

  git clone "$remote" "$path"
}

ensure_config_parent() {
  local parent
  parent="$(dirname "$NVIM_CONFIG_PATH")"

  if [[ -d "$parent" ]]; then
    return
  fi

  if [[ "$DRY_RUN" == true ]]; then
    log "Dry run: configuration directory would be created at $parent"
    return
  fi

  mkdir -p "$parent"
}

ensure_neovim_runtime_link() {
  if [[ -L "$NVIM_CONFIG_PATH" ]]; then
    local target
    target="$(readlink "$NVIM_CONFIG_PATH")"

    if [[ "$target" == "$NEOVIM_AIDE_DIR" ]]; then
      log "Neovim runtime link already exists"
      return
    fi

    fail "Neovim runtime link points somewhere unexpected: $target"
  fi

  if [[ -e "$NVIM_CONFIG_PATH" ]]; then
    fail "$NVIM_CONFIG_PATH exists and is not the expected symlink."
  fi

  if [[ "$DRY_RUN" == true ]]; then
    log "Dry run: $NVIM_CONFIG_PATH would link to $NEOVIM_AIDE_DIR"
    return
  fi

  ln -s "$NEOVIM_AIDE_DIR" "$NVIM_CONFIG_PATH"
  log "Created Neovim runtime link"
}

verify_neovim_aide() {
  local remote branch target

  [[ -d "$NEOVIM_AIDE_DIR/.git" ]] \
    || fail "Neovim-AIDE repository is missing after restoration."

  remote="$(git -C "$NEOVIM_AIDE_DIR" remote get-url origin 2>/dev/null || true)"
  branch="$(git -C "$NEOVIM_AIDE_DIR" branch --show-current)"

  [[ "$remote" == "$NEOVIM_AIDE_URL" ]] \
    || fail "Neovim-AIDE repository origin does not match expected remote."

  [[ "$branch" == "main" ]] \
    || fail "Neovim-AIDE repository is not on branch main."

  [[ -L "$NVIM_CONFIG_PATH" ]] \
    || fail "Neovim runtime path is not a symlink."

  target="$(readlink "$NVIM_CONFIG_PATH")"

  [[ "$target" == "$NEOVIM_AIDE_DIR" ]] \
    || fail "Neovim runtime symlink does not point to the expected repository."

  log "Project restoration verified"
  printf 'Repository:   %s\n' "$NEOVIM_AIDE_DIR"
  printf 'Remote:       %s\n' "$remote"
  printf 'Branch:       %s\n' "$branch"
  printf 'Runtime link: %s -> %s\n' "$NVIM_CONFIG_PATH" "$target"
}

main() {
  ensure_git
  ensure_github_access
  ensure_projects_root

  ensure_project \
    "$NEOVIM_AIDE_DIR" \
    "$NEOVIM_AIDE_URL" \
    "Neovim-AIDE"

  ensure_config_parent
  ensure_neovim_runtime_link

  if [[ "$DRY_RUN" == true ]]; then
    log "Dry run complete. No changes were made."
    exit 0
  fi

  verify_neovim_aide
}

main "$@"
