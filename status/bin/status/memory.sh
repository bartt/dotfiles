#!/bin/sh
# based on https://github.com/koekeishiya/kwm/issues/8

ps -A -o %mem | awk '{s+=$1} END {print "mem " s}' | tr -d '\n'