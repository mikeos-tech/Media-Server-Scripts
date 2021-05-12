# install_get_iplayer.sh 
# creator: Mike O'Shea 
# Updated: 12/05/2021 
# Installs the non-snap version of get-iplayer, which I had problems with 
# as far as the installation letting me update it's configuration folder.

# GNU General Public License, version 3

#!/bin/bash

sudo apt install libwww-perl liblwp-protocol-h ttps-perl libmojolicious-perl libxml-libxml-perl libcgi-pm-perl
apt install build-essential cpanminus liblocal-lib-perl

# set configuration for current shell
eval `perl -I ~/perl5/lib/perl5 -Mlocal::lib`
# set configuration for future sessions
echo 'eval `perl -I ~/perl5/lib/perl5 -Mlocal::lib`' >> ~/.bash_profile

cpanm LWP LWP::Protocol::https XML::LibXML Mojolicious CGI

sudo apt install atomicparsley ffmpeg

cd ~
mkdir get-iplayer
cd get-iplayer
wget https://raw.githubusercontent.com/get-iplayer/get_iplayer/master/get_iplayer
sudo install -m 755 ./get_iplayer /usr/local/bin
