#!/bin/bash

cat << EOF >> ${BOOT_MOUNT_PATH}/config.txt

# Enable 1080p
gpu_mem=128
EOF
