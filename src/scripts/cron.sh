#!/bin/sh

TMPHOME=$HOME

sudo rm /etc/cron.d/parental-controls
echo $TMPHOME/gits/dotfiles/src/cron/parental-controls
sudo cp $TMPHOME/gits/dotfiles/src/cron/parental-controls /etc/cron.d/
sudo chown root:root /etc/cron.d/parental-controls
sudo chmod 700 /etc/cron.d/parental-controls

sleep 90
sudo grep cron /var/log/syslog | tail



