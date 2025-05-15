#!/bin/bash
# Loop through all attached batteries and format the info
for battery in /sys/class/power_supply/BAT?*; do
	# If non-first battery, print a space separator.
	[ -n "${capacity+x}" ] && printf " "
	# Sets up the status and capacity
	case "$(cat "$battery/status" 2>&1)" in
		"Full") status="FULL" ;;
		"Discharging") status="DISCHARGING" ;;
		"Charging") status="CHARGING" ;;
		"Not charging") status="NOT CHARGING" ;;
		"Unknown") status="UNKNOWN" ;;
		*) exit 1 ;;
	esac
	capacity="$(cat "$battery/capacity" 2>&1)"
	
	# Set colors based on status and capacity
	if [ "$status" = "DISCHARGING" ] && [ "$capacity" -le 30 ]; then
		# Red background for discharging and below 30%
		printf "^bg(FF0000)%s: %d%%^bg()" "$status" "$capacity"
	elif [ "$status" = "DISCHARGING" ]; then
		# Yellow background for discharging
    printf "^fg(FFFF00)%s: %d%%^fg()" "$status" "$capacity"
	elif [ "$status" = "CHARGING" ]; then
		# Blue background for charging (dwm blue)
		printf "^fg(00FF00)%s: %d%%^fg()" "$status" "$capacity"
	else
		# No background color for other states
		printf "%s: %d%%" "$status" "$capacity"
	fi
done && printf "\\n"
