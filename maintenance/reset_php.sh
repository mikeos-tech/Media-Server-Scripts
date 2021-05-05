# reset_php.sh 
# creator: Mike O'Shea 
# Updated: 05/05/2021 
# When working on PHP web pages I found that changes in the pages 
# were not displayed unless the PHP service was restarted.
# This script is a record/reminder of the required command.
# I ran this command with the linux watch command:
# 	watch -n 120 reset_php.sh
# Which repeated the excution of the command every 2  mins
# (120 seconds).
# GNU General Public License, version 3

#!/bin/bash

service php7.4-fpm restart
if [ $? -ne 0 ]; then
   clear
   echo -e "\n\nFailed to restart PHP\n\n"
else
   clear
   echo -e "\n\nPHP restarted:- $(date +'%Y-%m-%d - %A - %T')\n\n"
fi
