# backup_history.sh 
# creator: Mike O'Shea 
# Updated: 07/05/2021 
# Creates a zip file backup of the get-iplayer history files, the files
# that retain a list of everthing that has been downloaded.
# This is worth backing up to avoid downloading programmes again.
# Once the zip is created it is copied to the NAS as a backup and
# the local copy is deleted

# GNU General Public License, version 3

#!/bin/bash

source_folder='/home/mike/.get_iplayer/'
now=$(date +%Y-%m-%d,%H:%M)
fnow=$(date +%Y%m%d-%H%M)
local_target='/backups_local/'
log=$target'script_log.csv'
remote_target='root@192.168.2.4:/mnt/Storage/Media_Share/get_iplayer_history/'

x=`find $source_folder -mmin +1 -mmin -1380 -ls`
if [ ! -z "$x" ]
then
    file_name="$local_target$fnow-get_iplayer_history.zip"
    zip -r $file_name "$source_folder""options"
    zip -r $file_name "$source_folder""download_history"
    zip -r $file_name "/get_iplayer/lists/Series_list.txt"
    zip -r $file_name "/get_iplayer/lists/radio_progs.txt"
    zip -r $file_name "/get_iplayer/lists/tv_progs.txt"
    rsync -a -r "$file_name" "$remote_target"
    echo "$now,backup_history.sh,$file_name,$remote_target" >> $log
    rm $file_name
fi
