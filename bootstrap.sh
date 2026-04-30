#!/usr/bin/env bash
# One-shot bootstrap for a fresh macOS machine.
# Run from the repo root: `bash bootstrap.sh` or `make bootstrap`.

set -e

cd "$(dirname "$0")"
DOTFILES_ROOT=$(pwd -P)

info ()    { printf "\r  [ \033[00;34minfo\033[0m ] %s\n" "$1"; }
success () { printf "\r\033[2K  [ \033[00;32m OK \033[0m ] %s\n" "$1"; }
warn ()    { printf "\r\033[2K  [\033[00;33mWARN\033[0m] %s\n" "$1"; }
fail ()    { printf "\r\033[2K  [\033[0;31mFAIL\033[0m] %s\n" "$1"; exit 1; }

# --- 1. Xcode Command Line Tools -----------------------------------------------
ensure_xcode_clt () {
  if xcode-select -p >/dev/null 2>&1; then
    success "Xcode Command Line Tools already installed"
    return
  fi
  info "Installing Xcode Command Line Tools (a GUI prompt may appear)"
  xcode-select --install || true
  until xcode-select -p >/dev/null 2>&1; do
    sleep 5
  done
  success "Xcode Command Line Tools installed"
}

# --- 2. Homebrew --------------------------------------------------------------
ensure_homebrew () {
  if command -v brew >/dev/null 2>&1; then
    success "Homebrew already installed"
  else
    info "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  # Make brew available in this shell on Apple Silicon and Intel.
  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
}

# --- 3. brew bundle ------------------------------------------------------------
brew_bundle () {
  info "Running brew bundle (this can take a while on first run)"
  brew bundle --file="$DOTFILES_ROOT/Brewfile"
  success "brew bundle finished"
}

# --- 4. fzf shell integration --------------------------------------------------
install_fzf () {
  local fzf_prefix
  fzf_prefix="$(brew --prefix)/opt/fzf"
  if [ -x "$fzf_prefix/install" ]; then
    info "Installing fzf shell integration"
    "$fzf_prefix/install" --all --no-update-rc >/dev/null
    success "fzf shell integration installed"
  else
    warn "fzf installer not found at $fzf_prefix/install — skipping"
  fi
}

# --- 5. tmux plugin manager ----------------------------------------------------
install_tpm () {
  local tpm_dir="$HOME/.tmux/plugins/tpm"
  if [ -d "$tpm_dir/.git" ]; then
    success "tpm already cloned at $tpm_dir"
  else
    info "Cloning tpm to $tpm_dir"
    git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
    success "tpm cloned"
  fi
}

# --- 6. zinit ------------------------------------------------------------------
# zshrc auto-installs zinit on first shell start, so nothing to do here.

# --- 7. Dotfiles --------------------------------------------------------------
apply_dotfiles () {
  info "Applying dotfiles via tools/install.sh"
  bash "$DOTFILES_ROOT/tools/install.sh"
}

seed_gitconfig () {
  if [ -e "$HOME/.gitconfig" ]; then
    success "~/.gitconfig already exists; leaving it alone"
    return
  fi
  info "Seeding ~/.gitconfig from template"
  cp "$DOTFILES_ROOT/gitconfig" "$HOME/.gitconfig"
  warn "Set your git identity:  git config --global user.name 'Your Name'"
  warn "                        git config --global user.email 'you@example.com'"
  warn "                        git config --global user.signingkey <GPG_KEY_ID>"
}

# --- 8. Default shell ---------------------------------------------------------
ensure_zsh_default () {
  local target_shell
  target_shell="$(brew --prefix)/bin/zsh"
  [ -x "$target_shell" ] || target_shell="$(command -v zsh)"
  if [ -z "$target_shell" ]; then
    warn "zsh not found; skipping chsh"
    return
  fi
  if [ "$SHELL" = "$target_shell" ]; then
    success "Default shell is already $target_shell"
    return
  fi
  if ! grep -qx "$target_shell" /etc/shells 2>/dev/null; then
    info "Adding $target_shell to /etc/shells (requires sudo)"
    echo "$target_shell" | sudo tee -a /etc/shells >/dev/null
  fi
  info "Setting default shell to $target_shell (you may be prompted for your password)"
  chsh -s "$target_shell" || warn "chsh failed; run it manually later"
}

# --- 9. Neovim plugins ---------------------------------------------------------
install_nvim_plugins () {
  if ! command -v nvim >/dev/null 2>&1; then
    warn "nvim not installed; skipping plugin sync"
    return
  fi
  info "Syncing Neovim plugins (lazy.nvim) headlessly"
  nvim --headless "+Lazy! sync" +qa 2>/dev/null || \
    warn "Neovim plugin sync failed; open nvim manually to retry"
}

main () {
  info "Bootstrapping dotfiles from $DOTFILES_ROOT"
  ensure_xcode_clt
  ensure_homebrew
  brew_bundle
  install_fzf
  install_tpm
  apply_dotfiles
  seed_gitconfig
  ensure_zsh_default
  install_nvim_plugins
  echo
  success "Bootstrap complete."
  info "Open a new shell, then in tmux press prefix + I to install tmux plugins."
}

main "$@"
