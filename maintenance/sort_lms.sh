# sort_lms.sh
# creator: Mike O'Shea 
# Updated: 05/05/2021 
# Some early versions of LMS (Logitech Media Server) had 
# problems with the database, these tended to be related 
# to the image files. This script deletes all the SQLite 
# database files and then shuts down the computer.  
# Once restarted LMS will read the music collection and 
# rebuild the databases.
# GNU General Public License, version 3

#!/usr/bin/env bash
cd /var/lib/squeezeboxserver/cache/

rm /var/lib/squeezeboxserver/cache/artwork.db
rm /var/lib/squeezeboxserver/cache/library.db
rm /var/lib/squeezeboxserver/cache/cache.db
rm /var/lib/squeezeboxserver/cache/imgproxy.db
rm /var/lib/squeezeboxserver/cache/*.db-shm
rm /var/lib/squeezeboxserver/cache/*.db-wal

shutdown now
