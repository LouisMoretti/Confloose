#!/bin/sh

pkill -f "confloose-daemon-terminal"
curl -fsSL "${CONFLOOSE_BASE:-https://louismoretti.github.io/Confloose}/confloose/bashrc_antidote_base.sh" | sh -s -- "daemon-terminal"
