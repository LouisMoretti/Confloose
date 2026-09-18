#!/bin/sh

dir="$HOME/.config/alacritty"
file="$dir/alacritty.toml"
backup="$dir/alacritty.toml.bak"
absent="$dir/alacritty.toml.absent"

if [ -f "$absent" ]; then
    rm -f "$file" "$absent" "$backup"
elif [ -f "$backup" ]; then
    cp "$backup" "$file"
    rm -f "$backup"
fi
