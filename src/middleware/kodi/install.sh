#!/bin/bash

if [ "$(id -u)" != "0" ]
then
    echo "Please run this script as root."
    exit 1
fi

SCRIPT_PATH=$(dirname "$(readlink -f "$0")")

apt-get update
apt-get install -y kodi

cp ${SCRIPT_PATH}/conf/kodi.service /lib/systemd/system/
systemctl enable kodi
systemctl start kodi
