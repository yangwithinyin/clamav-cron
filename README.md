clamav-cron
=========

Overview:

This is a simple and easy to configure bash script, for those who want to schedule definition updates, scanning, and e-mail a report via the local MTA.

Licensing:

This is free software licensed under the GPLv3 and is based on the original script by Stefano Stagnaro.

You can find the original script here:

https://code.google.com/p/clamav-cron/

Functions performed (in order):

1. Update the ClamAV virus database (freshclam).
2. Perform personal system scan (clamscan).
3. Send a brief report via e-mail (sendmail).

without any knowledge about ClamAV configuration files (such as clamd.conf or freshclam.conf) and without running the ClamAV daemon. You just have to configure the e-mail address(es) that will receive the report.

Dependencies:

The ClamAV engine (clamav).

A mail server (e.g. sendmail).

Installation and configuration:

1. Download clamav-cron.sh somewhere like /usr/local/bin/ and give it execute permissions.

2. Set the permissions required for clamav-cron.sh to run properly.

	chmod 755 /usr/local/bin/clamav-cron.sh
	
        chown clamav:clamav /usr/local/bin/clamav-cron.sh
        
        chown clamav:clamav /var/log/clamav

3. Open clamav-cron, and edit the "User configuration" section.

4. Schedule clamav-cron.sh via crontab.

	crontab -e 
	
	45 23 * * 5 /usr/local/bin/clamav-cron.sh /

Cron will run clamav-cron every Friday at 23:45 (11:45 pm) to recursively scan the whole / tree. 

At the end of task it will send a notification e-mail to the users specified at step 3. 

For more information about crontab see the manual (e.g. man 5 crontab).
