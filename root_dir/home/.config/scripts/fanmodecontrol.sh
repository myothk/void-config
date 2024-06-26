#!/bin/bash
#
# Change the fanmode of asus laptop by using the file provided by asus-nb-wmi kernel module.
# value of /sys/devices/platform/asus-nb-wmi/throttle_thermal_policy = fan mode
# 0 = balanced
# 1 = turbo
# 2 = silent

FILE=/sys/devices/platform/asus-nb-wmi/throttle_thermal_policy

if test -f "$FILE";then
    speed=$(cat /sys/devices/platform/asus-nb-wmi/throttle_thermal_policy)
    if [[ "$1" == "show" ]]; then
	case $speed in
	    0) echo " Balanced";;
	    1) echo " Turbo";;
	    2) echo " Silent";;
	esac
    elif [[ "$1" == "toggle" ]];then
	speed=$(($speed+1))
	if [ $speed -gt 2 ]; then
	    speed=0
	fi
	echo $speed > /sys/devices/platform/asus-nb-wmi/throttle_thermal_policy
        pkill -RTMIN+2 waybar
    fi
fi

## TODO
# fix bug: gpu wakes up from D3cold to D0. 
