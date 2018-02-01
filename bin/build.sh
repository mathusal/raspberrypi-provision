#!/bin/bash

set -e

. ${SCRIPT_PATH}/bin/common.sh

usage() {
cat << EOF
Usage: $0 SOFTWARE...
       $0 [ -h | --help ]

Build image

Argument:
  SOFTWARE      Software to install into image

Options:
  -h, --help    Print usage

EOF
exit
}

checkArchive() {
  title "Check archive"

  # check latest online version
#  LATEST_URL=$(curl -w "%{url_effective}" -I -L -s -S https://downloads.raspberrypi.org/raspbian_lite_latest -o /dev/null)
  LATEST_URL=$(curl -w "%{url_effective}" -I -L -s -S http://downloads.raspberrypi.org/raspbian_lite/images/raspbian_lite-2017-07-05/2017-07-05-raspbian-jessie-lite.zip -o /dev/null)
  LATEST_VERSION=$(basename ${LATEST_URL} | cut -d'.' -f1)

  # create tmp folder if not exists
  [ -z ${TMP_PATH} ] || mkdir -p ${TMP_PATH}

  # check tmp folder
  ARCHIVE_NAME=$(ls -h ${TMP_PATH} | tail -n -1)
  if [ "$ARCHIVE_NAME" = "" ]
  then
    message "Raspbian archive does not exist, downloading latest version"
    curl ${LATEST_URL} -o ${TMP_PATH}/${LATEST_VERSION}.zip
    ARCHIVE_NAME=${LATEST_VERSION}.zip
  else
    message "Raspbian archive exists at $TMP_PATH/$ARCHIVE_NAME"

    # propose latest version
    if [ "$ARCHIVE_NAME" != "${LATEST_VERSION}.zip" ]
    then
      read -p "[ A new Raspbian version exists : $LATEST_VERSION ] Download it? [y/N] " -n 1 -r
      echo
      if [[ $REPLY =~ ^[Yy]$ ]]
      then
        curl ${LATEST_URL} -o ${TMP_PATH}/${LATEST_VERSION}.zip
        ARCHIVE_NAME=${LATEST_VERSION}.zip
      fi
    fi
  fi
}

extractArchive() {
  title "Extract archive"

  mkdir -p ${DIST_PATH}
  unzip -q ${TMP_PATH}/${ARCHIVE_NAME} -d ${DIST_PATH}

  message "Extract success"
}

mountImage() {
  title "Mount image"

  mkdir -p ${DIST_PATH}/mount/boot ${DIST_PATH}/mount/system
  BOOT_OFFSET=$(( $(fdisk -lu ${DIST_PATH}/*.img | grep img1 | tr -s ' ' | cut -d ' ' -f 2)  * 512))
  SYSTEM_OFFSET=$(( $(fdisk -lu ${DIST_PATH}/*.img | grep img2 | tr -s ' ' | cut -d ' ' -f 2)  * 512))
  mount -o loop,offset=${BOOT_OFFSET} ${DIST_PATH}/*.img ${BOOT_MOUNT_PATH}
  mount -o loop,offset=${SYSTEM_OFFSET} ${DIST_PATH}/*.img ${SYSTEM_MOUNT_PATH}

  message "Mount success"
}

setupImage() {
  title "Setup image"

  # execute system scripts
  for script in src/system/*
  do
    . ${script}
  done

#  # execute middleware scripts
#  while [ "$1" != "" ]
#  do
#    . ./src/middleware/$1/install.sh
#    shift
#  done
  cp -r ${SCRIPT_PATH}/src/middleware/* ${SYSTEM_MOUNT_PATH}/home/pi

  message "Setup success"
}

umountImage() {
  title "Umount image"

  umount ${DIST_PATH}/mount/*

  message "Umount success"
}

if [ "$1" = "-h" -o "$1" = "--help" ]
then
  usage
fi
# clean the workspace
${SCRIPT_PATH}/bin/clean.sh

# setup custom image
checkArchive
extractArchive
mountImage
setupImage $*
umountImage

# clean up the folder owner caused by root execution
chown -R ${SUDO_USER}:${SUDO_USER} ${TMP_PATH} ${DIST_PATH}
