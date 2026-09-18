#!/bin/sh

conf="$HOME/.config/i3/config"

[ -f "$conf" ] && sed -i "s/^# \(.*\) # confloose by leo \[no-terminal\]$/\1/" "$conf"
i3-msg restart
