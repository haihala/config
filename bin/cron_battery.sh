#!/usr/bin/env bash

battery_level=$(acpi -b | sed -r 's/[^,]*, ([0-9]+)%.*/\1/' | sort -rn | head -n 1)
if [ $battery_level -le 10 ]; then
    notify-send "Battery low" "Battery level is ${battery_level}%!"
fi
