##############################################################################
################################# Zsh Config #################################
##############################################################################
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export TERM=xterm-256color
eval "$(/opt/homebrew/bin/brew shellenv)"


#################################
####### Aliases Config ##########
#################################
[ -f "$HOME/.aliases" ]   && source "$HOME/.aliases"
[ -f "$HOME/.functions" ] && source "$HOME/.functions"
#################################


###################################
####### Theme Config ##############
###################################
#zinit install
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Load pure theme
zinit ice pick"async.zsh" src"pure.zsh" # with zsh-async library that's bundled with it.
zinit light sindresorhus/pure

zinit for \
    light-mode \
  zsh-users/zsh-autosuggestions \
    light-mode \
  zdharma-continuum/fast-syntax-highlighting \
  zdharma-continuum/history-search-multi-word \
    light-mode \
    pick"async.zsh" \
    src"pure.zsh" \
  sindresorhus/pure

zi ice from"gh-r" as"program"
zi light junegunn/fzf
zi snippet OMZP::autojump/autojump.plugin.zsh
zi snippet OMZP::git/git.plugin.zsh

# unlimiate zsh history size
HISTFILE=~/.zsh_history
HISTSIZE=999999999
SAVEHIST=$HISTSIZE
#################################


#################################
####### PATH & ENV Config #######
#################################
# Go conf
export GOPATH=$HOME/go
export GOBIN=$HOME/go/bin
export OS_OUTPUT_GOPATH=1
export GO111MODULE=on
export PATH="$GOBIN:$PATH"

# Rust conf
export PATH="$HOME/.cargo/bin:$PATH"

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
# export PATH="$HOME/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

# export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"
# export PATH="/opt/homebrew/opt/postgresql@14/bin:$PATH"

# pyenv config
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
command -v pyenv >/dev/null && eval "$(pyenv init - zsh)"

export WORKON_HOME=~/.envs
## Python path
#export XDG_RUNTIME_DIR="$HOME/.tmp"
#export GPG_TTY=$(tty)
#
## NVM Config
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#################################

export EDITOR='nvim'

# claude code PATH
export PATH="$HOME/.local/bin:$PATH"
##############################################################################

# Added by Antigravity
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

precmd() { printf '\e]7;file://%s%s\a' "$HOST" "$PWD" }

# OpenClaw Completion
# [ -f "$HOME/.openclaw/completions/openclaw.zsh" ] && source "$HOME/.openclaw/completions/openclaw.zsh"
export GPG_TTY=$(tty)

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
# opencode
export PATH="$HOME/.local/opencode-bin/bin:$PATH"
