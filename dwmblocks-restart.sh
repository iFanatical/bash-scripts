#!/bin/bash

pgrep -f dwmblocks &> /dev/null && killall dwmblocks || dwmblocks
