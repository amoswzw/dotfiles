##############################################################################
################################# Amos Zsh Config ############################
##############################################################################
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export TERM=xterm-256color
eval "$(/opt/homebrew/bin/brew shellenv)"

#################################
####### Aliases Config ##########
#################################
source /Users/amos/.aliases
source /users/amos/.functions
#################################


#################################
####### Zinit Config ############
#################################
### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load the pure theme, with zsh-async library that's bundled with it.
zi ice pick"async.zsh" src"pure.zsh"
zi light sindresorhus/pure

# A glance at the new for-syntax – load all of the above
# plugins with a single command. For more information see:
# https://zdharma-continuum.github.io/zinit/wiki/For-Syntax/
zinit for \
    light-mode \
  zsh-users/zsh-autosuggestions \
    light-mode \
  zdharma-continuum/fast-syntax-highlighting

# Binary release in archive, from GitHub-releases page.
# After automatic unpacking it provides program "fzf".
zi ice from"gh-r" as"program"
zi light junegunn/fzf
zi for \
    https://github.com/junegunn/fzf/raw/master/shell/{'completion','key-bindings'}.zsh

zi for \
  Fakerr/git-recall \
  davidosomething/git-my \
  iwata/git-now \
  paulirish/git-open \
  paulirish/git-recent \
    atload'export _MENU_THEME=legacy' \
  arzzen/git-quick-stats \
    make'install' \
  tj/git-extras \
  zdharma-continuum/git-url

zi light-mode wait lucid for \
OMZ::plugins/autojump/autojump.plugin.zsh \
OMZ::plugins/git/git.plugin.zsh

# One other binary release, it needs renaming from `docker-compose-Linux-x86_64`.
# This is done by ice-mod `mv'{from} -> {to}'. There are multiple packages per
# single version, for OS X, Linux and Windows – so ice-mod `bpick' is used to
# select Linux package – in this case this is actually not needed, Zinit will
# grep operating system name and architecture automatically when there's no `bpick'.
zi ice from"gh-r" as"program" mv"docker* -> docker-compose" bpick"*linux*"
zi load docker/compose

# Scripts built at install (there's single default make target, "install",
# and it constructs scripts by `cat'ing a few files). The make'' ice could also be:
# `make"install PREFIX=$ZPFX"`, if "install" wouldn't be the only default target.
zi ice as"program" pick"$ZPFX/bin/git-*" make"PREFIX=$ZPFX"
zi light tj/git-extras

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

# Rust conf
export PATH="/Users/amos/.cargo/bin:$PATH"
export EDITOR='nvim'

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/amos/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

# export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"
export PATH="/opt/homebrew/opt/postgresql@14/bin:$PATH"

# pyenv config
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init - bash)"
# eval "$(pyenv virtualenv-init -)"
export WORKON_HOME=~/.envs
# Python path
export PATH="/Library/Frameworks/Python.framework/Versions/3.12/bin:$PATH"
source "/Library/Frameworks/Python.framework/Versions/3.12/bin/virtualenvwrapper_lazy.sh"
export VIRTUALENVWRAPPER_PYTHON="/usr/local/bin/python3"
export XDG_RUNTIME_DIR="/Users/amos/.tmp"
export GPG_TTY=$(tty)
export SCRIPTS_ROOT="/Users/amos/workspace/hwy/netbox-source/netbox/scripts"
# NVM Config
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#################################


##############################################################################

