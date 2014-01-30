#!/bin/bash

declare -A colors

# Blue is really green... Thx Jenkins ;)
colors=([red]=`tput setaf 1` [blue]=`tput setaf 2` [yellow]=`tput setaf 3` [disabled]="`tput setaf 7`[X] " [aborted]=`tput setaf 7` [notbuilt]=i"`tput setaf 7`[N] ")
bold=`tput bold`
restore=`tput sgr0`
building="${restore}${bold}"
reset_pos=`tput cup 0 0`
WALKINS_PATH=~/.walkins
ASSETS_PATH=$WALKINS_PATH/assets

exists()
{
    if [ "$2" != in ]
    then
        echo "Incorrect usage. Should be: exists {key} in {array}"
        return
    fi

    eval '[ ${'$3'[$1]+wat} ]'
}


init() {
    source "$WALKINS_PATH/.install-path"
    source $INSTALL_PATH/utils/sourcerer.sh
    source_utils
    check_paths
    read_config
    notify_app_started
    main_loop
}


main_loop() {
    while [ true ]
    do
        i=0
        raw=$(curl --silent -u "$CREDENTIALS" "$URL")

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
                result+=${building}
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
