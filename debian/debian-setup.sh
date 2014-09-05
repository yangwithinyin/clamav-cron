#!/bin/bash


# =============================================================================
# - title        : Quick setup script for Debian based systems
# - description  : Initiates quick setup process for clamav-cron
# - author       : Mark Parraway
# - date         : 2014-09-04
# - version      : 0.8.3
# - usage        : bash debian-setup.sh
# - oses         : Debian
# =============================================================================
#
# - fork         : clamav-cron v. 0.6 - Copyright 2009, Stefano Stagnaro
# - site         : https://code.google.com/p/clamav-cron/
#
#
# This is Free Software released under the GNU GPL license version 3
#

cd ~

# Update aptitude
apt-get -y update

echo "You chose to use the clamav-cron easy w/ clamav clamav-daemon and sendmail."

apt-get install clamav clamav-daemon sendmail

wget https://raw.githubusercontent.com/yangwithinyin/clamav-cron/master/debian/clamav-cron.sh

# Update virus definitions

freshclam

# Configure, and setup symlinks for clamav-cron

cd ~
ln -s /usr/sbin/sendmail /usr/local/bin/mail
cp clamav-cron.sh /usr/local/bin/clamav-cron.sh
chmod 755 /usr/local/bin/clamav-cron.sh
ln -s /usr/bin/clamdscan /usr/local/bin/clamdscan
ln -s /usr/bin/clamscan /usr/local/bin/clamscan
ln -s /usr/bin/freshclam /usr/local/bin/freshclam
chown clamav:clamav /usr/local/bin/clamav-cron.sh
chown clamav:clamav /var/log/clamav
chown root: /var/lib/clamav
chmod g+w /var/lib/clamav
touch /var/log/clamav/clamav-cron.log

# Debian clamav daemon restart 
#(you should do this after running)

service clamav-daemon restart

