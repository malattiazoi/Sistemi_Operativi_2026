#!/bin/bash
i=0
echo il mio pid è $$

mia_funzione(){
    echo ecco qui $i    
}

# trap 'echo ecco qui $i' SIGTERM
trap mia_funzione SIGTERM
while true; do
    # ((i++))
    i=$((i+1))
    sleep 1
done


