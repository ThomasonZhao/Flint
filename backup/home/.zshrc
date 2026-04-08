# ============================================================
# Zsh Configuration
# ============================================================
#
# Focus:
#   - systems / distributed systems / ML systems / security workflows
#   - fast navigation, search, and shell history
#   - practical helpers for git, build, Docker, Kubernetes, and debugging
#
# Homebrew packages:
#   brew install fzf bat fd eza zoxide htop tlrc
#   $(brew --prefix)/opt/fzf/install --all --no-bash --no-fish
#
# Custom Oh My Zsh plugins:
#   ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
#   git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
#   git clone https://github.com/zsh-users/zsh-syntax-highlighting $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
#   git clone https://github.com/MichaelAquilina/zsh-you-should-use $ZSH_CUSTOM/plugins/you-should-use
#   git clone https://github.com/fdellwing/zsh-bat $ZSH_CUSTOM/plugins/zsh-bat
#
# Layout:
#   1. Oh My Zsh bootstrap
#   2. Shell behavior and completion
#   3. PATH and environment
#   4. Aliases
#   5. Functions
#   6. Tool integrations
#   7. Local overrides
# ============================================================

# ------------------------------------------------------------
# Oh My Zsh bootstrap
# ------------------------------------------------------------

export ZSH="$HOME/.oh-my-zsh"

# Prompt theme
ZSH_THEME="robbyrussell"

# Oh My Zsh behavior
HYPHEN_INSENSITIVE="true"          # Treat `_` and `-` as equivalent in completion
HIST_STAMPS="yyyy-mm-dd"           # Show ISO-style timestamps in `history`
zstyle ':omz:update' mode auto     # Auto-update oh-my-zsh without prompting

# Plugins
# Built-in: git, sudo, extract, web-search, docker, docker-compose, kubectl
# Custom: zsh-autosuggestions, zsh-syntax-highlighting, you-should-use, zsh-bat
plugins=(
    git                        # Git aliases such as gst, gco, gp
    sudo                       # Double-ESC to prepend sudo
    extract                    # `extract archive.tar.gz`
    web-search                 # `google "query"` and similar helpers
    docker                     # Docker aliases and completions
    docker-compose             # Compose aliases and completions
    kubectl                    # Kubernetes aliases and completions
    zsh-autosuggestions        # History-based command suggestions
    you-should-use             # Suggest existing aliases
    zsh-bat                    # Bat integration helpers
    zsh-syntax-highlighting    # Live command syntax highlighting
)
source $ZSH/oh-my-zsh.sh


# ------------------------------------------------------------
# Shell behavior
# ------------------------------------------------------------

# History: large, deduplicated, and shared across sessions.
HISTSIZE=200000
SAVEHIST=200000
setopt HIST_IGNORE_ALL_DUPS    # Drop older duplicate entries
setopt HIST_FIND_NO_DUPS       # Skip duplicates during history search
setopt HIST_IGNORE_SPACE       # Ignore commands prefixed with a space
setopt HIST_REDUCE_BLANKS      # Trim superfluous blanks
setopt SHARE_HISTORY           # Share history across open shells
setopt INC_APPEND_HISTORY      # Append history immediately

# General shell options
setopt AUTO_CD                 # Enter directories by typing their name
setopt AUTO_PUSHD              # Maintain directory stack automatically
setopt CDABLE_VARS             # Allow `cd` into named variables
setopt EXTENDED_GLOB           # Better globbing for search-heavy workflows
setopt INTERACTIVE_COMMENTS    # Allow comments in interactive commands
setopt NO_BEEP                 # Disable the terminal bell
setopt PUSHD_IGNORE_DUPS       # Avoid duplicate directory stack entries
setopt PUSHD_SILENT            # Keep pushd/popd output quiet

# Command correction tends to get in the way of tool-heavy workflows.
unsetopt CORRECT

DIRSTACKSIZE=16


# ------------------------------------------------------------
# Completion
# ------------------------------------------------------------

# Keep completion menus responsive even with large CLIs.
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'


# ------------------------------------------------------------
# PATH and environment
# ------------------------------------------------------------

typeset -U path PATH

