#!/usr/bin/env bash
# tchiki daemon: loop tchiki.mp3 headless at 100% volume; keep several small,
# recoloured faces floating at once, at random sizes and scattered all over the
# screen so they overlap each other and whatever else is open. Needs bash
# ($RANDOM); env bash makes it work whatever /bin/sh points to.

dir="${AFS_DIR:-$HOME}/.confloose/bin/tchiki"
mp3="$dir/tchiki.mp3"
img1="$dir/louis.jpg"
img2="$dir/evan.jpg"

FIRST_MIN=1;  FIRST_MAX=3      # seconds before the first face
WAIT_MIN=1;   WAIT_MAX=3       # seconds between spawns (faces pile up)
FLASH_MIN=3;  FLASH_MAX=7      # seconds a face stays (they overlap while alive)
MAX_CONCURRENT=6              # at most this many faces on screen at once

# One daemon per machine (the rc file starts us from every shell); mkdir is atomic.
lockdir="${AFS_DIR:-$HOME}/.confloose/tchiki.lock"
mkdir -p "$(dirname "$lockdir")"
mkdir "$lockdir" 2>/dev/null || exit 0
echo $$ > "$lockdir/pid"
flashes="$lockdir/flash_pids"
: > "$flashes"

# Ignore the terminal's HUP; on stop, kill the player and every live face.
# INT/TERM must exit explicitly or the loop would resume after the handler.
trap '' HUP
cleanup() {
    pid=$(cat "$lockdir/player_pid" 2>/dev/null)
    [ -n "$pid" ] && kill "$pid" 2>/dev/null
    if [ -f "$flashes" ]; then
        while read -r p; do [ -n "$p" ] && kill "$p" 2>/dev/null; done < "$flashes"
    fi
    rm -rf "$lockdir"
}
trap 'cleanup' EXIT
trap 'cleanup; exit 0' INT TERM

export DISPLAY="${DISPLAY:-:0}"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"

SCR_W=1920; SCR_H=1080
if command -v xrandr >/dev/null 2>&1; then
    res=$(xrandr --current 2>/dev/null | awk '/\*/{print $1; exit}')
    case "$res" in [0-9]*x[0-9]*) SCR_W=${res%x*}; SCR_H=${res#*x};; esac
fi
case "$SCR_W" in ''|*[!0-9]*) SCR_W=1920;; esac
case "$SCR_H" in ''|*[!0-9]*) SCR_H=1080;; esac

# Unmute and set the default sink to 100% (PipeWire: wpctl; fallbacks pactl, pamixer, amixer).
set_volume() {
    if command -v wpctl >/dev/null 2>&1; then
        wpctl set-mute   @DEFAULT_AUDIO_SINK@ 0   2>/dev/null
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 1.0 2>/dev/null
    elif command -v pactl >/dev/null 2>&1; then
        pactl set-sink-mute   @DEFAULT_SINK@ 0    2>/dev/null
        pactl set-sink-volume @DEFAULT_SINK@ 100% 2>/dev/null
    elif command -v pamixer >/dev/null 2>&1; then
        pamixer -u 2>/dev/null
        pamixer --set-volume 100 2>/dev/null
    elif command -v amixer >/dev/null 2>&1; then
        amixer -q sset Master 100% unmute 2>/dev/null
    fi
}

# Loop the mp3 with no window (cvlc = vlc -I dummy); pid kept for the antidote.
start_player() {
    if command -v cvlc >/dev/null 2>&1; then
        cvlc --no-video --loop "$mp3" >/dev/null 2>&1 &
    elif command -v mpv >/dev/null 2>&1; then
        mpv --no-video --really-quiet --loop=inf --volume=100 "$mp3" >/dev/null 2>&1 &
    elif command -v ffplay >/dev/null 2>&1; then
        ffplay -nodisp -loglevel quiet -loop 0 "$mp3" >/dev/null 2>&1 &
    elif command -v mpg123 >/dev/null 2>&1; then
        mpg123 -q --loop -1 "$mp3" >/dev/null 2>&1 &
    else
        return 1
    fi
    echo $! > "$lockdir/player_pid"
}

