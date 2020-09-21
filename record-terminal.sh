#!/usr/bin/env bash 

USAGE="$0 [output_file]"
CAST_FILENAME="term.cast"
AUDIO_FILENAME="audio.ogg"

#cleanup $child_pid $temp_dir $output_file
function cleanup {
    child_pid=$1
    working_dir=$2
    output_file=`realpath $3`
    if [ "$child_pid" -ne "0" ]; then
        # give it one second to finish recording
        env sleep 2.5
        kill $child_pid
    fi

    pushd . >/dev/null
    cd $working_dir;
    tar -czf $output_file $AUDIO_FILENAME $CAST_FILENAME 
    popd > /dev/null

    rm -rf $working_dir
    
    kill 0
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
    output_file="$1"
    if [ -z "$output_file" ]; then
        fatal please provide the output file
    fi
    working_dir=`mktemp -d`
    cast_file=$working_dir/$CAST_FILENAME
    audio_file=$working_dir/$AUDIO_FILENAME

    function call_cleanup {
        cleanup $child_pid $working_dir $output_file
    }
    trap "exit" INT TERM ERR
    trap "call_cleanup;" EXIT

    debug begin recording auido
    arecord -f S16_LE -c1 -r22050 -t raw | oggenc - -r -C 1 -R 22050 -o $audio_file -Q &
    child_pid=$!

    debug starting asciicema
    asciinema rec $cast_file

}

main "$@"