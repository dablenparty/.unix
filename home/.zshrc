#!/bin/zsh
# Check if homebrew is installed
if [[ -f "/usr/local/bin/brew" ]]; then
  BREW_HOME="/usr/local/bin/brew"
elif [[ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
  BREW_HOME="/home/linuxbrew/.linuxbrew/bin/brew"
# Apple Silicon
elif [[ -f "/opt/homebrew/bin/brew" ]]; then
  BREW_HOME="/opt/homebrew/bin/brew"
fi

if [[ -n "$BREW_HOME" ]]; then
  eval "$($BREW_HOME shellenv)"
fi

# fzf fuzzy finder
export FZF_DEFAULT_COMMAND="fd --type file --hidden --no-ignore-vcs --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
eval "$(fzf --zsh)"

# Initialize oh-my-posh, but not on Apple Terminal
if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  eval "$(oh-my-posh init zsh --config "$HOME"/zen.omp.toml)"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

## Source/Load zinit
source "$ZINIT_HOME/zinit.zsh"

## Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

## Add in snippets
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found

## Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

## Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region
# Some terminal emulators already do this; some don't
bindkey '^[[3~' delete-char

## History
HISTSIZE=5000
HISTFILE=$HOME/.zsh_history
export SAVEHIST=$HISTSIZE
export HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

## Completion styling

# case insensitive match
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# shows ls colors in completions
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# disable default zsh completion menu
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza $realpath'

# Aliases
alias zshconfig="nvim \$HOME/.zshrc"
alias l='eza'
alias ll='eza -hal --git --smart-group'
alias la='eza -a'
alias lg='lazygit'
# wrap cat with bat for colors and paging
alias cat='bat -p'
# wrap neovim with zoxide for easier directory cd'ing
nvz() { if [[ $# -eq 1 && -e $1 ]]; then nvim "$1"; else
  cd "$(zoxide query "$@")" || exit 1
  nvim .
fi; }

## Shell integrations
eval "$(zoxide init --cmd cd zsh)"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
if [[ -d $PYENV_ROOT/bin ]]; then
  export PATH="$PYENV_ROOT/bin:$PATH"

  # install pyenv-virtualenv if not installed
  if [[ ! -d "$PYENV_ROOT/plugins/pyenv-virtualenv" ]]; then
    git clone https://github.com/pyenv/pyenv-virtualenv.git "$(pyenv root)"/plugins/pyenv-virtualenv
  fi

  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

# jenv
JENV_PATH="$HOME/.jenv/bin"
if [[ -d "$JENV_PATH" ]]; then
  export PATH="$HOME/.jenv/bin:$PATH"
  eval "$(jenv init -)"
fi

# flutter & dart
FLUTTER_PATH="$HOME/.flutter/flutter"
if [ -d "$FLUTTER_PATH" ]; then
  export PATH="$PATH":"$HOME/.pub-cache/bin":"$FLUTTER_PATH/bin"
  if [[ -f "$HOME/.dart-cli-completion/zsh-config.zsh" ]]; then
    . "$HOME/.dart-cli-completion/zsh-config.zsh"
  fi
fi

# fnm (node)
# modified from fnm install script: https://github.com/Schniz/fnm/blob/master/.ci/install.sh
OS="$(uname -s)"

case "${OS}" in
MINGW* | Win*) OS="Windows" ;;
esac

if [ -d "$HOME/.fnm" ]; then
  FNM_PATH="$HOME/.fnm"
elif [ -n "$XDG_DATA_HOME" ]; then
  FNM_PATH="$XDG_DATA_HOME/fnm"
elif [ "$OS" = "Darwin" ]; then
  FNM_PATH="$HOME/Library/Application Support/fnm"
else
  FNM_PATH="$HOME/.local/share/fnm"
fi

if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "$(fnm env --use-on-cd --version-file-strategy=recursive --shell=zsh)"
  if [[ -e "$FNM_PATH/_fnm.sh" ]]; then
    # consider auto-installing them if they don't exist
    . "$FNM_PATH/_fnm.sh"
  fi
fi

# Golang
GOPATH="${GOPATH:-$HOME/go}"

if [ -d "$GOPATH" ]; then
  export GOPATH="$GOPATH"

  # Update PATH to include GOPATH and GOROOT binaries
  export PATH="$GOPATH/bin:$GOROOT/bin:$HOME/.local/bin:$PATH"
fi
