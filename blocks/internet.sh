#!/bin/sh
# Initialize status variable
status="NO INTERNET"

# Get default route interface
default_interface=$(ip route show default 2>/dev/null | awk '/default/ {print $5; exit}')

if [ -n "$default_interface" ]; then
    # Get IP address of default interface
    ip_address=$(ip addr show dev "$default_interface" 2>/dev/null | awk '/inet / {print $2; exit}' | cut -d'/' -f1)

    # Check if it's a WiFi interface (starts with w)
    if echo "$default_interface" | grep -q "^w"; then
        # Get WiFi signal strength percentage
        wifi_strength=$(awk '/^\s*w/ { print int($3 * 100 / 70) "%" }' /proc/net/wireless)

        # Get WiFi SSID
        wifi_ssid=$(iwgetid -r)

        # Format WiFi status with SSID and IP
        status="${wifi_ssid} (${wifi_strength}) ${ip_address}"
    else
        # It's Ethernet or another interface type
        status="ETHERNET ${ip_address}"
    fi
fi

# Print the final status
printf "%s\n" "$status"
