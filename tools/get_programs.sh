# get_programs.sh 
# creator: Mike O'Shea 
# Updated: 07/05/2021 
# This script downloads the programmes from the BBC site using get-iplayer. 
# It downloads them, attempts to archive them and for radio programmes it
# creates a flac copy and adds the file to LMS.
# It runs from cron on a nightly basis.

# GNU General Public License, version 3

#  This script uses the exiftool tool, so that needs to be installed before it will work.

#!/bin/bash

# Define the path variables
app_root='/get_iplayer/'
radio_downloads=$app_root"downloads/Radio/"
tv_downloads=$app_root"downloads/TV/"

radio_Program_list=$app_root"lists/radio_progs.txt"
series_list=$app_root"lists/Series_list.txt"
tv_Program_list=$app_root"lists/tv_progs.txt"

tv_search_criteria="$tv_downloads*.mp4"
radio_search_criteria="$radio_downloads*.m4a"

#lms_server='root@192.168.2.9'
lms_radio_path='/storage/music/flac/radio/'

archive_server='root@192.168.2.4'
archive_root='/mnt/Storage/Media_Share/'
tv_archive=$archive_root'TV_Archive/'
film_archive=$archive_root'Films/'
radio_archive=$archive_root'Radio_Programes/'

database='/get_iplayer/database/get-iplayer_log.db'

declare -a TV_Programs=()
declare -a Radio_Programs=()
declare -a categorise_Programs=()


function get_genre {
    # Read the genre and if it finds something appropriate convert it to one of my equivalents
    genre=""
    temp=$(exiftool $1 | grep '^Grouping[ ]*:')
    echo "Grouping: "$temp
    if [ "$temp" != "" ]; then
        genrelist=""
        genrelist=${temp:34}
        if [ "$genrelist" != "" ]; then
            if echo "$genrelist" | grep -q "Films" && [ "$genre" == "" ]; then
                genre="Films"
            fi
            if echo "$genrelist" | grep -q "Music" && [ "$genre" == "" ]; then
                genre="Music"
            fi
            if echo "$genrelist" | grep -q "Arts" && [ "$genre" == "" ]; then
                genre="Art"
            fi
            if echo "$genrelist" | grep -q "Biographical" && [ "$genre" == "" ]; then
                genre="Biography"
            fi
            if echo "$genrelist" | grep -q "Classic & Period" && [ "$genre" == "" ]; then
                genre="Costume_Drama"
            fi
            if echo "$genrelist" | grep -q "Drama" && [ "$genre" == "" ]; then
                genre="Drama"
            fi
            if echo "$genrelist" | grep -q "History" && [ "$genre" == "" ]; then
                genre="History"
            fi
            if echo "$genrelist" | grep -q "Comedy" && [ "$genre" == "" ]; then
                genre="Humour"
            fi
            if echo "$genrelist" | grep -q "Science" && [ "$genre" == "" ]; then
                 genre="Science"
            fi
            if echo "$genrelist" | grep -q "Crime" && echo "$genrelist" | grep -q -e "Factual" && echo "$genrelist" | grep -q -e "Documentaries" && [ "$genre" == "" ]; then
                 genre="Crime"
            fi
        fi
    fi
    if [ "$genre" == "" ]; then
        genre="categorise"
    fi
}

function get_selected_progs {
    # Read the list of programmes and download them
    while IFS= read -r url; do
    #   get_iplayer --type=tv --force --url  $url
        get_iplayer --type=$2 --url  $url
    done <$1
}

