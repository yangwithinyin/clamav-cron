#!/bin/bash

# =============================================================================
# - title        : Scanning and mailing script for crontab scans
# - description  : Initiates scan targets on clamscand (ClamAV daemon clamd)
# - author       : Mark Parraway
# - date         : 2014-09-04
# - version      : 0.8.3
# - usage        : bash clamav-cron.sh
# - oses         : Debian, FreeBSD
# =============================================================================
#
# - fork         : clamav-cron v. 0.6 - Copyright 2009, Stefano Stagnaro
# - site         : https://code.google.com/p/clamav-cron/
#
#
# This is Free Software released under the GNU GPL license version 3
#
#===========================================#
#        CRONTAB SETUP INSTRUCTIONS         #
#===========================================#
#
# Add to crontab, e.g. crontab -e
# 45 23 * * 5 /usr/local/bin/clamav-cron.sh /
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

#
#============================================#
#

CV_TARGET="$1"
CV_VERSION_ORIG="0.6"
CV_VERSION_FORK="0.8.3"

if [ -e $CV_LOGFILE ]
then
        /bin/rm $CV_LOGFILE
fi

if [ -z "$1" ]
then
        CV_TARGET="$HOME"
fi

#To be read on stdout (and root mail):
echo -e clamav-cron v. $CV_VERSION_ORIG - Copyright 2009, Stefano Stagnaro '\n'
echo -e `basename $0` v. $CV_VERSION_FORK - Copyright 2014, Mark Parraway '\n'

#To be read on logfile (sent via sendmail):
echo -e $CV_SUBJECT - $(date) '\n' >> $CV_LOGFILE
echo -e Script: clamav-cron v. $CV_VERSION_ORIG - Copyright 2009, Stefano Stagnaro  >> $CV_LOGFILE
echo -e Script: `basename $0` v. $CV_VERSION_FORK - Copyright 2014, Mark Parraway  >> $CV_LOGFILE
echo -e Scanned: $CV_TARGET on $HOSTNAME'\n' >> $CV_LOGFILE

# /usr/local/bin/stuff may need to be symlinked
# easy symlink in your OS setup script
# you may use debian-setup.sh to set this up

/usr/local/bin/freshclam --log=$CV_LOGFILE --user $USER --verbose

# intiiate the scan target list creation

# set and export clamav-cron easy install script dir

rm /tmp/clamdscan.files
touch /tmp/clamdscan.files

# add a file listing of the scandir to file listing

find $CV_TARGET -maxdepth 1 -type f >> /tmp/clamdscan.files

# get directories

DIRS=`ls -l $CV_TARGET | egrep '^d' | awk '{print $9}'`

# add a dir listing of the scandir for clamdscan

for DIR in $DIRS
do
echo  ${DIR} >> /tmp/clamdscan.files
done

# remove sensible exclusions

sed -e 's/\<dev\>//g' /tmp/clamdscan.files > /tmp/temp.files
sed -e 's/\<proc\>//g' /tmp/temp.files >  /tmp/clamdscan.files
sed -e 's/\<sys\>//g' /tmp/clamdscan.files > /tmp/temp.files
sed -e 's/\<media\>//g' /tmp/temp.files > /tmp/clamdscan.files
sed -e 's/\<mnt\>//g' /tmp/clamdscan.files > /tmp/temp.files

# added /run & /tmp to exclusions:
# /dev /proc /sys /media /mnt

sed -e 's/\<run\>//g' /tmp/temp.files > /tmp/clamdscan.files

# comment out for scanning /tmp

sed -e 's/\<tmp\>//g' /tmp/clamdscan.files > /tmp/temp.files

# clean out blank lines

sed 's/  *$//;/^$/d' /tmp/temp.files > /tmp/clamdscan.files

#To be read on stdout (and root mail):
echo -e '------------------------------------\n'

# Change directory for clamdscan

cd /

/usr/local/bin/clamdscan --fdpass --log=$CV_LOGFILE --file-list=/tmp/clamdscan.files

CLAMSCAN=$?

if [ "$CLAMSCAN" -eq "1" ]
then
        CV_SUBJECT="[VIRUS!] "$CV_SUBJECT
        /bin/mail -s $CV_SUBJECT -c $CV_MAILTO_CC $CV_MAILTO -- -f $CV_MAILFROM < $CV_LOGFILE
elif [ "$CLAMSCAN" -gt "1" ]
then
        CV_SUBJECT="[ERR] "$CV_SUBJECT
        /bin/mail -s $CV_SUBJECT -c $CV_MAILTO_CC $CV_MAILTO -- -f $CV_MAILFROM < $CV_LOGFILE
fi
