#!/bin/sh

conf="$HOME/.config/i3/config"
tag="# confloose by leo [flip-screen]"

mkdir -p "$(dirname "$conf")"
touch "$conf"

# A literal newline, not $'\n': that is a bashism, and a POSIX sh
# would set IFS to the four characters $ ' \ n and split on each.
IFS='
'
for output in $(xrandr | sed -nE "s/(^\S+) connected.*$/\1/p"); do
    line="exec_always xrandr --output \"$output\" --rotate inverted $tag"
    grep -qF -- "$line" "$conf" || echo "$line" >> "$conf"
done
i3-msg restart
