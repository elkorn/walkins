#!/bin/bash
notify_build_status_changed() {
    case "$2" in
        "blue")     notify-send 'Build succeeded' "$1" -i "$ASSETS_PATH/happy.png"
                    ;;
        "red")      notify-send 'Build failed' "$1" -i "$ASSETS_PATH/scared.png"
                    ;;
        "yellow")   notify-send 'Build unstable' "$1" -i "$ASSETS_PATH/faint.png"
                    ;;
        "aborted")  notify-send 'Build aborted' "$1" -i "$ASSETS_PATH/faint.png" # Change the icon.
                    ;;
        "disabled")  notify-send 'Build disabled' "$1" -i "$ASSETS_PATH/faint.png" # Change the icon.
                    ;;
    esac
}

notify_job_progress_changed() {
    if [[ "$2" == "building" ]]
    then
        notify-send 'Build started' "$1" -i "$ASSETS_PATH/happy.png"
    fi
}

notify_app_started() {
    notify-send 'Walkins operational' 'Hello there!' -i "$ASSETS_PATH/happy.png"
}

notify_error() {
    notify-send "Walkins has crashed!" "Please check the log and send it to the author. Sorry! :(" -i "$ASSETS_PATH/painful.png"
}

notify_connection_error() {
    notify-send "Walkins cannot connect" "Please verify that the Jenkins is up and the provided URL is correct." -i "$ASSETS_PATH/puzzled.png"
}

notify_credentials_error() {
    notify-send "Walkins cannot log on" "Please verify whether provided credentials are correct." -i "$ASSETS_PATH/puzzled.png"
}
