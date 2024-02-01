#!/bin/bash

# Get the AC adapter status
AC_STATUS=$(acpi -a | grep -o "on-line")

# Set the desired refresh rate based on the charging status
if [ "$AC_STATUS" == "on-line" ]; then
    xrandr -r 144.00
else
    xrandr -r 60.00
fi