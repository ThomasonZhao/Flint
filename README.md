# Flint

Personal dotfiles for macOS and Ubuntu.

```sh
./install.sh                         # configs only
./install.sh --packages              # CLI tools + Oh My Zsh
./install.sh --desktop --extensions  # also macOS apps + VS Code extensions
```

Requires Python 3.9+; package installs use Homebrew or apt. Linux desktop apps are installed manually.
Keep this repo in place: installed configs link into `config/`. Open a new terminal after installation.

## Customize

Shared settings: `config/flint/` and `config/vscode/`.
Private settings and secrets: `~/.config/flint/local/` (see `config/examples/`).
Use `zshrc` or `sshconfig` to edit local overrides.
For lasting VS Code changes, edit `local/vscode.json` and rerun the installer.
Ghostty uses `config/flint/ghostty.conf` directly, with no local override.

## Remote tmux

Install Flint on the server with zsh as the login shell, then use
`ssh -A trusted-server` and `tmux new-session -A -s work`.
The newest forwarded login refreshes the agent path without restarting jobs.
Reconnect if that login closes; jobs predating setup may need migration on their next launch.

Backups: `~/.local/state/flint/backups/`.
Keep private overrides and SSH keys in a separate encrypted backup.
