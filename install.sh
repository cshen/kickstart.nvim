#!/usr/bin/env bash
#
# install.sh -- macOS installer for this kickstart.nvim fork.
#
# Does exactly what the Installation section of README.md describes:
#   Homebrew -> neovim + dependencies -> clone -> symlink into ~/.config/nvim -> run nvim
# macOS only; it refuses to run anywhere else.
#
#   ./install.sh [--with-extras] [--dry-run]
#
#   --with-extras  also install the optional bits: Nerd Font, node, age
#   --dry-run      print what would happen, change nothing

set -euo pipefail

REPO_URL='https://github.com/cshen/kickstart.nvim'
PROJECTS_DIR="${HOME}/Projects"
REPO_DIR="${PROJECTS_DIR}/kickstart.nvim"
NVIM_CONFIG="${HOME}/.config/nvim"

DRY_RUN=0
WITH_EXTRAS=0

say() { printf '%s\n' "$*"; }
step() { printf '\n==> %s\n' "$*"; }
die() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

# Run a command, or only print it in dry-run mode.
run() {
  if [ "$DRY_RUN" -eq 1 ]; then
    printf '    [dry-run] %s\n' "$*"
  else
    "$@"
  fi
}

die_on_other_os() {
  local os
  os="$(uname -s)"
  if [ "$os" != 'Darwin' ]; then
    say "Error: this installer is for macOS only."
    say "       Detected: ${os}. See README.md for what it needs; there is no"
    say "       install path for this system here."
    exit 1
  fi
}

refuse_existing_config() {
  # -L catches a dangling symlink too, which -e alone would miss.
  if [ -e "$NVIM_CONFIG" ] || [ -L "$NVIM_CONFIG" ]; then
    say "Found an existing ${NVIM_CONFIG}"
    say 'you need to remove that first and try again'
    exit 1
  fi
}

require_homebrew() {
  if ! command -v brew >/dev/null 2>&1; then
    say 'Homebrew is not installed. Run the following, then re-run this script:'
    say ''
    say '  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
    say ''
    exit 1
  fi
  if ! xcode-select -p >/dev/null 2>&1; then
    say 'The Xcode Command Line Tools are missing (clang and make are needed to'
    say 'compile treesitter parsers). Run this, then re-run this script:'
    say ''
    say '  xcode-select --install'
    say ''
    exit 1
  fi
}

require_arg() {
  die "unknown option: $1 (try --help)"
}

usage() {
  # Not read from $0: this script is also meant to be run as `curl ... | bash`,
  # where $0 is just "bash" and no file exists to read.
  cat <<'EOF'
install.sh -- macOS installer for this kickstart.nvim fork.

Does exactly what the Installation section of README.md describes:
  Homebrew -> neovim + dependencies -> clone -> symlink into ~/.config/nvim -> run nvim
macOS only; it refuses to run anywhere else.

  ./install.sh [--with-extras] [--dry-run]

  --with-extras  also install the optional bits: Nerd Font, node, age
  --dry-run      print what would happen, change nothing
EOF
  exit 0
}

for arg in "$@"; do
  case "$arg" in
    --with-extras) WITH_EXTRAS=1 ;;
    --dry-run) DRY_RUN=1 ;;
    -h | --help) usage ;;
    *) require_arg "$arg" ;;
  esac
done

# --- 1. macOS only, and never clobber an existing configuration -------------
die_on_other_os
refuse_existing_config

# --- 2. Homebrew, Neovim and dependencies -----------------------------------
require_homebrew

step 'Installing Neovim and dependencies with Homebrew'
run brew install neovim git ripgrep fd   tree-sitter-cli

if [ "$WITH_EXTRAS" -eq 1 ]; then
  step 'Installing optional extras'
  run brew install --cask font-jetbrains-mono-nerd-font
  run brew install node age
fi

# --- 3. Clone the configuration and link it into place ----------------------
step 'Cloning the configuration'
if [ -d "$REPO_DIR/.git" ]; then
  say "Reusing the existing checkout at ${REPO_DIR}"
else
  run mkdir -p "$PROJECTS_DIR"
  run git clone "$REPO_URL" "$REPO_DIR"
fi

step 'Linking it to the Neovim config directory'
run mkdir -p "$(dirname "$NVIM_CONFIG")"
run ln -s "$REPO_DIR" "$NVIM_CONFIG"
say "${NVIM_CONFIG} -> ${REPO_DIR}"

# --- 4. First run -----------------------------------------------------------
printf '\n==> Done\n'
say 'Start Neovim and let lazy.nvim install the plugins:'
say ''
say '  nvim'
say ''
say 'Then try :Lazy (plugin status), :checkhealth (missing dependencies) and'
say ':help kickstart. Note that lua/local/_user.vim hardcodes my age key paths'
say 'for *.age files -- change them or comment that section out.'
