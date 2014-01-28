#!/bin/bash

declare -A colors
colors=([restore]="sgr0" [red]="1" [blue]="2" [yellow]="3")


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
        i=0
        raw=$(curl --silent -u "$1" "$2/api/json")
        job=$(echo $raw | jq ".jobs[$i]")
        result=""

        while [[ $job != "null" ]]
        do
            color=${colors[$(echo $(echo $job | jq ".color") | sed -r 's/\"//g' | sed -r 's/_anime//g')]}
            name=$(echo $job | jq ".name")
            result+="$(tput setaf $color)${name}\n"
            let i++
            job=$(echo $raw | jq ".jobs[$i]")
        done
        clear
        echo -e "$result"
        sleep 1
    done
}

init
