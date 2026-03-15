#!/bin/bash

file1=x.txt
file2=y.txt

# Verifica che entrambi i file esistano
if [ ! -f "$file1" ] || [ ! -f "$file2" ]; then
    echo "!!!! Errore: uno o entrambi i file non esistono."
    exit 1
fi

# Conteggio delle righe nei due file (command substitutions)
righe1=$(cat "$file1" | wc -l )
righe2=$(cat "$file2" | wc -l )

# Confronto dei numeri di righe
if [ "$righe1" -eq "$righe2" ]; then
    echo "I file hanno lo stesso numero di righe"
    echo "Righe: $righe1"
else
    if [ "$righe1" -gt "$righe2" ]; then
        echo differenza righe: $(($righe1-$righe2))
    else
        echo differenza righe: $(($righe2-$righe1))
    fi
    echo il primo file contiene $righe1 righe
    echo il secondo file file contiene $righe2 righe
fi
