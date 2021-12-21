#!/usr/bin/env bash
 
# Created by: Mike O’Shea
# Created on: 19/12/2021
 
# This script creates a Journal file for the current day
# within the Obsidian Note Taking Applications folder structure.
# This script should be executed within cron so that a new file
# is created every day.
 
# The journal should be used every day and includes a series
# of questions to provoke reflection/thought.
 
# Create the target file path including the current date.
obsidian_path="Mikes/Journal/"$(date + "%Y-%m-%d")"-Journal.md"
filename="/Obsidian_Share/Obsidian_notes/$obsidian_path"

# Add the YAML Front Matter for the Meta-Data
echo -e "---\n" > $filename
echo -e "\ntags: [Journal]\n" >> $filename
echo -e "\nalias: []\n" >> $filename
echo -e "\n---\n" >> $filename
echo -e "\n" >> $filename

# Add the title to the file.
echo -e "# $(date +"%Y-%m-%d") - Journal\n" >> $filename

# Append the body to the file
echo -e "\n---\n" >> $filename
echo -e "\n" >> $filename
echo "## What have I learned today?" >> $filename
echo -e "\n\n\n" >> $filename
echo "---" >> $filename
echo -e "\n" >> $filename
echo "## What could I have done better?" >> $filename
echo -e "\n\n\n" >> $filename
echo "---" >> $filename
echo -e "\n" >> $filename
echo "## What have I enjoyed today?" >> $filename
echo -e "\n\n\n" >> $filename
echo "---" >> $filename
echo -e "\n" >> $filename
echo "## Have you had any interesting ideas today?" >> $filename
echo -e "\n\n\n" >> $filename
echo "---" >> $filename
echo -e "\n" >> $filename
echo "## What have I done/has happened today that is important?" >> $filename
echo -e "\n\n\n" >> $filename
echo "---" >> $filename
echo -e "\n" >> $filename
echo "## Is there anything from today that I need to remember/record for future reference?" >> $filename
echo -e "\n\n\n" >> $filename
# Add the end line
echo -e "---\n" >> $filename
# Adding the file to the git repository
cd /Obsidian_Share/Obsidian_notes/
git add $obsidian_path
git commit -m 'Adding Journal'
git push -u origin main
