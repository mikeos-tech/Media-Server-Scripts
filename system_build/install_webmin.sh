# install_webmin.sh 
# creator: Mike O'Shea 
# Updated: 12/05/2021 
# Installs webmin on the server. 
# If you are running this a second time it would be better to comment out the sudo echo command
# near the top.  

# GNU General Public License, version 3

#!/bin/bash

sudo echo "deb http://download.webmin.com/download/repository sarge contrib" >> /etc/apt/sources.list
wget -q -O- http://www.webmin.com/jcameron-key.asc | sudo apt-key add
sudo apt update
sudo apt install webmin
sudo ufw allow 10000
