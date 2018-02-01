#!/bin/bash

if [ "$(id -u)" != "0" ]
then
    echo "Please run this script as root."
    exit 1
fi

SCRIPT_PATH=$(dirname "$(readlink -f "$0")")

mkdir /opt/jdownloader
# TODO replace with wget
cp ${SCRIPT_PATH}/conf/JDownloader.jar /opt/jdownloader/
cp ${SCRIPT_PATH}/conf/jdownloader.service /lib/systemd/system/
systemctl enable jdownloader
