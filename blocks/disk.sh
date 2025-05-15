#!/bin/bash

printf "%s: %s\n" "root" "$(df -h / | awk ' /[0-9]/ {print $3 "/" $2}')"
