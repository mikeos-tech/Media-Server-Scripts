# git_check.sh 
# creator: Mike O'Shea 
# Updated: 04/06/2021 
# Iterates an array of paths pointing to git repositories and ensures
# everything is included within the repository and that it
# is updated in GitHub.

# GNU General Public License, version 3

#!/bin/bash

declare -a git_paths=(
"/documentation/"
"/scripts/"
"/var/www/html/"
"~/.vim_spell"
"~/projects/backupQ"
"~/projects/git_sync_project"
)

# Iterate the string array using for loop
for val in ${git_paths[@]}; do
	echo $val
	cd $val
	git add .
	git commit -m 'Over Night Update'
	git push
   done
