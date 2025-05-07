#!/usr/bin/env bash
#shellcheck disable=1091

set -eo pipefail

echo "Before continuing, please make sure your system is up-to-date."
echo "    sudo pacman -Syu"
read -rp "Continue? [Y\n]" -n 1 key
printf "\n"

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

echo "installing CachyOS repos"
cachy_tar_path=/tmp/cachyos-repo.tar.xz
cachy_extract_path=/tmp/cachyos-repo
curl https://mirror.cachyos.org/cachyos-repo.tar.xz -o "$cachy_tar_path"
tar -xvf "$cachy_tar_path" -C /tmp
sudo "$cachy_extract_path"/cachyos-repo.sh

echo "installing dependencies"
sudo pacman --overwrite "*" --needed --noconfirm -S \
  base-devel \
  cmake \
  curl \
  gcc \
  git \
  man-db \
  ntfs-3g \
  pacman-contrib \
  ripgrep \
  unzip \
  yazi \
  zsh

# I don't like installing rustup with pacman, it makes using cargo as
# a package manager a bit difficult.
echo "installing rustup"
eval "$(curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs)"
source "$HOME/.cargo/env"

echo "installing Rust toolchains"
rustup toolchain install stable
rustup toolchain install nightly
rustup default stable
rustup component add rust-analyzer

echo "setting git config"
read -rep "git username: " git_username
printf "\n"
git config --global user.name "$git_username"

read -rep "git email: " git_email
printf "\n"
git config --global user.email "$git_email"

echo "temp installing boxunbox"
boxunbox_path="$HOME/Documents/repos/boxunbox"
# make parent dir(s)
mkdir -vp "${boxunbox_path%/*}"
git clone https://github.com/dablenparty/boxunbox.git "$boxunbox_path"
cargo build --release

force_unbox() {
  if (($# < 1)); then
    echo "usage: $0 <package_dir> [package_dirs...]" 1>&2
    return 1
  fi
  unbox_bin="$boxunbox_path/target/release/unbox"
  "$unbox_bin" --force "$@"
}

echo "installing AUR helper: paru"
paru_path="$HOME/aur/paru"
sudo pacman --noconfirm --needed -S base-devel
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
modules_to_unbox=(home lazygit makepkg neovim pacman paru yazi)
# TODO: once boxunbox is in the AUR, install it here
paru --needed --noconfirm -S \
  bat \
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
  unzip \
  zoxide \
  zsh
git clone https://github.com/dablenparty/.unix.git "$dotfiles_path"
cd "$dotfiles_path" || exit 1
git submodule update --init --remote --rebase neovim
cd "$ORIG_DIR" || exit 1
force_unbox "${modules_to_unbox[@]}"

paru --needed --noconfirm -S oh-my-posh-bin

echo "installing gaming dependencies"
paru --noconfirm --needed -S wine \
  wine-gecko \
  wine-mono \
  pipewire-pulse \
  lib32-pipewire \
  lib32-libpulse \
  lib32-sdl2 \
  xdg-desktop-portal-kde

# steam must be installed after all the Wine stuff
paru --noconfirm --needed --rebuild=all -S steam

echo "installing extras"
paru --needed --noconfirm --asexplicit -S \
  obsidian \
  syncthingtray-qt6 \
  syncthing
