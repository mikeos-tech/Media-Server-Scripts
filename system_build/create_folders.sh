# create_folders.sh
# creator: Mike O'Shea 
# Updated: 08/05/2021 
# Creates the folder structure used by the music server and sets the 
# permissions for it to work.

# I've added a folder structure to hold the web site once I have moved
# everything to a sub-folder allowing for multiple sites to be hosted.

# GNU General Public License, version 3

#!/bin/bash

#sudo adduser squeezeboxserver
sudo groupadd -f musicserver
#sudo groupadd -f squeezeboxserver
sudo groupadd -f www-data
sudo usermod -a -G musicserver $USER
sudo usermod -a -G www-data $USER
#sudo usermod -a -G squeezeboxserver $USER
sudo usermod -a -G debian-transmission $USER

sudo mkdir -p /backup
sudo chgrp -R musicserver /backup/
sudo chmod -R g+rw /backup/

sudo mkdir -p /backups_local
sudo chgrp -R musicserver /backups_local/
sudo chmod -R g+rw /backups_local/

sudo mkdir -p /backupQ
sudo chgrp -R musicserver /backupQ/
sudo chmod -R g+rw /backupQ/

sudo mkdir -p /documenation
sudo chgrp -R musicserver /documenation/
sudo chmod -R g+rw /documenation/

# This was something I set up to test NFS
#sudo mkdir -p /general_share
#sudo chgrp -R musicserver /general_share/
#sudo chmod -R g+rw /general_share/

sudo mkdir -p /get_iplayer/database
sudo mkdir -p /get_iplayer/downloads
sudo mkdir -p /get_iplayer/lists
sudo chgrp -R musicserver /get_iplayer/
sudo chmod -R g+rw /get_iplayer/

sudo mkdir -p ~/projects

sudo mkdir -p /scripts/backup
sudo mkdir -p /scripts/maintenance
sudo mkdir -p /scripts/system_build
sudo mkdir -p /scripts/tools
sudo chgrp -R musicserver /scripts/
sudo chmod -R 777 /scripts/

sudo mkdir -p /storage
#sudo chown -R squeezeboxserver:squeezeboxserver /storage/
sudo chown -R mike:mike /storage/
sudo chmod -R g+rw /storage/


sudo mkdir -p /var/www/html/music_server/MAL
sudo mkdir -p /var/www/html/music_server/css
sudo mkdir -p /var/www/html/music_server/environment
sudo mkdir -p /var/www/html/music_server/images
sudo mkdir -p /var/www/html/music_server/javascript
sudo mkdir -p /var/www/html/music_server/smarty/cache
sudo mkdir -p /var/www/html/music_server/smarty/config
sudo mkdir -p /var/www/html/music_server/smarty/templates
sudo mkdir -p /var/www/html/music_server/smarty/templates_c
sudo chgrp -R www-data /var/www
sudo chmod -R g+rw /var/www

# these may be required by nfs
#sudo chown -R nobody:nogroup /storage/
#sudo chown -R nobody:nogroup /general_share/
#sudo chown -R nobody:nogroup /get_iplayer/lists/
