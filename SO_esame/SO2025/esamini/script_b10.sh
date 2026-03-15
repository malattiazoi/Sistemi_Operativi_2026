#!/bin/bash

pid_target=$1
# pid_target=$(pgrep -f "script_a.sh")
while true; do
    echo sto rompendo al pid $pid_target
    kill -15 $pid_target
    sleep 2
done
