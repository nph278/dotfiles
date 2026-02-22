#!/bin/sh

echo "" > $1
tail -f $1 | while read -r line; do $line & echo ""; done
