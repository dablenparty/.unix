#!/bin/zsh
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
export FZF_DEFAULT_COMMAND="fd -uuu -tf --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
eval "$(fzf --zsh)"

# Initialize oh-my-posh, but not on Apple Terminal
if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  if [[ "$XDG_CURRENT_DESKTOP" == "Hyprland" ]]; then
    config="$HOME/zen-wal.omp.toml"
  else
    config="$HOME/zen.omp.toml"
  fi
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
zcomet snippet OMZ::plugins/git/git.plugin.zsh
zcomet snippet OMZ::plugins/sudo/sudo.plugin.zsh
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
alias zshconfig="nvim \$HOME/.zshrc"
alias l='eza'
alias ll='eza -hal --git --smart-group'
alias la='eza -a'
alias lg='lazygit'
# wrap cat with bat for colors and paging
alias cat='bat -p'

## Shell integrations
eval "$(zoxide init --cmd cd zsh)"

# neovim
# wrap neovim with zoxide for easier directory cd'ing
nvz() {
  if [[ $# -eq 1 && -e $1 ]]; then cd "$1" || exit 1; else
    dir="$(zoxide query "$@")"
    if [[ -d "$dir" ]]; then
      cd "$dir" || exit 1
      nvim .
    fi
  fi
}

nvf() {
  if [[ $# -eq 1 && -e $1 ]]; then
    nvim $1
  elif [[ $# -ge 2 ]]; then
    # given args such as nvz path dir file.txt, use zoxide query to locate "path dir" and then pipe that into fd to search for files and then to fzf with "file.txt" as the search term
    z_args="${@:1:($# - 1)}"
    file_arg="${@:$#}"
    dir="$(zoxide query "$z_args")"
    if [[ -d "$dir" ]]; then
      cd "$dir" || exit 1
      if [[ -f "$dir/$file_arg" ]]; then
        nvim "$file_arg"
      else
        fd --type file --hidden --no-ignore-vcs --exclude .git | fzf -q "$file_arg" | xargs nvim
      fi
    fi
  else
    echo 'usage: nvf <DIR_QUERY>[...DIR_QUERY] <FILE_QUERY>'
  fi
}

# for yazi
export EDITOR=nvim

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

  # add yarn globals to path
  yarn_bin="$(yarn global bin)"
  if [ -d "$yarn_bin" ]; then
    export PATH="$(yarn global bin):$PATH"
  fi
fi

# Golang
GOPATH="${GOPATH:-$HOME/go}"

if [ -d "$GOPATH" ]; then
  export GOPATH="$GOPATH"

  # Update PATH to include GOPATH and GOROOT binaries
  export PATH="$GOPATH/bin:$GOROOT/bin:$HOME/.local/bin:$PATH"
fi
