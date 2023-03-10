# Lift Legal CLI

***Before beginning, ensure that you have SSH Gateway access established and API Credentials and Access enabled***

https://wpengine.com/support/ssh-gateway/
https://wpengine.com/support/enabling-wp-engine-api/

Contained within this folder are four scripts designed to initiate bulk backups, bulk plugin installation, mass password reset, and bulk WordPress Core verify checksums.

To use them navigate to the folder in your terminal e.g.

`cd ~/path/to/directory/liftlegal-loops/`

Invoke the `chmod` command to make them executable e.g.

`chmod +x *.sh`

(The above command will make all shell scripts in the folder executable).

Then to use each script simply invoke them by typing out the file name e.g.

`./ll-backup.sh`

This will invoke the Backup script, this applies to all scripts.