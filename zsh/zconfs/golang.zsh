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
