#!/bin/bash

while true; do

    pid_tetris=$(ps -e | grep -i tetris | grep -v grep | tr -s " " | cut -d " " -f2)
    pid_gta6=$(ps -e | grep -i gta6 | grep -v grep | tr -s " " | cut -d " " -f2)
    
    if [[ "$pid_tetris" != "" || "$pid_gta6" != "" ]]; then
        echo tetris rilevato, mo te lo killo
        sleep 180
        kill -9 $pid_tetris 2>/dev/null
        kill -9 $pid_gta6 2>/dev/null
        echo killato male
    else
        echo non ho trovato giochi sospetti
    fi
    
    sleep 1

done
