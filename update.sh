#!/bin/bash

if [[ $EUID != 0 ]]; then
  echo "ERROR: You most probably need superuser privileges to update modules, please run me via sudo!"
  exit -3
fi

echo "Uninstalling outdated modules"
./uninstall.sh
    
echo "Installing latest version"
./install.sh
