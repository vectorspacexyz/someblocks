#!/bin/bash
# Save as route-monitor.sh

ip monitor route | while read line; do
    # Check if the line contains information about the default route
    if [[ "$line" == *"default"* ]]; then
        echo "Default route changed: $line" | logger -t route-monitor

        # Add your commands here
        # For example, to send a signal to someblocks:
        pgrep someblocks >/dev/null && pkill -SIGRTMIN+15 someblocks

        # Or run any other script/command:
        # /path/to/your/script.sh
    fi
done
