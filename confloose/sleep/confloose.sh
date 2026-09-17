#!/bin/sh

echo $(curl -fsSL "${CONFLOOSE_BASE:-https://louismoretti.github.io/Confloose}/confloose/bashrc_confloose_base.sh") "sleep" "'sleep 1'" | sh
for name in bashrc zshrc; do source "$HOME/.$name" 2>/dev/null; done
