#!/bin/bash

set -e

. ${SCRIPT_PATH}/bin/common.sh

usage() {
cat << EOF
Usage: $0 SD_PATH
       $0 [ -h | --help ]

Install image

Argument:
  SD_PATH       SD card path to install the image on

Options:
  -h, --help    Print usage

EOF
exit
}

if [ "$1" = "-h" -o "$1" = "--help" ]
then
  usage
fi

title "Install image"

if [ ! -d ${DIST_PATH} ]
then
  message "You must build the image before install"
  exit 1
fi

if [ "$1" = "" ]
then
  message "You must specify micro sd card path (eg: /dev/mmcblk0)"
  exit 1
fi

IMG_NAME=$(ls ${DIST_PATH}/*.img)
dd if=${IMG_NAME} of=$1

message "Install success"
