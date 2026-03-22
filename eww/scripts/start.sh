#!/bin/bash

killall eww-wayland 2>/dev/null
killall eww-x 2>/dev/null

if [ "$1" == "x" ]; then
	eww-x daemon
	eww-x open-many barx11 audioWindow helpersWindow
elif [ "$1" == "wayland" ]; then
	eww-wayland daemon
	eww-wayland open-many barwayland helpersWindow
else
	echo "Unidentified argument"
fi
