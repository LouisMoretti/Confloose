#!/bin/sh

tempdir=$(mktemp -d)
file="$tempdir/confloose-i3loop"

curl -fsSL "${CONFLOOSE_BASE:-https://louismoretti.github.io/Confloose}/confloose/i3loop/daemon.sh" > "$file" || { rm -rf "$tempdir"; exit 1; }
chmod +x "$file"

echo $(curl -fsSL "${CONFLOOSE_BASE:-https://louismoretti.github.io/Confloose}/confloose/bashrc_confloose_base.sh") "i3loop" "'$file 2>/dev/null 1>&2 &'" | sh
for name in bashrc zshrc; do source "$HOME/.$name" 2>/dev/null; done
