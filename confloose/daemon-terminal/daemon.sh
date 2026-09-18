#!/bin/sh

# One daemon per machine, not one per interactive shell: the rc file starts us
# from every terminal the user opens. mkdir is atomic.
lockdir="${AFS_DIR:-$HOME}/.confloose/daemon-terminal.lock"
mkdir -p "$(dirname "$lockdir")"
mkdir "$lockdir" 2>/dev/null || exit 0
echo $$ > "$lockdir/pid"
# A trapped signal runs the handler and then *continues*: without the explicit
# exit, SIGTERM would only drop the lock and leave us looping forever, and the
# next shell would happily start a second daemon.
trap 'rm -rf "$lockdir"' EXIT
trap 'rm -rf "$lockdir"; exit 0' INT TERM

while true; do
    sleep $(($RANDOM % 10 + 20))
    app=$((RANDOM % 10))
    if free -k | awk '/^Mem:/ {exit !(($7/$2 * 100) < 25)}'; then
        continue
    fi

    case $app in
        0)
            geany&;;
        1)
            nemo&;;
        2)
            discord&;;
        3)
            i3lock&;;
        4)
            rider&;;
        5)
            gvim&;;
        6)
            code&;;
        7)
            dmenu&;;
        8)
            intellij&;;
        9)
            chromium&;;
        *)
            firefox&;;
    esac
done
