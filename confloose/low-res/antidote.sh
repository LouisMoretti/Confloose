#!/bin/sh

conf="$HOME/.config/i3/config"

[ -f "$conf" ] && sed -i "/confloose by leo \[low-res\]/d" "$conf"

# A literal newline, not $'\n': that is a bashism, and a POSIX sh
# would set IFS to the four characters $ ' \ n and split on each.
IFS='
'
for output in $(xrandr | sed -nE "s/(^\S+) connected.*$/\1/p"); do
    # --auto avoids hardcoding a mode that may not exist on this display.
    xrandr --output "$output" --auto || true
done
i3-msg restart
