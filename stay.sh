#!/bin/bash
alacritty -e bash -c "$*; echo; echo; tput setaf 5; read -p 'Press any key to continue.' -n 1"
