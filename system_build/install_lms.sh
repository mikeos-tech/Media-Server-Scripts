# install_lms.sh 
# creator: Mike O'Shea 
# Updated: 10/05/2021 
# Downloads a version of lms/squeezebox server, you need to ensure
# it is the latest version before you run the script.

# It then installs it and some dependences and changes the 
# permissions on some folders and sets LMS to load automatically
# when the server starts.

# GNU General Public License, version 3

#!/bin/bash

wget http://downloads.slimdevices.com/LogitechMediaServer_v8.1.1/logitechmediaserver_8.1.1_amd64.deb
sudo dpkg -i logitechmediaserver_8.1.1_amd64.deb
sudo apt install libio-socket-ssl-perl
sudo apt --fix-broken install
sudo adduser squeezeboxserver
sudo groupadd squeezeboxserver
sudo mkdir /var/run/logitechmediaserver
sudo usermod -a -G squeezeboxserver squeezeboxserver
sudo chown squeezeboxserver:squeezeboxserver /var/run/logitechmediaserver
sudo chown squeezeboxserver:squeezeboxserver /var/lib/squeezeboxserver
sudo chown -R squeezeboxserver:squeezeboxserver /var/lib/squeezeboxserver/*
sudo chown -R squeezeboxserver:squeezeboxserver /storage/

sudo usermod -a -G squeezeboxserver $USER

sudo chown -R squeezeboxserver:squeezeboxserver /storage/
sudo chmod -R g+rw /storage/

sudo systemctl daemon-reload
/etc/init.d/logitechmediaserver start
/etc/init.d/logitechmediaserver stop
sudo systemctl enable logitechmediaserver.service
