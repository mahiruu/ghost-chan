#!/bin/bash

# usage: cmac <interface>
function cmac {
  SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
  interf="$1"
  nmcli networking off
  ifconfig "$interf" down
  macchanger -abr "$interf"
  ifconfig "$interf" up
  nmcli networking on
  sh "$SCRIPT_DIR"/animeGirls/giggle.sh
  echo "* hiding successful ~ senpai uwu"
  echo
}

#  TODO: help menu
cmac "$1"
