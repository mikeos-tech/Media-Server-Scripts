# install_transmission.sh 
# creator: Mike O'Shea 
# Updated: 125/05/2021 
# Creates a SQLite Database and stores it in the folder specified below. 
# Is used by the backupQ executable to maintain a record of available  
# backup USB drives and record their usage. 

# GNU General Public License, version 3

#!/bin/bash

sudo add-apt-repository ppa:transmissionbt/ppa
sudo apt install transmission

sudo usermod -a -G debian-transmission $USER

This line give the group access, so combined with putting the current use in the group it makes it possible to back up the transmissions settings file
sudo chmod g+r /etc/transmission-daemon/settings.json
