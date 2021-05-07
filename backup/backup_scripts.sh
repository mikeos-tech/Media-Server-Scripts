# backup_scripts.sh 
# creator: Mike O'Shea 
# Updated: 07/05/2021 
# Creates a zip file backup of script files in both the /scripts folder
# and the /get_iplayer folder.
# The created zip file is transfered to the NAS and the local file
# removed.

# GNU General Public License, version 3

#!/usr/bin/env bash

now=$(date +%Y-%m-%d,%H:%M)
fnow=$(date +%Y%m%d-%H%M)
log='/get_iplayer/lists/script_log.csv'
backup_source='/scripts/'
target='root@192.168.2.4:/mnt/Storage/Dev_Backup/'

x=`find $backup_source -mmin +1 -mmin -1020 -ls`
echo $x
if [ ! -z "$x" ] 
then
    backup_file="/tmp/$fnow-scripts_backup.zip"
    zip -r $backup_file $backup_source -i '*.sh'
    rsync -a -r "$backup_file" "$target"
    echo "$now,backup_scripts.sh,$backup_file,$target" >> $log
fi
