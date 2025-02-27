# dotfiles

A collection of dotfiles I use on macOS and various Linux distros.

## Components

### `boxunbox`

Shameless plug: I have been developing an alternative to GNU `stow` for fun called [`boxunbox`](https://github.com/dablenparty/boxunbox). It is designed for my use case, so they are _not_ the same. Check it out!

The biggest difference is how they handle packages; `stow` just replicates the directory structure with relative links while `boxunbox` allows more fine-grained control over what gets linked where via config files. It also uses absolute links by default. I found this to be better for my own personal use case.

Each folder is an individual "package". Anything loose or multi-platform (e.g. [`oh-my-posh`](home/zen.omp.toml)) is in the [`home`](home/) package. Linking a package is easy; just unbox it:

```bash
unbox home
```

And that's it! The `.unboxrc.ron` file(s) takes care of the rest.

### `oh-my-posh`

Installs with [Homebrew](https://brew.sh/):

```bash
brew install jandedobbeleer/oh-my-posh/oh-my-posh
```

or manually, with an [installation script](https://ohmyposh.dev/docs/installation/linux) (Linux only).

<details>

  <summary>Arch</summary>

If you're using Arch Linux and don't want to use **Homebrew**, there is an [unofficial AUR package (`oh-my-posh-bin`)](https://aur.archlinux.org/packages/oh-my-posh-bin) that updates daily. Install that with whatever tool you prefer.

</details>

`oh-my-posh` can also be used to install nerd fonts. For example:

```bash
oh-my-posh font install JetBrainsMono
```

### Terminal Emulator

My current terminal emulators are [`ghostty`](https://ghostty.org) for macOS and [`foot`](https://codeberg.org/dnkl/foot) on Linux. Both require the JetBrainsMono [Nerd Font](https://www.nerdfonts.com/font-downloads) to work properly with my configs.

### [`.zshrc`](home/.zshrc)

This is the single most important file in this repo, as well as the only requried one.

`zsh` plugins are installed automatically via [`zcomet`](https://zcomet.io/).

#### Pre-requisites

These are used by `zcomet` and other tools:

- `gcc`
- `git`
- `make`
- `unzip`
- `zsh`

> [!IMPORTANT]
> Don't forget to change your shell to `zsh` if necessary. **Do not run the command as root!** You want to change your _user_ shell:
>
> ```bash
> chsh -s /usr/bin/zsh
> ```

#### CLI Tools

- `bat`
  - `cat` replacement with syntax highlighting, paging, and more.
- `eza`
  - An improved `ls` command. Replaced my use of `lsd` in this config.
- `fd`
  - A faster file finder.
- `fzf`
  - A _fuzzy_ finder that works with almost anything.
- `lazygit`
  - My _favorite_ terminal-based git client. Also runs in neovim!
- [`neovim`](https://github.com/dablenparty/dablenparty.nvim)
  - My favorite text editor. Follow the instructions in the linked repository, there are a few extra dependencies not found here.
- `ripgrep`
  - `grep` replacement that is faster and easier to use.
- `zoxide`
  - `cd` replacement with _fuzzy_ directory finding.

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