function get_series {
    # Read the list of tv and radio series and download them
    declare -a url_list
    while IFS=$'#' read -r url name; do
        size=${#url}
        if [ $size -gt 5 ]; then
            url_list+=("$url")
        fi
    done <$series_list

    for i in "${url_list[@]}"; do
        get_iplayer --pid-recursive $i
    done
}

function process_tv_files {
    # Count number of search_criteria matching files in the folder
    local tvfiles=$(ls .sh $tv_search_criteria 2> /dev/null | wc -l)  # Build a list of all the files in the folder that meet the search_criteria
    if [ "$tvfiles" == "0" ]; then # If no files are found
        echo
        echo -e "No TV files have been Downloaded."
        echo
    else  # If files are found
        filenames=`ls $tv_search_criteria` # Build a list of all the downloaded files

        # Process the list of downloaded files
        for eachfile in $filenames
        do
            # Read the Number for the TV series if there is one
            series_no=""
            holder=$(exiftool $eachfile | grep '^TV Season[ ]*:')
            if [ "$holder" != "" ]; then
                series_no=${holder:34}
                printf -v holder "%02d" $series_no
                series_no=$holder
            fi

            # Read the name for the TV series if there is one, removing a series number string if there is one
            series_title=""
            holder=$(exiftool $eachfile | grep '^Album[ ]*:')
            if [ "$holder" != "" ]; then
                temp=${holder:34}
                if [[ $temp =~ (.*):\ *[Ss]eries\ *[0-9]+ ]]; then
                    temp="${BASH_REMATCH[1]}"
                fi
                series_title=${temp// /_}
            fi

            # Read the file name from the metadata and see if it include an Episode string and remove it if necessary
            filename=""
            before=""
            holder=$(exiftool $eachfile | grep '^File Name[ ]*:')
            if [ "$holder" != "" ]; then
                temp=${holder:34}
                before=$temp
                if [[ $temp =~ (.*)-\ *[Ee]pisode_[0-9]+ ]]; then
                    filename="${BASH_REMATCH[1]}"
                    temp=$filename
                fi
                if [[ $temp =~ (.*)-\ *[Ss]eries_[0-9]+ ]]; then
                    filename="${BASH_REMATCH[1]}"
                    temp=$filename
                fi
                if [[ $temp =~ (.*)-\ *[Ss]eason_[0-9]+ ]]; then
                    filename="${BASH_REMATCH[1]}"
                fi
                if [ "$filename" == "" ]; then
                    filename=$before
                else
                    filename+=".mp4"
                fi
            fi

            get_genre $eachfile  # Function that gets the genre for the file

            # If there is a genre add it to the path - if there isn't just ignore it
            if [ "$genre" != "" ]; then
                folder_path=""

                # Add the genre as an element to the path if it isn't a film or music related
                if [ "$genre" != "Films" ]; then
                    temp=${genre// /_}
                    folder_path+=$temp
                    folder_path+="/"
                fi

                if [ "$genre" == "Music" ]; then
                        archive_path+="hold/"
                fi

                # If there is an series title add it to the path
                if [ "$series_title" != "" ]; then
                    folder_path+=$series_title
                    folder_path+="/"
                fi

                # If there is a series number add it to the path
                if [ "$series_no" != "" ]; then
                    folder_path+="Series_"
                    folder_path+=$series_no
                    folder_path+="/"
                fi

                # If the genre is something other than music or file give it the archive and folder path
                if [ "$genre" != "Films" ]; then
                    archive_path=$tv_archive
                    archive_path+=$folder_path
                else
                    if [ "$genre" == "Films" ]; then
                        archive_path=$film_archive
                        archive_path+=$folder_path
                    fi
                fi

                # Remove any illegal characters from the paths
                archive_path=$(echo $archive_path | tr -d "\'")
                archive_path=$(echo $archive_path | tr -d ':;,&<>')

                # The folder paths have been created, now append the target file name before the copy/move takes place
                if [ "$before" != "$filename" ]; then  # If the file name has been modified during the processing
                    temp=$filename
                    filename=${temp// /_}
                    path=$( echo ${eachfile%/*} )
                    new_name="$path/$filename"
                    # Remove any illegal characters from the strings after filename has been added, the folder paths were check before they were created and then the file name was added
                    new_name=$(echo $new_name | tr -d "\'")
                    new_name=$(echo $new_name | tr -d ':;,&<>')
                    mv $eachfile $new_name
                else # If file name remains the same
                    new_name=$eachfile
                fi

                ssh $archive_server "mkdir -p $archive_path"
                rsync -a -r -p "$new_name" "$archive_server:$archive_path"
                if [ "$?" -eq "0" ]
                then
		    record="$archive_path$filename"
		    record=${record#"$archive_root"}
                    printf -v date '%(%Y-%m-%d)T' -1
                    sqlite3 $database "INSERT INTO updates ( date, path, type ) VALUES( '$date', '$record', 'TV' );"
                    sync
		    rm "$new_name"
                    TV_Programs+=($record)
                    if [ "$genre" == "categorise" ]; then
                        categorise_Programs+=($new_name)
                    fi
                else
                    echo "Error copying: " $new_name
                    download_date=printf -v date '%(%Y-%m-%d)T' -1
                    echo "Subject: $download_date - TV File Addition Error" > "$app_root"TV_error.txt
                    echo "TV Program downloaded on $download_date could not be added to the TV Archive:" >> "$app_root"TV_error.txt
                    echo "Source: $new_name" >> "$app_root"TV_error.txt
                    echo "Target: $archive_path" >> "$app_root"TV_error.txt
                    cat "$app_root"TV_error.txt | ssmtp michaeloshea@blueyonder.co.uk

                fi
            fi
        done
    fi
}

function process_radio_files {
    local radiofiles=$(ls .sh $radio_search_criteria 2> /dev/null | wc -l)
    if [ "$radiofiles" == "0" ]; then
        echo
        echo -e "No Radio files have been Downloaded."
        echo
    else
        # Build a list of files
        filenames=`ls $radio_search_criteria`
        for eachfile in $filenames
        do
            echo $eachfile
            #read -rsp $'1 Press any key to continue...\n' -n1 key
            folder_path=""
            holder=$(exiftool $eachfile | grep '^TV Season[ ]*:')
            if [ "$holder" != "" ]; then
                series_no=${holder:34}
                printf -v holder "%02d" $series_no
            fi
            # The creation date, if it exists is added to the start of the file name, if it doesn't its added as an empty value
            creation_date=$(exiftool $eachfile | grep '^Content Create Date[ ]*:')
            if [ "$creation_date" != "" ]; then
                creation_date=${creation_date:34}
                creation_date="${creation_date//:}"
                creation_date=$(echo $creation_date | cut -c1-8)
                file_date=$creation_date
                file_date+="1200"
                creation_date+="-"
            fi

            holder=$(exiftool $eachfile | grep '^Album[ ]*:')
            temp=${holder:34}
            series_title=${temp// /_}
            # If there is an series title add it to the path
            if [ "$series_title" != "" ]; then
                folder_path+=$series_title
                folder_path+="/"
            fi
            # If there is a series number add it to the path
            if [ "$series_no" != "" ]; then
                folder_path+="Series_"
                folder_path+=$series_no
                folder_path+="/"
            fi

            archive_path=$radio_archive
            archive_path+=$folder_path
            listen_path=$lms_radio_path
            listen_path+=$folder_path

            path=$( echo ${eachfile%/*} )
            file=$( echo ${eachfile##/*/} )
            local new_name="$path/$creation_date$file"
            cp $eachfile $new_name

            ssh $archive_server "mkdir -p $archive_path"
            rsync -a -r -p "$new_name" "$archive_server:$archive_path"
            if [ "$?" -eq "0" ]
            then
		record="$archive_path$creation_date$file"
		record=${record#"$radio_archive"}
                printf -v date '%(%Y-%m-%d)T' -1
                sqlite3 $database "INSERT INTO updates ( date, path, type ) VALUES( '$date', '$record', 'Radio' );"
                add_2_lms $new_name "$listen_path" 
                sync
                rm "$new_name"
                rm "$eachfile"
                Radio_Programs+=($record)
            else
                echo "Error copying: " $new_name
                download_date=printf -v date '%(%Y-%m-%d)T' -1
                echo "Subject: $download_date - Radio File Addition Error" > "$app_root"radio_error.txt
                echo "Radio Program downloaded on $download_date could not be added to the Radio Archive:" >> "$app_root"radio_error.txt
                echo "Source: $new_name" >> "$app_root"radio_error.txt
                echo "Target: $archive_path" >> "$app_root"radio_error.txt
                cat "$app_root"radio_error.txt | ssmtp michaeloshea@blueyonder.co.uk
            fi
        done
        curl -s "http://192.168.2.9:9000/settings/index.html?p0=rescan" &>/dev/null
    fi
}

function add_2_lms {
    local archive_file=$1
    local target_file="${archive_file%.[^.]*}.flac"
    local target_location=$2

    if [ ! -f "$target_file" ]; then
        ffmpeg -i "$archive_file" -f flac "$target_file"  # Create a file in new format at new location
        sync
        # Set the genre tag to Radio, which I exclude from randomly generated playlists
        # Sets the date string to a simpler format
        # Removes some tags I wanted to remove and prefixes the title with the date in a sortable format
        title=$(metaflac --show-tag="Title" "$target_file" | cut -c7-200)
        metaflac --preserve-modtime --remove-tag="Title" --remove-tag="Date" --remove-tag="Genre" --remove-tag="LYRICS" --remove-tag="MAJOR_BRAND" --remove-tag="MEDIA_TYPE" --remove-tag="MINOR_VERSION" --set-tag="Date=$creation_date" --set-tag="Genre=Radio" --set-tag="Title=$creation_date-$title" "$target_file"
        touch -a -m -t "$file_date" "$target_file"
        sync
    fi
    if [ -f "$target_file" ]; then
        mkdir -p "$target_location"
        rsync -a -r -p "$target_file" "$target_location"
        if [ "$?" -eq "0" ]
        then
            sync
            rm "$target_file"
        else
            download_date=printf -v date '%(%Y-%m-%d)T' -1
            echo "Error copying: " $target_file
	    echo "Subject: $download_date - LMS File Addition Error" > "$app_root"LMS_error.txt
            echo "Radio Programs downloaded on $download_date could not be added to LMS:" >> "$app_root"LMS_error.txt
            echo "Source: $target_file" >> "$app_root"LMS_error.txt
            echo "Target: $target_location" >> "$app_root"LMS_error.txt
            cat "$app_root"LMS_error.txt | ssmtp michaeloshea@blueyonder.co.uk
        fi
    fi
}

function notify_me {
    download_date=printf date '%(%Y-%m-%d)T' -1
    if (( ${#TV_Programs[@]} )); then
        echo "Subject: $download_date - TV Programs Downloaded" > "$app_root"TV_progs.txt
        echo "TV Programs downloaded on $download_date:" >> "$app_root"TV_progs.txt
        for var in "${TV_Programs[@]}"
        do
            echo "${var}" >> "$app_root"TV_progs.txt
        done
        cat "$app_root"TV_progs.txt | ssmtp michaeloshea@blueyonder.co.uk
    fi

    if (( ${#Radio_Programs[@]} )); then
        echo "Subject: $download_date - Radio Programs Downloaded" > "$app_root"Radio_progs.txt
        echo "Radio Programs downloaded on $download_date:" >> "$app_root"Radio_progs.txt
        for var in "${Radio_Programs[@]}"
        do
            echo "${var}" >> "$app_root"Radio_progs.txt
        done
        cat "$app_root"Radio_progs.txt | ssmtp michaeloshea@blueyonder.co.uk
    fi

    if (( ${#categorise_Programs[@]} )); then
        echo "Subject: $download_date - TV Programs to be Categorised" > "$app_root"Cat_progs.txt
        echo "TV Programs put in the categorised folder on $download_date, that don't fit an existing Category definition." >> "$app_root"Cat_progs.txt
        for var in "${categorise_Programs[@]}"
        do
            echo "${var}" >> "$app_root"Cat_progs.txt
        done
        cat "$app_root"Cat_progs.txt | ssmtp michaeloshea@blueyonder.co.uk
    fi
}

# Set my default setting, they are remembered by programme, helps me remember them
get_iplayer --prefs-add --file-prefix="<nameshort><-00seriesnum-><00episodenum><-episodeshort>"
get_iplayer --prefs-add --outputradio=$radio_downloads
get_iplayer --prefs-add --outputtv=$tv_downloads
clear

get_series  # function that reads the TV & Radio list and downloads them
get_selected_progs $tv_Program_list     tv
get_selected_progs $radio_Program_list  radio

process_tv_files
process_radio_files

notify_me

now=$(date +%Y-%m-%d,%H%M)
log='/get_iplayer/lists/script_log.csv'
echo "$now,get_programs,," >> $log
