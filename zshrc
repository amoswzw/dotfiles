# ------------------------------------------------------------------------------
# Locale
# ------------------------------------------------------------------------------
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export TERM=xterm-256color
typeset -U path PATH

# ------------------------------------------------------------------------------
# Aliases and functions
# ------------------------------------------------------------------------------
[ -f "$HOME/.aliases" ]   && source "$HOME/.aliases"
[ -f "$HOME/.functions" ] && source "$HOME/.functions"
[ -f "$HOME/.security_env" ] && source "$HOME/.security_env"

# ------------------------------------------------------------------------------
# Prompt and plugins
# ------------------------------------------------------------------------------

# zinit bootstrap
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d "$ZINIT_HOME" ] && mkdir -p "$(dirname "$ZINIT_HOME")"
[ ! -d "$ZINIT_HOME/.git" ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Extra completions
zi ice \
  blockf \
  atclone"zi creinstall -q ." \
  atpull"%atclone"
zi light zsh-users/zsh-completions

# Completion-related snippets
zi snippet OMZP::autojump/autojump.plugin.zsh
zi snippet OMZP::git/git.plugin.zsh

# Extra tools
zi ice from"gh-r" as"program"
zi light junegunn/fzf

# ------------------------------------------------------------------------------
# History
# ------------------------------------------------------------------------------
HISTFILE="$HOME/.zsh_history"
HISTSIZE=999999999
SAVEHIST=$HISTSIZE

# ------------------------------------------------------------------------------
# Environment and PATH
# ------------------------------------------------------------------------------

# Go
export GOPATH="$HOME/go"
export GOBIN="$HOME/go/bin"
export OS_OUTPUT_GOPATH=1
export GO111MODULE=on

# Python / pyenv
export PYENV_ROOT="$HOME/.pyenv"
export WORKON_HOME="$HOME/.envs"

# Node / NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Bun
export BUN_INSTALL="$HOME/.bun"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# General environment
export EDITOR="nvim"
export GPG_TTY="$(tty)"

# Prompt hook
autoload -Uz add-zsh-hook
codex_emit_osc7_cwd() { printf '\e]7;file://%s%s\a' "$HOST" "$PWD" }
add-zsh-hook precmd codex_emit_osc7_cwd

# Completion setup
if command -v rustc >/dev/null 2>&1; then
  local_rust_fpath="$(rustc --print sysroot 2>/dev/null)/share/zsh/site-functions"
  [ -d "$local_rust_fpath" ] && fpath=("$local_rust_fpath" $fpath)
  unset local_rust_fpath
fi

zstyle ':completion:*' menu no
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.cache/zsh"
zstyle ':completion:*' matcher-list \
  'm:{a-z}={A-Z}' \
  'r:|[._-]=* r:|=*'
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':fzf-tab:*' fzf-flags \
  --height=60% \
  --layout=reverse \
  --border \
  --color=fg:#ebdbb2,bg:#282828,hl:#fabd2f \
  --color=fg+:#ebdbb2,bg+:#3c3836,hl+:#b8bb26 \
  --color=info:#83a598,prompt:#d79921,pointer:#fb4934 \
  --color=marker:#8ec07c,spinner:#d3869b,header:#928374,border:#665c54
zstyle ':fzf-tab:*' switch-group '<' '>'

autoload -Uz compinit
compinit
zi cdreplay -q
compdef _vim nvim nvimdiff

# Fuzzy completion UI
zi light Aloxaf/fzf-tab

# Shell plugins and prompt
zi light zsh-users/zsh-autosuggestions
zi light zdharma-continuum/fast-syntax-highlighting
zi light zdharma-continuum/history-search-multi-word
export PURE_CMD_MAX_EXEC_TIME=1
zi ice pick"async.zsh" src"pure.zsh"
zi light sindresorhus/pure
typeset -g prompt_newline=''

# Let Tab accept an inline autosuggestion first; otherwise fall back to fzf-tab.
smart-tab() {
  if [[ -n "$POSTDISPLAY" ]]; then
    zle autosuggest-accept
  else
    zle fzf-tab-complete
  fi
}
zle -N smart-tab
bindkey -M emacs '^I' smart-tab
bindkey -M viins '^I' smart-tab

# PATH priority
# Homebrew itself is initialized in ~/.zprofile.
# pyenv shims stay first so pyenv-managed commands resolve predictably.
# Everything else follows a single explicit user-level order.
path=(
  "$PYENV_ROOT/shims"
  "$HOME/.local/opencode-bin/bin"
  "$BUN_INSTALL/bin"
  "$HOME/.antigravity/antigravity/bin"
  "$HOME/.local/bin"
  "$GOBIN"
  "$HOME/.cargo/bin"
  "$PYENV_ROOT/bin"
  $path
)
export PATH

# Let pyenv restore its shims after PATH assembly.
command -v pyenv >/dev/null && eval "$(pyenv init - zsh)"

# ------------------------------------------------------------------------------
# API keys
# ------------------------------------------------------------------------------
