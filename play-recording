#!/usr/bin/env bash 

USAGE="$0 [recording_file]"
CAST_FILENAME="term.cast"
AUDIO_FILENAME="audio.ogg"

#cleanup $child_pid $temp_dir $output_file
function cleanup {
    child_pid=$1
    if [ "$child_pid" -ne "0" ]; then
        kill $child_pid > /dev/null 2> /dev/null
    fi

    kill 0 > /dev/null 2> /dev/null
}

function fatal {
    echo -e "Usage:\n$USAGE\n\nerror: $@"
    exit 1
}

function debug {
    if [ -z "$DEBUG"];
    then
        return
    fi
    echo $@
}

function main {

    child_pid=0 # will be set below after arecord is started.
    recording_file="$1"
    if [ -z "$recording_file" ]; then
        fatal please provide the recording file
    fi
    recording_path=`realpath $recording_file`
    
    function call_cleanup {
        cleanup $child_pid 
    }
    trap "exit" INT TERM ERR
    trap "call_cleanup;" EXIT

     	
    # Start audio playback
    tar -xOzf $recording_path $AUDIO_FILENAME | play -q - &
    child_pid=$!

    # start asciinema playback
    tar -xOzf $recording_path $CAST_FILENAME | asciinema play -

}

main "$@"