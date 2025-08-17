# modified from fnm install script: https://github.com/Schniz/fnm/blob/master/.ci/install.sh
OS="$(uname -s)"

case "${OS}" in
MINGW* | Win*) OS="Windows" ;;
esac

if [[ -d "$HOME/.fnm" ]]; then
  FNM_PATH="$HOME/.fnm"
elif [[ -n "$XDG_DATA_HOME" ]]; then
  FNM_PATH="$XDG_DATA_HOME/fnm"
elif [[ "$OS" = "Darwin" ]]; then
  FNM_PATH="$HOME/Library/Application Support/fnm"
else
  FNM_PATH="$HOME/.local/share/fnm"
fi

if [[ -d "$FNM_PATH" ]]; then
  export PATH="$FNM_PATH:$PATH"
  eval "$(fnm env --use-on-cd --version-file-strategy=recursive --shell=zsh)"
  if [[ -e "$FNM_PATH/_fnm.sh" ]]; then
    # consider auto-installing them if they don't exist
    . "$FNM_PATH/_fnm.sh"
  fi

  # add yarn globals to path
  yarn_bin="$(yarn global bin)"
  if [[ -d "$yarn_bin" ]]; then
    export PATH="$yarn_bin:$PATH"
  fi
fi
