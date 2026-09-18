#!/bin/sh

conf="$HOME/.config/i3/config"
tag="# confloose by leo [no-mod]"

[ -f "$conf" ] || exit 0
grep -qF -- "$tag" "$conf" || exit 0
sed -i "s/Mod3/Mod1/g" "$conf"
sed -i "s/Mod5/Mod4/g" "$conf"
sed -i "/confloose by leo \[no-mod\]/d" "$conf"
i3-msg restart
