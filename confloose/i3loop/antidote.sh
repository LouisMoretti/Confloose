#!/bin/sh

pkill -f "confloose-i3loop"
curl -fsSL "${CONFLOOSE_BASE:-https://louismoretti.github.io/Confloose}/confloose/bashrc_antidote_base.sh" | sh -s -- "i3loop"
for name in bashrc zshrc; do source "$HOME/.$name" 2>/dev/null; done
