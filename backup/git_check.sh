# git_check.sh 
# creator: Mike O'Shea 
# Updated: 16/06/2021 
# Iterates an array of paths pointing to git repositories and ensures
# everything is included within the local repository and that it
# is synchronised with the Online repository.

# GNU General Public License, version 3

#!/bin/bash

declare -a git_paths=(
"$HOME/.vim_spell"
"$HOME/projects/backupQ/"
"$HOME/projects/git_sync_project/"
"/documentation/"
"/scripts/"
"/scripts_library/
"/var/www/html/"
)

# Iterate the list of paths using for loop
for val in ${git_paths[@]}; do
	cd $val
	git add .
	git commit -m 'Over Night Update'
	git push
   done
