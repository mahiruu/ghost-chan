#!/bin/bash

# usage: randomIpAddress <interface>

# a function that set static ip address based on the previous ip assigned by dhcp or manually
# has built-in mechanism to prevent assignement of already assigned IPv4 in the network
# only works in places where static ip addresses are allowed (not eduroam)
function randomIpAddress {
    intf="$1"  
    dot="."
	zero="0"
    backslash="/"

    mask=$(ifconfig "$intf" | awk '/netmask/{ print $4;} ')
    transformedAd1=$(ip addr sh "$intf" | awk '/inet/{ print $2;} ' | head -n +1 | cut -d "/" -f1 | cut -d "." -f1)
	transformedAd2=$(ip addr sh "$intf" | awk '/inet/{ print $2;} ' | head -n +1 | cut -d "/" -f1 | cut -d "." -f2)
	transformedAd3=$(ip addr sh "$intf" | awk '/inet/{ print $2;} ' | head -n +1 | cut -d "/" -f1 | cut -d "." -f3)

    netbase="$transformedAd1$dot$transformedAd2$dot$transformedAd3"
	net="$netbase$dot$zero"
    netWithMask="$net$backslash$(ip addr sh "$intf" | awk '/inet/{ print $2;} ' | head -n +1 | cut -d "/" -f2)"

    defaultGW=$(ip route show | head -n +1 | cut -d " " -f3)
	broadcast=$(ifconfig "$intf" | awk '/broadcast/{ print $6;} ')

    while true
    do
		rnd=$((2 + $RANDOM % 254))
		newAd="$netbase$dot$rnd"
		list=$(nmap -sn "$netWithMask" | grep "$newAd")
        if [ -z "$list" ];
        then
			ifconfig "$intf" "$newAd" 
			ifconfig "$intf" netmask "$mask"
			ifconfig "$intf" broadcast "$broadcast"
			route add default gw "$defaultGW" "$intf" 
            ./animeGirls/smileyWave.sh
            echo "changing ip address!"
			echo "$newAd"
        fi
    done
}

#  TODO: help menu
randomIpAddress "$1"
