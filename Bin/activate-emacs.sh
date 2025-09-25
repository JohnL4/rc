#!/bin/bash

set -u                          # xdotool returns error status if window not found; not helpful here.
# set -x

# xdotool search --onlyvisible --class Emacs

emacsWindowId=`xdotool search --limit 1 --onlyvisible --class Emacs`
echo ">$emacsWindowId<"

if [ "$emacsWindowId" ]; then
    xdotool windowactivate $emacsWindowId
else
    emacs &
fi
