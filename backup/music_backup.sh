# music_backup.sh 
# creator: Mike O'Shea 
# Updated: 05/05/2021 
# Is triggered by use action on a web page. 
# It backs up all the music files in the /storage folder
# to the drive mounted in the /backup/storage folder.  
# This element of the web pages is under development so 
# this is still under development.

# GNU General Public License, version 3

#!/bin/bash

now="$(date +%Y-%m-%d %H:%M)"
FILE='/backup/madmikes_backup.txt'
if [ -f "$FILE" ]; then
    echo "Valid backup disk, backup started: $now."

    rsync --archive --verbose --delete --force /storage/ /backup/storage/
    sync
    umount /backup
    log='/get_iplayer/script_log.csv'
    now="$(date +%Y-%m-%d %H:%M)"
    echo >> "$now,music_backup.sh,,USB Drive" >> $log
else
    echo "Not a valid backup disk, backup aborted."
fi