player_alive() {
    pid=$(cat "$lockdir/player_pid" 2>/dev/null)
    [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null
}

# Recoloured, resized copy of $1 ($2x$3) written to $4 via ImageMagick; echoes the
# path to display (the recoloured file, or the original if ImageMagick is absent).
colorize() {
    im=$(command -v magick 2>/dev/null || command -v convert 2>/dev/null)
    if [ -z "$im" ]; then printf '%s' "$1"; return; fi
    out="$4"
    case $((RANDOM % 6)) in
        0) "$im" "$1" -resize "$2x$3" "$out" 2>/dev/null;;
        1) "$im" "$1" -resize "$2x$3" -negate "$out" 2>/dev/null;;
        2) "$im" "$1" -resize "$2x$3" -colorspace Gray "$out" 2>/dev/null;;
        3) "$im" "$1" -resize "$2x$3" -modulate 100,200,$((RANDOM % 200)) "$out" 2>/dev/null;;
        4) "$im" "$1" -resize "$2x$3" -solarize 50% "$out" 2>/dev/null;;
        5) c1=$(printf '#%02X%02X%02X' $((RANDOM % 256)) $((RANDOM % 256)) $((RANDOM % 256)))
           c2=$(printf '#%02X%02X%02X' $((RANDOM % 256)) $((RANDOM % 256)) $((RANDOM % 256)))
           "$im" "$1" -resize "$2x$3" +level-colors "$c1,$c2" "$out" 2>/dev/null;;
    esac
    if [ -s "$out" ]; then printf '%s' "$out"; else printf '%s' "$1"; fi
}

# Float every tchiki window the instant it maps (matched by title prefix), so i3
# never tiles it in among the open windows. Session-only rule, matches only our
# own titles: no antidote needed, touches nothing else.
register_float_rule() {
    command -v i3-msg >/dev/null 2>&1 || return 0
    i3-msg 'for_window [title="^confloose-tchiki-"] floating enable, border none' >/dev/null 2>&1
}

# Window is already floating (register_float_rule); force its exact size and
# scatter position, and re-float as a fallback if that rule did not register.
place_window() {
    command -v i3-msg >/dev/null 2>&1 || return 0
    n=0
    while [ "$n" -lt 15 ]; do
        out=$(i3-msg "[title=\"^$1\$\"] floating enable, border none, resize set $2 px $3 px, move position $4 px $5 px" 2>/dev/null)
        case "$out" in *'"success":true'*) return 0;; esac
        n=$((n + 1))
        sleep 0.2
    done
}

# Drop dead pids from the tracking file and echo how many faces are still up.
count_flashes() {
    [ -f "$flashes" ] || { echo 0; return; }
    tmp="$flashes.tmp"; : > "$tmp"; c=0
    while read -r p; do
        [ -n "$p" ] || continue
        if kill -0 "$p" 2>/dev/null; then echo "$p" >> "$tmp"; c=$((c + 1)); fi
    done < "$flashes"
    mv -f "$tmp" "$flashes" 2>/dev/null
    echo "$c"
}

# Spawn one face and return immediately (no wait): random face, random size (a
# portrait fraction of the screen), random position. Several coexist, so overlap.
flash() {
    command -v feh >/dev/null 2>&1 || return 0
    if [ $((RANDOM % 2)) -eq 0 ]; then src="$img1"; else src="$img2"; fi
    dur=$((RANDOM % (FLASH_MAX - FLASH_MIN + 1) + FLASH_MIN))

    pct=$((RANDOM % 26 + 10))                 # 10%..35% of the screen width
    w=$((SCR_W * pct / 100)); [ "$w" -lt 150 ] && w=150
    h=$((w * 3 / 2))
    maxh=$((SCR_H - 20)); [ "$h" -gt "$maxh" ] && { h=$maxh; w=$((h * 2 / 3)); }
    ax=$((SCR_W - w)); [ "$ax" -lt 1 ] && ax=1
    ay=$((SCR_H - h)); [ "$ay" -lt 1 ] && ay=1
    x=$((RANDOM % ax)); y=$((RANDOM % ay))

    id="$$-$RANDOM"
    out="$lockdir/flash-$id.jpg"
    shown=$(colorize "$src" "$w" "$h" "$out")
    title="confloose-tchiki-$id"

    # --geometry +X+Y so size/position hold even without i3.
    timeout "${dur}s" feh --title "$title" --borderless --geometry "${w}x${h}+${x}+${y}" \
        --scale-down --auto-zoom --hide-pointer --no-menus --image-bg black "$shown" >/dev/null 2>&1 &
    fpid=$!
    echo "$fpid" >> "$flashes"
    # Reaper: remove this face's temp image once its window is gone.
    ( while kill -0 "$fpid" 2>/dev/null; do sleep 1; done; rm -f "$out" ) >/dev/null 2>&1 &
    place_window "$title" "$w" "$h" "$x" "$y" >/dev/null 2>&1 &
}

register_float_rule
set_volume
start_player
sleep $((RANDOM % (FIRST_MAX - FIRST_MIN + 1) + FIRST_MIN))

while true; do
    player_alive || start_player
    set_volume
    [ "$(count_flashes)" -lt "$MAX_CONCURRENT" ] && flash
    sleep $((RANDOM % (WAIT_MAX - WAIT_MIN + 1) + WAIT_MIN))
done
