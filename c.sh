#!/bin/bash

LIST=$(cut -d':' -f1 servers.txt)
SERVER=$(zenity --height=400 --list --column Server $LIST)
if [[ $SERVER == '' ]]; then
    exit
fi

PASS=$(grep $SERVER servers.txt | cut -d':' -f2)
sshpass -p$PASS ssh -o StrictHostKeyChecking=no root@$SERVER
exec $0
