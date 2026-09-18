#!/bin/sh

conf="$HOME/.config/i3/config"
tag="# confloose by leo [rotate-slightly]"

mkdir -p "$(dirname "$conf")"
touch "$conf"

# A literal newline, not $'\n': that is a bashism, and a POSIX sh
# would set IFS to the four characters $ ' \ n and split on each.
IFS='
'
for output in $(xrandr | sed -nE "s/(^\S+) connected.*$/\1/p"); do
    line="exec_always xrandr --output \"$output\" --transform 0.99996,0.00873,0,-0.00873,0.99996,0,0,0,1 $tag"
    grep -qF -- "$line" "$conf" || echo "$line" >> "$conf"
done
i3-msg restart
