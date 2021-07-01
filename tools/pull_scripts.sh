# pull_scripts.sh 
# creator: Mike O'Shea 
# Updated: 19/06/2021 
# Pulls down any updated scripts from the git repository.
# Run from the tmuxinator startup script so it should update every time
# I remotely access the system using tmux.

# GNU General Public License, version 3

#!/bin/bash

cd /scripts_library

test=$(rsync -a -i --exclude='.git/' --include '*/' --include '*.sh' --exclude '.gitignore' --exclude '*' /scripts/ /scripts_library/musicmachine)

if [ -z "$test" ] 
then
	git push
fi

git pull
