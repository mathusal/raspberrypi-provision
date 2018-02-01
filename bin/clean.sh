#!/bin/bash

set -e

. ${SCRIPT_PATH}/bin/common.sh

usage() {
cat << EOF
Usage: $0 [opt...]
       $0 [ -h | --help ]

Clean workspace

Options:
  -a            Clean all data (dist & tmp folders)
  -h, --help    Print usage

EOF
exit
}

COMMAND="rm -rf rm -rf $DIST_PATH"

case $1 in
  -a)
    COMMAND="$COMMAND $TMP_PATH"
    ;;
  -h|--help)
    usage
    ;;
esac

title "Clean project"

${COMMAND}

message "Clean success"
