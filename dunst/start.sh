#!/bin/bash

debugMode () {
	killall dunst
	dunst &
	while true
	do
		inotifywait -q -e modify ./dunstrc
		echo "dunstrc changed! Reloading"
		dunstctl reload
		dunstify "This is a test"
	done
}

normalMode () {
	killall dunst
	echo "Dunst started"
	dunst
}

if [ "$1" == "debug" ]; then
	debugMode
else
	normalMode
fi
