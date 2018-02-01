#!/bin/bash

if [ "$(id -u)" != "0" ]
then
    echo "Please run this script as root."
    exit 1
fi

SCRIPT_PATH=$(dirname "$(readlink -f "$0")")

# TODO