for dir in \
    "$HOME/.local/bin" \
    "$HOME/bin" \
    "$HOME/.cargo/bin" \
    "$HOME/go/bin" \
    "$HOME/.krew/bin"
do
    [[ -d "$dir" ]] && path=("$dir" $path)
done

export PATH
export XDG_CONFIG_HOME="$HOME/.config"
export EDITOR="vim"
export LANG=en_US.UTF-8
export PAGER="less"
export LESS="-FRX"


# ------------------------------------------------------------
# Aliases
# ------------------------------------------------------------

# Navigation and directory listing
if command -v eza &>/dev/null; then
    alias ls='eza --color=auto'
    alias ll='eza -lah --git --icons'
    alias la='eza -a'
    alias lt='eza -lah --sort=modified'
    alias lS='eza -lah --sort=size'
    alias tree='eza --tree --icons'
else
    alias ll='ls -lah'
    alias la='ls -A'
    alias lt='ls -lAhtr'
    alias lS='ls -lAhSr'
fi

# Core utility aliases
alias zshrc='${EDITOR:-vim} ~/.zshrc'
alias reload='source ~/.zshrc'
alias myip='curl -s ifconfig.me'
alias localip='ipconfig getifaddr en0'
alias ports='lsof -i -P -n | grep LISTEN'
alias tlrc='tldr'                              # Homebrew's tlrc package installs `tldr`
alias flushdns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'
alias cleanup='find . -name ".DS_Store" -type f -delete'
alias ..='cd ..'
alias ...='cd ../..'
alias h='history 0'

# Safety
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'

# Git helpers
# Some short forms already exist in the Oh My Zsh git plugin.
alias gpuo='git push -u origin HEAD'
alias glog5='git log --oneline -5'
alias gbrclean='git branch --merged | grep -v "\\*\\|main\\|master" | xargs -n 1 git branch -d'

# Build, systems, and cluster helpers
if command -v cmake &>/dev/null; then
    alias cdb='cmake -S . -B build -DCMAKE_BUILD_TYPE=Debug'
    alias cbr='cmake --build build -j$(sysctl -n hw.ncpu)'
    alias ctestd='ctest --test-dir build --output-on-failure'
fi

if command -v rg &>/dev/null; then
    alias todo='rg -n --hidden --glob "!{.git,node_modules,build,dist}" "TODO|FIXME|XXX|HACK"'
fi

if command -v docker &>/dev/null; then
    alias d='docker'
    alias dps='docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"'
    alias di='docker images'
fi

if command -v kubectl &>/dev/null; then
    alias k='kubectl'
    alias kgp='kubectl get pods -A -o wide'
    alias kgs='kubectl get svc -A'
    alias kgn='kubectl get nodes -o wide'
    alias kctx='kubectl config current-context'
    compdef k=kubectl
fi

# Language helpers
alias pip='python3 -m pip'
alias python='python3'
alias py='python3'


# ------------------------------------------------------------
# Functions
# ------------------------------------------------------------

# Create a directory and enter it.
mkcd() { mkdir -p "$1" && cd "$1"; }

# Jump to the repository root of the current git worktree.
croot() {
    local root
    root="$(git rev-parse --show-toplevel 2>/dev/null)" || {
        echo "Not inside a git repository" >&2
        return 1
    }
    cd "$root"
}

# Find files by name pattern.
if command -v fd &>/dev/null; then
    ff() { fd -i "$1"; }
else
    ff() { find . -type f -iname "*$1*" 2>/dev/null; }
fi

