#!/bin/bash

# TRACCIA:
# Scrivere uno script analizza_dir.sh che:
# - Prenda come argomento una directory.
# - Per ogni file regolare al suo interno (solo livello corrente, no sub-dir):
#   - Stampi nome, numero righe (solo se testo leggibile), dimensione byte.
# - Alla fine stampi il numero totale di file analizzati.

DIR="$1"

if [ -z "$DIR" ] || [ ! -d "$DIR" ]; then
    echo "Errore: Specificare una directory valida."
    exit 1
fi

echo "Analisi directory: $DIR"
echo ""
printf "%-30s | %-10s | %-10s\n" "Nome File" "Dim (Byte)" "Righe"
echo "---------------------------------------------------"

COUNT_FILES=0

# 2. Iterazione (Globbing *)
# "$DIR"/* espande tutti i file dentro la cartella senza scendere nelle sottocartelle
for FILE_PATH in "$DIR"/*; do
    
    # Controllo che sia un file regolare (escludo directory o link rotti)
    if [ -f "$FILE_PATH" ]; then
        ((COUNT_FILES++))
        
        # Estraggo solo il nome del file (senza percorso)
        NOME=$(basename "$FILE_PATH")
        
        # Calcolo dimensione in byte
        # wc -c conta i byte. < evita di stampare il nome file
        DIM=$(wc -c < "$FILE_PATH")
        # Pulisco spazi
        DIM=$(echo $DIM)
        
        # Controllo se è un file di testo leggibile
        # Il comando 'file' analizza il tipo. Cerchiamo la parola "text".
        IS_TEXT=$(file "$FILE_PATH" | grep -i "text")
        
        RIGHE="N/A" # Default se non è testo
        
        if [ -n "$IS_TEXT" ]; then
            # Se è testo, conto le righe
            RIGHE=$(wc -l < "$FILE_PATH")
            RIGHE=$(echo $RIGHE) # Trim spazi
        fi
        
        # Stampa formattata
        printf "%-30s | %-10s | %-10s\n" "$NOME" "$DIM" "$RIGHE"
    fi
done

echo "---------------------------------------------------"
echo "Totale file analizzati: $COUNT_FILES"