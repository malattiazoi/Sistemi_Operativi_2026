#!/bin/bash
while true;
do 
    echo ti spacco la faccia al pid $1
    kill -15 $1
    sleep 3
done