#!/bin/bash

if [[ $EUID != 0 ]]; then
  echo "ERROR: This script must be run as root!"
  exit -3
fi

echo "Unloading current driver module"
modprobe -r hid-nintendo-nx

echo "Looking for registered instances"
VERSIONS=($(dkms status 2>/dev/null | sed -E -n 's/hid-nintendo-nx, ([0-9]+.[0-9]+).*/\1/ p' | sort -u))
echo "found ${#VERSIONS[@]} registered instance(s) on your system"

for instance in "${VERSIONS[@]}"
do
    echo ">> $instance"

    echo "Uninstalling and removing $instance from DKMS"
    dkms remove -m hid-nintendo-nx -v "$instance" --all

    echo "Rmoving $instance folder from /usr/src"
    rm --recursive "/usr/src/hid-nintendo-nx$instance/"
done
