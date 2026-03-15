#!/bin/bash

# ------------------------------------------------------------------------------
# TRACCIA:
# Scrivere uno script che accetta come argomento il nome di una directory e
# calcola una stringa che è indice dell'integrità della directory.
# Se rieseguendo lo script il risultato non cambia, la struttura/contenuti 
# non sono cambiati.
# ------------------------------------------------------------------------------

TARGET_DIR="$1"

if [ ! -d "$TARGET_DIR" ]; then
    echo "Errore: Directory non valida."
    exit 1
fi

# 1. Selezione comando MD5 (Compatibilità)
if command -v md5sum >/dev/null 2>&1; then
    HASHER="md5sum"
else
    HASHER="md5"
fi

# 2. Calcolo Integrità
# ls -lR mostra: permessi, proprietari, dimensioni, date, nomi di TUTTO l'albero.
# Se cambia anche un solo bit nel contenuto di un file, cambia la dimensione o la data.
# Se cambia un nome, cambia l'output di ls.
# Hashiamo tutto questo output in un'unica stringa.

INTEGRITY_HASH=$(ls -lR "$TARGET_DIR" | $HASHER | awk '{print $1}')

echo "Indice di Integrità (Hash):"
echo "$INTEGRITY_HASH"