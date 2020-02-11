#!/bin/bash
###
# LXC Seedbox Install
###
#
###


## Includes ##
. inc/vars.sh
. inc/funcs.sh

test_lxc ; test_root


echo -e "Updating and installing required packages"
apt update && apt upgrade -y
apt install -y apt-transport-https gnupg2
hr


add_repository ; install_packages

install_xmrpc 

install_libtorrent
install_rtorrent
install_rutorrent ; install_rutorrentplugins