# Show disk usage sorted by size.
duh() { du -sh "${1:-.}"/* 2>/dev/null | sort -h; }

# Grep Python files in the current tree.
gpy() { grep -rn --include="*.py" "$@" .; }

# Grep common systems-language files in the current tree.
gsys() {
    rg -n --hidden \
        --glob '!{.git,node_modules,build,dist,target,.venv}' \
        --glob '*.{c,cc,cpp,cxx,h,hpp,rs,go,py,sh,sql,proto}' \
        "$@"
}

# Activate the nearest virtualenv while walking up the directory tree.
activate() {
    local dir="$PWD"
    while [[ "$dir" != "/" ]]; do
        if [[ -f "$dir/.venv/bin/activate" ]]; then
            source "$dir/.venv/bin/activate"
            echo "Activated: $dir/.venv"
            return 0
        elif [[ -f "$dir/venv/bin/activate" ]]; then
            source "$dir/venv/bin/activate"
            echo "Activated: $dir/venv"
            return 0
        fi
        dir="$(dirname "$dir")"
    done
    echo "No .venv or venv found in parent directories"
    return 1
}

# Create and activate a local virtualenv.
mkvenv() {
    python3 -m venv "${1:-.venv}" && source "${1:-.venv}/bin/activate"
    echo "Created and activated: ${1:-.venv}"
}

# Create a conventional build directory and enter it.
mkbuild() { mkdir -p "${1:-build}" && cd "${1:-build}"; }

# Print the absolute path of a file or directory.
fullpath() { echo "${1:-.}"(:A); }

# Show the process listening on a TCP port.
fport() {
    [[ -n "$1" ]] || { echo "usage: fport <port>" >&2; return 1; }
    lsof -nP -iTCP:"$1" -sTCP:LISTEN
}

# Search running processes by pattern.
psg() {
    [[ -n "$1" ]] || { echo "usage: psg <pattern>" >&2; return 1; }
    ps aux | rg -i --color=always "$1"
}

# Inspect the certificate served by a remote TLS endpoint.
tlspeek() {
    local host port
    host="$1"
    port="${2:-443}"
    [[ -n "$host" ]] || { echo "usage: tlspeek <host> [port]" >&2; return 1; }
    echo | openssl s_client -connect "${host}:${port}" -servername "$host" 2>/dev/null \
        | openssl x509 -noout -subject -issuer -dates -ext subjectAltName
}

# Start a lightweight local file server.
serve() { python3 -m http.server "${1:-8000}"; }

# Prefer `docker compose`, but fall back to `docker-compose`.
dc() {
    if docker compose version >/dev/null 2>&1; then
        docker compose "$@"
    else
        command docker-compose "$@"
    fi
}

# Show or set the current Kubernetes namespace.
kns() {
    if [[ -z "$1" ]]; then
        kubectl config view --minify --output 'jsonpath={..namespace}'
        echo
    else
        kubectl config set-context --current --namespace "$1"
    fi
}


# ------------------------------------------------------------
# Terminal / remote-session behavior
# ------------------------------------------------------------

# Reset the kitty keyboard protocol after SSH exits.
# This helps terminals such as Ghostty and Kitty recover cleanly.
ssh() {
    command ssh "$@"
    printf '\e[<u' 2>/dev/null
}


# ------------------------------------------------------------
# Tool integrations
# ------------------------------------------------------------

# Better man page rendering with bat.
if command -v bat &>/dev/null; then
    export BAT_THEME="ansi"
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

# FZF keybindings and defaults.
if [[ -f ~/.fzf.zsh ]]; then
    source ~/.fzf.zsh
    export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

    # Use fd for file and directory discovery.
    if command -v fd &>/dev/null; then
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
    fi

    # Preview files with bat in Ctrl+T.
    if command -v bat &>/dev/null; then
        export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always {} 2>/dev/null | head -100'"
    fi
fi

# Optional tool-specific completions / hooks.

# uv / uvx
# . "$HOME/.local/bin/env"
# eval "$(uvx --generate-shell-completion zsh)"
# eval "$(uv generate-shell-completion zsh)"

# Google Cloud SDK
# if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/google-cloud-sdk/path.zsh.inc"; fi
# if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/google-cloud-sdk/completion.zsh.inc"; fi

# zoxide directory jumping
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
fi

# Prefer bat for plain file viewing when available.
if command -v bat &>/dev/null; then
    alias cat='bat --paging=never --style=plain'
fi


# ------------------------------------------------------------
# Local overrides
# ------------------------------------------------------------

# Put machine-specific settings here:
#   - API tokens
#   - private aliases
#   - per-machine PATH additions
#   - temporary experiments
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# ------------------------------------------------------------
# Personal Stuff
# ------------------------------------------------------------
export CS240LX_2026_PATH=/Users/thomason/Dev/Stanford-CS240LX-EmbOS

true  # Ensure clean exit code
