#!/bin/bash

notify-send -t 3000 "Playing Video" "$(copyq clipboard)";
mpv --ytdl-format=bestvideo+bestaudio/best --profile=norm --fs "$(copyq clipboard)"