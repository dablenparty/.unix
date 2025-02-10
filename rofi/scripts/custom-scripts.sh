#!/bin/bash

# TODO: test this
runnables_root="$HOME/.local/share/rofi"

if (($# > 0)); then
  fd -d1 --color=never "$*" "$runnables_root"
  exit 0
fi

if [[ -L "$runnables_root" ]]; then
  runnables_root="$(readlink -f "$runnables_root")"
fi

if [[ ! -d "$runnables_root" ]]; then
  echo "$runnables_root is not a directory"
  exit 1
fi

fd -d1 -tx --color=never --absolute-path . "$runnables_root" -x basename
