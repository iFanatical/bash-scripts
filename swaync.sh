#!/bin/bash

pgrep -f swaync &> /dev/null && killall swaync || swaync
