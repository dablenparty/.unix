#!/usr/bin/env bash
#shellcheck disable=1091

set -eo pipefail

echo "Before continuing, please make sure your system is up-to-date."
echo "    sudo pacman -Syu"
read -rp "Continue? [Y\n]"$'\n' -n 1 key

# save the original dir for undoing cd commands
ORIG_DIR="$PWD"

case $key in
y | Y | "")
  echo "Beginning installation..."
  ;;
*)
  echo "aborting..."
  exit 0
  ;;
esac

echo "installing dependencies"
sudo pacman --overwrite "*" --noconfirm -S \
  base-devel \
  cmake \
  curl \
  devtools \
  gcc \
  git \
  man-db \
  ntfs-3g \
  openssh \
  pacman-contrib \
  ripgrep \
  rust \
  unzip \
  yazi \
  zsh

echo "setting git config"
git config --global init.defaultBranch main
read -rep 'git username: ' git_username
git config --global user.name "$git_username"
read -rep 'git email: ' git_email
git config --global user.email "$git_email"

echo "creating ssh keys (you have to install them yourself)"
ssh_home="$HOME/.ssh"
mkdir -vp "$ssh_home"
ssh-keygen -t ed25519 -f "$ssh_home/github" -P "" -C "$git_email"
ssh-keygen -t rsa -f "$ssh_home/aur" -P ""
ssh-keygen -t rsa -f "$ssh_home/couchlab" -P ""

echo "installing AUR helper: paru"
paru_path="$HOME/aur/paru"
mkdir -vp "$paru_path"
git clone https://aur.archlinux.org/paru.git "$paru_path"
cd "$paru_path" || exit 1
# paru is a Rust project and I don't use any crazy custom RUSTFLAGS,
# so it's OK to do this before unboxing the makepkg config in my dotfiles.
# I actually like having paru be different.
makepkg -si
cd "$ORIG_DIR" || exit 1
paru --gendb

echo "installing dotfiles"
dotfiles_path="$HOME/dotfiles"
mkdir -vp "$dotfiles_path"
modules_to_unbox=(home lazygit makepkg neovim paru yazi)
# there are duplicates here, but that's what --needed is for
paru --needed --noconfirm -S \
  bat \
  boxunbox \
  eza \
  fd \
  fnm \
  fzf \
  gcc \
  git \
  jenv \
  lazygit \
  make \
  oh-my-posh-bin \
  neovim \
  ripgrep \
  ttf-jetbrains-mono-nerd \
  unzip \
  zoxide \
  zsh
git clone https://github.com/dablenparty/.unix.git "$dotfiles_path"
cd "$dotfiles_path" || exit 1
git submodule update --init --remote --rebase neovim
unbox --force "${modules_to_unbox[@]}"
cd "$ORIG_DIR" || exit 1

echo "installing gaming dependencies"
paru --noconfirm -S wine \
  wine-gecko \
  wine-mono \
  pipewire-pulse \
  lib32-pipewire \
  lib32-libpulse \
  lib32-sdl2 \
  xdg-desktop-portal-kde

# steam must be installed after all the Wine stuff
paru --noconfirm --rebuild=all -S steam

echo "installing extras"
paru --needed --noconfirm --asexplicit -S \
  obsidian \
  syncthingtray-qt6 \
  syncthing

echo "installing rustup from rustup.rs"
paru -Rus rust
eval "$(curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs)"
source "$HOME/.cargo/env"

echo "installing Rust toolchains"
rustup toolchain install stable
rustup toolchain install nightly
rustup default stable
rustup component add rust-analyzer

echo "Installation complete! Make sure you double-check pacman and reboot when you're done!"
