#!/bin/bash

PERFORMANCE="󰉁 per"
BALANCED="󰉁 bal"
POWERSAVING="󰉁 pow"
if powerprofilesctl list | grep -q "* balanced" ; then
    echo $BALANCED; 
fi
if powerprofilesctl list | grep -q "* performance" ; then
    echo $PERFORMANCE; 
fi
if powerprofilesctl list | grep -q "* power-saver" ; then
    echo $POWERSAVING; 
fi
