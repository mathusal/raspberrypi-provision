#!/bin/bash

# ssh key
SSH_RSA="ssh-rsa PRIVATE_KEY"

# enable ssh
touch ${BOOT_MOUNT_PATH}/ssh

# configure ssh
mkdir -p ${SYSTEM_MOUNT_PATH}/home/pi/.ssh
cat << EOF > ${SYSTEM_MOUNT_PATH}/home/pi/.ssh/authorized_keys
${SSH_RSA}
EOF
chmod 600 ${SYSTEM_MOUNT_PATH}/home/pi/.ssh/authorized_keys
chown -R 1000:1000 ${SYSTEM_MOUNT_PATH}/home/pi/.ssh
