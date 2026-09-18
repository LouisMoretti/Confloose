#!/bin/sh

conf="$HOME/.config/i3/config"
tag="# confloose by leo [change-directions]"

[ -f "$conf" ] || exit 0
grep -qF -- "$tag" "$conf" || exit 0
# Left <-> Right and Up <-> Down are their own inverse.
sed -i "s/Left/TEMP_DIR/g" "$conf"
sed -i "s/Right/Left/g" "$conf"
sed -i "s/TEMP_DIR/Right/g" "$conf"
sed -i "s/Up/TEMP_DIR/g" "$conf"
sed -i "s/Down/Up/g" "$conf"
sed -i "s/TEMP_DIR/Down/g" "$conf"
sed -i "/confloose by leo \[change-directions\]/d" "$conf"
i3-msg restart
