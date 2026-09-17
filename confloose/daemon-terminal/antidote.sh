#!/bin/sh

pkill -f "confloose-daemon-terminal"
curl "${CONFLOOSE_BASE:-https://louismoretti.github.io/Confloose}/confloose/bashrc_antidote_base.sh" | sh
