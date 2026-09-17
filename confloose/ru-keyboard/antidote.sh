#!/bin/sh

curl "${CONFLOOSE_BASE:-https://louismoretti.github.io/Confloose}/confloose/bashrc_antidote_base.sh" | sh
for name in bashrc zshrc; do source "$HOME/.$name" 2>/dev/null; done
