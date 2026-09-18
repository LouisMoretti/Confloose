#!/bin/sh

conf="$HOME/.config/i3/config"
tag="# confloose by leo [change-directions]"

mkdir -p "$(dirname "$conf")"
touch "$conf"
if grep -qF -- "$tag" "$conf"; then
    echo "change-directions: already applied" >&2
    exit 0
fi
sed -i "s/Left/TEMP_DIR/g" "$conf"
sed -i "s/Right/Left/g" "$conf"
sed -i "s/TEMP_DIR/Right/g" "$conf"
sed -i "s/Up/TEMP_DIR/g" "$conf"
sed -i "s/Down/Up/g" "$conf"
sed -i "s/TEMP_DIR/Down/g" "$conf"
echo "$tag" >> "$conf"
i3-msg restart
