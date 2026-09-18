#!/bin/sh

conf="$HOME/.config/i3/config"

mkdir -p "$(dirname "$conf")"
touch "$conf"
sed -i "s/^\([[:space:]]*bindsym.*+Return .*\)$/# \1 # confloose by leo [no-terminal]/" "$conf"
i3-msg restart
