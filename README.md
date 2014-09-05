clamav-cron
=========

# Overview:

This is an easy to configure bash script, for those who want to schedule definition updates, scanning, and e-mail a report upon any virus detection or clamav-cron errors via the local MTA.

# Licensing:

This is free software licensed under the GPLv3 and is based on the original script by Stefano Stagnaro.

You can find the original script here:

https://code.google.com/p/clamav-cron/

# Functions performed (in order):

1. Update the ClamAV virus database (freshclam).
2. Perform personal system scan (clamscan/clamdscan).
3. Send a brief report upon virus detection via e-mail (sendmail).

Without any knowledge about ClamAV configuration files (such as clamd.conf or freshclam.conf). You only need to configure the e-mail address(es) that will receive the report.

# Dependencies:

The ClamAV engine (clamav).

A mail server (sendmail). required for sending mail reports).

## w/ easy setup script:

The ClamAV daemon (clamd).

# Installation and configuration:

## Option 1. Use the setup scripts for the intial install

### Requires: ClamAV daemon (clamd)

#### Supported Installations

Debian/Ubuntu quick setup (debian-setup.sh)
```
mkdir -p /opt/clamav-cron
cd /opt/clamav-cron
wget https://raw.githubusercontent.com/yangwithinyin/clamav-cron/master/debian/debian-setup.sh
chmod 755 debian-setup.sh
```

FreeBSD quick setup (freebsd-setup.sh)
```
mkdir -p /opt/clamav-cron
cd /opt/clamav-cron
wget https://raw.githubusercontent.com/yangwithinyin/clamav-cron/master/freebsd/freebsd-setup.sh
chmod 755 freebsd-setup.sh
```

## Option 2. Download and copy clamav-cron.sh to /usr/local/bin/

```
cd ~
wget https://raw.githubusercontent.com/yangwithinyin/clamav-cron/master/clamav-cron.sh
cp ~/clamav-cron.sh /usr/local/bin/clamav-cron.sh
```

## Setup the permissions and ownership

```
chmod 755 /usr/local/bin/clamav-cron.sh
chown clamav:clamav /usr/local/bin/clamav-cron.sh
chown clamav:clamav /var/log/clamav
```
## Update clamav-cron "User configuration"
### Open /usr/local/bin/clamav-cron.sh in your favorite editor

```
#============================================#
#        User configuration section          #
#============================================#

# Log file name and its path:
CV_LOGFILE="/var/log/clamav/clamav-cron.log" 

# Notification e-mail sender (will work when invalid):
CV_MAILFROM="user@server.tld" 

# Notification e-mail recipient (must be valid):
CV_MAILTO="user@maildomain.tld" 

# Notification e-mail secondary recipients (must be valid):
CV_MAILTO_CC="webmaster@yourcompany.tld" 

# Notification e-mail subject:
CV_SUBJECT="Your Company - ClamAV scan report" 
```

## Schedule clamav-cron.sh via crontab.

```
crontab -e 
45 23 * * 5 /usr/local/bin/clamav-cron.sh /
```

### Crontab details

Cron will run clamav-cron every Friday at 23:45 (11:45 pm) to recursively scan the whole / tree. 

At the end of task it will send a notification e-mail upon virus detection to the users specified at step 3. 

For more information about crontab see the manual (e.g. man 5 crontab).
