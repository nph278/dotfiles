#!/bin/sh

date=$(date +'%Y-%m-%d %I:%M:%S %p')

batt=$(upower -i "$(upower -e | grep battery)" | grep percentage | awk '{print $2}' || echo "PC")

echo $batt " | " $date
