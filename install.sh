#!/usr/bin/env bash
set -euo pipefail

# Dotfiles installation script - replaces Homesick
# Modern, dependency-free symlink management for dotfiles

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_HOME="$SCRIPT_DIR/home"
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
DRY_RUN="${DRY_RUN:-0}"

# Colors for output (disabled if not a tty)
if [ -t 1 ]; then
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  YELLOW='\033[1;33m'
  BLUE='\033[0;34m'
  NC='\033[0m' # No Color
else
  RED=''
  GREEN=''
  YELLOW=''
  BLUE=''
  NC=''
fi

# Logging functions
log_info() {
  echo -e "${BLUE}ℹ ${NC}$*"
}

log_success() {
  echo -e "${GREEN}✓ ${NC}$*"
}

log_warn() {
  echo -e "${YELLOW}⚠ ${NC}$*"
}

log_error() {
  echo -e "${RED}✗ ${NC}$*" >&2
}

# Show help
usage() {
  cat << EOF
Usage: $0 [OPTIONS]

Install dotfiles by creating symlinks from \$HOME to the dotfiles directory.

OPTIONS:
  -d, --dry-run       Show what would be done without making changes
  -f, --force         Overwrite existing symlinks
  -h, --help          Show this help message
  -s, --skip-submodules  Skip git submodule initialization
  -u, --uninstall     Remove all symlinks (restore from backup if available)

ENVIRONMENT:
  DRY_RUN=1           Same as --dry-run

EXAMPLES:
  # Install dotfiles (interactive for conflicts)
  \$ $0

  # See what would be installed
  \$ $0 --dry-run

  # Force install, overwriting existing files
  \$ $0 --force

  # Remove all installed symlinks
  \$ $0 --uninstall

EOF
  exit "${1:-0}"
}

# Execute action or show what would be done
execute() {
  if [ "$DRY_RUN" = "1" ]; then
    echo "  [DRY RUN] $*"
  else
    "$@"
  fi
}

# Ask user for confirmation
confirm() {
  local prompt="$1"
  local response
  
  if ! [ -t 0 ]; then
    # Not interactive, assume no
    return 1
  fi
  
  while true; do
    read -r -p "$prompt (y/N) " response
    case "$response" in
      [yY][eE][sS]|[yY])
        return 0
        ;;
      [nN][oO]|[nN]|'')
        return 1
        ;;
      *)
        echo "Please answer yes or no."
        ;;
    esac
  done
}

# Backup existing file
backup_file() {
  local file="$1"
  
  if [ ! -e "$file" ]; then
    return 0
  fi
  
  if [ ! -d "$BACKUP_DIR" ]; then
    execute mkdir -p "$BACKUP_DIR"
  fi
  
  local backup_path="$BACKUP_DIR/$(basename "$file")"
  log_warn "Backing up $file"
  execute cp -r "$file" "$backup_path"
}

# Create symlink
create_symlink() {
  local source="$1"
  local target="$2"
  local force="${3:-0}"
  
  # Skip if source doesn't exist
  if [ ! -e "$source" ]; then
    log_error "Source does not exist: $source"
    return 1
  fi
  
  # Handle existing target
  if [ -e "$target" ] || [ -L "$target" ]; then
    if [ -L "$target" ]; then
      # It's already a symlink
      local current_target
      current_target=$(readlink "$target")
      if [ "$current_target" = "$source" ]; then
        log_success "Already linked: $target"
        return 0
      else
        log_warn "Symlink mismatch: $target -> $current_target"
        if [ "$force" = "1" ]; then
          log_warn "Removing conflicting symlink"
          execute rm "$target"
        else
          if confirm "Overwrite symlink $target?"; then
            execute rm "$target"
          else
            log_warn "Skipped: $target"
            return 1
          fi
        fi
      fi
    else
      # It's a regular file
      log_warn "File exists: $target"
      if [ "$force" = "1" ]; then
        backup_file "$target"
        execute rm -r "$target"
      else
        if confirm "Overwrite file $target (will be backed up)?"; then
          backup_file "$target"
          execute rm -r "$target"
        else
          log_warn "Skipped: $target"
          return 1
        fi
      fi
    fi
  fi
  
  # Create parent directory if needed
  local parent_dir
  parent_dir=$(dirname "$target")
  if [ ! -d "$parent_dir" ]; then
    execute mkdir -p "$parent_dir"
  fi
  
  # Create the symlink
  execute ln -s "$source" "$target"
  log_success "Linked: $target"
}

# Remove symlink
remove_symlink() {
  local target="$1"
  
  if [ ! -L "$target" ]; then
    return 0
  fi
  
  execute rm "$target"
  log_success "Removed: $target"
}

