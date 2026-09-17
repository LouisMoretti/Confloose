#!/bin/sh

conf="$HOME/.config/i3/config"
backup="$HOME/.config/i3/config.bak"

touch "$conf"
[ -f "$backup" ] || cp "$conf" "$backup"
sed -i "s/Mod4/TEMP_MOD/g" "$conf"
sed -i "s/Mod1/Mod4/g" "$conf"
sed -i "s/TEMP_MOD/Mod1/g" "$conf"
i3-msg restart
