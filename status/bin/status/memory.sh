#!/bin/sh
# from https://github.com/koekeishiya/kwm/issues/8

ESC=`printf "\e"`
printf "mem $ESC[34m"
ps -A -o %mem | awk '{s+=$1} END {print "" s}'
