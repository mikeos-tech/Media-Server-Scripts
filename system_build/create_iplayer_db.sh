# create_iplayer_db.sh 
# creator: Mike O'Shea 
# Updated: 05/05/2021 
# Creates a SQLite Database and stores it in the folder specified below. 
# Stores entries for BBC radio/tv programmes using the get-iplayer software.  
# Data is recorded using the get_programs.sh bash script and is read by and 
# displayed in the web pages.
# GNU General Public License, version 3

#!/bin/bash

database_path='/get_iplayer/database/'
database_name='get-iplayer_log.db'

sudo mkdir -p "$database_path"
sudo chgrp -R www-data "$database_path"
sudo chown -R mike:www-data "$database_path"*
sudo chmod -R 0777 "$database_path" 

sqlite3 "$database_path$database_name" <<'END_SQL'
.timeout 2000
CREATE TABLE IF NOT EXISTS "updates" (
	"date"	TEXT NOT NULL,
	"path"	TEXT NOT NULL,
	"type"	TEXT NOT NULL,
	"watched"	INTEGER NOT NULL DEFAULT 0 CHECK(watched IN (0,1)),
	"archive"	INTEGER NOT NULL DEFAULT 0 CHECK(archive IN (0,1))
);
END_SQL
