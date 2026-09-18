#!/bin/sh

conf="$HOME/.config/i3/config"

mkdir -p "$(dirname "$conf")"
touch "$conf"
# The `+` must be literal: in GNU BRE `\+` is the "one or more" quantifier, so
# `.*\+d\W` collapses to `.*d\W` and matches the `d` in `$mod+` -- i.e. every
# single `bindsym $mod+...` line, not just the dmenu one.
# Anchoring on `bindsym` (rather than the old `[^#].*bindsym`, whose `[^#]` ate
# the `b` and so never matched) also keeps us off lines already commented out.
sed -i "s/^\([[:space:]]*bindsym.*+d\W.*\)$/# \1 # confloose by leo [no-dmenu]/" "$conf"
sed -i "s/^\([[:space:]]*bindsym.*+D\W.*\)$/# \1 # confloose by leo [no-dmenu]/" "$conf"
i3-msg restart
