#!/usr/bin/env bash

record() {
  wf-recorder -o DP-2 -r 60 -f "/drives/wd4TB/videos/recordings/video_$(date '+%a__%b%d__%H_%M_%S').mkv" &
  echo $! > /tmp/recpid
  ffmpeg -f alsa -i default -af "afftdn=nf=-75" "/drives/wd4TB/videos/recordings/audio_$(date '+%a__%b%d__%H_%M_%S').wav" &
  echo $! > /tmp/audpid

  echo " Rec • " > /tmp/recordingicon && pkill -SIGRTMIN+12 waybar
  notify-send -t 3000 -h string:bgcolor:#8bbf48 "Recording started & mic toggled"
  }

end() {
  kill -15 "$(cat /tmp/recpid)" "$(cat /tmp/audpid)" && rm -f /tmp/recpid /tmp/audpid
  echo "" > /tmp/recordingicon && pkill -SIGRTMIN+12 waybar

  notify-send -t 3000 -h string:bgcolor:#fc5353 "Recording ended & mic toggled"
  }
([[ -f /tmp/recpid ]] && end && exit 0) || record
