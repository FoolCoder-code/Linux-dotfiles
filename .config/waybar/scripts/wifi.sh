#!/usr/bin/env bash

# Check if nmcli exists
if ! command -v nmcli >/dev/null 2>&1; then
    echo "󰖪"
    exit 0
fi

STATE=$(nmcli -t -f WIFI g)

if [[ "$STATE" != "enabled" ]]; then
    echo "󰖪"
    exit 0
fi

ACTIVE=$(nmcli -t -f ACTIVE,SSID,SIGNAL dev wifi | grep '^yes')

if [[ -z "$ACTIVE" ]]; then
    echo "󰖪"
    exit 0
fi

SSID=$(echo "$ACTIVE" | cut -d: -f2)
SIGNAL=$(echo "$ACTIVE" | cut -d: -f3)

# Choose icon based on signal
if (( SIGNAL > 80 )); then
    ICON="󰤨"
elif (( SIGNAL > 60 )); then
    ICON="󰤥"
elif (( SIGNAL > 40 )); then
    ICON="󰤢"
elif (( SIGNAL > 20 )); then
    ICON="󰤟"
else
    ICON="󰤯"
fi

echo "$ICON $SSID"
