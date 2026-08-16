#!/usr/bin/env bash
set -euo pipefail

DRY_RUN=false

REPO_URL="git@github.com:shanedowley/dotfiles.git"
WORK_TREE="${DOTFILES_WORK_TREE:-$HOME}"
DOTFILES_DIR="${DOTFILES_DIR:-$WORK_TREE/.dotfiles}"

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
  restore-dotfiles.sh [--dry-run]

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

dotgit() {
  /usr/bin/git \
    --git-dir="$DOTFILES_DIR" \
    --work-tree="$WORK_TREE" \
    "$@"
}

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

existing_repo_valid() {
  [[ -d "$DOTFILES_DIR" ]] || return 1

  [[ "$(/usr/bin/git --git-dir="$DOTFILES_DIR" config --get core.bare 2>/dev/null || true)" == "true" ]] \
    || fail "$DOTFILES_DIR exists but is not a valid bare Git repository."

  local remote
  remote="$(/usr/bin/git --git-dir="$DOTFILES_DIR" remote get-url origin 2>/dev/null || true)"

  [[ "$remote" == "$REPO_URL" ]] \
    || fail "Existing dotfiles repository has unexpected origin: ${remote:-<none>}"

  return 0
}

clone_repo() {
  if existing_repo_valid; then
    log "Bare dotfiles repository already exists"
    return
  fi

  log "Bare dotfiles repository not found"

  if [[ "$DRY_RUN" == true ]]; then
    log "Dry run: repository would be cloned to $DOTFILES_DIR"
    return
  fi

  /usr/bin/git clone --bare "$REPO_URL" "$DOTFILES_DIR"
}

configure_repo() {
  if [[ "$DRY_RUN" == true ]]; then
    log "Dry run: repository-local Git settings would be configured"
    return
  fi

  /usr/bin/git --git-dir="$DOTFILES_DIR" config core.fsmonitor false
  /usr/bin/git --git-dir="$DOTFILES_DIR" config status.showUntrackedFiles no
}

checkout_dotfiles() {
  if [[ "$DRY_RUN" == true ]]; then
    log "Dry run: dotfiles would be checked out into $WORK_TREE"
    return
  fi

  log "Checking out dotfiles into $WORK_TREE"

  if ! dotgit checkout; then
    fail "Dotfiles checkout failed. Existing files may conflict. No files were moved or deleted automatically."
  fi
}

verify_repo() {
  local remote branch bare

  bare="$(/usr/bin/git --git-dir="$DOTFILES_DIR" config --get core.bare 2>/dev/null || true)"
  remote="$(/usr/bin/git --git-dir="$DOTFILES_DIR" remote get-url origin 2>/dev/null || true)"
  branch="$(dotgit branch --show-current)"

  [[ "$bare" == "true" ]] || fail "Dotfiles repository is not bare."
  [[ "$remote" == "$REPO_URL" ]] || fail "Dotfiles origin does not match expected repository."
  [[ "$branch" == "main" ]] || fail "Dotfiles repository is not on branch main."

  if [[ -n "$(dotgit status --short)" ]]; then
    fail "Dotfiles working tree is not clean after restoration."
  fi

  log "Dotfiles restoration verified"
  printf 'Repository:   %s\n' "$DOTFILES_DIR"
  printf 'Working tree: %s\n' "$WORK_TREE"
  printf 'Branch:       %s\n' "$branch"
}

main() {
  ensure_git
  ensure_github_access

  clone_repo
  configure_repo
  checkout_dotfiles

  if [[ "$DRY_RUN" == true ]]; then
    log "Dry run complete. No changes were made."
    exit 0
  fi

  verify_repo
}

main "$@"
