#!/bin/sh

conf="$HOME/.config/i3/config"

[ -f "$conf" ] && sed -i "/confloose by leo \[rotate-slightly\]/d" "$conf"

# A literal newline, not $'\n': that is a bashism, and a POSIX sh
# would set IFS to the four characters $ ' \ n and split on each.
IFS='
'
for output in $(xrandr | sed -nE "s/(^\S+) connected.*$/\1/p"); do
    xrandr --output "$output" --transform none --rotate normal
done
i3-msg restart
