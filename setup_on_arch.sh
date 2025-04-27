#!/usr/bin/env bash

echo "installing dependencies"
sudo pacman --overwrite "*" --needed --noconfirm -S \
  base-devel \
  cmake \
  gcc \
  git \
  man-db \
  ntfs-3g \
  pacman-contrib \
  ripgrep \
  rustup \
  unzip \
  yazi \
  zsh

rustup toolchain install stable
rustup toolchain install nightly
rustup default stable

read -rep "git username: " git_username
read -rep "git email: " git_email

echo "setting git config"
git config --global user.name "$git_username"
git config --global user.email "$git_email"

boxunbox_path="$HOME/boxunbox"
git clone https://github.com/dablenparty/boxunbox.git "$boxunbox_path"
cargo install --path "$boxunbox_path"

# TODO: download and install dotfiles
# TODO: download and install paru
# TODO: install cachy repos
# TODO: install neovim dependencies
