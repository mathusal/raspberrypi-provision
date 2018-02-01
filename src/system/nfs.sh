#!/bin/bash

mkdir -p ${SYSTEM_MOUNT_PATH}/media/pi
cat << EOF > ${SYSTEM_MOUNT_PATH}/etc/exports
/media/pi *(rw,async,no_subtree_check,no_root_squash)
EOF
