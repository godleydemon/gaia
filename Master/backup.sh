#!/bin/bash
dateForm=`date +%m-%d-%Y`
fileName=SERVERNAME-"$dateForm"

screen -xr SERVERNAME -X stuff "broadcast Backup starting. World no longer saving... $(printf '\r')"
screen -xr SERVERNAME -X stuff "save-off $(printf '\r')"
screen -xr SERVERNAME -X stuff "save-all $(printf '\r')"
sleep 3

tar -cpvzf "/home/servers/SERVERNAME/backups/$fileName".tar.gz /home/servers/SERVERNAME --exclude '/home/servers/SERVERNAME/backups'

screen -xr SERVERNAME -X stuff "save-on $(printf '\r')"
screen -xr SERVERNAME -X stuff "broadcast Backup complete. World now saving. $(printf '\r')"

echo "All Done Boss"