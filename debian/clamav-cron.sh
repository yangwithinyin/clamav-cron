#!/bin/bash

# =============================================================================
# - title        : Crontab wrapper script for for launching clamav-easy.sh
# - description  : Initiates target list for clamdscan (ClamAV daemon clamd)
# - License      : GPLv3
# - author       : Mark Parraway
# - date         : 2014-09-04
# - version      : 0.8.3
# - usage        : bash clamav-cron.sh
# - OS Supported : Debian
# =============================================================================
#
# This is Free Software released under the GNU GPL license version 3
#

# set the target directory for scans

SCANDIR="/"

# set and export clamav-cron easy install script dir

CCE_DIR="/usr/local/bin"
export CCE_DIR;

rm /tmp/clamdscan.files
touch /tmp/clamdscan.files

# add a file listing of the scandir to file listing

find $SCANDIR -maxdepth 1 -type f >> /tmp/clamdscan.files

# get directories

DIRS=`ls -l $SCANDIR | egrep '^d' | awk '{print $9}'`

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
sed -e 's/\<tmp\>//g' /tmp/clamdscan.files > /tmp/temp.files

# clean out blank lines

sed 's/  *$//;/^$/d' /tmp/temp.files > /tmp/clamdscan.files

#debug
#cat clamdscan.files

$CCE_DIR/clamav-easy.sh
