#!/bin/bash

exists()
{
    if [ "$2" != in ]
    then
        echo "Incorrect usage. Should be: exists {key} in {array}"
        return
    fi

    eval '[ ${'$3'[$1]+wat} ]'
}
