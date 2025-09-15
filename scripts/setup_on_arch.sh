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

sudo --reset-timestamp
echo "installing dependencies"
sudo pacman --overwrite "*" --noconfirm --needed -S \
  base-devel \
  cmake \
  curl \
  devtools \
  gcc \
  git \
  make \
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
ssh-keygen -t ed25519 -f "$ssh_home/forgejo" -P "" -C "$git_email"
ssh-keygen -t ed25519 -f "$ssh_home/github" -P "" -C "$git_email"
ssh-keygen -t rsa -f "$ssh_home/aur" -P ""
ssh-keygen -t rsa -f "$ssh_home/couchlab" -P ""
cat > "$ssh_home/config" <<EOF
Host aur.archlinux.org
  IdentityFile ~/.ssh/aur
  User $git_username

Host forgejo-ssh.couchlab.me
	IdentityFile ~/.ssh/forgejo
	ProxyCommand /usr/bin/env cloudflared access ssh --hostname %h

Host github.com
  AddKeysToAgent yes
  IdentityFile ~/.ssh/github
EOF

echo "installing AUR helper: paru"
if ! sudo pacman --noconfirm -S paru; then
  echo "failed to install paru from repos, installing manually..."
  paru_path="$HOME/aur/paru"
  mkdir -vp "$paru_path"
  git clone https://aur.archlinux.org/paru.git "$paru_path"
  cd "$paru_path" || exit 1
  # paru is a Rust project and I don't use any crazy custom RUSTFLAGS,
  # so it's OK to do this before unboxing the makepkg config in my dotfiles.
  makepkg -si
  cd "$ORIG_DIR" || exit 1
fi
paru --gendb

echo "installing dotfiles"
#shellcheck disable=SC2016
echo 'export ZDOTDIR="$HOME/.zsh"' >> "$HOME/.zshenv"
source "$HOME/.zshenv"
dotfiles_path="$HOME/dotfiles"
mkdir -vp "$dotfiles_path"
paru -S boxunbox
sudo unbox --if-exists move "$dotfiles_path/pacman"
# there are duplicates here, but that's what --needed is for
paru --needed --noconfirm -S \
  autorestic-bin \
  bat \
  eza \
  fd \
  fnm \
  foot \
  fzf \
  gcc \
  git \
  jenv \
  make \
  oh-my-posh-bin \
  neovim \
  ripgrep \
  ttf-jetbrains-mono-nerd \
  unzip \
  zoxide \
  zsh
git clone --recurse-submodules=neovim https://github.com/dablenparty/.unix.git "$dotfiles_path"
modules_to_unbox=(foot git makepkg neovim paru yazi zsh)
# prepend "$dotfiles_path/" to each module
modules_to_unbox=("${modules_to_unbox[@]/#/$dotfiles_path/}")
unbox --if-exists overwrite "${modules_to_unbox[@]}"

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

echo "installing syncthing"
paru --needed --noconfirm --asexplicit -S \
  syncthingtray-qt6 \
  syncthing

sudo systemctl enable --now syncthing@"$USER".service

echo "installing obsidian"
paru --needed --noconfirm -S obsidian

echo "installing rustup from rustup.rs"
paru -Rus rust
eval "${ curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs; }"
source "$HOME/.cargo/env"

rustup toolchain install stable
rustup toolchain install nightly
rustup default stable
rustup component add rust-analyzer

echo "Installation complete! Make sure you double-check pacman and reboot when you're done!"
