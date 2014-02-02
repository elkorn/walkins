#!/bin/bash

log() {
    if [ -z "$1" ]
    then
        echo "Provide the message to be logged. Correct usage: log {message} [{type}]"
        return
    fi
    type="$2"
    if [ -z "$type" ]
    then
        # The main purpose of this is to log errors.
        type="ERROR"
    fi

    echo -e "[$type @ $(echo $(date))] $1" >> ~/.walkins/logfile
}
