# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme.
ZSH_THEME="powerlevel10k/powerlevel10k"

# Disable auto-update of oh-my-zsh for better startup performance
DISABLE_AUTO_UPDATE="true"

# Disable marking untracked files as dirty (faster repo checks)
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Modern plugin set: core utilities and development tools
plugins=(
  git                    # git aliases and functions
  vi-mode               # vi keybindings
  asdf                  # version manager
  kubectl               # k8s completions
  npm                   # npm completions
  python                # python development
  tmux                  # tmux integration
  aws                   # aws cli completions
)


# Source oh-my-zsh (must come before plugin initialization)
source $ZSH/oh-my-zsh.sh

# Initialize fnm (Node Version Manager) - faster and modern replacement for nvm
if command -v fnm &> /dev/null; then
  eval "$(fnm env --use-on-cd)"
fi

# Initialize asdf version manager (if installed)
if [ -f "$HOME/.asdf/asdf.sh" ]; then
  . "$HOME/.asdf/asdf.sh"
  . "$HOME/.asdf/completions/asdf.bash"
fi

# Language and locale settings
if locale -a 2>/dev/null | grep -qi '^en_US\.utf8$'; then
  export LANG=en_US.UTF-8
  export LC_ALL=en_US.UTF-8
else
  export LANG=C.UTF-8
  export LC_ALL=C.UTF-8
fi

# Editor preference
export EDITOR=vim
export VISUAL=vim

# User binary paths
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

# Useful aliases
alias ll='ls -lah'
alias l='ls -lh'
alias ...='cd ../..'
alias ....='cd ../../..'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gd='git diff'
alias gl='git log --oneline -10'

# Load Powerlevel10k configuration
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
