#!/usr/bin/env bash
mode=$1

case $mode in
    e|enable)
        # stop running caffeinate instances
        killall caffeinate 2>/dev/null
        if [[ $2 =~ '^[0-9]+$' ]]; then # test if enable was passed with a time (in minutes)
            FLAGS=${@:3}
            caffeinate -t $2*60 $FLAGS > /dev/null 2>&1 &
        elif [[ ! -z $2 ]]; then # test for standard flags
            FLAGS=${@:2}
            # pass any flags to caffeinate
            caffeinate $FLAGS > /dev/null 2>&1 &
        else
            # start caffeinate indefinitely with standard mode
            caffeinate -d > /dev/null 2>&1 &
        fi
        ;;
    d|disable)
        killall caffeinate 2>/dev/null
        ;;
    s|status)
        ps -fwwp $(pgrep caffeinate)
        ;;
    *)
        echo """
        Caffeinate options:
        [e]nable
        [d]isable
        [s]status

        Flags for enable:
        -d: keep the display awake
        -i: prevent idle sleep
        -s: prevent system sleep
        -u: emulate user activity

        -t [s]: set a timeout in seconds
        -w [PID]: watch a process by PID
        """
        ;;
esac
