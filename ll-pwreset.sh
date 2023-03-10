#!/bin/bash

# Read list of installs 4096 character bash limit
read -p "List Installs Here: " installlist

# Loop through list of installs and pass commands through SSH to list user IDs of installs and resetting passwords of found user IDs.
for install in $installlist; 
do
    useridlist=$(echo $(ssh $install@$install.ssh.wpengine.net "cd ~/sites/$install/ && wp user list --field=ID")); 
    echo USER IDs FOUND: $useridlist;
    echo RESETTING PASSWORDS FOR $install...;
    ssh $install@$install.ssh.wpengine.net "cd ~/sites/$install/ && wp user reset-password $useridlist";
done;

echo PASSWORD RESET COMPLETE FOR: $installlist;