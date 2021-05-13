# tidy_history.sh 
# creator: Mike O'Shea 
# Updated: 09/05/2021 
# I have had problems getting the bash histroy to work as I would like, I managed
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

export HISTFILE=~/.bash_history
export HISTFILESIZE=20000
export HISTSIZE=10000
# Combine multiline commands into one in history
shopt -s cmdhist
# Ignore duplicates, ls without options and builtin commands
export HISTIGNORE="&:ls:[bf]g:exit:clear:"
shopt -s histappend
export HISTCONTROL=ignoreboth:erasedups
export PROMPT_COMMAND="history -n; history -w; history -c; history -r; $PROMPT_COMMAND"

tac "$HISTFILE" | awk '!x[$0]++' > $tmp_file 
tac $tmp_file > "$HISTFILE"
# rm $tmp_file

echo "$now,tidy_history.sh,$HISTFILE,$HOME,$completed" >> $log
