#!/bin/bash

# Check API Credentials
echo Checking API Credentials;

if [ -z "$(cat .wpeapicreds 2>/dev/null | grep wpeapiuser_id)" ]; 
then 
    echo API Credentials NOT FOUND;
    read -p "Enter your WP Engine API User ID: "  wpeapiuser;
    read -p "Enter your WP Engine API Password: " wpeapipw;
    echo Exporting Credentials...
    touch .wpeapicreds
    echo wpeapiuser_id=$wpeapiuser >> .wpeapicreds;
    echo wpeapiuser_pw=$wpeapipw >> .wpeapicreds;
    echo WP Engine API Credentials Exported to Credentials File;
    
else 
    echo API CREDENTIALS FOUND; 
    wpeapiuser=$(cat .wpeapicreds | grep wpeapiuser_id | cut -d'=' -f2);
    wpeapipw=$(cat .wpeapicreds | grep wpeapiuser_pw | cut -d'=' -f2);
fi;

# Check Notification Email
echo Checking Notification Email;

if [ -z "$(cat .apidata.json 2>/dev/null | grep notification_emails)" ]; 
then 
    echo Notification Email NOT FOUND;
    read -p "Enter your notification email: " wpeapiem;
    echo Exporting default JSON data file...
    touch .apidata.json
    datafile=".apidata.json"
    tempapidata='{ "description": "Automated API CLI Backup", "notification_emails": [ "TEMPEMAIL" ] }'
    printf "$tempapidata" >> .apidata.json;
    sed -i '' "s/TEMPEMAIL/$wpeapiem/g" "$datafile";
    echo Exported default JSON data file...;
else 
    echo Notification Email FOUND;
fi

# Read list of installs 4096 character bash limit
read -p "List Installs to Backup Here: " installlist

# Find Install ID then loop to complete backup

for install in $installlist; 
do
    installid=$(curl -X GET "https://api.wpengineapi.com/v1/installs" -u "$wpeapiuser":"$wpeapipw" | jq . | grep $install -B 1 | tr '"' ' ' | grep id | tr -d ',' | cut -d':' -f2 | tr -d ' ';)
    echo $install ID: $installid;
    echo Initiating backup...;
    curl -X POST "https://api.wpengineapi.com/v1/installs/$installid/backups" -u $wpeapiuser:$wpeapipw \
        -H 'accept: application/json' \
        -H 'Content-Type: application/json' \
        -d @.apidata.json;
done

echo ...;
echo BACKUPS INITIATED FOR: $installlist;

# Check whether user wishes to save credentials or not

while true; 
do
    read -p "Would you like to retain your API Credentials and Email (NOTE: You may need to create NEW API Credentials in the WP Engine User Portal next use)? (y/n) " yn
    case $yn in 
        [yY] ) echo Exiting...;
            exit;;
        [nN] ) echo Cleaning Up...;
            rm .apidata.json .wpeapicreds;
            echo Exiting...;
            exit;;
        * ) echo invalid response;;
    esac
done;