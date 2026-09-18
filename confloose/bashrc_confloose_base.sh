function add_to_rc() {
    [ -f "$HOME/.bashrc" ] || [ -f "$HOME/.zshrc" ] || : > "$HOME/.bashrc";
    for name in bashrc zshrc; do
        if [ -f "$HOME/.$name" ]; then
            grep -qF -- "$2 # confloose by leo [$1]" "$HOME/.$name" 2>/dev/null || echo "$2 # confloose by leo [$1]" >> "$HOME/.$name";
        fi;
    done;
}; add_to_rc
