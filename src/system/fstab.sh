#!/bin/bash

# TODO or not TODO ?
#mkdir \
#  ${SYSTEM_MOUNT_PATH}/media/rodolpheche \
#  ${SYSTEM_MOUNT_PATH}/media/raspmedia \
#  ${SYSTEM_MOUNT_PATH}/media/raspbackup
#
cat << eof >> ${SYSTEM_MOUNT_PATH}/etc/fstab
#uuid=                        /media/rodolpheche   ntfs    nofail             0       0
UUID=3DE2518407869147                       /media/raspmedia    ntfs   defaults,nofail,users,permissions,auto   0   0
UUID=21046ee9-1563-4fa1-b1fa-7612cbbf03be   /media/raspbackup   ext4   defaults,nofail                          0   0
eof
