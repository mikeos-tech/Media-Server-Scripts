# monthly_backup.sh
# creator: Mike O'Shea 
# Updated: 07/05/2021 
# Creates a singe zip file backup of the key folders 
# and config files specified in the last column 
# of the zip commands.
# It records when it runs in the defined log file.
# It backs up the same files as the build_backup.sh script,
# but is run using cron, rather than manually and saves its
# files remotely rather than locally.
 
# GNU General Public License, version 3

#!/bin/bash 

now=$(date +%Y-%m-%d,%H:%M)
fnow=$(date +%Y%m%d-%H%M)
name="$fnow-media_server.zip"
log='/get_iplayer/lists/script_log.csv'
target='root@192.168.2.4:/mnt/Storage/Dev_Backup/'

zip -r -Z bzip2 /storage/$name	/var/www/html/
zip -r -Z bzip2 /storage/$name 	/get_iplayer/  -x "*.mp4" "*.flac" "*.m4a"
zip -r -Z bzip2 /storage/$name 	/scripts/
zip -r -Z bzip2 /storage/$name	/home/mike/.get_iplayer/
zip -r -Z bzip2 /storage/$name	/home/mike/.config/tmuxinator/
zip -r -Z bzip2 /storage/$name	/etc/fstab
zip -r -Z bzip2 /storage/$name 	/etc/samba/smb.conf
zip -r -Z bzip2 /storage/$name 	/home/mike/.vimrc
zip -r -Z bzip2 /storage/$name 	/home/mike/.gitconfig
zip -r -Z bzip2 /storage/$name 	/home/mike/.bashrc
zip -r -Z bzip2 /storage/$name	/home/mike/.tmux.conf
zip -r -Z bzip2 /storage/$name  /etc/nginx/nginx.conf
zip -r -Z bzip2 /storage/$name	/home/mike/.config/transmission-daemon/settings.json

rsync -a -r $name  $target

if [ $? -eq 0 ]; then
	echo "$now,monthly_backup.sh,$name,$target" >> $log
	rm $name
fi
