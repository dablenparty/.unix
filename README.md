# dotfiles

A collection of dotfiles I use on macOS and various Linux distros.

## Installation

### General Pre-Requisites

First, you'll need a package manager or two:
    - macOS: [Homebrew](https://brew.sh/)
    - Linux: [Homebrew](https://brew.sh/)
        - Arch can use `pacman`, but `brew` is still required for `oh-my-posh`

Next, you'll need `oh-my-posh` for terminal customization. It gets installed via `brew` (even on Arch):

```bash
brew install jandedobbeleer/oh-my-posh/oh-my-posh
```

The next thing you'll need is a [Nerd Font](https://ohmyposh.dev/docs/installation/fonts). These can be installed [manually](https://www.nerdfonts.com/), via `brew`, or via `oh-my-posh`. At the time of writing, I currently use JetBrains Mono:

```bash
oh-my-posh font install JetBrainsMono
```

### Required Packages

- `gcc`
- `git`
- `make`
- `stow`
- `unzip`
- `zsh`

Don't forget to change your shell to `zsh` if necessary. **Do not run the command as root!** You want to change your *user* shell:

```bash
chsh -s /usr/bin/zsh
```

#### Arch Install Command

```bash
sudo pacman -Syu gcc git make stow unzip zsh
```

#### Ubuntu Install Command

First, update your system:

```bash
sudo apt update && sudo apt upgrade -y --fix-missing
```

Then install the packages:

```bash
sudo apt install build-essential git make stow unzip zsh
```

### `zsh` Packages

These are mostly commandline programs that are referenced by [`zshrc`](.zshrc), but some I just like.

<details>

<summary>Arch</summary>

```bash
sudo pacman -S bat fd fzf lazygit lsd ripgrep zoxide
```

</details>

<details>

<summary>Homebrew</summary>

```bash
brew install bat fd fzf lazygit lsd ripgrep zoxide
```

</details>

- `bat`
    - `cat` replacement with syntax highlighting, paging, and more.
- `fd`
    - A faster file finder.
- `fzf`
    - A *fuzzy* file finder.
- `lazygit`
    - My absolute favorite terminal-based git client. Also runs in neovim!
- `lsd`
    - An improved `ls` command.
- `ripgrep`
    - `grep` replacement that is faster and easier to use.
- `zoxide`
    - `cd` replacement with fuzzy directory finding.

#### Optional Packages

These packages install tools that are used in this repository, but are not required for it to work.

- `flutter`
    - Flutter toolkit.
- `fnm`
    - Fast Node Manager. A fast, cross-platform Node version manager that works quite well with environments.
- [`ghostty`](https://ghostty.org)
    - My current choice of terminal emulator. I previously used [`alacrirtty`](https://alacritty.org/index.html).
- `go`
    - Golang toolkit.
- `jenv`
    - Manages the Java environment, making switching versions easy. Note: does **not** install Java, only manages installed versions.
- `pyenv`
    - A python version manager with support for virtual environments. I love how simple it is.