# Find all dotfiles and create symlinks
install_dotfiles() {
  log_info "Installing dotfiles from $DOTFILES_HOME"

  if [ ! -d "$DOTFILES_HOME" ]; then
    log_error "Dotfiles directory not found: $DOTFILES_HOME"
    return 1
  fi
  
  local force="${1:-0}"
  local count=0
  
  # Find all files in DOTFILES_HOME and link them into $HOME.
  # Parent directories are created as needed by create_symlink.
  while IFS= read -r -d '' source_file; do
    # Get relative path from DOTFILES_HOME
    local rel_path="${source_file#$DOTFILES_HOME/}"
    local target_file="$HOME/$rel_path"
    
    # Skip certain directories
    if [[ "$rel_path" =~ ^\.vim/(bundle/|plugged/|undo/) ]]; then
      continue
    fi
    if [[ "$rel_path" =~ ^\.oh-my-zsh ]]; then
      continue
    fi
    if [[ "$rel_path" =~ ^\.local/share ]]; then
      continue
    fi
    
    # Create symlink for files
    if create_symlink "$source_file" "$target_file" "$force"; then
      count=$((count + 1))
    fi
  done < <(find "$DOTFILES_HOME" -mindepth 1 \( -type f -o -type l \) -print0)
  
  log_info "Installed $count symlinks"
}

# Uninstall dotfiles
uninstall_dotfiles() {
  log_info "Removing dotfiles symlinks"

  if [ ! -d "$DOTFILES_HOME" ]; then
    log_error "Dotfiles directory not found: $DOTFILES_HOME"
    return 1
  fi
  
  local count=0
  
  while IFS= read -r -d '' source_file; do
    local rel_path="${source_file#$DOTFILES_HOME/}"
    local target_file="$HOME/$rel_path"
    
    # Skip certain directories
    if [[ "$rel_path" =~ ^\.vim/(bundle/|plugged/|undo/) ]]; then
      continue
    fi
    if [[ "$rel_path" =~ ^\.oh-my-zsh ]]; then
      continue
    fi
    
    if [ -L "$target_file" ]; then
      remove_symlink "$target_file"
      count=$((count + 1))
    fi
  done < <(find "$DOTFILES_HOME" -mindepth 1 \( -type f -o -type l \) -print0)
  
  log_info "Removed $count symlinks"
  
  if [ -d "$BACKUP_DIR" ] && [ -n "$(ls -A "$BACKUP_DIR")" ]; then
    log_info "Backup available at: $BACKUP_DIR"
  fi
}

# Initialize git submodules
init_submodules() {
  if [ ! -d "$SCRIPT_DIR/.git" ]; then
    log_warn "Not a git repository, skipping submodule initialization"
    return 0
  fi
  
  log_info "Initializing git submodules"
  execute git -C "$SCRIPT_DIR" submodule update --init --recursive
  log_success "Submodules initialized"
}

ensure_oh_my_zsh() {
  local ohmyzsh_dir="$DOTFILES_HOME/.oh-my-zsh"

  if [ -f "$ohmyzsh_dir/oh-my-zsh.sh" ]; then
    return 0
  fi

  log_warn "Oh My Zsh not present in $ohmyzsh_dir; restoring from upstream"
  execute mkdir -p "$DOTFILES_HOME"

  if [ -d "$ohmyzsh_dir/.git" ]; then
    execute git -C "$ohmyzsh_dir" pull --ff-only
  else
    execute rm -rf "$ohmyzsh_dir"
    execute git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$ohmyzsh_dir"
  fi

  if [ -f "$ohmyzsh_dir/oh-my-zsh.sh" ]; then
    log_success "Oh My Zsh is ready"
    return 0
  fi

  log_error "Failed to prepare Oh My Zsh at $ohmyzsh_dir"
  return 1
}

# Main function
main() {
  local force=0
  local skip_submodules=0
  local uninstall=0
  
  # Parse arguments
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -d|--dry-run)
        DRY_RUN=1
        shift
        ;;
      -f|--force)
        force=1
        shift
        ;;
      -s|--skip-submodules)
        skip_submodules=1
        shift
        ;;
      -u|--uninstall)
        uninstall=1
        shift
        ;;
      -h|--help)
        usage 0
        ;;
      *)
        log_error "Unknown option: $1"
        usage 1
        ;;
    esac
  done
  
  # Show dry-run info
  if [ "$DRY_RUN" = "1" ]; then
    log_warn "Running in dry-run mode - no changes will be made"
  fi
  
  # Run requested operations
  if [ "$uninstall" = "1" ]; then
    uninstall_dotfiles
  else
    if [ "$skip_submodules" != "1" ]; then
      init_submodules
    fi
    ensure_oh_my_zsh
    install_dotfiles "$force"
  fi
  
  log_success "Done!"
}

# Run main function
main "$@"
