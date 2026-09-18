#!/bin/sh

conf="$HOME/.config/i3/config"
tag="# confloose by leo [change-mod]"

[ -f "$conf" ] || exit 0
grep -qF -- "$tag" "$conf" || exit 0
# Mod1 <-> Mod4 is its own inverse.
sed -i "s/Mod4/TEMP_MOD/g" "$conf"
sed -i "s/Mod1/Mod4/g" "$conf"
sed -i "s/TEMP_MOD/Mod1/g" "$conf"
sed -i "/confloose by leo \[change-mod\]/d" "$conf"
i3-msg restart
