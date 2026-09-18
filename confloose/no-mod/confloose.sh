#!/bin/sh

conf="$HOME/.config/i3/config"
tag="# confloose by leo [no-mod]"

mkdir -p "$(dirname "$conf")"
touch "$conf"
if grep -qF -- "$tag" "$conf"; then
    echo "no-mod: already applied" >&2
    exit 0
fi
# no-mod and change-mod both remap Mod1/Mod4, so applying one on top of the
# other is contradictory: the second becomes a no-op, and its antidote then
# introduces a swap that was never applied. Refuse instead.
if grep -qF -- "# confloose by leo [change-mod]" "$conf"; then
    echo "no-mod: conflicts with change-mod, antidote that one first" >&2
    exit 1
fi
# Mod1 and Mod4 go to *distinct* unused modifiers so the mapping stays a
# bijection and the antidote can invert it. Sending both to Mod3 (as before)
# loses which was which and forces a whole-file snapshot, which is what used to
# let one i3 confloose clobber another.
# The antidote maps Mod3/Mod5 back to Mod1/Mod4, so pre-existing Mod3/Mod5
# bindings would be silently rewritten on the way out. Refuse instead.
if grep -qE "Mod3|Mod5" "$conf"; then
    echo "no-mod: config already uses Mod3/Mod5, refusing (not reversible)" >&2
    exit 1
fi
sed -i "s/Mod1/Mod3/g" "$conf"
sed -i "s/Mod4/Mod5/g" "$conf"
echo "$tag" >> "$conf"
i3-msg restart
