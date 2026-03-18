# Dotfiles

Personal dotfiles for Ubuntu (WSL), managed with [GNU Stow](https://www.gnu.org/software/stow/).
Configures Neovim, Zsh, Git, Starship prompt, and Tmux.

## Quick Start

```bash
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles
bash setup.sh
```

## Installation

`setup.sh` handles everything:

```bash
bash setup.sh
```

This installs:
- apt packages: `stow`, `git`, `zsh`, `tmux`, `fzf`, `ripgrep`, etc.
- Neovim (via apt with Neovim PPA)
- Starship prompt
- zoxide

Then stows all packages: `git zsh starship nvim tmux`

## Structure

Each top-level directory is a Stow package. Paths inside mirror where symlinks
land relative to `~`.

```
dotfiles-zsh2/
├── git/                  # ~/.gitconfig, ~/.config/git/ignore
├── nvim/                 # ~/.config/nvim/
│   └── .config/nvim/
│       ├── init.lua
│       └── lua/
│           ├── config/lazy.lua
│           └── plugins/
│               ├── ui.lua
│               ├── treesitter.lua
│               ├── lsp.lua
│               ├── completion.lua
│               ├── telescope.lua
│               ├── git.lua
│               ├── formatting.lua
│               └── editing.lua
├── starship/             # ~/.config/starship.toml
├── tmux/                 # ~/.tmux.conf
├── zsh/                  # ~/.zshrc
├── setup.sh              # Ubuntu/WSL bootstrap
├── .stylua.toml          # Lua formatter settings
└── CLAUDE.md             # Repo documentation
```

## What's Included

### Shell (Zsh)

- **Plugin manager**: Zinit (auto-installed on first launch)
- **Plugins**: zsh-syntax-highlighting, zsh-completions, zsh-autosuggestions
- **Prompt**: Starship
- **Tools**: zoxide (`cd`), fzf, fnm, asdf
- `~/.secrets.zsh` loaded if present (not committed)

### Neovim

- **Plugin manager**: Lazy.nvim (auto-installed on first launch)
- **LSP**: Mason + lua_ls, pyright, ruff
- **Fuzzy finder**: Telescope
- **Completion**: nvim-cmp + LuaSnip
- **Formatting**: conform.nvim (format on save)
- **Theme**: base16 Tomorrow Night Eighties
- Leader key: `,`

## Adding a New Tool

1. Create a directory at the repo root (e.g., `mytool/`)
2. Mirror the path from `~` inside it (e.g., `mytool/.config/mytool/config`)
3. Add the directory name to the `stow` line in `setup.sh`

## Adding a Neovim Plugin

Create a file in `nvim/.config/nvim/lua/plugins/<name>.lua` returning a
Lazy.nvim spec table. Lazy auto-discovers all files in `plugins/`.

## Version Managers

The `.zshrc` initializes these if installed:

- **fnm** - Node.js: `curl -fsSL https://fnm.vercel.app/install | bash`
- **asdf** - multi-language: `git clone https://github.com/asdf-vm/asdf.git ~/.asdf`

## License

Feel free to adapt for your own use.
