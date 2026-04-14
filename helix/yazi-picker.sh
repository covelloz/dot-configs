#!/usr/bin/env bash

zellij action move-pane left

# path references keep track of where yazi left off
project_root="$PWD"
last_dir_file="${XDG_CACHE_HOME:-$HOME/.cache}/yazi/lastdir"
cwd_file=$(mktemp)

# cache cleanup when script fully exits
trap 'rm -f "$cwd_file"; rm -f "$last_dir_file"' EXIT

while true; do
	# checks lastdir cache & resets if pwd changes
	stored_root=$(sed -n '1p' "$last_dir_file" 2>/dev/null)
	stored_last=$(sed -n '2p' "$last_dir_file" 2>/dev/null)
	if [[ "$stored_root" == "$project_root" && -d "$stored_last" ]]; then
		last_dir="$stored_last"
	else
		last_dir="$project_root"
	fi

	# open yazi at cached dir
	paths=$(yazi --chooser-file=/dev/stdout --cwd-file="$cwd_file" "$last_dir" | sed 's/^/"/;s/$/"/' | tr '\n' ' ')

	# update the lastdir cache
	new_dir=$(cat "$cwd_file" 2>/dev/null)
	[[ -d "$new_dir" ]] && printf '%s\n%s\n' "$project_root" "$new_dir" > "$last_dir_file"

	# use zellij to open the yazi path ref in helix
	if [[ -n "$paths" ]]; then
		zellij action focus-next-pane
		zellij action write 27 # send <Escape> key
		zellij action write-chars ":open $paths"
		zellij action write 13 # send <Enter> key
		zellij action focus-previous-pane
	fi
done
