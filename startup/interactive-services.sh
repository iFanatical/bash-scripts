#!/bin/bash
$SCRIPTS/media-notification.sh &
$SCRIPTS/gpu-screen-recorder.sh &
/usr/lib/mate-polkit/polkit-mate-authentication-agent-1 &
