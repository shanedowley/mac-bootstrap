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
  install-homebrew.sh [--dry-run]

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

ensure_macos() {
  [[ "$(uname -s)" == "Darwin" ]] || fail "This script supports macOS only."
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

report_existing_homebrew() {
  local brew_bin="$1"

  log "Homebrew is already installed"
  printf 'Path:    %s\n' "$brew_bin"
  printf 'Prefix:  %s\n' "$("$brew_bin" --prefix)"
  printf 'Version: %s\n' "$("$brew_bin" --version | head -n 1)"
}

install_homebrew() {
  log "Homebrew is not installed"

  if [[ "$DRY_RUN" == true ]]; then
    log "Dry run: Homebrew would be installed using the official installer"
    return
  fi

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

establish_brew_environment() {
  local candidate=""

  if [[ -x /opt/homebrew/bin/brew ]]; then
    candidate="/opt/homebrew/bin/brew"
  elif [[ -x /usr/local/bin/brew ]]; then
    candidate="/usr/local/bin/brew"
  else
    fail "Homebrew installation completed, but brew was not found in an expected location."
  fi

  eval "$("$candidate" shellenv)"
}

verify_homebrew() {
  local brew_bin

  brew_bin="$(brew_path)"

  [[ -n "$brew_bin" ]] || fail "Homebrew is not available after installation."

  log "Homebrew installation verified"
  printf 'Path:    %s\n' "$brew_bin"
  printf 'Prefix:  %s\n' "$("$brew_bin" --prefix)"
  printf 'Version: %s\n' "$("$brew_bin" --version | head -n 1)"
}

main() {
  ensure_macos

  local existing_brew
  existing_brew="$(brew_path)"

  if [[ -n "$existing_brew" ]]; then
    if ! command -v brew >/dev/null 2>&1; then
      eval "$("$existing_brew" shellenv)"
      existing_brew="$(brew_path)"
    fi

    report_existing_homebrew "$existing_brew"
    exit 0
  fi

  install_homebrew

  if [[ "$DRY_RUN" == true ]]; then
    log "Dry run complete. No changes were made."
    exit 0
  fi

  establish_brew_environment
  verify_homebrew
}

main "$@"
