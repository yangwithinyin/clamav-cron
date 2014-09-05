#!/bin/bash
#
# clamav-cron v. 0.6 - Copyright 2009, Stefano Stagnaro
# clamav-cron v. 0.8.1 - Created by Mark Parraway
# This is Free Software released under the GNU GPL license version 3
#
# freebsd-setup.sh - quick FreeBSD setup script tested on FreeBSD 8.4-RELEASE
#

#============================================#
#        DO NOT EDIT DO NOT EDIT             #
#============================================#

# Update ports

portsnap update
portsnap fetch

# Setup clamav 

pkg_add -r clamav

# Update virus definitions

freshclam

# Download, configure, and setup symlinks for clamav-cron

cd ~
wget --no-check-certificate https://raw.githubusercontent.com/yangwithinyin/clamav-cron/0.8.1/clamav-cron.sh
cp clamav-cron.sh /usr/local/bin/clamav-cron.sh
ln -s /usr/local/bin/clamscan  /usr/bin/clamscan
ln -s /usr/local/bin/freshclam /usr/bin/freshclam
ln -s /usr/sbin/sendmail /bin/mail
chown -R clamav:clamav /var/log/clamav
touch /var/log/clamav/clamav-cron.log

# Make sure to configure/setup sendmail

# FreeBSD specific daemon settings and startup

echo '## Enable clamav ##' >> /etc/rc.conf
echo 'clamav_clamd_enable="YES"' >> /etc/rc.conf
echo 'clamav_freshclam_enable="YES"' >> /etc/rc.conf
/usr/local/etc/rc.d/clamav-clamd start
/usr/local/etc/rc.d/clamav-freshclam start
