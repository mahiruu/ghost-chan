#!/bin/bash

# usage: rmac <interface>
function rmac {
  interf="$1"
  nmcli networking off
  ifconfig "$interf" down # TODO: replace deprecated ifconfig with ip
  macchanger -p "$interf" >/dev/null
  ifconfig "$interf" up # TODO: replace deprecated ifconfig with ip
  nmcli networking on
  sh ./animeGirls/confusedStare.sh
  echo "* all settings have been reset ~ senpai"
}

rmac "$1"
