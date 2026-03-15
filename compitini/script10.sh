#!/bin/bash

i=0


trap 'echo $i' SIGTERM

while true; do
    i=$((i + 1))
    echo "in esecuzione $i ..."
    echo il mio pid=$$
    sleep 1
done