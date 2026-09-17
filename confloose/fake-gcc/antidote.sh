#!/bin/sh

if [ -n "$AFS_DIR" ]; then
    dir="$AFS_DIR/bin"
else
    dir="$HOME/.local/bin"
fi

for name in gcc cc clang; do rm -f "$dir/$name"; done

curl -fsSL "${CONFLOOSE_BASE:-https://louismoretti.github.io/Confloose}/confloose/bashrc_antidote_base.sh" | sh -s -- "fake-gcc"
for name in bashrc zshrc; do source "$HOME/.$name" 2>/dev/null; done
