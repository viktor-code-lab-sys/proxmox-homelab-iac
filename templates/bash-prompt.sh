#!/usr/bin/env bash
# Red user@host prompt, appended once to ~/.bashrc of the template user.
set -euo pipefail
line='PS1="\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "'
grep -qxF "$line" "$HOME/.bashrc" || printf '%s\n' "$line" >> "$HOME/.bashrc"
