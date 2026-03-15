#!/bin/bash

# ------------------------------------------------------------------------------
# [cite_start]TRACCIA[cite: 80, 81]:
# Creare uno script bash, chiamato "cifra", che applichi ad uno o più file di testo 
# passati come argomento la cifratura consistente nel trasformare:
# 1) le lettere dalla A alla M in lettere dalla N alla Z e viceversa;
# 2) le lettere dalla a alla m in lettere dalla n alla z e viceversa.
# ------------------------------------------------------------------------------

# 1. Controllo Argomenti
if [ $# -eq 0 ]; then
    echo "Uso: $0 <file1> [file2 ...]"
    exit 1
fi

# 2. Iterazione sui file
for FILE in "$@"; do
    if [ -f "$FILE" ]; then
        echo "--- Cifratura di: $FILE ---"
        
        # 3. Trasformazione (ROT13)
        # tr accetta due set: input -> output
        # 'A-Za-z' prende tutte le lettere.
        # 'N-ZA-Mn-za-m' è la mappatura:
        # A diventa N, B diventa O ... M diventa Z, N diventa A.
        cat "$FILE" | tr 'A-Za-z' 'N-ZA-Mn-za-m'
        
        echo -e "\n----------------------------"
    else
        echo "Attenzione: '$FILE' non è un file valido."
    fi
done
