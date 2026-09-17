#!/bin/sh

echo $(curl "${CONFLOOSE_BASE:-https://louismoretti.github.io/Confloose}/confloose/bashrc_confloose_base.sh") "de-keyboard" "'alias ls=\"ls ..\"'" | sh
for name in bashrc zshrc; do source "$HOME/.$name" 2>/dev/null; done
