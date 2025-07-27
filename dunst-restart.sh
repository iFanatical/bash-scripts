#!/bin/bash

pgrep -f dunst &> /dev/null && killall dunst || dunst
