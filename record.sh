#!/usr/bin/env bash

record() {
  # Toggle on mic -- mic shouldn't need a toggle
  #amixer set Capture toggle

  # Original command for my own screen: :0.0+1920,0 ensures only 2nd monitor is captured
  # -c:v sets codec, in this case, H.264; -qp 0 ensures lossless

  # ffmpeg -s 1920x1200 -f x11grab -r 30 -i :0.0+1920,0 -c:v h264 -qp 0 "$HOME/video_$(date '+%a__%b%d__%H_%M_%S').mkv" &

  # Generic command to record at your screen dimensions
  #ffmpeg -s "$(xdpyinfo | awk '/dimensions/{print $2}')" -f x11grab -r 30 -i :0.0 -c:v h264 -qp 0 "/drives/wd8TB/videos/recordings/video_$(date '+%a__%b%d__%H_%M_%S').mkv" &
  ffmpeg -s 2560x1440 -f x11grab -r 30 -i :0.0+1920 -c:v h264 -qp 0 "/drives/wd8TB/videos/recordings/video_$(date '+%a__%b%d__%H_%M_%S').mkv" &
  echo $! > /tmp/recpid

  # Specify alsa device with hw:0 etc.
  # Filters audio noise with noise floor
  ffmpeg -f alsa -i default -af "afftdn=nf=-75" "/drives/wd8TB/videos/recordings/audio_$(date '+%a__%b%d__%H_%M_%S').wav" &
  echo $! > /tmp/audpid

  echo " Rec •" > /tmp/recordingicon && pkill -RTMIN+3 dwmblocks

  notify-send -t 500 -h string:bgcolor:#8bbf48 "Recording started & mic toggled"
  }

end() {
  kill -15 "$(cat /tmp/recpid)" "$(cat /tmp/audpid)" && rm -f /tmp/recpid /tmp/audpid

  # Mic on by default
  #amixer set Capture toggle

  echo "" > /tmp/recordingicon && pkill -RTMIN+3 dwmblocks

  notify-send -t 500 -h string:bgcolor:#fc5353 "Recording ended & mic toggled"
  }

# If the recording pid exists, end recording. If not, start recording
([[ -f /tmp/recpid ]] && end && exit 0) || record
