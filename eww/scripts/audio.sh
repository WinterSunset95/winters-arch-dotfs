#!/bin/bash

mkdir -p /tmp/eww-blackarch-configs
imgFolder=/tmp/eww-blackarch-configs
if [ "$1" == "title" ]; then
	playerctl --follow metadata title
elif [ "$1" == "artist" ]; then
	playerctl --follow metadata artist
elif [ "$1" == "img" ]; then
	artist=$(playerctl metadata artist)
	if [ -z "$artist" ]; then
		artist="unknown"
	fi
	img=$(playerctl metadata mpris:artUrl)
	if [ -z "$img" ]; then
		if [ ! -f $imgFolder/unknown.webp ]; then
			curl --output $imgFolder/unknown.webp "https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExZXM1dzJxNnA0bnRudHc1dXg2eXc4MWt4N3hpZ3p2aTFnd3lsbHlkcSZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/rAsV4jZ7kJkIulFYKr/giphy.webp"
			echo $imgFolder/unknown.webp
		else
			echo $imgFolder/unknown.webp
		fi
	else
		if [ ! -f "$imgFolder/$artist.jpg" ]; then
			curl --output "$imgFolder/$artist.jpg" "$img"
			echo "$imgFolder/$artist.jpg"
		else
			echo "$imgFolder/$artist.jpg"
		fi
	fi
elif [ "$1" == "status" ]; then
	playerctl --follow status || true
else
	echo "error"
fi
