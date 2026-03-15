#!/bin/bash

# ------------------------------------------------------------------------------
# TRACCIA:
# Scrivere uno script hash_dir.sh <DIR> che produca un hash del contenuto.
# Il calcolo deve cambiare se cambia anche uno solo di:
# a) nome (con percorso)
# b) dimensione
# c) permessi
# d) istante ultima modifica
# ------------------------------------------------------------------------------

TARGET_DIR="$1"

# 1. Controllo
if [ ! -d "$TARGET_DIR" ]; then
    echo "Errore: Directory non valida."
    exit 1
fi

# 2. Selezione comando MD5 (Compatibilità Mac/Linux)
if command -v md5sum >/dev/null 2>&1; then
    HASH_CMD="md5sum" # Linux standard
else
    HASH_CMD="md5"    # Mac standard
fi

# 3. Generazione Hash
# Spiegazione logica:
# 'ls -lR' elenca ricorsivamente tutti i file mostrando:
# Permessi, Utente, Dimensione, Data, Nome.
# Soddisfa esattamente tutti i requisiti (a,b,c,d) della traccia.
# Se cambia un bit di queste info, l'output di ls cambia, e quindi l'hash cambia.

SNAPSHOT=$(ls -lR "$TARGET_DIR")

# Calcolo l'hash della stringa prodotta da ls -lR
DIR_HASH=$(echo "$SNAPSHOT" | $HASH_CMD | awk '{print $1}')
# awk '{print $1}' serve perché md5sum stampa "HASH  -" e noi vogliamo solo l'hash.

echo "Hash dello stato della directory:"
echo "$DIR_HASH"