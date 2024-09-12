#!/bin/bash

export HOME_DIR=/home/jonatan
# password for the user
password=$(cat $HOME_DIR/.backup_password)

#SQL wordpress adtabase backup
mysqldump -u backup -p$password --databases wordpress > $HOME_DIR/backups/wrdsql-`date "+%Y-%m-%d-%H-%M"`.sql

#Wordpress data backup
echo "$password" | sudo -S tar -zcvf $HOME_DIR/backups/wrdusr-`date "+%Y-%m-%d-%H-%M"`.tar.gz /usr/share/wordpress

#Variable with all sql backups with error handling if there are no matching files
db_backup_files=($(ls -t $HOME_DIR/backups/wrdsql* 2> /dev/null))

# Check if there are more than 8 SQL backups
if [ ${#db_backup_files[@]} -gt 8 ]; then
    # Calculate how many SQL backups to delete
    db_files_to_delete=(${db_backup_files[@]:8})  # Files from index 8 onwards

    # Delete the old SQL backups
    for file in "${db_files_to_delete[@]}"; do
        rm "$file"
    done
fi

#Variable with all /usr backups
db_backup_files=($(ls -t $HOME_DIR/backups/wrdusr* 2> /dev/null))
# Check if there are more than 8 /usr backups
if [ ${#db_backup_files[@]} -gt 8 ]; then
    # Calculate how many /usr backups to delete
    db_files_to_delete=(${db_backup_files[@]:8})  # Files from index 8 onwards

    # Delete the old /usr backups
    for file in "${db_files_to_delete[@]}"; do
        rm -f "$file"
    done
fi
