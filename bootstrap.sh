#!/usr/bin/env bash
set -euo pipefail

DRY_RUN=false

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$SCRIPT_DIR/scripts"

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
  bootstrap.sh [--dry-run]

Options:
  --dry-run   Show what mutating stages would do without making changes.
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
  [[ "$(uname -s)" == "Darwin" ]] || fail "This bootstrap supports macOS only."
}

ensure_script() {
  local script="$1"

  [[ -f "$script" ]] || fail "Required script not found: $script"
  [[ -x "$script" ]] || fail "Required script is not executable: $script"
}

ensure_scripts() {
  ensure_script "$SCRIPTS_DIR/install-homebrew.sh"
  ensure_script "$SCRIPTS_DIR/restore-brewfile.sh"
  ensure_script "$SCRIPTS_DIR/restore-dotfiles.sh"
  ensure_script "$SCRIPTS_DIR/clone-projects.sh"
  ensure_script "$SCRIPTS_DIR/validate-system.sh"
}

print_header() {
  printf '%s\n' \
    "========================================" \
    "mac-bootstrap" \
    "========================================"
}

run_stage() {
  local number="$1"
  local total="$2"
  local name="$3"
  local script="$4"
  shift 4

  printf '\nStage %s/%s — %s\n' "$number" "$total" "$name"
  printf '%s\n' "----------------------------------------"

  "$script" "$@"
}

run_mutating_stage() {
  local number="$1"
  local total="$2"
  local name="$3"
  local script="$4"

  if [[ "$DRY_RUN" == true ]]; then
    run_stage "$number" "$total" "$name" "$script" --dry-run
  else
    run_stage "$number" "$total" "$name" "$script"
  fi
}

main() {
  ensure_macos
  ensure_scripts

  print_header

  if [[ "$DRY_RUN" == true ]]; then
    log "Dry-run mode enabled"
  fi

  run_mutating_stage \
    1 5 \
    "Homebrew" \
    "$SCRIPTS_DIR/install-homebrew.sh"

  run_mutating_stage \
    2 5 \
    "Brewfile" \
    "$SCRIPTS_DIR/restore-brewfile.sh"

  run_mutating_stage \
    3 5 \
    "Dotfiles" \
    "$SCRIPTS_DIR/restore-dotfiles.sh"

  run_mutating_stage \
    4 5 \
    "Projects" \
    "$SCRIPTS_DIR/clone-projects.sh"

  run_stage \
    5 5 \
    "Validation" \
    "$SCRIPTS_DIR/validate-system.sh"

  printf '\n'
  printf '%s\n' \
    "========================================" \
    "Bootstrap complete" \
    "========================================"
}

main "$@"