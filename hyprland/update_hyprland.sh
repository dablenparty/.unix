#!/bin/bash

# wait for the y key, returning 0 when it is pressed
wait_for_y_key() {
  if [[ -n "$1" ]]; then
    prompt="$1"
  else
    prompt="Would you like to continue? [Y\n]"
  fi
  read -p "$prompt" -r -s -n 1 key
  printf '\n'

  case $key in
  y | Y) return 0 ;;
  n | N)
    return 1
    ;;
  *)
    return 1
    ;;
  esac
}

# TODO: colors
echo 'Checking Hyprland for update...'

if (($# == 1)); then
  hyprland_path=$1
elif (($# > 1)); then
  echo 'usage: update_hyprland.sh [HYPRLAND_PATH]'
  exit 1
else
  hyprland_path="$HOME/Hyprland/"
fi

if [[ ! -e "$hyprland_path/.git" ]]; then
  echo "Failed to locate valid Hyprland repository at '$hyprland_path', make sure you cloned it properly!"
  exit 1
fi

# cd into Hyprland and fetch from the remote
cd "$hyprland_path" || (printf "Failed to cd into %s" "$hyprland_path" && exit 1)
git fetch

hyprland_match_count="$(git remote get-url origin | rg --color=never --count 'Hyprland' || echo 0)"
diff_count="$(git rev-list --count origin/main --not main)"

# if the remote URL doesn't include the word 'Hyprland', it's probably not the right folder
if (("$hyprland_match_count" < 1)); then
  echo "Could not find Hyprland fetch url in '$hyprland_path'"
  exit 1
elif (("$diff_count" <= 0)); then
  echo 'Hyprland is up to date!'
  exit 0
fi

printf "You are %s commits behind.\n" "$diff_count"

if ! wait_for_y_key "Would you like to update Hyprland? [Y\n]"; then
  exit 0
fi

echo 'Updating dependencies'
# dependencies are done first in case the install needs to be aborted while
# keeping this script functional (once git pull is run, this won't find an
# update).
# if this gets out-of-date, check the list in your Obsidian vault
yay -S --needed --asdeps --noconfirm cairo \
  cmake \
  cpio \
  gcc \
  glaze \
  hyprcursor-git \
  hyprgraphics-git \
  hyprlang-git \
  hyprutils-git \
  hyprwayland-scanner-git \
  libdisplay-info \
  libinput \
  libliftoff \
  libx11 \
  libxcb \
  libxcomposite \
  libxfixes \
  libxkbcommon \
  libxrender \
  meson \
  ninja \
  pango \
  pixman \
  tomlplusplus \
  wayland-protocols \
  xcb-proto \
  xcb-util \
  xcb-util-errors \
  xcb-util-keysyms \
  xcb-util-wm \
  xorg-xwayland

yay -S --needed --noconfirm aquamarine-git \
  egl-wayland \
  kitty \
  hyprpolkitagent-git \
  qt5-wayland \
  qt6-wayland \
  seatd \
  uwsm \
  xdg-desktop-portal-hyprland-git

if wait_for_y_key "Clean build? [Y\n]"; then
  make clear
fi

echo 'Updating Hyprland'
git pull || exit 1
make all
sudo make install
