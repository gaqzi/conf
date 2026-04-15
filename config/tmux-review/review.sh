#!/bin/sh
# tmux review mode: scroll output above while writing notes below.
# :wq pastes notes into the original pane via bracketed paste. :q! aborts.
# When zoomed, other panes are temporarily moved out and restored after.
# Temp files kept in /tmp for recovery (cleaned on reboot).
#
# Modes:
#   (default)  — entry point, called from tmux keybind
#   edit       — runs inside the split pane: vim + paste + schedule restore
#   restore    — deferred: moves panes back, restores layout, re-zooms

: ${REVIEW_ROWS:=8}

SELF="$HOME/.config/tmux-review/review.sh"
VIM_CONFIG="$HOME/.config/tmux-review/review.vim"

mode="${1:-}"
case "$mode" in
edit)    shift ;;
restore) shift ;;
*)       mode="start" ;;
esac

log="/tmp/tmux-review-${mode}.log"
echo "--- $(date) ---" > "$log"

# --- start: entry point from tmux keybind ---
if [ "$mode" = "start" ]; then
    target_pane="$1"
    tmpfile=$(mktemp /tmp/review-XXXXXX)
    was_zoomed=0
    temp_window=""
    saved_layout=""
    window_id=$(tmux display-message -t "$target_pane" -p '#{window_id}')

    # If zoomed, evacuate other panes to a temp window
    if [ "$(tmux display-message -t "$target_pane" -p '#{window_zoomed_flag}')" = "1" ]; then
        was_zoomed=1
        saved_layout=$(tmux display-message -t "$target_pane" -p '#{window_layout}')

        tmux resize-pane -t "$target_pane" -Z

        other_panes=$(tmux list-panes -t "$window_id" -F '#{pane_id}' | grep -v "^${target_pane}$")
        for pane in $other_panes; do
            if [ -z "$temp_window" ]; then
                tmux break-pane -d -s "$pane"
                temp_window=$(tmux display-message -t "$pane" -p '#{window_id}')
            else
                tmux join-pane -d -s "$pane" -t "$temp_window"
            fi
        done
    fi

    # Put the target pane into copy-mode and open vim in a split below
    tmux copy-mode -t "$target_pane"
    tmux send-keys -t "$target_pane" -X halfpage-up
    tmux split-window -v -l "$REVIEW_ROWS" -t "$target_pane" \
        "$SELF edit '$target_pane' '$tmpfile' '$was_zoomed' '$temp_window' '$saved_layout' '$window_id'"
    exit 0
fi

# --- edit: runs inside the split pane ---
if [ "$mode" = "edit" ]; then
    target_pane="$1"
    tmpfile="$2"
    was_zoomed="$3"
    temp_window="$4"
    saved_layout="$5"
    window_id="$6"

    echo "args: $@" >> "$log"

    REVIEW_TARGET_PANE="$target_pane" vim -S "$VIM_CONFIG" "$tmpfile"
    echo "vim exited: $?" >> "$log"

    # Paste if file has content
    if [ -s "$tmpfile" ]; then
        echo "pasting" >> "$log"
        tmux send-keys -t "$target_pane" -X cancel 2>/dev/null
        printf '%s' "$(cat "$tmpfile")" | tmux load-buffer -
        tmux paste-buffer -dp -t "$target_pane" 2>> "$log"
        echo "paste exit: $?" >> "$log"
    else
        echo "empty, skipping paste" >> "$log"
        tmux send-keys -t "$target_pane" -X cancel 2>/dev/null
    fi

    # Schedule restore after this pane closes (layout needs correct pane count)
    if [ "$was_zoomed" = "1" ] && [ -n "$temp_window" ]; then
        echo "scheduling restore" >> "$log"
        tmux run-shell -b "$SELF restore '$target_pane' '$temp_window' '$saved_layout' '$window_id'"
    fi
    exit 0
fi

# --- restore: deferred, runs after the review pane closes ---
if [ "$mode" = "restore" ]; then
    target_pane="$1"
    temp_window="$2"
    saved_layout="$3"
    window_id="$4"

    echo "target: $target_pane, temp: $temp_window, window: $window_id" >> "$log"

    # Small delay to ensure the review pane has fully closed
    sleep 0.2

    # Move all panes back one at a time
    while true; do
        pane=$(tmux list-panes -t "$temp_window" -F '#{pane_id}' 2>/dev/null | head -1)
        if [ -z "$pane" ]; then
            break
        fi
        tmux join-pane -d -s "$pane" -t "$window_id" 2>> "$log"
        echo "moved $pane: $?" >> "$log"
    done

    echo "panes now: $(tmux list-panes -t "$window_id" -F '#{pane_id}')" >> "$log"

    # Restore original layout and re-zoom
    tmux select-layout -t "$window_id" "$saved_layout" 2>> "$log"
    echo "layout exit: $?" >> "$log"
    tmux resize-pane -t "$target_pane" -Z 2>> "$log"
    echo "zoom exit: $?" >> "$log"
    exit 0
fi
