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

install_dotfiles () {
  info "Installing dotfiles from $DOTFILES_ROOT"
  for entry in "${mapping[@]}"; do
    key="${entry%%|*}"
    dst="${entry#*|}"
    info "Apply $key -> $dst"
    sync_path "$DOTFILES_ROOT/$key" "$dst"
  done
  success "Dotfiles installed."
}

install_dotfiles
