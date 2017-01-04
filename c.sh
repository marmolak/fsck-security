#!/bin/bash

CONTENT=$(gpg2 --output - --decrypt servers.txt.gpg 2> /dev/null)
LIST=$(cut -d':' -f1 <(printf "$CONTENT"))
SERVER=$(zenity --height=400 --list --column Server $LIST)
if [[ $SERVER == '' ]]; then
    exit
fi

PASS=$(grep $SERVER  <(printf "$CONTENT") | cut -d':' -f2)
sshpass -p$PASS ssh -o StrictHostKeyChecking=no root@$SERVER
exec $0
