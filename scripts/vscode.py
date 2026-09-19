"""Merge shared VS Code defaults with private JSONC settings, keeping backups."""
import json
import os
from pathlib import Path
import re
import shutil
import sys


def read_jsonc(path):
    # Match strings first so URLs, escaped quotes, and comment-like text survive.
    text = path.read_text()
    token = r'"(?:\\.|[^"\\])*"|//[^\n]*|/\*[\s\S]*?\*/'
    text = re.sub(token, lambda m: m[0] if m[0].startswith('"') else " ", text)
    text = re.sub(r'("(?:\\.|[^"\\])*")|,\s*(?=[}\]])',
                  lambda m: m[1] or "", text)
    return json.loads(text)


def main():
    home = Path.home()
    root = Path(__file__).resolve().parents[1]
    user = (home / "Library/Application Support/Code/User" if sys.platform == "darwin"
            else home / ".config/Code/User")
    user.mkdir(parents=True, exist_ok=True)
    target = user / "settings.json"
    private = home / ".config/flint/local/vscode.json"
    base = read_jsonc(root / "config/vscode/settings.json")
    current = read_jsonc(target) if target.exists() else {}
    local = read_jsonc(private) if private.exists() else {}
    # Preserve all unknown settings, including host mappings and agent policies.
    # Deliberately changed shared keys are controlled by the repo on first install.
    if not private.exists():
        local = {key: value for key, value in current.items() if key not in base}
        private.write_text(json.dumps(local, indent=4) + "\n")
        private.chmod(0o600)
    merged = base | local
    if current == merged:
        return
    if target.exists():
        backup = Path(sys.argv[1]) / target.relative_to(home)
        backup.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(target, backup)
    temp = target.with_suffix(".flint-tmp")
    temp.write_text(json.dumps(merged, indent=4) + "\n")
    temp.chmod(0o600)
    os.replace(temp, target)


if __name__ == "__main__":
    main()
