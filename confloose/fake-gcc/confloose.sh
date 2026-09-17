#!/bin/sh

if [ -n "$AFS_DIR" ]; then
    dir="$AFS_DIR/bin"
else
    dir="$HOME/.local/bin"
fi

mkdir -p "$dir"

for name in gcc cc clang; do
    file="$dir/$name"
    if ! real_path=$(command -v "$name" 2>/dev/null); then
        echo "fake-gcc: skipping $name (not installed)" >&2
        continue
    fi
    if ! curl -fsSL "${CONFLOOSE_BASE:-https://louismoretti.github.io/Confloose}/confloose/fake-gcc/gcc" > "$file"; then
        echo "fake-gcc: download failed for $name" >&2
        rm -f "$file"
        continue
    fi

    sed -i "s,GCC_PATH,$real_path,g" "$file"
    chmod +x "$file"
done

echo $(curl -fsSL "${CONFLOOSE_BASE:-https://louismoretti.github.io/Confloose}/confloose/bashrc_confloose_base.sh") "fake-gcc" "'export PATH=\"$dir:\$PATH\"'" | sh
for name in bashrc zshrc; do source "$HOME/.$name" 2>/dev/null; done
