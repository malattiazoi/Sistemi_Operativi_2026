#!/bin/bash

# TRACCIA:
# Scrivere uno script pdf_by_header.sh <DIR> che conti quanti file nella directory
# <DIR>, a qualsiasi livello di annidamento, iniziano con la sequenza di byte
# tipica dei file PDF (Hex: "255044462d").

SEARCH_DIR="$1"
MAGIC_HEX="255044462d"

# 1. Controllo Argomenti
if [ ! -d "$SEARCH_DIR" ]; then
    echo "Errore: Directory '$SEARCH_DIR' non trovata."
    exit 1
fi

echo "Ricerca file PDF (header magic) in $SEARCH_DIR..."

PDF_COUNT=0

# 2. Ricerca Ricorsiva
# Uso find per trovare tutti i file (-type f)
# Pipe (|) verso un ciclo while che legge percorso per percorso
while IFS= read -r FILE; do
    
    # Leggo i primi 5 byte del file
    # head -c 5: prende i primi 5 caratteri
    # xxd -p: li converte in esadecimale puro (senza formattazione)
    # 2>/dev/null: nasconde errori se il file è illeggibile
    FILE_HEADER=$(head -c 5 "$FILE" 2>/dev/null | xxd -p)
    
    # Verifica corrispondenza
    if [ "$FILE_HEADER" == "$MAGIC_HEX" ]; then
        # echo "Trovato: $FILE" # Decommenta per vedere i file
        ((PDF_COUNT++))
    fi

done < <(find "$SEARCH_DIR" -type f)
# Nota: < <(...) è Process Substitution, serve per evitare che il while giri
# in una subshell e perda il valore di PDF_COUNT alla fine.

echo "Totale file PDF trovati: $PDF_COUNT"

