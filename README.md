# USB and Bluetooth Linux Driver for Nintendo Switch Pro Controller and Joycons
This driver is based on Daniel Ogorchock's driver that is included in https://github.com/DanielOgorchock/linux. I've added proper controller enumeration similar to how it works on Nintendo Switch.
DKMS and build scripts are based on https://github.com/atar-axis/xpadneo. This driver was tested on Ubuntu 19.10.

For dual joycon support as one controller you are going to need: https://github.com/DanielOgorchock/joycond

## Build instructions
### Dependencies 

* Ubuntu and derivatives 
``sudo apt install dkms linux-headers-`uname -r` ``  

### Installation
* `git clone https://github.com/mpawlowski7/nxcontrollers.git`
* `cd nxcontrollers`
* `sudo ./install.sh`

### Usage
* Load module `sudo modprobe hid_nintendo` (or reboot)
* Connect controller via USB or Bluetooth,
* Verify that driver is loaded `lsmod | grep 'hid_nintendo'`

### Update
* `git pull`
* `sudo ./update.sh`

### Uninstallation
* Run `sudo ./uninstall.sh` to remove all installed versions of hid-nintendo.

## Using in Lutris
To use it in Lutris copy paste path to **sdl2/gamecontrollerdb.txt** or **sdl2/gamecontrollerdb_nx.txt(for reverse Nintendo-like button order)** into **System options > Show advanced options > SDL2 gamepad mapping**