JENV_PATH="$HOME/.jenv/bin"
if [[ -d "$JENV_PATH" ]]; then
  export PATH="$JENV_PATH:$PATH"
  source <(jenv init -)
fi
