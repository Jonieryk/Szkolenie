#!/bin/bash

export HOME_DIR=/home/jonatan

#Amount of backups to keep
AMOUNT=8

# password for the user
password=$(cat $HOME_DIR/.backup_password)

#SQL wordpress adtabase backup
mysqldump -u backup -p$password --databases wordpress > $HOME_DIR/backups/wrdsql-`date "+%Y-%m-%d-%H-%M"`.sql

#Wordpress data backup
echo "$password" | sudo -S tar -zcvf $HOME_DIR/backups/wrdusr-`date "+%Y-%m-%d-%H-%M"`.tar.gz /usr/share/wordpress

# Check if there are more than 8 SQL backups and delete all but the newest 8
find $HOME_DIR/backups -name 'wrdsq*' -type f | sort | head -n -$AMOUNT | xargs -r rm

# Check if there are more than 8 usr backups and delete all but the newest 8
find $HOME_DIR/backups -name 'wrdusr*' -type f | sort | head -n -$AMOUNT | xargs -r rm -f

