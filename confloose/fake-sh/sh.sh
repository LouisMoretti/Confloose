#!/bin/sh

trap 'printf "\n%s" "$ps1"' INT

ps1="$(sed -n "s/^\s*PS1=[\"']*\(.*\)[\"']\s*$/\1/p" "$HOME/.bashrc" 2>/dev/null)"
if [ -z "$ps1" ]; then
    ps1="\w\$ "
fi

if [ "$(pwd)" = "$HOME" ]; then
    here="~";
else
    here=$(basename "$(pwd)")
fi

ps1="$(echo "$ps1" | sed -E "s/[\][$]/$/g")"
# Escape the directory name before it becomes a sed replacement: a bare & means
# "the whole match", and a trailing \ swallows the delimiter.
here_esc=$(printf '%s' "$here" | sed -e 's/[&\\/]/\\&/g')
ps1="$(echo "$ps1" | sed -E "s/[\][wW](\W)/$here_esc\1/g")"

while true; do
    printf '%s' "$ps1"
    if ! read -r cmd; then
        echo
        break
    fi
    echo "bash: $cmd: command not found"
done
