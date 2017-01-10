#!/bin/bash
# Author: Robin Hack (hack.robin@gmail.com)

if [[ $MPASS == "" ]]; then
    stty_orig=$(stty -g)
    echo -n "password: "
    stty -echo
    read MPASS
    stty $stty_orig
    echo ""
    MPASS="$MPASS" exec $0
fi

CONTENT=$(gpg2 --batch --passphrase $MPASS --output - --decrypt servers.txt.gpg 2> /dev/null)
RET=$?
if [[ $RET -ne 0 ]]; then
    exit 1
fi
OLD_IFS=$IFS
IFS=$'\n'
LIST=($(cut -d':' -f1,2 <(echo "$CONTENT")))
IFS=$OLD_IFS

SERVER_SEL=($CONTENT)
select SERVER in "${LIST[@]}"; do
    case $SERVER in
        *)
            SERVER=$(echo $SERVER | cut -d':' -f1)
            PASS=$(grep $SERVER  <(printf "$CONTENT") | cut -d':' -f3)
            sshpass -p$PASS ssh -o StrictHostKeyChecking=no root@$SERVER
            MPASS="$MPASS" exec $0
        esac
done

