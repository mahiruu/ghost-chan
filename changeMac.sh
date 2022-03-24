#!/bin/bash

# usage: cmac <interface>
function cmac {
    clear
    interf="$1"
	  ifconfig "$interf" down
	  macchanger -abr "$interf"
	  ifconfig "$interf" up
	  ./animeGirls/giggle.sh
	  echo "* hiding successful ~ senpai uwu"
}

#  TODO: help menu
cmac "$1"
