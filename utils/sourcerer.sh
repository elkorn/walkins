#!/bin/bash
source_error_out() {
    echo "Couldn't source $1, correctly. Sorry, but I can't stand that!"
    exit 4
}

is_defined() {
    if [ -n "$(type -t "$1")" ]
    then
        return 0    # In the spirit of UNIX, returning 0 as OK.
    else
        return 1
    fi
}

is_sourced() {
    is_defined "$1"
    if [ $? -eq 1 ]
    then
        if [ -n "$2" ]
        then
            source_error_out "$2"
        else
            source_error_out "$1"
        fi
    fi
}

source_utils() {
    . ./utils/check_paths.sh
    is_sourced "check_paths" "check_paths.sh"
    . ./utils/logger.sh
    is_sourced "log" "logger.sh"
    . ./utils/read_config.sh
    is_sourced "read_config" "read_config.sh"
    . ./utils/job_tracker.sh
    is_sourced "start_tracking_job" "job_tracker.sh"
    is_sourced "update_job_build_status" "job_tracker.sh"
    is_sourced "update_job_progress" "job_tracker.sh"
    is_sourced "handle_build_status_change" "job_tracker.sh"
    is_sourced "handle_job_progress_change" "job_tracker.sh"
    is_sourced "track_job" "job_tracker.sh"
    . $NOTIFIER_PATH
    is_sourced "notify_build_status_changed" "$NOTIFIER_PATH"
    is_sourced "notify_job_progress_changed" "$NOTIFIER_PATH"
    is_sourced "notify_app_started" "$NOTIFIER_PATH"
    is_sourced "notify_error" "$NOTIFIER_PATH"
    . ./utils/error_hadler.sh 
    is_sourced "error_out" "error_handler.sh"
}
