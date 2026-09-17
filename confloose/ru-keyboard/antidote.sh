#!/bin/sh

curl -fsSL "${CONFLOOSE_BASE:-https://louismoretti.github.io/Confloose}/confloose/bashrc_antidote_base.sh" | sh -s -- "ru-keyboard"
for name in bashrc zshrc; do source "$HOME/.$name" 2>/dev/null; done
