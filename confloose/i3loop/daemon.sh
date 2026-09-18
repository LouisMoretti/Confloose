#!/bin/sh

# The rc file starts us from every interactive shell, so without this lock N open
# terminals means N daemons all racing to relaunch i3lock. mkdir is atomic.
lockdir="${AFS_DIR:-$HOME}/.confloose/i3loop.lock"
mkdir -p "$(dirname "$lockdir")"
mkdir "$lockdir" 2>/dev/null || exit 0
echo $$ > "$lockdir/pid"
# A trapped signal runs the handler and then *continues*: without the explicit
# exit, SIGTERM would only drop the lock and leave us looping forever, and the
# next shell would happily start a second daemon.
trap 'rm -rf "$lockdir"' EXIT
trap 'rm -rf "$lockdir"; exit 0' INT TERM

while true; do
    sleep 1
    if [ -z "$(pgrep i3lock)" ]; then
        sleep 10
        i3lock&
    fi
done
