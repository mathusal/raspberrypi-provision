#!/bin/bash

if [ "$(id -u)" != "0" ]
then
    echo "Please run this script as root."
    exit 1
fi

set -e

apt-get update
apt-get upgrade -y
apt-get install -y tree nfs-kernel-server

# fix for portmapper start before nfs server
cat <<EOF | sudo tee -a /etc/systemd/system/rpcbind.service
[Unit]
Description=RPC bind portmap service
After=systemd-tmpfiles-setup.service
Wants=remote-fs-pre.target
Before=remote-fs-pre.target
DefaultDependencies=no

[Service]
ExecStart=/sbin/rpcbind -f -w
KillMode=process
Restart=on-failure

[Install]
WantedBy=sysinit.target
Alias=portmap
EOF

systemctl enable rpcbind
systemctl start rpcbind
systemctl enable nfs-kernel-server
systemctl restart nfs-kernel-server

