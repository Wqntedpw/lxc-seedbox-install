#!/bin/bash
###
# LXC Seedbox Install
###
#
###



## Includes ##
. inc/vars.sh
. inc/funcs.sh

test_lxc
echo -e "[${green}V${nc}] Runnning in an LXC"

test_root
echo -e "[${green}V${nc}] Runnning as root"

echo -e "Updating and installing required packages"
apt update && apt upgrade -y
apt install -y apt-transport-https gnupg2
clear

echo -e "Adding repository"
add_repository 
clear

echo -e "Installing packages"
install_packages ; install_xmrpc ; install_libtorrent ; install_rtorrent ; install_rutorrent ; install_rutorrentplugins

