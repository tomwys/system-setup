#!/bin/bash

function install_from_url {
        if [ -n "$((dpkg --status $1 || true) | grep 'Status: install ok installed')" ]; then return; fi
        rm /tmp/package.deb
	wget $2 -O /tmp/package.deb
        sudo dpkg -i /tmp/package.deb
        sudo apt-get -fy install
}
