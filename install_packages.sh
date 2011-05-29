#!/bin/bash
set -e

cd `dirname $0`

# add partner sources
sudo sed -ie 's/# \(deb.*partner\)/\1/g' /etc/apt/sources.list

# dist-upgrade
sudo apt-get update
sudo apt-get -fy install
sudo apt-get dist-upgrade -y

# install from install_packages by aptitude
sudo apt-get install -y $(sed 's/#.*//g' $(find install_packages -name '*.apt'))

# install from install_packages by sh scripts
for script in $(find install_packages -name '*.sh'); do ./$script; done

# install from .deb files
function install_from_deb {
        PACKAGE=$(dpkg --info $1  | grep Package | awk '{ print $2 }')
        if [ -n "$((dpkg --status $PACKAGE || true) | grep 'Status: install ok installed')" ]; then return; fi
	sudo gdebi -n $1
}
for deb in $(find install_packages -name '*.deb'); do install_from_deb ./$deb; done
