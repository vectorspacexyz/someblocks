#!/bin/sh
# Module showing network traffic. Shows the total amount of data that has been 
# received (RX) or transmitted (TX) with colored arrows when traffic exceeds 1MB/s.

# Cache file to store previous values
CACHE_FILE="/tmp/network_traffic.cache"

update() {
    sum=0
    for arg; do
        read -r i < "$arg"
        sum=$(( sum + i ))
    done
    echo "$sum"
}

# Get current values
rx=$(update /sys/class/net/[ew]*/statistics/rx_bytes)
tx=$(update /sys/class/net/[ew]*/statistics/tx_bytes)

# Check for previous values
if [ -f "$CACHE_FILE" ]; then
    read -r prev_rx prev_tx < "$CACHE_FILE"

    # Calculate differences (bytes)
    rx_diff=$(( rx - prev_rx ))
    tx_diff=$(( tx - prev_tx ))

    # 1MB in bytes
    # MB_THRESHOLD=1048576
    MB_THRESHOLD=262144

    # Set arrow colors based on threshold
    if [ "$rx_diff" -ge "$MB_THRESHOLD" ]; then
        rx_arrow="^fg(00FF00)⮟^fg()"
    else
        rx_arrow="⮟"
    fi

    if [ "$tx_diff" -ge "$MB_THRESHOLD" ]; then
        tx_arrow="^fg(FF0000)⮝^fg()"
    else
        tx_arrow="⮝"
    fi
else
    # First run, no coloring
    rx_arrow="⮟"
    tx_arrow="⮝"
fi

# Save current values for next run
echo "$rx $tx" > "$CACHE_FILE"

# Output with potentially colored arrows
printf "%s %sB %s %sB\n" "$rx_arrow" "$(numfmt --to=iec "$rx")" "$tx_arrow" "$(numfmt --to=iec "$tx")"
