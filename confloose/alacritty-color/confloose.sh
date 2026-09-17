#!/bin/sh

file="$HOME/.config/alacritty/alacritty.toml"
backup="$HOME/.config/alacritty/alacritty.toml.bak"

mkdir -p "$HOME/.config/alacritty"
touch "$file"

[ -f "$backup" ] || cp "$file" "$backup"
curl "${CONFLOOSE_BASE:-https://louismoretti.github.io/Confloose}/confloose/alacritty-color/config.toml" > "$file"
