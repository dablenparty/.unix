#!/bin/bash

wallpaper_root="$HOME/Pictures/Wallpapers"

if [[ ! -d "$wallpaper_root" ]]; then
  printf "Could not find wallpaper directory '%s'" "$wallpaper_root"
  exit 1
fi

# TODO: actually fix the wallpaper icons
selected_wallpaper="$(eza --color=never --oneline "$wallpaper_root" | xargs -I% echo -en "%\0icon\x1f%\n" | rofi -dmenu -i -show-icons -p "Wallpaper")"

if [[ -z "$selected_wallpaper" ]]; then
  exit 0
fi

"$HOME/update-wallpaper-hyprpaper.sh" "$selected_wallpaper" &>/dev/null
