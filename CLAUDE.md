# CLAUDE.md

## Repository Overview

Personal dotfiles repository for Ubuntu (WSL), managed with
[GNU Stow](https://www.gnu.org/software/stow/). Configures Neovim, Zsh, Git,
Starship prompt, and Tmux.

## Directory Structure

```
dotfiles-zsh2/
├── git/                  # Git config (~/.gitconfig, ~/.config/git/ignore)
├── nvim/                 # Neovim config (~/.config/nvim/)
│   └── .config/nvim/
│       ├── init.lua              # Entry point: leader key, core keymaps, options
│       └── lua/
│           ├── config/lazy.lua   # Lazy.nvim plugin manager bootstrap
│           └── plugins/          # One file per plugin group
│               ├── ui.lua        # Colorscheme, lualine, indent guides
│               ├── treesitter.lua
│               ├── lsp.lua       # Mason + nvim-lspconfig
│               ├── completion.lua # nvim-cmp + LuaSnip
│               ├── telescope.lua  # Fuzzy finder
│               ├── git.lua        # vim-fugitive, gitsigns
│               ├── formatting.lua # conform.nvim
│               └── editing.lua    # surround, autopairs, comment
├── starship/             # Starship prompt config (~/.config/starship.toml)
├── tmux/                 # Tmux config (~/.tmux.conf)
├── zsh/                  # Zsh config (~/.zshrc)
├── setup.sh              # Ubuntu/WSL bootstrap (apt + stow)
├── .stylua.toml          # Lua formatter settings
└── CLAUDE.md             # This file
```

Each top-level directory is a Stow package. The internal paths mirror where
symlinks land relative to `~`.

## Installation

`setup.sh` is Ubuntu/WSL-only. It installs system packages (via apt), Neovim
(via apt with Neovim PPA), Starship, and zoxide, then runs:

```bash
stow -t ~ git zsh starship nvim tmux
```

Run it:

```bash
bash setup.sh
```

## Key Conventions

### Code Style
- **Lua**: 2-space indent, single quotes preferred, 100-char line width (enforced
  by `.stylua.toml`)
- **Default (non-Lua)**: 4-space indent, spaces not tabs

### Neovim
- **Leader key**: `,` (comma)
- **Plugin manager**: Lazy.nvim with specs auto-imported from `lua/plugins/`
- **LSP tools**: Mason auto-installs `lua_ls`, `pyright`, `ruff`
- **Key mappings**: `jk` = Escape, `<CR>` = clear search, `gl` = line
  diagnostics, `<leader>ff` = find files, `<leader>fb` = find buffers,
  `<leader>fo` = format buffer
- **Theme**: base16 Tomorrow Night Eighties
- Each plugin group gets its own file in `lua/plugins/`

### Shell (Zsh)
- **Plugin manager**: Zinit (auto-installed on first shell launch)
- **Plugins**: zsh-syntax-highlighting, zsh-completions, zsh-autosuggestions
- **Tools initialized**: starship, zoxide (aliased to `cd`), fzf
- **Aliases**: `vim` → `nvim`, `ls` → `ls --color`, `ll` → `ls --color -lah`
- Machine-local secrets loaded from `~/.secrets.zsh` (not committed)

### Git Commit Style
- Lowercase, imperative mood, no conventional-commit prefixes
- Short single-line messages describing the change
- Examples: `add autopairs plugin`, `update starship config`, `fix zshrc path`

## Adding a New Tool Configuration

1. Create a directory at the repo root named after the tool (e.g., `mytool/`)
2. Inside it, mirror the path from `~` (e.g., `mytool/.config/mytool/config`)
3. Add the directory name to the `stow` command in `setup.sh`

## Adding a New Neovim Plugin

1. Create a new file in `nvim/.config/nvim/lua/plugins/<plugin-name>.lua`
2. Return a Lazy.nvim plugin spec table
3. Lazy.nvim auto-discovers files in the `plugins/` directory

## No Build/Test/Lint Pipeline

This repo has no CI, tests, or automated linting. Changes are validated
manually. The only formatter is stylua for Lua files (runs on save in Neovim).
