#!/bin/bash

# =============================================================================
# - title        : Quick setup script for BSD based systems
# - description  : Initiates quick setup process for clamav-cron
# - author       : Mark Parraway
# - date         : 2014-09-04
# - version      : 0.8.3
# - usage        : bash freebsd-setup.sh
# - oses         : FreeBSD
# =============================================================================
#
# - fork         : clamav-cron v. 0.6 - Copyright 2009, Stefano Stagnaro
# - site         : https://code.google.com/p/clamav-cron/
#
#
# This is Free Software released under the GNU GPL license version 3
#

cd ~

# Update ports

portsnap update
portsnap fetch

# Setup clamav 

pkg_add -r clamav

# Update virus definitions

freshclam

# Download, configure, and setup symlinks for clamav-cron

cd ~
wget --no-check-certificate https://raw.githubusercontent.com/yangwithinyin/clamav-cron/master/freebsd/clamav-cron.sh
cp clamav-cron.sh /usr/local/bin/clamav-cron.sh
ln -s /usr/sbin/sendmail /usr/local/bin/mail
chown -R clamav:clamav /var/log/clamav
touch /var/log/clamav/clamav-cron.log

# Make sure to configure/setup sendmail

# FreeBSD specific daemon settings and startup (required)

echo '## Enable clamav ##' >> /etc/rc.conf
echo 'clamav_clamd_enable="YES"' >> /etc/rc.conf
echo 'clamav_freshclam_enable="YES"' >> /etc/rc.conf
/usr/local/etc/rc.d/clamav-clamd start
/usr/local/etc/rc.d/clamav-freshclam start
