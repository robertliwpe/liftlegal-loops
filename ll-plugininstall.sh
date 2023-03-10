#!/bin/bash

# Read plugin to be installed, accepts official plugin slug, the path to a local zip file, or a URL to a remote zip file.
read -p "What plugin are you installing? " plugin

# Read list of installs 4096 character bash limit
read -p "List Installs Here: " installlist

# Loop through list of installs and pass commands through SSH to to install plugin and activate.
for install in $installlist; 
do
    echo Installing and Activating $plugin For $install;
    ssh $install@$install.ssh.wpengine.net "cd ~/sites/$install/ && wp plugin install $plugin --activate";
done;

echo $plugin INSTALLED FOR: $installlist;