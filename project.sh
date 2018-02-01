#!/bin/bash

if [ "$(id -u)" != "0" ]
then
    echo "Please run this script as root."
    exit 1
fi

export SCRIPT_PATH=$(dirname "$(readlink -f "$0")")
export TMP_PATH="$SCRIPT_PATH/.tmp"
export DIST_PATH="$SCRIPT_PATH/.dist"
export BOOT_MOUNT_PATH="$DIST_PATH/mount/boot"
export SYSTEM_MOUNT_PATH="$DIST_PATH/mount/system"

usage() {
cat << EOF
Usage: $0 COMMAND [arg...]
       $0 [ -h | --help ]

Prepare your custom raspberry image

Options:
  -h, --help    Print usage

Commands:
  clean         Clean workspace
  build         Build image
  install       Install image into specified micro sd card

Run '$0 COMMAND --help' for more information on a command.
EOF
exit
}

case $1 in
  clean|build|install)
    ./bin/$1.sh ${@:2}
    ;;
  *)
    usage
    ;;
esac
