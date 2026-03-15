#!/bin/bash

# ------------------------------------------------------------------------------
# TRACCIA:
# Scrivere uno script bash che accetta come argomento il nome di una directory e
# stampi a terminale il numero di inode più alto presente nella directory e 
# in tutte le sue sottodirectory.
# ------------------------------------------------------------------------------

TARGET_DIR="$1"

# 1. Controllo Directory
if [ ! -d "$TARGET_DIR" ]; then
    echo "Errore: Directory '$TARGET_DIR' non valida."
    exit 1
fi

echo "Ricerca Inode più alto in: $TARGET_DIR..."

# 2. Ricerca e Ordinamento
# find "$TARGET_DIR": cerca ricorsivamente.
# -printf "%i\n": istruzione specifica di find per stampare SOLO il numero inode (%i) e a capo.
# sort -n: ordina numericament (dal più piccolo al più grande).
# tail -n 1: prende l'ultimo della lista (il più grande).

MAX_INODE=$(find "$TARGET_DIR" -printf "%i\n" 2>/dev/null | sort -n | tail -n 1)

# Nota compatibilità Mac: Se su Mac 'find' non supporta -printf, si usa:
# find "$TARGET_DIR" -ls | awk '{print $1}' | sort -n | tail -n 1

echo "Inode più alto trovato: $MAX_INODE"