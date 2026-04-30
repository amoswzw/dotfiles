#!/usr/bin/env bash

cd "$(dirname "$0")/.."
DOTFILES_ROOT=$(pwd -P)

source "$DOTFILES_ROOT/tools/dot_configs.sh"

set -e

info ()    { printf "\r  [ \033[00;34minfo\033[0m ] %s\n" "$1"; }
success () { printf "\r\033[2K  [ \033[00;32m OK \033[0m ] %s\n" "$1"; }
fail ()    { printf "\r\033[2K  [\033[0;31mFAIL\033[0m] %s\n" "$1"; exit 1; }

RSYNC_EXCLUDES=(
  --exclude='.DS_Store'
  --exclude='*.swp'
  --exclude='*.bak'
  --exclude='*.tmp'
  --exclude='.claude/'
)

sync_path () {
  local src=$1 dst=$2
  if [[ "$src" == */ ]]; then
    mkdir -p "$dst"
    rsync -a --delete "${RSYNC_EXCLUDES[@]}" "$src" "$dst"
  else
    mkdir -p "$(dirname "$dst")"
    cp -f "$src" "$dst"
  fi
}

backup_brewfile () {
  if command -v brew >/dev/null 2>&1; then
    info "Dumping Brewfile via brew bundle dump"
    rm -f "$DOTFILES_ROOT/Brewfile"
    (cd "$DOTFILES_ROOT" && brew bundle dump --file=Brewfile)
  else
    info "brew not found, skipping Brewfile dump"
  fi
}

backup_dotfiles () {
  info "Backing up dotfiles to $DOTFILES_ROOT"
  for entry in "${mapping[@]}"; do
    key="${entry%%|*}"
    src="${entry#*|}"
    if [[ ! -e "$src" ]]; then
      info "Skip missing source $src"
      continue
    fi
    info "Capture $src -> $key"
    sync_path "$src" "$DOTFILES_ROOT/$key"
  done
  success "Dotfiles backed up."
}

backup_brewfile
backup_dotfiles
