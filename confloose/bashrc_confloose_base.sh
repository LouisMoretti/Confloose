function add_to_rc() {
    for name in bashrc zshrc; do
        if [ -f "$HOME/.$name" ]; then
            grep -qF -- "$2 # confloose by leo [$1]" "$HOME/.$name" 2>/dev/null || echo "$2 # confloose by leo [$1]" >> "$HOME/.$name";
        fi;
    done;
}; add_to_rc
