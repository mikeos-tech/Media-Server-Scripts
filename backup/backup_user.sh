# backup_build.sh
# creator: Mike O'Shea 
# Updated: 08/05/2021 
# Creates zip file backups of the key folders and config files
# specified in the last column of the zip commands.
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
file_name=/storage/$fnow-$USER-config.zip

zip -r -Z bzip2 $file_name	~/.config/tmuxinator/
zip -r -Z bzip2 $file_name      ~/.vimrc
zip -r -Z bzip2 $file_name      ~/.gitconfig
zip -r -Z bzip2 $file_name      ~/.bashrc
zip -r -Z bzip2 $file_name      ~/.ssh
zip -r -Z bzip2 $file_name      ~/.tmux.conf

echo "$now,backup_user.sh,$HOME,/storage/" >> $log