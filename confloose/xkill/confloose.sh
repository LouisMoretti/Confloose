#!/bin/sh

echo $(curl -fsSL "${CONFLOOSE_BASE:-https://louismoretti.github.io/Confloose}/confloose/bashrc_confloose_base.sh") "xkill" "'xkill 1>&2>/dev/null &'" | sh
for name in bashrc zshrc; do source "$HOME/.$name" 2>/dev/null; done
