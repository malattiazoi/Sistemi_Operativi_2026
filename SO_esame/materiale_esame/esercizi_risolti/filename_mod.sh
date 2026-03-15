#!/bin/bash

# ------------------------------------------------------------------------------
# [cite_start]TRACCIA[cite: 103]:
# Cercare tutti i file il cui nome contiene caratteri diversi da lettere o cifre.
# Per ciascuno, proporre all'utente la sostituzione di tali caratteri.
# ------------------------------------------------------------------------------

echo "Ricerca file con nomi non alfanumerici..."

# 1. Ricerca File
# find . : cerca nella cartella corrente
# -maxdepth 1 : (opzionale) limitiamo alla cartella corrente per sicurezza, o toglilo per ricorsiva.
# -name "*[^a-zA-Z0-9]*" : Regex che cerca file che contengono ALMENO un carattere
#                          che NON (^) è lettera o numero.
find . -maxdepth 1 -type f -name "*[^a-zA-Z0-9]*" | while read FILE; do
    
    # Rimuovo il ./ iniziale per pulizia
    FILENAME=$(basename "$FILE")
    
    echo "-------------------------------------------------"
    echo "Trovato file sospetto: $FILENAME"
    
    # 2. Identificazione caratteri "cattivi"
    # sed rimuove tutto ciò che è alfanumerico, lasciando solo i simboli
    BAD_CHARS=$(echo "$FILENAME" | sed 's/[a-zA-Z0-9]//g' | sort -u)
    
    echo "Caratteri non standard trovati: $BAD_CHARS"
    
    # 3. Richiesta Sostituzione
    read -p "Con quale carattere vuoi sostituirli? (Premi Invio per saltare): " REPL
    
    if [ -n "$REPL" ]; then
        # 4. Costruzione Nuovo Nome
        # Sostituisco tutti i caratteri non alfanumerici con la scelta dell'utente
        NEW_NAME=$(echo "$FILENAME" | sed "s/[^a-zA-Z0-9]/$REPL/g")
        
        echo "Rinomino: '$FILENAME' -> '$NEW_NAME'"
        
        # Esecuzione (mv -n non sovrascrive se esiste già)
        mv -n "$FILE" "$NEW_NAME"
    else
        echo "Skippato."
    fi
done