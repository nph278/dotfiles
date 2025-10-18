#!/bin/sh

date=$(date +'%Y-%m-%d %I:%M:%S %p')

batt=$(upower -i "$(upower -e | grep battery)" | grep percentage | awk '{print $2}' || echo "PC")

netdev=$(ip r get 1.1.1.1 | grep 'dev ' | sed 's/.*dev \([^ ]*\).*/\1/')

echo $batt " | " $netdev " | " $date
