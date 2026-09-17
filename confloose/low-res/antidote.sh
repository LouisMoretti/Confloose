#!/bin/sh

conf="$HOME/.config/i3/config"
backup="$HOME/.config/i3/config.bak"

[ -f "$backup" ] && mv "$backup" "$conf"

IFS=$'\n'
for output in $(xrandr | sed -nE "s/(^\S+) connected.*$/\1/p"); do
    # Config restore above handles persistence; --auto avoids hardcoding a
    # mode that may not exist on this display.
    xrandr --output "$output" --auto || true
done
i3-msg restart
