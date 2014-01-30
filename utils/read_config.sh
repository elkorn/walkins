#!~/bin/bash
URL=""
INTERVAL=30
NOTIFIER_PATH=$INSTALL_PATH/notifiers/libnotify.sh
read_config() {
    config=$(cat "$WALKINS_PATH/.walkinsrc")
    custom_notifier_path=$(echo "$config" | jq ".notifier_path" | sed -r 's/\"//g')
    URL=$(echo "$config" | jq ".url" | sed -r 's/\"//g')
    if [[ "$URL" != */ ]]
    then
        URL+=/
    fi

    URL+="api/json"
    INTERVAL=$(echo "$config" | jq ".interval")
    CREDENTIALS=$(cat "$WALKINS_PATH/.credentials")
    if [ -z "$custom_notifier_path" -a -e "$custom_notifier_path" ]
    then
        NOTIFIER_PATH=$custom_notifier_path
    fi
}

