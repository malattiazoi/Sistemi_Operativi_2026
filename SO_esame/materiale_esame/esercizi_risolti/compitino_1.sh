#!/bin/bash


# Scrivere uno script Bash che prenda in input due file e confronti il numero 
# di righe contenute in ciascuno.
# - Se uguali: stampare "I file hanno lo stesso numero di righe" e il numero.
# - Altrimenti: stampare la differenza e quante righe hanno rispettivamente.
# Nota: usare almeno due command substitutions.

if [ $# -ne 2 ]; then
    echo "Errore: Servono due file."
    echo "Uso: $0 <file1> <file2>"
    exit 1
fi

FILE_A="$1"
FILE_B="$2"

if [ ! -f "$FILE_A" ] || [ ! -f "$FILE_B" ]; then
    echo "Errore: Uno o entrambi i file non esistono."
    exit 1
fi

RIGHE_A=$(wc -l < "$FILE_A")
RIGHE_B=$(wc -l < "$FILE_B")

# Pulisco eventuali spazi vuoti (wc su Mac a volte lascia spazi prima del numero)
RIGHE_A=$(echo $RIGHE_A)
RIGHE_B=$(echo $RIGHE_B)

if [ "$RIGHE_A" -eq "$RIGHE_B" ]; then
    echo "I file hanno lo stesso numero di righe: $RIGHE_A"
else
    if [ "$RIGHE_A" -gt "$RIGHE_B" ]; then
        DIFF=$((RIGHE_A - RIGHE_B))
    else
        DIFF=$((RIGHE_B - RIGHE_A))
    fi

    echo "I file hanno un numero di righe diverso."
    echo "Differenza: $DIFF"
    echo "File 1 ($FILE_A): $RIGHE_A righe"
    echo "File 2 ($FILE_B): $RIGHE_B righe"
fi