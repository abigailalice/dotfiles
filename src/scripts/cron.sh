#!/bin/sh

# {{{ cron.d/parental-controls
sudo rm /etc/cron.d/parental-controls
echo "0 19 * * * root pkill -u ably -x sshd" \
    | sudo tee -a /etc/cron.d/parental-controls > /dev/null
sudo chown root:root /etc/cron.d/parental-controls
sudo chmod 700 /etc/cron.d/parental-controls
echo "Sleeping to check cron syntax"
sleep 90
sudo grep cron /var/log/syslog | tail
# }}}
# {{{ /etc/security/time.conf
echo "sshd;*;*;A10900-1900" | sudo tee -a /etc/security/time.conf > /dev/null
# }}}
# {{{ /etc/pam.d/sshd
# TODO this must go at the end of 'account' lines
echo "account required pam_time.so" \
    | sudo tee -a /etc/pam.d/sshd > /dev/null
# }}}




