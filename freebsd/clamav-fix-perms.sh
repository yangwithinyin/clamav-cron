#!/bin/bash

# this should be patched into release
# fixes for running cron @root
# clamav is @nologin shell

chown -R :wheel /var/db/clamav
chmod +w clamav
