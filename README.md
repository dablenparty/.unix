# dotfiles

A collection of my dotfiles. These are primarily for macOS/Linux, but certain files/scripts do exist for Windows

## Installation

### General Pre-Requisites

- Package Managers
    - macOS/Linux: [Homebrew](https://brew.sh/)
    - Windows: `winget` **and** [`choco`](https://chocolatey.org/install#individual)
- `oh-my-posh`
    - macOS/Linux: `brew install jandedobbeleer/oh-my-posh/oh-my-posh`
    - [Windows](https://ohmyposh.dev/docs/installation/windows)
- A [Nerd Font](https://www.nerdfonts.com/)
    - Can be installed with `oh-my-posh`

### Unix Pre-Requisites

- `gcc`
    - I recommend using `build-essential`
- `git`
- `make`
    - Install with `brew` on macOS
- `unzip`
- `zsh`
    - Comes pre-installed on macOS, if not use Homebrew

#### Ubuntu Install Command

First, update your system:

```bash
sudo apt update && sudo apt upgrade -y --fix-missing
```

Then install the packages:

```bash
sudo apt install build-essential git make unzip zsh
```

### Homebrew Packages

Skip the words:

```bash
brew install bat fd fzf lazygit lsd ripgrep zoxide
```

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

#### Optional Homebrew Packages

These packages install tools that are used in my `.zshrc`, but are not required for it to work. I do use them all.

- `alacritty`
    - My choice of terminal emulator.
- `flutter`
    - Flutter toolkit.
- `fnm`
    - Fast Node Manager. A fast, cross-platform Node version manager that works quite well with environments.
- `jenv`
    - Manages the Java environment, making switching versions easy. Note: does **not** install Java, only manages installed versions.
- `pyenv`
    - A python version manager with support for virtual environments.

