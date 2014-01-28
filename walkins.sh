#!/bin/bash

declare -A colors
# Blue is really green... Thx Jenkins ;)
colors=([red]=`tput setaf 2` [blue]=`tput setaf 2` [yellow]=`tput setaf 3`)
bold_on=`tput bold`
bold_off=`tput rmso`
restore=`tput sgr0`
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
    clear
    while [ true ]
    do
        i=0
        raw=$(curl --silent -u "$1" "$2/api/json")
        job=$(echo $raw | jq ".jobs[$i]")
        result=""

        while [[ $job != "null" ]]
        do
            color=$(echo $(echo $job | jq ".color") | sed -r 's/\"//g')
            name=$(echo $job | jq ".name")
            if [[ $color = *_anime* ]]
            then
                result+="${restore}@ "
            fi

            color=$(echo "$color" | sed -r 's/_anime//g')
            result+="${colors[$color]}${name}\n"
            let i++
            job=$(echo $raw | jq ".jobs[$i]")
        done
        echo -e "$(tput cup 0 0)$result"
        sleep 1
    done
}

init
