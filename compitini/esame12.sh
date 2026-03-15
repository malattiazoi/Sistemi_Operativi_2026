#!/bin/bash
# Script esame12.txt

# Scrivere uno script bash di nome "script1" che a partire da una
# directory (data come primo parametro) trovi tra tutte le sue
# sottodirectory di qualunque livello quella che contiene il maggior
# numero di elementi (contando solo i  file regolari). Sia A tale
# directory. Nell'ambito dello stesso script creare in essa una directory
# avente come nome una stringa data come secondo parametro e spostare in
# essa tutti i file che sono entries della directory A e che contenengono
# nel loro nome o al loro interno tale stringa.

if [ $# -ne 2 ]; then
    echo "inserisci: $0 <directory> <stringa>"
    exit 1
fi
DIR=$1
STRINGA=$2

if [ ! -d "$DIR" ]; then
    echo "Errore: $DIR non è una directory"
    exit 2
fi

MAX_COUNT=0
TARGET_DIR=""

while IFS= read -r -d '' SUBDIR; do
    COUNT=$(find "$SUBDIR" -maxdepth 1 -type f | wc -l)
    if [ "$COUNT" -gt "$MAX_COUNT" ]; then
        MAX_COUNT=$COUNT
        TARGET_DIR="$SUBDIR"
    fi
done < <(find "$DIR" -type d -print0)

if [ -z "$TARGET_DIR" ]; then
    echo "Nessuna sottodirectory trovata."
    exit 3
fi

NEW_DIR="$TARGET_DIR/$STRINGA"
mkdir -p "$NEW_DIR"

while IFS= read -r -d '' FILE; do
    if [[ "$FILE" == *"$STRINGA"* ]] || grep -q "$STRINGA" "$FILE"; then
        mv "$FILE" "$NEW_DIR/"
    fi
done < <(find "$TARGET_DIR" -maxdepth 1 -type f -print0)