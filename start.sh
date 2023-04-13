#!/bin/bash

make

koFile=$(ls *.ko)
hFile=$(ls *.h)
if test -f "$koFile"; then
    sudo insmod "$koFile"
    magicPrefix=$(awk '/MAGIC_PREFIX/{print $3}' "$hFile" | tr -d '"')
    thisDirPath=$(pwd)
    thisDir=${PWD##*/}
    mv "$thisDirPath" '../'"$magicPrefix""$thisDir"

    echo "built."
fi