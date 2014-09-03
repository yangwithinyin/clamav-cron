#!/bin/bash
#
# clamav-cron v. 0.6 - Copyright 2009, Stefano Stagnaro
# clamav-cron easy v. 0.8.2 - Created by Mark Parraway
# This is Free Software released under the GNU GPL license version 3
#
# debian-setup.sh - quick Debian based setup script tested on Ubuntu 12.04 LTS
#

#============================================#
#        DO NOT EDIT DO NOT EDIT             #
#============================================#

apt-get -y update && apt-get -y install clamav clamav-daemon sendmail
cd ~
wget https://raw.githubusercontent.com/yangwithinyin/clamav-cron/master/clamav-cron.sh
ln -s /usr/sbin/sendmail /bin/mail
cp clamav-cron.sh /usr/local/bin/clamav-cron.sh
chmod 755 /usr/local/bin/clamav-cron.sh
ln -s /usr/bin/clamdscan /usr/local/bin/clamscan
chown clamav:clamav /usr/local/bin/clamav-cron.sh
chown clamav:clamav /var/log/clamav
chown root: /var/lib/clamav
chmod g+w /var/lib/clamav
touch /var/log/clamav/clamav-cron.log
/usr/bin/freshclam
