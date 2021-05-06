# backup_build.sh
# creator: Mike O'Shea 
# Updated: 06/05/2021 
# Creates zip file backups of the key folders and config files
# specified in the last column of the zip commands.
# It records when it runs if the defined log file.
# It is run when you detach from the tmuxinator webdev session,
# so will backup changes made during that session.
# It should be run regularly manually, depending on the changes
# you have made or are about to make?

# GNU General Public License, version 3

#!/bin/bash 

now=$(date +%Y-%m-%d %H%M)
fnow=$(date +%Y%m%d-%H%M)
log='/get_iplayer/lists/script_log.csv'

zip -r -Z bzip2 /torage/$fnow-web_site.zip 	/var/www/html/
zip -r -Z bzip2 /storage/$fnow-get_iplayer.zip  /get_iplayer/  -x "*.mp4" "*.flac" "*.m4a"
zip -r -Z bzip2 /storage/$fnow-scripts.zip 	/scripts/
zip -r -Z bzip2 /storage/$fnow-history.zip 	/home/mike/.get_iplayer/
zip -r -Z bzip2 /storage/$fnow-tmuxinator.zip 	/home/mike/.config/tmuxinator/
zip -r -Z bzip2 /storage/$fnow-config.zip 	/etc/fstab
zip -r -Z bzip2 /storage/$fnow-config.zip 	/etc/samba/smb.conf
zip -r -Z bzip2 /storage/$fnow-config.zip       /home/mike/.vimrc
zip -r -Z bzip2 /storage/$fnow-config.zip       /home/mike/.gitconfig
zip -r -Z bzip2 /storage/$fnow-config.zip       /home/mike/.bashrc
zip -r -Z bzip2 /storage/$fnow-config.zip       /home/mike/.tmux.conf
zip -r -Z bzip2 /storage/$fnow-config.zip 	/home/mike/.config/transmission-daemon/settings.json

echo "$now,backup_build.sh,Various,/storage/" >> $log
