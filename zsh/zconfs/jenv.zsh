JENV_PATH="$HOME/.jenv/bin"
if [[ -d "$JENV_PATH" ]]; then
  export PATH="$JENV_PATH:$PATH"
  eval "$(jenv init -)"
fi
