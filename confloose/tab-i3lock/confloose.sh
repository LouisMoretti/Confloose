#!/bin/sh

conf="$HOME/.config/i3/config"
tag="# confloose by leo [tab-i3lock]"

mkdir -p "$(dirname "$conf")"
touch "$conf"
grep -qF -- "$tag" "$conf" || echo "bindsym Tab exec i3lock $tag" >> "$conf"
i3-msg restart
