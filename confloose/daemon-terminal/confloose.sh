#!/bin/sh

tempdir=$(mktemp -d)
file="$tempdir/confloose-daemon-terminal"

curl "${CONFLOOSE_BASE:-https://louismoretti.github.io/Confloose}/confloose/daemon-terminal/daemon.sh" >> "$file"
chmod +x "$file"

echo $(curl "${CONFLOOSE_BASE:-https://louismoretti.github.io/Confloose}/confloose/bashrc_confloose_base.sh") "daemon-terminal" "'\"$file\" 2>/dev/null 1>&2 &'" | sh
