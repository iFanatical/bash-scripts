#!/bin/bash

pgrep -f conky &> /dev/null && killall conky || conky