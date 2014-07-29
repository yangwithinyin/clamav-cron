clam-cron
=========

Overview:

This is a bash script for those who want to schedule a clamscan and e-mail a report via crontab.

Licensing:

This is free software licensed under the GPLv3 and is based on the original script Copyright © 2009, by Stefano Stagnaro.

Functions performed:

update the ClamAV virus database (freshclam)
perform personal system scan (clamscan)
send a brief report via e-mail

without any knowledge about ClamAV configuration files (such as clamd.conf or freshclam.conf) and without running the ClamAV daemon. You just have to configure the e-mail address(es) that will receive the report.

Dependencies:

The ClamAV engine and daemon.
A mail server, e.g. sendmail.

Installation and configuration:

1. Download clam-cron somewhere like /usr/local/bin/ and give it execute permissions.

2. chmod 755 /usr/local/bin/clam-cron

3. Open clam-cron, and edit the "User configuration" section.

4. schedule the clamav-cron script via cron.

crontab -e 

45 23 * * 5 /usr/local/bin/clamav-cron /

Cron will run clamav-cron every Friday at 23:45 (11:45 pm) to recursively scan the whole / tree. 

At the end of task it will send a notification e-mail to the users specified at step  3. 

For more information about crontab see the manual (e.g. man 5 crontab).
