#!/usr/bin/env bash
#shellcheck disable=1091

set -eo pipefail

echo "Before continuing, please make sure your system is up-to-date."
echo "    sudo pacman -Syu"
read -rp "Continue? [Y\n]" -n 1 key
printf "\n"

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

echo "installing boxunbox"
boxunbox_path="$HOME/Documents/repos/boxunbox"
# make parent dir(s)
mkdir -vp "${boxunbox_path%/*}"
git clone https://github.com/dablenparty/boxunbox.git "$boxunbox_path"
cargo install --path "$boxunbox_path"

# TODO: download and install dotfiles
# TODO: download and install paru
# TODO: install cachy repos
# TODO: install neovim dependencies
