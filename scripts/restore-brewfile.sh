#!/usr/bin/env bash
set -euo pipefail

DRY_RUN=false

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
  restore-brewfile.sh [--dry-run]

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

script_dir() {
  cd "$(dirname "${BASH_SOURCE[0]}")" && pwd
}

repo_root() {
  cd "$(script_dir)/.." && pwd
}

brew_path() {
  if command -v brew >/dev/null 2>&1; then
    command -v brew
  elif [[ -x /opt/homebrew/bin/brew ]]; then
    printf '%s\n' "/opt/homebrew/bin/brew"
  elif [[ -x /usr/local/bin/brew ]]; then
    printf '%s\n' "/usr/local/bin/brew"
  fi
}

ensure_homebrew() {
  local brew_bin

  brew_bin="$(brew_path)"

  [[ -n "$brew_bin" ]] || fail "Homebrew is not installed. Run scripts/install-homebrew.sh first."

  if ! command -v brew >/dev/null 2>&1; then
    eval "$("$brew_bin" shellenv)"
  fi
}

brewfile_path() {
  printf '%s\n' "$(repo_root)/Brewfile"
}

ensure_brewfile() {
  local brewfile

  brewfile="$(brewfile_path)"

  [[ -f "$brewfile" ]] || fail "Brewfile not found at: $brewfile"
}

brewfile_satisfied() {
  brew bundle check \
    --no-upgrade \
    --file="$(brewfile_path)" \
    >/dev/null 2>&1
}

restore_brewfile() {
  local brewfile

  brewfile="$(brewfile_path)"

  if brewfile_satisfied; then
    log "Brewfile dependencies are already satisfied"
    return
  fi

  log "Brewfile dependencies are not fully satisfied"

  if [[ "$DRY_RUN" == true ]]; then
    log "Dry run: missing Brewfile dependencies would be installed"
    return
  fi

  log "Restoring Brewfile dependencies"

  brew bundle install \
    --no-upgrade \
    --file="$brewfile"
}

verify_brewfile() {
  if ! brew bundle check \
    --no-upgrade \
    --verbose \
    --file="$(brewfile_path)"; then
    fail "Brewfile dependencies are not satisfied after restoration."
  fi

  log "Brewfile dependencies verified"
}

main() {
  ensure_homebrew
  ensure_brewfile

  restore_brewfile

  if [[ "$DRY_RUN" == true ]]; then
    log "Dry run complete. No changes were made."
    exit 0
  fi

  verify_brewfile
}

main "$@"
