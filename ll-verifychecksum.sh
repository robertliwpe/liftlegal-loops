#!/bin/bash

# Read list of installs 4096 character bash limit
read -p "List Installs Here: " installlist

# Loop through list of installs and pass commands through SSH to verify core checksum. No options applied.
for install in $installlist; 
do
    echo Verifying Checksum for $install;
    ssh $install@$install.ssh.wpengine.net "cd ~/sites/$install/ && wp core verify-checksums";
done;

echo WP CORE VERIFY CHECKSUM COMPLETE FOR: $installlist;