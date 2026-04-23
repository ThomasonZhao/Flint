#!/usr/bin/env bash
# Flint — dotfile bootstrap
# Usage: ./install.sh           (full install)
#        ./install.sh --stow    (stow only, skip tool installation)
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
STOW_ONLY=false
[[ "${1:-}" == "--stow" ]] && STOW_ONLY=true

# ── Helpers ───────────────────────────────────────────────────

info()  { printf '\033[1;34m::\033[0m %s\n' "$*"; }
ok()    { printf '\033[1;32m✓\033[0m  %s\n' "$*"; }
skip()  { printf '\033[1;33m→\033[0m  %s (already installed)\n' "$*"; }

need() {
    if ! command -v "$1" &>/dev/null; then
        return 0  # needs install
    fi
    return 1      # already present
}

# ── Homebrew ──────────────────────────────────────────────────

install_homebrew() {
    if need brew; then
        info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        # Make brew available in the current session
        if [[ -f /opt/homebrew/bin/brew ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [[ -f /usr/local/bin/brew ]]; then
            eval "$(/usr/local/bin/brew shellenv)"
        fi
        ok "Homebrew"
    else
        skip "Homebrew"
    fi
}

# ── Homebrew packages ─────────────────────────────────────────

BREW_PACKAGES=(
    stow        # dotfile symlink manager
    fzf         # fuzzy finder
    bat         # cat with syntax highlighting
    fd          # fast find alternative
    eza         # modern ls
    zoxide      # smarter cd
    htop        # process viewer
    tlrc        # tldr client
    ripgrep     # fast grep
)

install_brew_packages() {
    info "Installing Homebrew packages..."
    local installed
    installed="$(brew list --formula -1 2>/dev/null)"
    for pkg in "${BREW_PACKAGES[@]}"; do
        if echo "$installed" | grep -qx "$pkg"; then
            skip "$pkg"
        else
            brew install "$pkg"
            ok "$pkg"
        fi
    done

    # fzf key bindings and completion (idempotent)
    if [[ ! -f ~/.fzf.zsh ]]; then
        "$(brew --prefix)/opt/fzf/install" --all --no-bash --no-fish
        ok "fzf shell integration"
    fi
}

# ── Oh My Zsh ─────────────────────────────────────────────────

install_oh_my_zsh() {
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        info "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        ok "Oh My Zsh"
    else
        skip "Oh My Zsh"
    fi
}

# ── Oh My Zsh custom plugins ─────────────────────────────────

install_omz_plugins() {
    info "Installing Oh My Zsh custom plugins..."
    local custom_dir="$HOME/.oh-my-zsh/custom"
    local -a names urls
    names=(zsh-autosuggestions   zsh-syntax-highlighting   you-should-use   zsh-bat)
    urls=(
        "https://github.com/zsh-users/zsh-autosuggestions"
        "https://github.com/zsh-users/zsh-syntax-highlighting"
        "https://github.com/MichaelAquilina/zsh-you-should-use"
        "https://github.com/fdellwing/zsh-bat"
    )
    local i
    for (( i=0; i<${#names[@]}; i++ )); do
        local dest="$custom_dir/plugins/${names[$i]}"
        if [[ -d "$dest" ]]; then
            skip "${names[$i]}"
        else
            git clone --depth 1 "${urls[$i]}" "$dest"
            ok "${names[$i]}"
        fi
    done
}

# ── iTerm2 shell integration ─────────────────────────────────

install_iterm2_integration() {
    if [[ -f "$HOME/.iterm2_shell_integration.zsh" ]]; then
        skip "iTerm2 shell integration"
    else
        info "Installing iTerm2 shell integration..."
        curl -fsSL https://iterm2.com/shell_integration/zsh -o "$HOME/.iterm2_shell_integration.zsh"
        ok "iTerm2 shell integration"
    fi
}

# ── Stow dotfiles ────────────────────────────────────────────

PACKAGES=(
    zsh
    git
    vim
    tmux
)

stow_packages() {
    info "Stowing packages from $DOTFILES_DIR → \$HOME"
    cd "$DOTFILES_DIR"
    for pkg in "${PACKAGES[@]}"; do
        if [[ -d "$pkg" ]]; then
            # Stow without --adopt first. If it fails due to existing
            # files, use --adopt to pull them in, then restore repo versions.
            if ! stow -v -t "$HOME" "$pkg" 2>/dev/null; then
                # --adopt moves existing home files into the repo, then symlinks.
                stow -v --adopt -t "$HOME" "$pkg"
                # Restore only tracked files that --adopt overwrote,
                # leaving uncommitted (new) repo content untouched.
                git -C "$DOTFILES_DIR" checkout HEAD -- "$pkg" 2>/dev/null || true
            fi
            ok "$pkg"
        else
            skip "$pkg (directory not found)"
        fi
    done
}

# ── Main ──────────────────────────────────────────────────────

main() {
    echo
    info "Flint — dotfile bootstrap"
    echo

    if [[ "$STOW_ONLY" == true ]]; then
        stow_packages
    else
        install_homebrew
        install_brew_packages
        install_oh_my_zsh
        install_omz_plugins
        install_iterm2_integration
        stow_packages
    fi

    echo
    info "Done. Restart your shell or run: source ~/.zshrc"
}

main
