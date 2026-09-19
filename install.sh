#!/usr/bin/env bash
# Flint bootstrap: preserve private settings, back up conflicts, then link configs.
# Package and extension installation are opt-in; running sessions are left alone.
set -euo pipefail

# Options ---------------------------------------------------------------------

ROOT="$(cd "$(dirname "$0")" && pwd)"
packages=false
desktop=false
extensions=false

for arg in "$@"; do
    case "$arg" in
        --packages) packages=true ;;
        --desktop)
            desktop=true
            packages=true
            ;;
        --extensions) extensions=true ;;
        --stow) ;; # Compatibility with the old link-only invocation.
        --help)
            printf '%s\n' 'Usage: ./install.sh [--packages] [--desktop] [--extensions]'
            exit 0
            ;;
        *)
            printf 'Unknown option: %s\n' "$arg" >&2
            exit 2
            ;;
    esac
done

# SSH includes use a fixed path for portability across non-shell applications.
if [[ ${XDG_CONFIG_HOME:-$HOME/.config} != "$HOME/.config" ]]; then
    printf '%s\n' 'Flint currently requires XDG_CONFIG_HOME=$HOME/.config.' >&2
    exit 1
fi

# Optional dependencies -------------------------------------------------------

if $packages; then
    case "$(uname -s)" in
        Darwin)
            if ! command -v brew >/dev/null; then
                printf '%s\n' 'Install Homebrew from https://brew.sh, then rerun.' >&2
                exit 1
            fi
            if $desktop; then
                brew bundle --file="$ROOT/Brewfile"
            else
                brew install git zsh vim tmux fzf ripgrep fd bat eza zoxide python
            fi
            ;;
        Linux)
            if ! command -v apt-get >/dev/null; then
                printf '%s\n' 'Install dependencies manually on non-apt Linux.' >&2
                exit 1
            fi
            sudo apt-get update
            sudo apt-get install -y git zsh vim tmux fzf ripgrep fd-find bat zoxide python3 ncurses-term
            if $desktop; then
                printf '%s\n' 'Install VS Code, Ghostty, and Obsidian from their official Linux downloads.'
            fi
            ;;
        *)
            printf '%s\n' 'Unsupported operating system.' >&2
            exit 1
            ;;
    esac

    # Reuse existing Oh My Zsh installs; only fresh installs use the XDG path.
    omz="${XDG_DATA_HOME:-$HOME/.local/share}/oh-my-zsh"
    if [[ ! -d $omz && ! -d $HOME/.oh-my-zsh ]]; then
        git clone --depth 1 https://github.com/ohmyzsh/ohmyzsh.git "$omz"
    fi
    [[ -d $omz ]] || omz="$HOME/.oh-my-zsh"
    for plugin in zsh-autosuggestions zsh-syntax-highlighting; do
        [[ -d $omz/custom/plugins/$plugin ]] ||
            git clone --depth 1 "https://github.com/zsh-users/$plugin.git" "$omz/custom/plugins/$plugin"
    done
fi
if ! command -v python3 >/dev/null; then
    printf '%s\n' 'python3 is required; use --packages.' >&2
    exit 1
fi

# Backups and safe linking ----------------------------------------------------

umask 077
config="$HOME/.config/flint"
local_dir="$config/local"
state="${XDG_STATE_HOME:-$HOME/.local/state}/flint"

mkdir -p "$local_dir" "$state/backups"
backup="$(mktemp -d "$state/backups/install.XXXXXXXX")"
chmod 700 "$local_dir"

# Existing home symlinks may already point at edited repository files.
# Keep the committed baseline too, so their old contents remain recoverable.
if git -C "$ROOT" rev-parse --verify HEAD >/dev/null 2>&1; then
    git -C "$ROOT" archive HEAD -o "$backup/repository-HEAD.tar"
fi

# Save replaced files with their original home-relative path.
save() {
    local dest="$1"
    local relative="${1#"$HOME"/}"

    if [[ -e $dest || -L $dest ]]; then
        mkdir -p "$backup/$(dirname "$relative")"
        cp -pP "$dest" "$backup/$relative"
    fi
}

link() {
    local src="$1"
    local dest="$2"

    [[ -L $dest && $(readlink "$dest") == "$src" ]] && return 0
    if [[ -d $dest && ! -L $dest ]]; then
        printf 'Refusing to replace directory: %s\n' "$dest" >&2
        exit 1
    fi
    save "$dest"
    mkdir -p "$(dirname "$dest")"
    ln -sfn "$src" "$dest"
}

# Private settings and history ------------------------------------------------

