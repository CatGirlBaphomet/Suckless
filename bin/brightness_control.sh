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

# Set the brightness value
brightness_file="/sys/class/backlight/intel_backlight/brightness"
current_brightness=$(cat "$brightness_file")
max_brightness=$(cat "/sys/class/backlight/intel_backlight/max_brightness")
percentage="$2"
new_brightness=0

if [ "$1" == "up" ]; then
    new_brightness=$((current_brightness + (max_brightness * percentage / 100)))
else
    new_brightness=$((current_brightness - (max_brightness * percentage / 100)))
fi

# Ensure the new brightness is within bounds
if [ "$new_brightness" -lt 0 ]; then
    new_brightness=0
elif [ "$new_brightness" -gt "$max_brightness" ]; then
    new_brightness="$max_brightness"
fi

# Set the new brightness
echo "$new_brightness" | sudo tee "$brightness_file"

# Display notification
notify_message="Brightness $1: $new_brightness/$max_brightness"
notify-send "Brightness Control" "$notify_message" --expire-time=1000
