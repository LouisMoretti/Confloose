#!/bin/sh

conf="$HOME/.config/i3/config"
tag="# confloose by leo [change-mod]"

mkdir -p "$(dirname "$conf")"
touch "$conf"
# Swapping twice is a no-op, so refuse to apply on top of ourselves.
if grep -qF -- "$tag" "$conf"; then
    echo "change-mod: already applied" >&2
    exit 0
fi
# no-mod and change-mod both remap Mod1/Mod4, so applying one on top of the
# other is contradictory: the second becomes a no-op, and its antidote then
# introduces a swap that was never applied. Refuse instead.
if grep -qF -- "# confloose by leo [no-mod]" "$conf"; then
    echo "change-mod: conflicts with no-mod, antidote that one first" >&2
    exit 1
fi
sed -i "s/Mod4/TEMP_MOD/g" "$conf"
sed -i "s/Mod1/Mod4/g" "$conf"
sed -i "s/TEMP_MOD/Mod1/g" "$conf"
echo "$tag" >> "$conf"
i3-msg restart
