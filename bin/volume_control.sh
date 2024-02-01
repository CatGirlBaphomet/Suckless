#!/bin/bash

# Check the number of arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 [up|down] <value>"
    exit 1
fi

# Validate the first argument
if [ "$1" != "up" ] && [ "$1" != "down" ]; then
    echo "Error: First argument must be 'up' or 'down'"
    exit 1
fi

# Validate the second argument as a number
if ! [[ "$2" =~ ^[0-9]+$ ]]; then
    echo "Error: Second argument must be a positive integer"
    exit 1
fi

# Set the volume value
current_volume=$(amixer sget Master | grep -oP '\d+%' | head -n1 | sed 's/%//')
percentage="$2"
new_volume=0

if [ "$1" == "up" ]; then
    new_volume=$((current_volume + percentage))
else
    new_volume=$((current_volume - percentage))
fi

# Ensure the new volume is within bounds
if [ "$new_volume" -lt 0 ]; then
    new_volume=0
elif [ "$new_volume" -gt 100 ]; then
    new_volume=100
fi

# Set the new volume
DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u)/bus amixer -q set Master "$new_volume%"

# Display notification
notify_message="Volume $1: $new_volume%"
DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u)/bus notify-send "Volume Control" "$notify_message" --expire-time=1000