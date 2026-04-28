#!/bin/bash
# tmux-notify.sh — Alert ALL tmux clients when Claude needs attention
set -euo pipefail

# Read notification JSON from stdin
INPUT=$(cat)
NOTIFICATION_TYPE=$(echo "$INPUT" | jq -r '.notification_type // "input_needed"')

# Bail if not in tmux
[ -z "${TMUX:-}" ] && exit 0

# Identify source pane's session and window
SOURCE_SESSION=$(tmux display-message -t "$TMUX_PANE" -p '#{session_name}' 2>/dev/null || echo "?")
SOURCE_WINDOW=$(tmux display-message -t "$TMUX_PANE" -p '#{window_name}' 2>/dev/null || echo "?")

# Build alert message
case "$NOTIFICATION_TYPE" in
    permission_prompt) LABEL="Permission needed" ;;
    idle_prompt)       LABEL="Waiting for input" ;;
    elicitation_dialog) LABEL="Question for you" ;;
    *)                 LABEL="Needs attention" ;;
esac

MSG="Claude [$SOURCE_SESSION:$SOURCE_WINDOW] — $LABEL"

# Save original message style, set blue alert style
ORIG_STYLE=$(tmux show-options -gv message-style 2>/dev/null || echo "")
tmux set-option -g message-style "bg=blue,fg=white,bold" 2>/dev/null || true

# Send styled display-message to ALL attached tmux clients (3s duration)
tmux list-clients -F '#{client_name}' 2>/dev/null | while read -r client; do
    tmux display-message -c "$client" -d 3000 " $MSG " 2>/dev/null || true
done

# Restore original message style after a delay (so the message renders in blue first)
(sleep 4 && tmux set-option -g message-style "$ORIG_STYLE" 2>/dev/null || true) &

# Ring bell in the source pane so tmux flags that window
tmux send-keys -t "$TMUX_PANE" "" 2>/dev/null || true
printf '\a' > "$(tmux display-message -t "$TMUX_PANE" -p '#{pane_tty}')" 2>/dev/null || true

exit 0
