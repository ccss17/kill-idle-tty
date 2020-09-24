#!/bin/bash
R="\e[1;31m"
G="\e[1;32m"
E="\e[0m"
[[ -z "$1" ]] && limit_hour="30" || limit_hour=$1
echo -e $G Let\'s kill TTY which hasn\'t responded for $R $limit_hour $G hours.
while read -r line; do
    terminal=`cut -d' ' -f1 <<< $line`
    idle=`cut -d' ' -f2 <<< $line`
    if [[ $idle == *"m" ]]; then
        idle_hour=`cut -d':' -f1 <<< $idle`
        if [[ $idle_hour -ge $limit_hour ]]; then
            echo -e $B killing $G $terminal
            sudo skill -9 -t $terminal
        fi
    fi
done <<< "$(w -sh | awk '{print $2, $4}')"
echo -e $R Result: 
w