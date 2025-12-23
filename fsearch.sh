#!/usr/bin/env bash
pgrep -f dunst &> /dev/null && pkill fsearch || fsearch
