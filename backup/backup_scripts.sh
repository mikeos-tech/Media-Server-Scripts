# backup_scripts.sh 
# creator: Mike O'Shea 
# Updated: 16/06/2021 
# Creates a zip file backup of script files in both the /scripts folder
# and the /get_iplayer folder.
# The created zip file is transfered to the NAS and the local file
# removed.
# Copies the script files in this folder to another  folder of script files.

# GNU General Public License, version 3

#!/bin/bash

now=$(date +%Y-%m-%d,%H:%M)
fnow=$(date +%Y%m%d-%H%M)
local_target='/backups_local/'
log=$local_target'script_log.csv'
backup_source='/scripts/'
remote_target='root@192.168.2.4:/mnt/Storage/Dev_Backup/'
completed=N

x=`find $backup_source -mmin +1 -mmin -1020 -ls`
echo $x
if [ ! -z "$x" ] 
then
	backup_file="$local_target$fnow-scripts_backup.zip"
	zip -r $backup_file $backup_source -i '*.sh'
	rsync -a -r "$backup_file" "$remote_target"
	completed=Y
	rsync -a --exclude='.git/' --include '*/' --include '*.sh' --exclude '.gitignore' --exclude '*' /scripts/ /scripts_library/musicmachine
	cd /scripts_library
	git push
fi
echo "$now,backup_scripts.sh,$backup_file,$local_target,$completed" >> $log

