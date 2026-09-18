#!/bin/sh

conf="$HOME/.config/i3/config"

# Remove only our own lines: a shared config.bak would clobber the other i3
# confloose and any edit the user made since.
[ -f "$conf" ] && sed -i "/confloose by leo \[tab-i3lock\]/d" "$conf"
i3-msg restart
