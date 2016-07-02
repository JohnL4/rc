#!/bin/bash

while true; do
    echo "------------------------------------------------" `date`
    netstat -t -W | egrep '^Proto| ec2|nflxvideo\.net'
    sleep 60
done
