#!/bin/bash

# usage: gmode <interface> <time_in_seconds>
function gmode {
  clear
  interf="$1"
  gint="$2"
  c=1
  sh ./animeGirls/giggle.sh
  echo "* I will be taking care of your privacy from now on"
  echo "* let's go!"
  echo "*"
  while true; do
    nmcli networking on
    ifconfig "$interf" down # TODO: replace deprecated ifconfig with ip
    macchanger -a "$interf" >/dev/null
    ifconfig "$interf" up # TODO: replace deprecated ifconfig with ip
    echo "* mac + ip address changed $c times"
    notify-send "Ghost-chan: changing mac ($c)"
    c=$((c + 1))
    sleep "$gint"
  done
}

#  TODO: help menu
gmode "$1" "$2"
