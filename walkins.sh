#!/bin/bash

declare -A colors
declare -A tracked_jobs

# Blue is really green... Thx Jenkins ;)
colors=([red]=`tput setaf 1` [blue]=`tput setaf 2` [yellow]=`tput setaf 3`)
bold_on=`tput bold`
bold_off=`tput rmso`
restore=`tput sgr0`
reset_pos=`tput cup 0 0`
job_status_change_notified=false
job_finished=false
WALKINS_PATH=~/.walkins
ASSETS_PATH=$WALKINS_PATH/assets
URL=""
INTERVAL=30

function read_config() {
    config=$(cat "$WALKINS_PATH/.walkinsrc")
    URL=$(echo "$config" | jq ".url" | sed -r 's/\"//g')
    INTERVAL=$(echo "$config" | jq ".interval")
    CREDENTIALS=$(cat "$WALKINS_PATH/.credentials")
}

function log() {
    if [ -z "$1" ]
    then
        echo "Provide the message to be logged. Correct usage: log {message} [{type}]"
        return
    fi

    if [ -z "$2" ]
    then
        # The main purpose of this function is to log errors.
        2="ERROR"
    fi

    echo -e "i[$2@$(date)] $1\n" > ~/.walkins/logfile
}

function check_paths() {
    if [ ! -d "$WALKINS_PATH" ]
    then
        echo "$WALKINS_PATH seems not to exist. Have you ran the configuration script?"
        exit 1
    fi
    if [ ! -d "$ASSETS_PATH" ]
    then
        echo "$ASSETS_PATH seems not to exist. Have you ran the configuration script?"
        exit 1
    fi

    if [ ! -f "$WALKINS_PATH/.credentials" ]
    then
        echo ".credentials file not found. Have you ran the configuration script?"
        exit 1
    fi

    if [ ! -f "$WALKINS_PATH/.walkinsrc" ]
    then
        echo ".walkinsrc file not found. Have you ran the configuration script?"
        exit 1
    fi
}

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
    tracked_jobs["$1_progress"]="$2"
}

function start_tracking_job() {
    update_job_build_status "$1" "$2"
    update_job_progress "$1" "$3"
}

function notify_build_status_changed() {
    if [[ "$2" == "blue" ]]
    then
        notify-send 'Build succeeded' "$1" -i "$ASSETS_PATH/happy.png"
    else
        if [[ "$2" == "red" ]]
        then
            notify-send 'Build failed!' "$1" -i "$ASSETS_PATH/scared.png"
        else
            if [[ "$2" == "yellow" ]]
            then
                notify-send 'Build unstable!' "$1" -i "$ASSETS_PATH/faint.png"
            fi
        fi
    fi
}

function notify_job_progress_changed() {
    if [[ "$2" == "building" ]]
    then
        notify-send 'Build started' "$1" -i "$ASSETS_PATH/happy.png"
        else if [[ "$2" == "idle" ]]
        then
            job_finished=true
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

    if [[ ${tracked_jobs["$1_status"]} != "$2" ]]
    then
        notify_build_status_changed "$1" "$2" # TODO: Export this functionality to a plugin.
        update_job_build_status "$1" "$2"
        job_status_change_notified=true
    fi
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

    if [[ ${tracked_jobs["$1_progress"]} != "$2" ]]
    then
        notify_job_progress_changed "$1" "$2" # TODO: Export this functionality to a plugin.
        update_job_progress "$1" "$2"
    fi
}

function track_job() {
    if [[ -z "$1" ]]
    then
        echo "Provide the name of the job to be tracked."
        echo "Correct usage: start_tracking_job {job_name} {current_state} {is_currently_progress}"
        return
    fi

    if [[ -z "$2" ]]
    then
        echo "Provide the current state of the job whose to be tracked."
        echo "Correct usage: start_tracking_job {job_name} {current_state} {is_currently_progress}"
        return
    fi

    if [[ -z "$3" ]]
    then
        echo "Provide the current building status of the job whose to be tracked."
        echo "Correct usage: start_tracking_job {job_name} {current_state} {is_currently_progress}"
        return
    fi

    if exists "$1_status" in tracked_jobs
    then
        handle_build_status_change "$1" "$2"
        handle_job_progress_change "$1" "$3"

        if [[ "$job_finished" == true && "$job_status_change_notified" == false ]]
        then
            notify_build_status_changed "$1" "$2"
        fi

        job_status_change_notified=false
        job_finished=false
    else
        start_tracking_job "$1" "$2" "$3"
    fi
}

function init() {
    check_paths
    read_config
    main_loop
}

function error_notify() {
    notify-send "Walkins has crashed!" "Please send the log to its creator. Sorry! :("
}

function error_out() {
    echo "I have failed you miserably! I'm so sorry. :( Check ~/.walkins/logfile for details."
    error_notify
    exit 3
}

function main_loop() {
    while [ true ]
    do
        i=0
        raw=$(curl --silent -u "$CREDENTIALS" "$URL/api/json")

        if [[ $raw = "*Error 401 Failed to login*" ]]
        then
            echo "Seems like your credentials are not valid for the specified URL. Please check them."
            exit 2
        fi

        job=$(echo $raw | jq ".jobs[$i]")

        if [ -z "$job" ]
        then
            echo "Seems like the URL provided in .walkinsrc is not correct. Please check it."
            exit 2
        fi

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
            if ! exists "$color" in colors
            then
                log "Unknown Jenkins status '$color' for job '$name' with index $i."
                log "$job"
                log "$raw"
                error_out
            fi

            track_job "$name" "$color" "$progress"
            result+="${colors[$color]}${name}${restore}\n"
            let i++
            job=$(echo $raw | jq ".jobs[$i]")
        done
        clear
        echo -e "$result"
        sleep "$INTERVAL"
    done
}

init
