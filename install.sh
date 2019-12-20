#!/bin/bash

# exit immediately if one command fails
set -e

if [[ $EUID != 0 ]]; then
  echo "ERROR: This script must be run as sudo!"
  exit -3
fi

VERSION=$(cat VERSION)

echo "Backup original files, preserve permissions"
cp --preserve hid-nintendo/dkms.conf hid-nintendo/dkms.conf.bak
cp --preserve hid-nintendo/src/hid-nintendo.c hid-nintendo/src/hid-nintendo.c.bak 

echo "Replacing version string if necessary"
sed -i 's/PACKAGE_VERSION="@DO_NOT_CHANGE@"/PACKAGE_VERSION="'"$VERSION"'"/g' hid-nintendo/dkms.conf

INSTALLED=$(dkms status 2>/dev/null | grep '^hid-nintendo,' 2>/dev/null | sed -E 's/^hid-nintendo, ([0-9]+.[0-9]+).*installed/\1/')

if [[ -z "$INSTALLED" ]]; then

    echo "Copying module into /usr/src"
    cp --recursive "$PWD/hid-nintendo/" "/usr/src/hid-nintendo-$VERSION"

    echo "Adding module to DKMS"
    dkms add -m hid-nintendo -v "$VERSION"

    echo "Installing module (using DKMS)"
    dkms install -m hid-nintendo -v "$VERSION"

else

    echo "Already installed!"
fi

# restore original files
mv hid-nintendo/dkms.conf.bak hid-nintendo/dkms.conf
mv hid-nintendo/src/hid-nintendo.c.bak hid-nintendo/src/hid-nintendo.c