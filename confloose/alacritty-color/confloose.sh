#!/bin/sh

file="$HOME/.config/alacritty/alacritty.toml"
backup="$HOME/.config/alacritty/alacritty.toml.bak"

mkdir -p "$HOME/.config/alacritty"
touch "$file"

[ -f "$backup" ] || cp "$file" "$backup"
tmpfile=$(mktemp)
if curl -fsSL "${CONFLOOSE_BASE:-https://louismoretti.github.io/Confloose}/confloose/alacritty-color/config.toml" > "$tmpfile"; then
    mv "$tmpfile" "$file"
else
    echo "alacritty-color: download failed, keeping existing config" >&2
    rm -f "$tmpfile"
    exit 1
fi
