#!/bin/sh

sudo rm /etc/cron.d/parental-controls
sudo cp ~/gits/dotfiles/src/cron/parental-controls /etc/cron.d/parental-controls
sudo chown root:root /etc/cron.d/parental-controls
sudo chmod 700 /etc/cron.d/parental-controls

sleep 90
sudo grep cron /var/log/syslog | tail



