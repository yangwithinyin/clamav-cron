#!/bin/bash

# =============================================================================
# - title        : Scanning and mailing script for crontab scans
# - description  : Initiates a clamscan (without a daemon) on a FreeBSD system
# - author       : Mark Parraway
# - date         : 2016-04-18
# - version      : 0.8.4q
# - usage        : bash clamav-cron.sh
# - oses         : FreeBSD
#
# =============================================================================
#
# - fork         : clamav-cron v. 0.6 - Copyright 2009, Stefano Stagnaro
# - site         : https://code.google.com/p/clamav-cron/
#
# This is Free Software released under the GNU GPL license version 3
#
# - 0.8.4 fixes  : log perms issue, file size increase, /var/db/clamav scan skip
# - 0.8.4q fixes : perm issues on /var/db 
#
#===========================================#
#        CRONTAB SETUP INSTRUCTIONS         #
#===========================================#
#
# Add to crontab, e.g. crontab -e
# 45 23 * * 5 /usr/local/bin/clamav-cron2.sh /
#
#============================================#
#        User configuration section          #
#============================================#
#

# Log file name and its path:
#CV_LOGFILE="$HOME/clamav-cron.log"
CV_LOGFILE="/var/log/clamav/clamav-cron.log"
# Notification e-mail sender:
CV_MAILFROM="clamav@yourserver.net"
# Notification e-mail recipient:
CV_MAILTO="user@yourdomain.com"
# Notification e-mail secondary recipients:
CV_MAILTO_CC="user2@yourdomain.com; user3@otherdomain.org"
# Notification e-mail subject:
CV_SUBJECT="Your Organization - Critical ClamAV scan report"

#============================================#
#        DO NOT EDIT DO NOT EDIT             #
#============================================#

CV_TARGET="$1"
CV_VERSION_ORIG="0.6"
CV_VERSION_FORK="0.8.4q"

if [ -e $CV_LOGFILE ]
then
        /bin/rm $CV_LOGFILE
        /usr/bin/touch $CV_LOGFILE
        /bin/chmod 770 $CV_LOGFILE
        /usr/sbin/chown clamav:wheel $CV_LOGFILE
fi

if [ -z "$1" ]
then
        CV_TARGET="$HOME"
fi

#To be read on stdout (and root mail):
echo -e clamav-cron v. $CV_VERSION_ORIG - Copyright 2009, Stefano Stagnaro '\n'
echo -e `basename $0` v. $CV_VERSION_FORK - Copyright 2015, Mark Parraway '\n'

#To be read on logfile (sent via sendmail):
echo -e $CV_SUBJECT - $(date) '\n' >> $CV_LOGFILE
echo -e Script: clamav-cron v. $CV_VERSION_ORIG - Copyright 2009, Stefano Stagnaro  >> $CV_LOGFILE
echo -e Script: `basename $0` v. $CV_VERSION_FORK - Copyright 2015, by Mark Parraway  >> $CV_LOGFILE
echo -e Scanned: $CV_TARGET on $HOSTNAME'\n' >> $CV_LOGFILE

# fixes running cron @root for /var/db/clamav database perms

chown -R :wheel /var/db/clamav
chmod +w clamav

# /usr/local/bin/stuff may need to be symlinked up
# easy symlink in your OS setup script

/usr/local/bin/freshclam --log=$CV_LOGFILE --user $USER --verbose

#To be read on stdout (and root mail):
echo -e '------------------------------------\n'

/usr/local/bin/clamscan --max-filesize=512000000 --max-scansize=512000000 --infected --log=$CV_LOGFILE --recursive $CV_TARGET --exclude=/proc --exclude=/sys --exclude=/dev --exclude=/media --exclude=/mnt --exclude=/var/db/clamav
CLAMSCAN=$?

if [ "$CLAMSCAN" -eq "1" ]
then
        CV_SUBJECT="[VIRUS!] "$CV_SUBJECT
        /usr/local/bin/mail -s "$CV_SUBJECT" -c $CV_MAILTO_CC $CV_MAILTO -- -f $CV_MAILFROM < $CV_LOGFILE
elif [ "$CLAMSCAN" -gt "1" ]
then
        CV_SUBJECT="[ERR] "$CV_SUBJECT
        /usr/local/bin/mail -s "$CV_SUBJECT" -c $CV_MAILTO_CC $CV_MAILTO -- -f $CV_MAILFROM < $CV_LOGFILE
fi
