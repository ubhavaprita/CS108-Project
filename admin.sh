#!/bin/bash

FILE="history.txt"

if [ ! -f "$FILE" ]; then
    echo "No history file found."
    exit 1
fi

echo "---- RAW GAME DATA ----"
cat "$FILE"