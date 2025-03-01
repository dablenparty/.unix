#!/usr/bin/env bash

wait_for_y_key() {
  if [[ -n "$1" ]]; then
    prompt="$1"
  else
    prompt="Would you like to continue? [Y\n]"
  fi
  read -p "$prompt" -r -s -n 1 key
  printf '\n'

  case $key in
  y | Y | "") return 0 ;;
  n | N)
    return 1
    ;;
  *)
    return 1
    ;;
  esac
}

paru

if wait_for_y_key "Update rustup? (Nightly always updates) [Y\n]"; then
  rustup update
else
  rustup toolchain update nightly
fi

if wait_for_y_key "Update Hyprland? [Y\n]"; then
  bash "$(readlink "$HOME/update_hyprland.sh")"
fi
