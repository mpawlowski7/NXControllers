#!/bin/bash

# exit immediately if one command fails
set -e

if [[ $EUID != 0 ]]; then
  echo "ERROR: This script must be run as sudo!"
  exit -3
fi

VERSION=$(cat VERSION)

echo "Backup original files, preserve permissions"
cp --preserve hid-nintendo-nx/dkms.conf hid-nintendo-nx/dkms.conf.bak
cp --preserve hid-nintendo-nx/src/hid-nintendo-nx.c hid-nintendo-nx/src/hid-nintendo-nx.c.bak 

echo "Replacing version string if necessary"
sed -i 's/PACKAGE_VERSION="@DO_NOT_CHANGE@"/PACKAGE_VERSION="'"$VERSION"'"/g' hid-nintendo-nx/dkms.conf

INSTALLED=$(dkms status 2>/dev/null | grep '^hid-nintendo-nx,' 2>/dev/null | sed -E 's/^hid-nintendo-nx, ([0-9]+.[0-9]+).*installed/\1/')

if [[ -z "$INSTALLED" ]]; then

    echo "Copying module into /usr/src"
    cp --recursive "$PWD/hid-nintendo-nx/" "/usr/src/hid-nintendo-nx-$VERSION"

    echo "Adding module to DKMS"
    dkms add -m hid-nintendo-nx -v "$VERSION"

    echo "Installing module (using DKMS)"
    dkms install -m hid-nintendo-nx -v "$VERSION"

else

    echo "Already installed!"
fi

# restore original files
mv hid-nintendo-nx/dkms.conf.bak hid-nintendo-nx/dkms.conf
mv hid-nintendo-nx/src/hid-nintendo-nx.c.bak hid-nintendo-nx/src/hid-nintendo-nx.c
