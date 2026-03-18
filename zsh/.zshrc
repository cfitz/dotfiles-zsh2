# --------------------------
# Zinit bootstrap
# --------------------------
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
if [[ ! -d "$ZINIT_HOME" ]]; then
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# --------------------------
# Plugins
# --------------------------
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions

# --------------------------
# Completion
# --------------------------
autoload -Uz compinit && compinit

# --------------------------
# Language & locale
# --------------------------
if locale -a 2>/dev/null | grep -qi '^en_US\.utf8$'; then
    export LANG=en_US.UTF-8
    export LC_ALL=en_US.UTF-8
else
    export LANG=C.UTF-8
    export LC_ALL=C.UTF-8
fi

# --------------------------
# Editor
# --------------------------
export EDITOR=nvim
export VISUAL=nvim

# --------------------------
# PATH
# --------------------------
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

# --------------------------
# Tool initialization
# --------------------------

# Starship prompt
if command -v starship &>/dev/null; then
    eval "$(starship init zsh)"
fi

# zoxide (smarter cd)
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
fi

# fzf shell integration
if [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
    source /usr/share/doc/fzf/examples/key-bindings.zsh
fi
if [[ -f /usr/share/doc/fzf/examples/completion.zsh ]]; then
    source /usr/share/doc/fzf/examples/completion.zsh
fi

# fnm (Node version manager)
if command -v fnm &>/dev/null; then
    eval "$(fnm env --use-on-cd)"
fi

# asdf version manager
if [[ -f "$HOME/.asdf/asdf.sh" ]]; then
    source "$HOME/.asdf/asdf.sh"
fi

# AWS CLI completions
if command -v aws_completer &>/dev/null; then
    complete -C aws_completer aws
fi

# kubectl completions
if command -v kubectl &>/dev/null; then
    source <(kubectl completion zsh)
fi

# --------------------------
# Aliases
# --------------------------
alias vim='nvim'
alias ls='ls --color=auto'
alias ll='ls --color=auto -lah'
alias l='ls --color=auto -lh'
alias ...='cd ../..'
alias ....='cd ../../..'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gd='git diff'
alias gl='git log --oneline -10'

# --------------------------
# Machine-local secrets (not committed)
# --------------------------
[[ -f ~/.secrets.zsh ]] && source ~/.secrets.zsh
