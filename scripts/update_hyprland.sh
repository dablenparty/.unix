echo 'Checking Hyprland for update...'

hyprland_path="$HOME/Hyprland/"
if [[ ! -d $hyprland_path ]]; then
  echo "Failed to locate Hyprland installation at '$hyprland_path', make sure you cloned it properly!"
fi

cd "$hyprland_path" || (printf "Failed to cd into %s" "$hyprland_path" && exit 1)

diff_count="$(git rev-list --count origin/main --not main)"
if [[ "$diff_count" -le 0 ]]; then
  echo 'Hyprland is up to date!'
  exit 0
fi

printf "You are %s commits behind.\n" "$diff_count"

read -p "Would you like to update Hyprland? [Y\n]" -r -s -n 1 key
printf '\n'

case $key in
y | Y) ;;
n | N)
  exit 0
  ;;
*)
  echo "Invalid input."
  ;;
esac

echo 'Updating dependencies'
# dependencies are done first in case the install needs to be aborted while
# keeping this script functional (once git pull is run, this won't find an
# update).
# if this gets out-of-date, check the list in your Obsidian vault
yay -S aquamarine-git \
  cairo \
  cmake \
  cpio \
  egl-wayland \
  gcc \
  glaze \
  kitty \
  hyprcursor-git \
  hyprgraphics-git \
  hyprlang-git \
  hyprpolkitagent-git \
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
  qt5-wayland \
  qt6-wayland \
  seatd \
  uwsm \
  tomlplusplus \
  wayland-protocols \
  xcb-proto \
  xcb-util \
  xcb-util-errors \
  xcb-util-keysyms \
  xcb-util-wm \
  xdg-desktop-portal-hyprland-git \
  xorg-xwayland

echo 'Updating Hyprland'
git pull || exit 1
make all
sudo make install
