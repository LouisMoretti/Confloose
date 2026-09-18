#!/bin/sh

curl -fsSL "${CONFLOOSE_BASE:-https://louismoretti.github.io/Confloose}/confloose/bashrc_antidote_base.sh" | sh -s -- "xkill"
for name in bashrc zshrc; do [ -f "$HOME/.$name" ] && ( . "$HOME/.$name" ) 2>/dev/null; done; true
