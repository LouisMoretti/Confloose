#!/bin/sh

conf="$HOME/.config/i3/config"

[ -f "$conf" ] && sed -i "/confloose by leo \[cheese\]/d" "$conf"

# A literal newline, not $'\n': that is a bashism, and a POSIX sh
# would set IFS to the four characters $ ' \ n and split on each.
IFS='
'
for pointer in $(xinput --list 2>/dev/null | sed -nE "s/^\W*(.+\w)\s+id=[0-9].*\Wpointer\W.*$/\1/p"); do
    xinput set-prop "$pointer" "Coordinate Transformation Matrix" 1 0 0 0 1 0 0 0 1
done

i3-msg restart
