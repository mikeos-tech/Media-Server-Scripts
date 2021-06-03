# software_install.sh 
# creator: Mike O'Shea 
# Updated: 09/05/2021 
# Installs a lot of the standard packages used by the build. 
# Some packages will be included in other scripts, but 
# including them multiple times has no significant impact.

# GNU General Public License, version 3

#!/bin/bash

# you need to set the command below to the correct timezone for you.
sudo timedatectl set-timezone Europe/London

sudo apt update && sudo apt upgrade

# This fails because there isn't yet a ppa for this version of ubuntu
sudo add-apt-repository ppa:transmissionbt/ppa

sudo apt install atomicparsley
sudo apt install build-essential 
sudo apt install bzip2
sudo apt install cifs-utils
sudo apt install cpanminus 
sudo apt install curl
sudo apt install dconf-editor
sudo apt install dpkg
sudo apt install exiftool
sudo apt install ffmpeg
sudo apt install flac
sudo apt install git
sudo apt install htop
sudo apt install libcgi-pm-perl
sudo apt install libio-socket-ssl-perl
sudo apt install liblocal-lib-perl
sudo apt install liblwp-protocol-h 
sudo apt install libmojolicious-perl 
sudo apt install libsqlite3-dev
sudo apt install libwww-perl 
sudo apt install libxml-libxml-perl 
sudo apt install mc
sudo apt install net-tools
sudo apt install nfs-kernel-server
sudo apt install nginx
sudo apt install php-fpm
sudo apt install php-sqlite3
sudo apt install rsync
sudo apt install samba
sudo apt install sqlite3
sudo apt install ssh
sudo apt install ssmtp
sudo apt-get install transmission-cli transmission-common transmission-daemon
sudo apt install tree
sudo apt install ttps-perl 
sudo apt install zip
sudo apt install -y usbmount

sudo apt install ca-certificates
sudo update-ca-certificates

sudo apt --fix-broken install
sudo apt update && sudo apt -y upgrade && sudo apt -y autoremove && sudo apt clean

# Adjusts for the fact that ubuntu stores certificates in a different location to other distros
sudo mkdir -p /etc/pki/tls/certs/
sudo ln -s /etc/ssl/certs/ca-certificates.crt /etc/pki/tls/certs/ca-bundle.crt

