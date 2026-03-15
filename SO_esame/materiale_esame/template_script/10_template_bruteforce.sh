#!/bin/bash

# TEMPLATE PER ESAME BRUTE FORCE MD5
# Obiettivo: Trovare una stringa il cui MD5 inizia con un TARGET

TARGET_PREFIX="$1" # Es. "8b" passato come argomento

if [ -z "$TARGET_PREFIX" ]; then
    echo "Uso: ./bruteforce.sh XX (Prime cifre hex)"
    exit 1
fi

echo "Cerco hash che inizia con: $TARGET_PREFIX"

# Loop infinito controllato
COUNT=0
while true; do
    # 1. Genera Candidato (Numero progressivo o Random)
    CANDIDATE="$COUNT"
    
    # 2. Calcola Hash (md5 -q su Mac)
    HASH=$(md5 -q -s "$CANDIDATE")
    
    # 3. Confronta Prefisso
    # ${VAR:OFFSET:LENGTH} prende sottostringa
    CURRENT_PREFIX="${HASH:0:${#TARGET_PREFIX}}"
    
    if [ "$CURRENT_PREFIX" == "$TARGET_PREFIX" ]; then
        echo "--- TROVATO ---"
        echo "Stringa: $CANDIDATE"
        echo "Hash:    $HASH"
        break
    fi
    
    ((COUNT++))
    
    # Feedback visivo ogni tanto (per non sembrare bloccato)
    if (( COUNT % 10000 == 0 )); then
        echo "Testati $COUNT candidati..."
    fi
done