#!/usr/bin/env bash
set -euo pipefail

FAILURES=0

REPO_ROOT="${REPO_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
BREWFILE_PATH="${BREWFILE_PATH:-$REPO_ROOT/Brewfile}"

DOTFILES_WORK_TREE="${DOTFILES_WORK_TREE:-$HOME}"
DOTFILES_DIR="${DOTFILES_DIR:-$DOTFILES_WORK_TREE/.dotfiles}"
DOTFILES_URL="git@github.com:shanedowley/dotfiles.git"

PROJECTS_ROOT="${PROJECTS_ROOT:-$HOME/Projects}"
NEOVIM_AIDE_DIR="${NEOVIM_AIDE_DIR:-$PROJECTS_ROOT/neovim-codex}"
NEOVIM_AIDE_URL="git@github.com:shanedowley/neovim-aide.git"

NVIM_CONFIG_PATH="${NVIM_CONFIG_PATH:-$HOME/.config/nvim}"

pass() {
  printf 'PASS  %s\n' "$1"
}

fail() {
  printf 'FAIL  %s\n' "$1"
  FAILURES=$((FAILURES + 1))
}

section() {
  printf '\n== %s ==\n' "$1"
}

dotgit() {
  /usr/bin/git \
    --git-dir="$DOTFILES_DIR" \
    --work-tree="$DOTFILES_WORK_TREE" \
    "$@"
}

check_system() {
  section "System"

  if [[ "$(uname -s)" == "Darwin" ]]; then
    pass "macOS detected"
  else
    fail "macOS detected"
  fi

  if [[ "$(uname -m)" == "arm64" ]]; then
    pass "Apple Silicon architecture"
  else
    fail "Apple Silicon architecture"
  fi
}

check_homebrew() {
  section "Homebrew"

  local brew_bin=""

  if command -v brew >/dev/null 2>&1; then
    brew_bin="$(command -v brew)"
  elif [[ -x /opt/homebrew/bin/brew ]]; then
    brew_bin="/opt/homebrew/bin/brew"
  elif [[ -x /usr/local/bin/brew ]]; then
    brew_bin="/usr/local/bin/brew"
  fi

  if [[ -n "$brew_bin" ]]; then
    pass "Homebrew available: $brew_bin"
  else
    fail "Homebrew available"
    return
  fi

  if "$brew_bin" --prefix >/dev/null 2>&1; then
    pass "Homebrew responds correctly"
  else
    fail "Homebrew responds correctly"
  fi
}

check_brewfile() {
  section "Brewfile"

  if [[ -f "$BREWFILE_PATH" ]]; then
    pass "Brewfile exists"
  else
    fail "Brewfile exists: $BREWFILE_PATH"
    return
  fi

  if brew bundle check \
    --no-upgrade \
    --file="$BREWFILE_PATH" \
    >/dev/null 2>&1; then
    pass "Brewfile dependencies satisfied"
  else
    fail "Brewfile dependencies satisfied"
  fi
}

check_dotfiles() {
  section "Dotfiles"

  if [[ -d "$DOTFILES_DIR" ]]; then
    pass "Dotfiles repository exists"
  else
    fail "Dotfiles repository exists: $DOTFILES_DIR"
    return
  fi

  if [[ "$(/usr/bin/git --git-dir="$DOTFILES_DIR" config --get core.bare 2>/dev/null || true)" == "true" ]]; then
    pass "Dotfiles repository is bare"
  else
    fail "Dotfiles repository is bare"
  fi

  if [[ "$(/usr/bin/git --git-dir="$DOTFILES_DIR" config --get core.fsmonitor 2>/dev/null || true)" == "false" ]]; then
    pass "Dotfiles fsmonitor disabled"
  else
    fail "Dotfiles fsmonitor disabled"
  fi

  if [[ "$(/usr/bin/git --git-dir="$DOTFILES_DIR" config --get status.showUntrackedFiles 2>/dev/null || true)" == "no" ]]; then
    pass "Dotfiles untracked files hidden"
  else
    fail "Dotfiles untracked files hidden"
  fi

  local remote
  remote="$(/usr/bin/git --git-dir="$DOTFILES_DIR" remote get-url origin 2>/dev/null || true)"

  if [[ "$remote" == "$DOTFILES_URL" ]]; then
    pass "Dotfiles origin correct"
  else
    fail "Dotfiles origin correct"
  fi

  local branch
  branch="$(dotgit branch --show-current 2>/dev/null || true)"

  if [[ "$branch" == "main" ]]; then
    pass "Dotfiles branch is main"
  else
    fail "Dotfiles branch is main"
  fi

  if [[ -z "$(dotgit status --short 2>/dev/null || true)" ]]; then
    pass "Dotfiles working tree clean"
  else
    fail "Dotfiles working tree clean"
  fi
}

check_neovim_aide() {
  section "Neovim-AIDE"

  if [[ -d "$NEOVIM_AIDE_DIR/.git" ]]; then
    pass "Neovim-AIDE repository exists"
  else
    fail "Neovim-AIDE repository exists: $NEOVIM_AIDE_DIR"
    return
  fi

  local remote
  remote="$(git -C "$NEOVIM_AIDE_DIR" remote get-url origin 2>/dev/null || true)"

  if [[ "$remote" == "$NEOVIM_AIDE_URL" ]]; then
    pass "Neovim-AIDE origin correct"
  else
    fail "Neovim-AIDE origin correct"
  fi

  local branch
  branch="$(git -C "$NEOVIM_AIDE_DIR" branch --show-current 2>/dev/null || true)"

  if [[ "$branch" == "main" ]]; then
    pass "Neovim-AIDE branch is main"
  else
    fail "Neovim-AIDE branch is main"
  fi

  if [[ -z "$(git -C "$NEOVIM_AIDE_DIR" status --short 2>/dev/null || true)" ]]; then
    pass "Neovim-AIDE working tree clean"
  else
    fail "Neovim-AIDE working tree clean"
  fi
}

check_neovim_runtime_link() {
  section "Neovim Runtime"

  if [[ -L "$NVIM_CONFIG_PATH" ]]; then
    pass "Neovim runtime path is a symlink"
  else
    fail "Neovim runtime path is a symlink"
    return
  fi

  local target
  target="$(readlink "$NVIM_CONFIG_PATH")"

  if [[ "$target" == "$NEOVIM_AIDE_DIR" ]]; then
    pass "Neovim runtime link target correct"
  else
    fail "Neovim runtime link target correct"
  fi
}

check_core_commands() {
  section "Core Commands"

  local commands=(
    git
    zsh
    brew
    nvim
    tmux
    rg
    fd
    gh
    node
    codex
    aerospace
    sketchybar
  )

  local cmd

  for cmd in "${commands[@]}"; do
    if command -v "$cmd" >/dev/null 2>&1; then
      pass "$cmd available"
    else
      fail "$cmd available"
    fi
  done
}

print_summary() {
  section "Summary"

  if [[ "$FAILURES" -eq 0 ]]; then
    printf 'System validation passed.\n'
    return 0
  fi

  printf 'System validation failed: %d check(s) failed.\n' "$FAILURES"
  return 1
}

main() {
  check_system
  check_homebrew
  check_brewfile
  check_dotfiles
  check_neovim_aide
  check_neovim_runtime_link
  check_core_commands
  print_summary
}

main "$@"
