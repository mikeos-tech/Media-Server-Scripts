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

zip -r -Z bzip2 /storage/$fnow-$(who)-config.zip       /home/mike/.config/tmuxinator/
zip -r -Z bzip2 /storage/$fnow-$(who)-config.zip       /home/mike/.vimrc
zip -r -Z bzip2 /storage/$fnow-$(who)-config.zip       /home/mike/.gitconfig
zip -r -Z bzip2 /storage/$fnow-$(who)-config.zip       /home/mike/.bashrc
zip -r -Z bzip2 /storage/$fnow-$(who)-config.zip       /home/mike/.ssh
zip -r -Z bzip2 /storage/$fnow-$(who)-config.zip       /home/mike/.tmux.conf

echo "$now,backup_user.sh,Various,/storage/" >> $log
