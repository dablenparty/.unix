#!/usr/bin/env zsh

# syntax highlighting and toc (`gO`) in manpages
export MANPAGER="nvim +Man!"

# Check if homebrew is installed
if [[ -f "/usr/local/bin/brew" ]]; then
  eval "$("/usr/local/bin/brew" shellenv)"
elif [[ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
  eval "$("/home/linuxbrew/.linuxbrew/bin/brew" shellenv)"
# # Apple Silicon
# elif [[ -f "/opt/homebrew/bin/brew" ]]; then
#   eval "$("/opt/homebrew/bin/brew" shellenv)"
fi

# fzf fuzzy finder
export FZF_DEFAULT_COMMAND="fd -uuu -tf -tl --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
eval "$(fzf --zsh)"

# Initialize oh-my-posh, but not on Apple Terminal
if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  if [[ "$XDG_CURRENT_DESKTOP" == "Hyprland" ]]; then
    config="$HOME/.cache/wal/zen-wal.omp.toml"
  else
    config="$HOME/zen.omp.toml"
  fi

  ## Enables dynamic window titles
  # Called before prompt(?)
  function precmd {
      # Set window title
      print -Pn "\e]0;zsh%L %(1j,%j job%(2j|s|); ,)%~\e\\"
  }

  # Called when executing a command
  function preexec {
      print -Pn "\e]0;${(q)1}\e\\"
  }

  eval "$(oh-my-posh init zsh --config "$config")"
fi

# force bad syntax to be highlighted red no matter the color scheme
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=160'

ZCOMET_HOME="${ZDOTDIR:-${HOME}}/.zcomet/bin"
# Clone zcomet if necessary
if [[ ! -f "$ZCOMET_HOME/zcomet.zsh" ]]; then
  command git clone https://github.com/agkozak/zcomet.git "$ZCOMET_HOME"
fi

source "$ZCOMET_HOME/zcomet.zsh"

## Add in zsh plugins
# this must be first!
zcomet load Aloxaf/fzf-tab

## Add in snippets
zcomet snippet OMZ::plugins/command-not-found/command-not-found.plugin.zsh

# load these last
zcomet load zsh-users/zsh-syntax-highlighting
zcomet load zsh-users/zsh-autosuggestions

zcomet load zsh-users/zsh-completions
zcomet compinit

## Completion styling

# case insensitive match
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# shows ls colors in completions
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# disable default zsh completion menu
zstyle ':completion:*' menu no

preview_cmd="eza -a1 --color=always -I '.DS_Store' \$realpath"
zstyle ':fzf-tab:complete:cd:*' fzf-preview "$preview_cmd"
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview "$preview_cmd"

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

# Aliases
# add -v to coreutils so that they always explain what they're doing
alias cp='cp -v'
alias mkdir='mkdir -v'
alias mv='mv -v'
alias rm='rm -v'

# Aliases: eza
alias l='eza --icons=auto'
alias ll='eza --icons=auto -hal --git --smart-group'
alias la='eza --icons=auto -a'
alias tree='eza --icons=auto -T'
# show a file tree sorted by size
alias stree='eza --icons=auto -laThs=size --total-size --no-permissions --no-user --no-time'
# wrap cat with bat for colors and paging
alias cat='bat -p'

# Aliases: git
alias ga='git add'
alias gap='ga --patch'
alias gb='git branch'
alias gba='gb --all'
alias gc='git commit'
alias gca='gc --amend --no-edit'
alias gce='gc --amend'
alias gco='git checkout'
alias gcl='git clone --recursive'
alias gd='git diff --output-indicator-new=" " --output-indicator-old=" "'
alias gds='gd --staged'
alias gi='git init'
alias gl='git log --graph --all --pretty=format:"%C(magenta)%h %C(white) %an  %ar%C(auto)  %D%n%s%n"'
alias gm='git merge'
alias gn='git checkout -b'  # new branch
alias gp='git push'
alias gr='git reset'
alias gs='git status --short'
alias gu='git pull'
alias ng='nvim +NeogitStandalone'

# for whatever reason, aliasing this doesn't register it as a valid alias
tetris() {
  autoload -Uz tetriscurses && tetriscurses
}

# alias bash help because I script a lot
help() {
  /usr/bin/env bash -c "builtin help $*"
}

## Shell integrations
eval "$(zoxide init --cmd cd zsh)"

# neovim + zoxide
nvz() {
  cd "$(zoxide query "$@")" && nvim
}

# yazi + zoxide
yz() {
  cd "$(zoxide query "$@")" && yazi
}

# for yazi
export EDITOR=nvim

# iterate over all files ending with .zsh, failing silently if nothing is found
conf_dir="${ZDOTDIR:-$HOME}/zconfs"
for conf in "$conf_dir/"**/*.zsh(N); do
  source "$conf"
done

# jenv
JENV_PATH="$HOME/.jenv/bin"
if [[ -d "$JENV_PATH" ]]; then
  export PATH="$HOME/.jenv/bin:$PATH"
  eval "$(jenv init -)"
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

  # add yarn globals to path
  yarn_bin="$(yarn global bin)"
  if [ -d "$yarn_bin" ]; then
    export PATH="$(yarn global bin):$PATH"
  fi
fi

# Golang
GOPATH="${GOPATH:-$HOME/go}"

# see `go help install` for info on each envvar
if [[ -d "$GOPATH" ]]; then
  export GOPATH="$GOPATH"
  if [[ -z "$GOBIN" ]]; then
    export GOBIN="$GOPATH/bin"
  fi

  local paths_to_add=("$GOBIN", "$HOME/.local/bin")
  if [[ -n "$GOTOOLDIR" && -d "$GOTOOLDIR" ]]; then
    paths_to_add+=("$GOTOOLDIR")
  elif [[ -n "$GOROOT" && -d "$GOROOT" ]]; then
    paths_to_add+=("$GOROOT/bin")
  fi

  # join go paths with a colon and prepend them to PATH
  # e.g.: (one two three) -> one:two:three
  # see: https://zsh.sourceforge.io/Guide/zshguide05.html#l124
  export PATH="${(j.:.)paths_to_add}:$PATH"
fi
