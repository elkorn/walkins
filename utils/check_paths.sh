#!/bin/bash

check_paths() {
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
