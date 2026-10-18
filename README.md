# kickstart.nvim

## Quick install (macOS, one-liner)

The installer does everything described under [Installation](#installation-macos):
Homebrew, the dependencies, the clone into `~/Projects/kickstart.nvim`, and the symlink
to `~/.config/nvim`. It is macOS only, it stops if `~/.config/nvim` already exists, and
it takes no questions, so it is safe to hand to an agent or a fresh machine.

```sh
# see what it would do, change nothing
curl -fsSL https://raw.githubusercontent.com/cshen/kickstart.nvim/master/install.sh | bash -s -- --dry-run

# include the optional bits: Nerd Font, node, age
curl -fsSL https://raw.githubusercontent.com/cshen/kickstart.nvim/master/install.sh | bash -s -- --with-extras
```

`bash -s --` is what hands the flags to the script instead of to `bash`; drop the flags
entirely (`| bash`) for a plain install.

## About

My personal, modular fork of [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim),
based on [dam9000/kickstart-modular.nvim](https://github.com/dam9000/kickstart-modular.nvim).
Kickstart is **not** a distribution: it is a small, completely documented starting point
for your own Neovim configuration, with just enough "IDE" features to build on.

How it is laid out:

- `init.lua` — sets the leader key (`,`), bootstraps `lazy.nvim`, loads the modules below
- `lua/options.lua`, `lua/keymaps.lua` — editor options and keymaps
- `lua/kickstart/plugins/*.lua` — one file per plugin (LSP, telescope, treesitter, cmp, …)
- `lua/local/*.vim` — my Vimscript bits (age-encrypted file editing, MS-Win keymaps, …)

It follows upstream and targets the latest Neovim *stable* (currently tested on 0.12).

## Installation (macOS)

### 1. Homebrew

Skip this if `brew` is already available:

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
xcode-select --install   # clang and make, needed to compile treesitter parsers
```

### 2. Neovim and dependencies

```sh
brew install neovim git ripgrep fd  tree-sitter-cli
```

Optional, depending on what you edit:

```sh
brew install --cask font-jetbrains-mono-nerd-font  # icons; `vim.g.have_nerd_font` is true in init.lua
brew install node                                  # npm, for JS/TS language servers and prettier
brew install age                                   # transparent editing of *.age files, see lua/local/_user.vim
```

Language servers and formatters do not need to be installed here — `mason.nvim` fetches
them on the first start.

### 3. Clone the configuration

On macOS Neovim reads its config from `~/.config/nvim`. Back up any existing config first
(`mv ~/.config/nvim ~/.config/nvim.bak`), then:

```sh
mkdir -p ~/Projects
git clone https://github.com/cshen/kickstart.nvim ~/Projects/kickstart.nvim
ln -sfn ~/Projects/kickstart.nvim ~/.config/nvim
```

The symlink is expected: `lua/options.lua` sources `~/.config/nvim/lua/local/*.vim` by
absolute path.

### 4. First run

```sh
nvim
```

`lazy.nvim` bootstraps itself, installs every plugin, and shows the progress window — wait
for it to finish and press `q` to close it. Worth visiting afterwards:

```
:Lazy             " plugin status; `:Lazy update` to update
:checkhealth      " missing dependencies
:help kickstart   " docs from doc/kickstart.txt
```

One thing to fix after cloning: `lua/local/_user.vim` hardcodes my age key paths
(`~/.config/age/cs.priv.key` / `cs.pub.key`) for `*.age` files — change them or comment out
that section.

<!-- vim: ts=2 sts=2 sw=2 et
-->
