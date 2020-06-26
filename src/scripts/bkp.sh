#!/bin/bash

# ln -s ABS_PATH_TO_THIS_FILE ~/.local/bin/bkp

# taken from https://superuser.com/questions/302842/resume-rsync-over-ssh-after-broken-connection

while [ 1 ]
do
    rsync --archive --verbose --compress --progress --partial --rsh="ssh -p 1050" $1 $2
    if [ "$?" = "0" ] ; then
        echo "rsync completed normally"
        exit
    else
        echo "Rsync failure. Backing off and retrying..."
        sleep 180
    fi
done
