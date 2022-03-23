#!/bin/bash

# usage: rmac <interface>
function rmac {	
    clear
    interf="$1"
    nmcli networking off
    ifconfig "$interf" down
    macchanger -p "$interf" >/dev/null
    ifconfig "$interf" up
    nmcli networking on
	./animeGirls/confusedStare.sh 
    echo "* all settings have been reset ~ senpai"
}

rmac "$1"