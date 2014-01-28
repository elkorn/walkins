#!/bin/bash

declare -A colors
declare -A tracked_jobs

# Blue is really green... Thx Jenkins ;)
colors=([red]=`tput setaf 2` [blue]=`tput setaf 2` [yellow]=`tput setaf 3`)
bold_on=`tput bold`
bold_off=`tput rmso`
restore=`tput sgr0`
reset_pos=`tput cup 0 0`

function exists()
{
    if [ "$2" != in ]
    then
        echo "Incorrect usage. Should be: exists {key} in {array}"
        return
    fi

    eval '[ ${'$3'[$1]+wat} ]'
}

function update_job_build_status() {
    tracked_jobs["$1_status"]="$2"
}

function update_job_progress() {
    tracked_jobs["$1_building"]="$2"
}

function start_tracking_job() {
    update_job_build_status "$1" "$2"
    update_job_progress "$1" "$3"
}

function notify_build_status_changed() {
    if [[ "$2" == "blue" ]]
    then
        echo "$1: Build OK."
    else
        if [[ "$2" == "red" ]]
        then
            echo "$1: Build Failed!"
        else
            if [[ "$2" == "yellow" ]]
            then
                echo "$1: Build unstable!"
            fi
        fi
    fi
}

function notify_job_progress_changed() {
    if [[ "$2" == "building" ]]
    then
        echo "$1: Build started."
    else
        if [[ "$2" == "idle" ]] 
            then
            echo "$1: Build finished."
        fi
    fi
}

function handle_build_status_change() {
    if [[ -z "$1" ]]
    then
        echo "Provide the name of the job whose status has changed."
        echo "Correct usage:  handle_build_status_change {job_name} {new_status}"
        return
    fi

    if [[ -z "$2" ]]
    then
        echo "Provide the new status of the job whose status has changed."
        echo "Correct usage:  handle_build_status_change {job_name} {new_status}"
        return
    fi

    notify_build_status_changed "$1" "$2" # TODO: Export this functionality to a plugin.
    update_job_build_status "$1" "$2"
}

function handle_job_progress_change() {
    if [[ -z "$1" ]]
    then
        echo "Provide the name of the job whose build progress has changed."
        echo "Correct usage:  handle_build_status_change {job_name} {new_progress_state}"
        return
    fi

    if [[ -z "$2" ]]
    then
        echo "Provide the new status of the job whose build progress has changed."
        echo "Correct usage:  handle_build_status_change {job_name} {new_progress_state}"
        return
    fi

    notify_job_progress_changed "$1" "$2" # TODO: Export this functionality to a plugin.
    update_job_progress "$1" "$2"
}


function track_job() {
    if [[ -z "$1" ]]
    then
        echo "Provide the name of the job to be tracked."
        echo "Correct usage: start_tracking_job {job_name} {current_state} {is_currently_building}"
        return
    fi

    if [[ -z "$2" ]]
    then
        echo "Provide the current state of the job whose to be tracked."
        echo "Correct usage: start_tracking_job {job_name} {current_state} {is_currently_building}"
        return
    fi

    if [[ -z "$3" ]]
    then
        echo "Provide the current building status of the job whose to be tracked."
        echo "Correct usage: start_tracking_job {job_name} {current_state} {is_currently_building}"
        return
    fi

    if exists "$1_status" in tracked_jobs
    then
        handle_build_status_change "$1" "$2"
        handle_job_progress_change "$1" "$3"
    else
        start_tracking_job "$1" "$2" "$3"
    fi
}

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
            name=$(echo $job | jq ".name" | sed -r 's/\"//g')
            progress="idle"
            if [[ $color = *_anime* ]]
            then
                progress="building"
                result+="${restore}@ "
            fi

            color=$(echo "$color" | sed -r 's/_anime//g')
            track_job "$name" "$color" "$progress"
            result+="${colors[$color]}${name}${restore}\n"
            let i++
            job=$(echo $raw | jq ".jobs[$i]")
        done
        # clear
        echo -e "$result"
        sleep 1
    done
}

init
