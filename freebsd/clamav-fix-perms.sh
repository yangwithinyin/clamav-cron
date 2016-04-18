#!/bin/bash

# this should be patched into release
# fixes for running cron @root
# clamav is @nologin shell

cd /var/db
chown :wheel clamav
chmod +w clamav
