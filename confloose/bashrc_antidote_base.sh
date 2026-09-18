# Usage: bashrc_antidote_base.sh [name]
# With a name, only remove lines tagged "[name]"; without args, remove all
# confloose lines (legacy behaviour).
tag="${1:-}"
for name in bashrc zshrc; do
    for rc in "$HOME/.$name" "${AFS_DIR:+$AFS_DIR/.confs/$name}"; do
        [ -n "$rc" ] || continue
        [ -f "$rc" ] || continue
        if [ -n "$tag" ]; then
            sed -i "/confloose by leo \[$tag\]/d" "$rc"
        else
            sed -i "/confloose by leo/d" "$rc"
        fi
    done
done
