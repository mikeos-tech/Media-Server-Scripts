# create_backupQ_db.sh
# creator: Mike O'Shea
# Updated: 05/05/2021
# Creates a SQLite Database and stores it in the folder specified below.
# Is used by the backupQ executable to maintain a record of available 
# backup USB drives and record their usage.
# GNU General Public License, version 3

#!/bin/bash

database_path='/backupQ/'
database_name='backupQ.db'

sudo mkdir -p "$database_path"
sudo chgrp -R www-data "$database_path"
sudo chown -R mike:www-data "$database_path"*
sudo chmod -R 0777 "$database_path" 

sqlite3 "$database_path$database_name" <<'END_SQL'
.timeout 2000

CREATE TABLE IF NOT EXISTS "Media" (
	"Media_key"	INTEGER NOT NULL UNIQUE,
	"Name"	TEXT NOT NULL UNIQUE,
	PRIMARY KEY("Media_key")
);

CREATE TABLE IF NOT EXISTS "History" (
	"F_Media_Key"	INTEGER NOT NULL,
	"Backup_Date"	TEXT NOT NULL,
	FOREIGN KEY (F_Media_Key) REFERENCES Media (Media_key)
	ON DELETE CASCADE
);

END_SQL
