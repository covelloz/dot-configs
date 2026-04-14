#!/usr/bin/env bash

zellij action move-pane left

# cache & temp files keep track of where yazi left off
last_dir_file="${XDG_CACHE_HOME:-$HOME/.cache}/yazi/lastdir"
cwd_file=$(mktemp)
chooser_file=$(mktemp)

# reset cache & yazi pid refs when script starts
yazi_pid=""
rm -f "$last_dir_file"

# cleanup cache & yazi process when script exits
cleanup() {
    rm -f "$cwd_file" "$chooser_file" "$last_dir_file"
    [[ -n "$yazi_pid" ]] && kill "$yazi_pid" 2>/dev/null
}
trap cleanup EXIT

while true; do
    # open yazi - checks lastdir cache, if no cache open yazi at pwd
    last_dir=$(cat "$last_dir_file" 2>/dev/null)
    [[ -d "$last_dir" ]] || last_dir="$PWD"
    yazi --chooser-file="$chooser_file" --cwd-file="$cwd_file" "$last_dir" &

    # store yazi process pid for cleanup (hack to get pid via a blocking background process)
    yazi_pid=$!
    wait "$yazi_pid"
    yazi_pid=""

    # formats yazi file(s) output for helix's :open command
    paths=$(sed 's/^/"/;s/$/"/' "$chooser_file" | tr '\n' ' ')

    # truncates chooser_file between iters
    > "$chooser_file"

    # update lastdir cache file in .cache/yazi (helpful for debugging)
    new_dir=$(cat "$cwd_file" 2>/dev/null)
    [[ -d "$new_dir" ]] && echo "$new_dir" > "$last_dir_file"

    # use zellij to open the yazi path ref in helix
    if [[ -n "$paths" ]]; then
        zellij action focus-next-pane
        zellij action write 27 # send <Escape> key
        zellij action write-chars ":open $paths"
        zellij action write 13 # send <Enter> key
        zellij action focus-previous-pane
    fi
done
