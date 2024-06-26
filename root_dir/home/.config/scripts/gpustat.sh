#!/bin/bash
#CPU [not added yet]
#GPU
FILE=/sys/bus/pci/devices/0000\:01\:00.0/power/runtime_status
if  test -f "$FILE"; then
	case $(cat $FILE) in
		"suspended") GPU="off";;
		"resuming") GPU="on!";;
		"suspending") GPU="off!";;
		"active") GPU="on";;
	esac
fi
echo "dGPU: $GPU"
pkill -RTMIN+3 waybar
