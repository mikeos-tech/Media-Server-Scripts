# monthly_backup.sh
# creator: Mike O'Shea 
# Updated: 08/05/2021 
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
target='/backups_local/'
name="$target$fnow-media_server.zip"
log=$target'script_log.csv'
remote_target='root@192.168.2.4:/mnt/Storage/Dev_Backup/'
completed=N

zip -r -Z bzip2 $name	/documenation/
zip -r -Z bzip2 $name	/etc/dnsmasq.conf
zip -r -Z bzip2 $name	/etc/fstab
zip -r -Z bzip2 $name	/etc/hosts
zip -r -Z bzip2 $name	/etc/nginx/nginx.conf
zip -r -Z bzip2 $name	/etc/resolv.conf
zip -r -Z bzip2 $name	/etc/samba/smb.conf
zip -r -Z bzip2 $name	/etc/transmission-daemon/settings.json
zip -r -Z bzip2 $name	/get_iplayer/  -x "*.mp4" "*.flac" "*.m4a"
zip -r -Z bzip2 $name	/home/mike/.bashrc
zip -r -Z bzip2 $name	/home/mike/.config/tmuxinator/
zip -r -Z bzip2 $name	/home/mike/.get_iplayer/
zip -r -Z bzip2 $name	/home/mike/.gitconfig
zip -r -Z bzip2 $name	/home/mike/.ssh
zip -r -Z bzip2 $name	/home/mike/.tmux.conf
zip -r -Z bzip2 $name	/home/mike/.vimrc
zip -r -Z bzip2 $name	/home/mike/projects/
zip -r -Z bzip2 $name	/scripts/
zip -r -Z bzip2 $name	/var/www/html/

rsync -a -r $name  $remote_target

if [ $? -eq 0 ]; then
	completed=Y
#	rm $name
fi
echo "$now,backup_monthly.sh,$name,$remote_target,$completed" >> $log
