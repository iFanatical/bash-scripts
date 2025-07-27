#!/bin/bash

pgrep -f picom &> /dev/null && killall picom || picom -b
