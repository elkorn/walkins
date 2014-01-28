#!/bin/bash

RESTORE=$(tput setaf sgr0)
GREEN=$(tput setaf 2)
RED=$(tput setaf 1)
YELLOW=$(tput setaf 3)
function init() {
    if [ ! -f ./.credentials ] 
    then
        echo ".credentials file not found. Sorry!"
        exit 1
    fi
    if [ ! -f ./.walkinsrc ]
    then
        echo ".walkinsrc file not found. Sorry!"
        exit 2
    fi

    main_loop $(cat .credentials) $(cat .walkinsrc)
}

function main_loop() {
    while [ true ]
    do
        jobs=$(curl --silent -u $1 $2 | jq ".jobs")
        clear
        echo ${jobs[*]}
        sleep 1
    done
}

init
