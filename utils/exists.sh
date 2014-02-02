#!/bin/bash

exists()
{
    if [ "$2" != in ]
    then
        echo "Incorrect usage. Should be: exists {key} in {array}"
        return
    fi

    assoc=$3
    test "${assoc[$1]+_}"
}
