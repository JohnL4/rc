#!/bin/bash

# Monitor logon status for the given kids, and, once they have logged
# on, set a timer to log them out.
#
# Usage: kid-time-window.sh -t 10 albert conrad savannah

myname=`basename -s .sh $0`

while getopts "t:" opt; do
    case $opt in
        (t) timewindow=$OPTARG
            ;;
    esac
done

shift `expr $OPTIND - 1`
kids=$@

echo "$myname: $timewindow min; $# kids:" $kids 1>&2

for kid in $kids; do
    # find /tmp/
    echo "$myname: $kid" 1>&2
    flagfileName="/tmp/${myname}-${kid}"
    if [ -e $flagfileName ]; then
        timestamp=`cat $flagfileName`
        # Figure out whether to slay kid
        flagfiles=`find $flagfileName -newermt "$timestamp"` # Will
        # always return something, so, no good.
    else
        date > $flagfileName
    fi
    flagfiles=`find $flagfileName -cmin $timewindow`
    if [ "$flagfiles" = "" ]; then
        # File touched more than $timewindow minutes ago
        slay $kid
        rm $flagfileName
    fi
done

