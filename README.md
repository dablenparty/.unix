# dotfiles

A collection of dotfiles I use on macOS and various Linux distros.

## Components

### `stow`

None of this would be possible without `stow`. It creates symlinks to the home directory to make managing what gets used much easier. Install with your system package manager:

<details>

<summary>Arch</summary>

```bash
sudo pacman -S stow
```

</details>

<details>

<summary>macOS</summary>

```bash
brew install stow
```

</details>

Then, simply clone this repo, `cd` into it, and run:

```bash
stow .
```

Specific folders must be enabled by `stow`'ing them. For example:

```bash
stow ghostty
```

### `oh-my-posh`

Installs only with [Homebrew](https://brew.sh/):

```bash
brew install jandedobbeleer/oh-my-posh/oh-my-posh
```

`oh-my-posh` can also be used to install nerd fonts:

```bash
oh-my-posh font install JetBrainsMono
```

### Terminal Emulator

My current terminal emulator is [`ghostty`](https://ghostty.org). Previously, I used [`alacrirtty`](https://alacritty.org/index.html) and keep the files around as I'm still trying `ghostty` out.

It requires the JetBrainsMono [Nerd Font](https://www.nerdfonts.com/font-downloads) to work properly with my config.

### [`.zshrc`](.zshrc)

`zsh` plugins are installed automatically via `zinit`.

#### Required Packages

These are used by `zinit` and other tools.

- `gcc`
- `git`
- `make`
- `unzip`
- `zsh`

Don't forget to change your shell to `zsh` if necessary. **Do not run the command as root!** You want to change your *user* shell:

```bash
chsh -s /usr/bin/zsh
```

<details>

<summary>Arch</summary>

Update and install with one command:

```bash
sudo pacman -Syu gcc git make unzip zsh
```

</details>

<details>

<summary>Ubuntu</summary>

First, update your system:

```bash
sudo apt update && sudo apt upgrade -y --fix-missing
```

Then install the packages:

```bash
sudo apt install build-essential git unzip zsh
```

</details>

#### CLI Tools

Skip the words:

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
    - My *favorite* terminal-based git client. Also runs in neovim!
- `lsd`
    - An improved `ls` command.
- `ripgrep`
    - `grep` replacement that is faster and easier to use.
- `zoxide`
    - `cd` replacement with fuzzy directory finding.

#### Optional Packages/Tools

These packages install tools that are used in this repository, but are not required for it to work.

- `flutter`
    - Flutter toolkit.
- `fnm`
    - Fast Node Manager. A fast, cross-platform Node version manager that works quite well with environments.
- `go`
    - Golang toolkit.
- `jenv`
    - Manages the Java environment, making switching versions easy. Note: does **not** install Java, only manages installed versions.
- `pyenv`
    - A python version manager with support for virtual environments. I love how simple it is.

