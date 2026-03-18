#!/usr/bin/env bash
# Ubuntu/WSL bootstrap script
# Installs packages and symlinks dotfiles via GNU Stow
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors
if [ -t 1 ]; then
    GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'
else
    GREEN=''; YELLOW=''; BLUE=''; NC=''
fi

info()    { echo -e "${BLUE}ℹ ${NC}$*"; }
success() { echo -e "${GREEN}✓ ${NC}$*"; }
warn()    { echo -e "${YELLOW}⚠ ${NC}$*"; }

legacy_link_target() {
    local target_path="$1"
    local expected_path="$2"
    local resolved_path

    if [ ! -L "$target_path" ]; then
        return 1
    fi

    resolved_path=$(readlink -f "$target_path") || return 1
    [ "$resolved_path" = "$expected_path" ]
}

# ------------------------------------------------------------
# 1. System packages (apt)
# ------------------------------------------------------------
install_packages() {
    info "Updating apt and installing packages..."
    sudo apt-get update -qq
    sudo apt-get install -y \
        stow \
        git \
        curl \
        wget \
        zsh \
        tmux \
        fzf \
        ripgrep \
        build-essential \
        unzip

    success "System packages installed"
}

# ------------------------------------------------------------
# 2. Neovim (PPA for newer versions on Ubuntu/WSL)
# ------------------------------------------------------------
install_neovim() {
    if command -v nvim &>/dev/null; then
        local ver
        ver=$(nvim --version | head -1)
        warn "Neovim already installed: $ver"
        return
    fi

    info "Installing Neovim via apt (with PPA fallback)..."
    sudo apt-get install -y software-properties-common
    if command -v add-apt-repository &>/dev/null; then
        sudo add-apt-repository -y ppa:neovim-ppa/unstable || true
    fi
    sudo apt-get update -qq
    sudo apt-get install -y neovim
    success "Neovim installed"
}

# ------------------------------------------------------------
# 3. Starship prompt
# ------------------------------------------------------------
install_starship() {
    if command -v starship &>/dev/null; then
        warn "Starship already installed"
        return
    fi

    info "Installing Starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- --yes
    success "Starship installed"
}

# ------------------------------------------------------------
# 4. zoxide (smarter cd)
# ------------------------------------------------------------
install_zoxide() {
    if command -v zoxide &>/dev/null; then
        warn "zoxide already installed"
        return
    fi

    info "Installing zoxide..."
    local github_token="${GITHUB_TOKEN:-}"
    if [ -n "$github_token" ]; then
        curl -sS -H "Authorization: token $github_token" https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
    else
        curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
    fi
    success "zoxide installed"
}

# ------------------------------------------------------------
# 5. Stow dotfiles packages
# ------------------------------------------------------------
migrate_legacy_home_symlinks() {
    local legacy_dir="$SCRIPT_DIR/home"

    if [ ! -d "$legacy_dir" ]; then
        return
    fi

    if legacy_link_target "$HOME/.gitconfig" "$legacy_dir/.gitconfig"; then
        info "Removing legacy ~/.gitconfig symlink from home/ layout"
        rm "$HOME/.gitconfig"
    fi

    if legacy_link_target "$HOME/.zshrc" "$legacy_dir/.zshrc"; then
        info "Removing legacy ~/.zshrc symlink from home/ layout"
        rm "$HOME/.zshrc"
    fi

    if legacy_link_target "$HOME/.tmux.conf" "$legacy_dir/.tmux.conf"; then
        info "Removing legacy ~/.tmux.conf symlink from home/ layout"
        rm "$HOME/.tmux.conf"
    fi
}

stow_packages() {
    info "Stowing dotfiles packages..."

    migrate_legacy_home_symlinks
    cd "$SCRIPT_DIR"
    stow --restow --dir "$SCRIPT_DIR" --target "$HOME" git zsh starship nvim tmux
    success "Dotfiles stowed"
}

# ------------------------------------------------------------
# 6. Set default shell to zsh
# ------------------------------------------------------------
set_shell() {
    if [[ "$SHELL" == */zsh ]]; then
        warn "zsh is already the default shell"
        return
    fi

    info "Setting zsh as default shell..."
    chsh -s "$(command -v zsh)"
    success "Default shell set to zsh — restart your terminal"
}

# ------------------------------------------------------------
# Main
# ------------------------------------------------------------
main() {
    info "Starting Ubuntu/WSL dotfiles bootstrap from $SCRIPT_DIR"

    install_packages
    install_neovim
    install_starship
    install_zoxide
    stow_packages
    set_shell

    success "Done! Start a new zsh session to finish setup."
    echo ""
    echo "  First launch of zsh: Zinit and plugins will auto-install"
    echo "  First launch of nvim: Lazy.nvim and plugins will auto-install"
}

main "$@"
