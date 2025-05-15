#!/bin/bash
# Get disk usage information
DISK_INFO=$(df -h / | awk '/[0-9]/ {print $3 "/" $2 " " $5}')
USED_SIZE=$(echo "$DISK_INFO" | cut -d' ' -f1)
USAGE_PCT=$(echo "$DISK_INFO" | cut -d' ' -f2 | tr -d '%')

# Check if usage is 90% or above and format accordingly
if [ "$USAGE_PCT" -ge 90 ]; then
  printf "%s : ^fg(FF0000)%s^fg()\n" "󰣇" "$USED_SIZE"
else
  printf "%s : %s\n" "󰣇" "$USED_SIZE"
fi
