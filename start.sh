#!/bin/bash
make
KO=diamorphine.ko
if test -f "$KO"; then #testing if .ko was built properly
    
    sudo insmod "$KO"
    echo "built."

fi