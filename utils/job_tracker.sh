#!/bin/bash
declare -A tracked_jobs
job_status_change_notified=false
job_finished=false

start_tracking_job() {
    update_job_build_status "$1" "$2"
    update_job_progress "$1" "$3"
}

update_job_build_status() {
    tracked_jobs["${1}_status"]="$2"
}

update_job_progress() {
    tracked_jobs["${1}_progress"]="$2"
}

handle_build_status_change() {
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

    if [[ ${tracked_jobs["${1}_status"]} != "$2" ]]
    then
        notify_build_status_changed "$1" "$2"
        update_job_build_status "$1" "$2"
        job_status_change_notified=true
    fi
}

handle_job_progress_change() {
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

    if [[ ${tracked_jobs["${1}_progress"]} != "$2" ]]
    then
        notify_job_progress_changed "$1" "$2"
        update_job_progress "$1" "$2"
        if [[ "$2" == "idle" ]]
        then
            job_finished=true
        fi
    fi
}

track_job() {
    if [[ -z "$1" ]]
    then
        echo "Provide the name of the job to be tracked."
        echo "Correct usage: track_job {job_name} {current_state} {is_currently_progress}"
        return
    fi

    if [[ -z "$2" ]]
    then
        echo "Provide the current state of the job whose to be tracked."
        echo "Correct usage: track_job {job_name} {current_state} {is_currently_progress}"
        return
    fi

    if [[ -z "$3" ]]
    then
        echo "Provide the current building status of the job whose to be tracked."
        echo "Correct usage: track_job {job_name} {current_state} {is_currently_progress}"
        return
    fi

    if exists "${1}_status" in "$tracked_jobs"
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