# Preserve local overrides before replacing any entry points.
if [[ -f $HOME/.zshrc.local ]]; then
    if [[ -e $local_dir/zshrc ]]; then
        printf '%s\n' 'Both local zsh files exist; leaving ~/.zshrc.local as a compatibility override.'
    else
        cp -p "$HOME/.zshrc.local" "$local_dir/zshrc"
        save "$HOME/.zshrc.local"
        mv "$HOME/.zshrc.local" "$backup/migrated-zshrc.local"
    fi
fi

[[ -e $local_dir/zshrc ]] || cp "$ROOT/config/examples/zshrc" "$local_dir/zshrc"
if [[ -f $HOME/.zshenv && ! -L $HOME/.zshenv && ! -e $local_dir/zshenv ]]; then
    cp -p "$HOME/.zshenv" "$local_dir/zshenv"
fi
if [[ ! -e $local_dir/ssh.conf ]]; then
    if [[ -f $HOME/.ssh/config && ! -L $HOME/.ssh/config ]]; then
        cp -p "$HOME/.ssh/config" "$local_dir/ssh.conf"
    else
        cp "$ROOT/config/examples/ssh.conf" "$local_dir/ssh.conf"
    fi
fi

# Preserve a real Git config; old Flint symlinks already have a shared identity.
if [[ -f $HOME/.gitconfig && ! -L $HOME/.gitconfig && ! -e $local_dir/gitconfig ]]; then
    cp -p "$HOME/.gitconfig" "$local_dir/gitconfig"
fi

# Snapshot history, but keep the old file for shells that are still running.
mkdir -p "${XDG_STATE_HOME:-$HOME/.local/state}/zsh"
if [[ -f $HOME/.zsh_history && ! -e ${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history ]]; then
    cp -p "$HOME/.zsh_history" "${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
fi

# Shared config links ---------------------------------------------------------

for file in "$ROOT"/config/flint/*; do
    link "$file" "$config/$(basename "$file")"
done

# Link application entry points directly; no duplicate wrapper files in the repo.
link "$ROOT/config/flint/zshrc" "$HOME/.zshrc"
link "$ROOT/config/flint/zshenv" "$HOME/.zshenv"
link "$ROOT/config/flint/gitconfig" "$HOME/.gitconfig"
link "$ROOT/config/flint/tmux.conf" "$HOME/.tmux.conf"
link "$ROOT/config/flint/vimrc" "$HOME/.vimrc"
link "$ROOT/config/flint/ssh.conf" "$HOME/.ssh/config"

# Git ignore ------------------------------------------------------------------

# Git ignore is additive: retain private patterns in a separate local file.
if [[ -f $HOME/.config/git/ignore && ! -L $HOME/.config/git/ignore && ! -e $local_dir/gitignore ]]; then
    cp -p "$HOME/.config/git/ignore" "$local_dir/gitignore"
fi
save "$HOME/.config/git/ignore"
mkdir -p "$HOME/.config/git"
# Do not follow an old symlink when writing a generated file.
ignore_tmp="$(mktemp "$HOME/.config/git/ignore.XXXXXXXX")"
cat "$ROOT/config/flint/gitignore" > "$ignore_tmp"
[[ ! -f $local_dir/gitignore ]] || cat "$local_dir/gitignore" >> "$ignore_tmp"
mv -f "$ignore_tmp" "$HOME/.config/git/ignore"

# Ghostty ---------------------------------------------------------------------

# Ghostty loads both XDG and macOS configs. Keep only one entry point.
# Archive old locations so duplicate loads cannot reintroduce cycle warnings.
ghostty_legacy=("$HOME/.config/ghostty/config")
if [[ $(uname -s) == Darwin ]]; then
    native="$HOME/Library/Application Support/com.mitchellh.ghostty"
    ghostty_legacy+=("$native/config" "$native/config.ghostty")
fi
for file in "${ghostty_legacy[@]}"; do
    if [[ -f $file || -L $file ]]; then
        relative="${file#"$HOME"/}"
        mkdir -p "$backup/$(dirname "$relative")"
        mv "$file" "$backup/$relative"
    fi
done
link "$ROOT/config/flint/ghostty.conf" "$HOME/.config/ghostty/config.ghostty"

# VS Code and private file permissions ----------------------------------------

python3 "$ROOT/scripts/vscode.py" "$backup"
for file in "$local_dir"/*; do
    [[ ! -f $file || -L $file ]] || chmod 600 "$file"
done
if $extensions; then
    if ! command -v code >/dev/null; then
        printf '%s\n' 'Install the code command in PATH first.' >&2
        exit 1
    fi
    while IFS= read -r extension; do
        [[ -z $extension || $extension == \#* ]] || code --install-extension "$extension"
    done < "$ROOT/config/vscode/extensions.txt"
fi

printf 'Installed. Backup: %s\nOpen a new terminal; running sessions were not reloaded.\n' "$backup"
