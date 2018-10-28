#!/bin/sh

TMPHOME=$HOME

sudo rm /etc/cron.d/parental-controls
echo $TMPHOME/gits/dotfiles/src/cron/parental-controls
sudo cp $TMPHOME/gits/dotfiles/src/cron/parental-controls /etc/cron.d/
sudo chown root:root /etc/cron.d/parental-controls
sudo chmod 700 /etc/cron.d/parental-controls

echo "ssh;*;*;A10900-1900" | sudo tee -a /etc/security/time.conf > /dev/null
echo "account required pam_time.so" | sudo tee -a /etc/pam.d/sshd > /dev/null

sleep 90
sudo grep cron /var/log/syslog | tail



