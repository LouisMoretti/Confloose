#!/bin/sh

backup="$HOME/.config/i3/config.bak"
conf="$HOME/.config/i3/config"

[ -f "$backup" ] && mv "$backup" "$conf"
rm -f "$backup"
i3-msg restart
