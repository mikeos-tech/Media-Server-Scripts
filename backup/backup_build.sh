# backup_build.sh
# creator: Mike O'Shea 
# Updated: 06/05/2021 
# Creates zip file backups of the key folders server specific 
# config files, specified in the last column of the zip commands.
# It records when it runs if the defined log file.
# It is run when you detach from the tmuxinator webdev session,
# so will backup changes made during that session.
# It should be run regularly manually, depending on the changes
# you have made or are about to make?

# GNU General Public License, version 3

#!/bin/bash 

now=$(date +%Y-%m-%d,%H:%M)
fnow=$(date +%Y%m%d-%H%M)
log='/get_iplayer/lists/script_log.csv'

zip -r -Z bzip2 /storage/$fnow-web_site.zip 	/var/www/html/
zip -r -Z bzip2 /storage/$fnow-get_iplayer.zip  /get_iplayer/  -x "*.mp4" "*.flac" "*.m4a"
zip -r -Z bzip2 /storage/$fnow-scripts.zip 	/scripts/
zip -r -Z bzip2 /storage/$fnow-history.zip 	/home/mike/.get_iplayer/
zip -r -Z bzip2 /storage/$fnow-config.zip 	/etc/fstab
zip -r -Z bzip2 /storage/$fnow-config.zip 	/etc/samba/smb.conf
zip -r -Z bzip2 /storage/$fnow-config.zip	/etc/nginx/nginx.conf
# The permissions for the folder won't let it be added to the zip, so I am
# copying it and trying backing up the copy.
cp /home/mike/.config/transmission-daemon/settings.json /tmp/settings.json
zip -r -Z bzip2 /storage/$fnow-config.zip 	/tmp/settings.json
rm /tmp/settings.json

echo "$now,backup_build.sh,Various,/storage/" >> $log
