#!/bin/bash

# usage: gmode <interface> <time_in_seconds>
function gmode {
    interf="$1"
    gint="$2"
	c=1
    ./animeGirls/giggle.sh
    echo "I will be taking care of your privacy from now on"
    echo "let's go!"
    echo ""
	while true
	do
		nmcli networking off
	    ifconfig "$interf" down
        macchanger -a "$interf" >/dev/null
        ifconfig "$interf" up
        nmcli networking on
        echo "mac changed $c times"
        notify-send "Ghost-chan: changing mac ($c)"
		c=$((c+1))
		sleep "$gint"
	done
}

#  TODO: help menu
gmode "$1" "$2"