#!/bin/bash

# Directory containing your wallpapers
WALLPAPER_DIR="/home/baph/Pictures/Wallpapers"

# Get the selected wallpaper using dmenu
selected_wallpaper=$(find "$WALLPAPER_DIR" -type f | dmenu -i -p "Wallpaper: ")

# Set the wallpaper using feh
feh --bg-fill "$selected_wallpaper"
