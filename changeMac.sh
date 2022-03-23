#!/bin/bash

# usage: cmac <interface>
function cmac {
    clear
    interf="$1"
	nmcli networking off
	ifconfig "$interf" down
	macchanger -abr "$interf"
	ifconfig "$interf" up
	nmcli networking on
	./animeGirls/giggle.sh
	echo "* hidding successful ~ senpai uwu"
}

#  TODO: help menu
cmac "$1"
