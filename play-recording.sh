#!/usr/bin/env bash 

USAGE="$0 [recording_file]"
CAST_FILENAME="term.cast"
AUDIO_FILENAME="audio.ogg"

#cleanup $child_pid $temp_dir $output_file
function cleanup {
    child_pid=$1
    working_dir=$2
    if [ "$child_pid" -ne "0" ]; then
        kill $child_pid > /dev/null 2> /dev/null
    fi

    rm -rf $working_dir
    
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
    working_dir=`mktemp -d`
    recording_path=`realpath $recording_file`
    
    function call_cleanup {
        cleanup $child_pid $working_dir
    }
    trap "exit" INT TERM ERR
    trap "call_cleanup;" EXIT

    cd $working_dir
    tar xzf $recording_path

    play -q $AUDIO_FILENAME &
    child_pid=$!

    `which sleep` .7
    asciinema play $CAST_FILENAME

}

main "$@"