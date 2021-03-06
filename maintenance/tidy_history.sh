# tidy_history.sh 
# creator: Mike O'Shea 
# Updated: 09/05/2021 
# I have had problems getting the bash history to work as I would like, I managed
# to get it working adding some code to my Bash configuration in .bashrc. This
# worked outside of tux, but because tuxanimator was loading multiple Bash shells
# at the same time it caused confusion with temp files.
# The code below is a sub set of that code, that has been commented out of the
# .bashrc, to be run in this script over night.
# This works similarly to working in the same shell all day, it that it only 
# runs once a day and because it is on a server it can be run over night.
# This could be run manually or run in cron at a time the user isn't likely
# to be working.

# GNU General Public License, version 3

#!/bin/bash

now=$(date +%Y-%m-%d,%H:%M)
log='/backups_local/script_log.csv'
completed=Y
tmp_file='/tmp/hist_sort'

# tmux kill-server

HISTFILE=~/.bash_history

cat $HISTFILE | sort | uniq -u > $tmp_file
mv $tmp_file $HISTFILE

echo "$now,tidy_history.sh,$HISTFILE,$HOME,$completed" >> $log
