#!/bin/bash

function cd {
    if [ "$@" = "-" ]; then
        z -
    else
        z "$@" && pwd
    fi
}