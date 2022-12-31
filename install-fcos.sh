#!/bin/sh
if ! (( $EUID == 0 )); then exec sudo "$0" "$@"; fi
set -v
docker run --rm -i quay.io/coreos/butane:release --pretty --strict <ignition.bu >ignition.ign
docker run --rm --privileged -v /dev:/dev -v /run/udev:/run/udev -v $PWD/ignition.ign:/data/ignition.ign -w /data quay.io/coreos/coreos-installer:release install --architecture=aarch64 /dev/mmcblk0 -i ignition.ign
sync
mount /dev/mmcblk0p2 /mnt
cd /mnt
curl -L 'https://github.com/pftf/RPi4/releases/download/v1.34/RPi4_UEFI_Firmware_v1.34.zip' | bsdtar xv
cd -
umount /mnt
sync
