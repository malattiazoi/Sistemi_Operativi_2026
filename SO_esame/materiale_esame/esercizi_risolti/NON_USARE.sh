#!/bin/bash

# ------------------------------------------------------------------------------
# TRACCIA:
# Creare uno script "elimina", che elimini dal sistema i file regolari passati 
# come argomento e tutti i link (hard e soft) a tali file.
# ------------------------------------------------------------------------------


exit 0

# 1. Controllo Argomenti (Loop su tutti i file passati)
if [ $# -eq 0 ]; then
    echo "Uso: $0 file1 [file2 ...]"
    exit 1
fi

# Itero su ogni file passato come argomento
for FILE in "$@"; do
    
    if [ ! -e "$FILE" ]; then
        echo "[SKIP] Il file '$FILE' non esiste."
        continue
    fi

    echo "--- Elaborazione: $FILE ---"

    # 2. Identificazione Inode (Per Hard Links)
    # ls -i stampa "inode nomefile". awk '{print $1}' prende l'inode.
    INODE=$(ls -i "$FILE" | awk '{print $1}')
    
    # [cite_start]3. Eliminazione Hard Links (e file originale) [cite: 74]
    # Gli hard link condividono lo stesso Inode.
    # Cerchiamo nella home dell'utente ($HOME) per sicurezza, invece che in tutto / (root)
    # che sarebbe lento e pericoloso.
    echo "Ricerca ed eliminazione Hard Links (Inode $INODE)..."
    
    # find cerca file con quell'inode e li elimina (-delete)
    # 2>/dev/null nasconde errori di permesso
    find "$HOME" -inum "$INODE" -type f -delete 2>/dev/null
    
    echo "Hard links (incluso originale) eliminati."

    # [cite_start]4. Eliminazione Soft Links (Simbolici) [cite: 74]
    # I soft link puntano al "nome" o "percorso".
    # Cerchiamo link simbolici (-type l) il cui target (-lname) corrisponde al file.
    # Nota: Questo trova link che puntano esattamente al nome del file.
    echo "Ricerca ed eliminazione Soft Links..."
    
    # Cerco link che contengono il nome del file nel loro target
    BASENAME=$(basename "$FILE")
    find "$HOME" -type l -lname "*$BASENAME*" -delete 2>/dev/null
    
    echo "Soft links eliminati."
    echo "Pulizia completata per $FILE."

done