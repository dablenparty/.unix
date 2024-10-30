# Check if homebrew is installed
if ! type brew >/dev/null 2>&1
then
  # Enable homebrew shellenv
  # which brew is used because Apple Silicon and Intel macs have different
  # install paths for homebrew
  eval "$($(which brew) shellenv)"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

## Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

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

# Initialize oh-my-posh, but not on Apple Terminal
if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  eval "$(oh-my-posh init zsh --config '~/zen.omp.toml')"
fi

## Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

## History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
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
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'lsd $realpath'

# Aliases
alias zshconfig='vim ~/.zshrc'
alias pubip="ifconfig -u | grep 'inet ' | grep -v 127.0.0.1 | cut -d\  -f2 | head -1"
alias ls='lsd'
alias ll='lsd -hAlF'
alias davenhome='ssh -i ~/.ssh/davenhome_rsa hunterdavenport@192.168.50.214'
alias cat='bat -p'

## Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Node Version Manager (nvm)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# iterm2
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# jenv
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

# flutter & dart
export PATH="$PATH":"$HOME/.pub-cache/bin"
[[ -f /Users/hunterdavenport/.dart-cli-completion/zsh-config.zsh ]] && . /Users/hunterdavenport/.dart-cli-completion/zsh-config.zsh || true
