#!/bin/bash

# ==============================================================================
# UTILS: FINDER & SEARCH
# ==============================================================================
# OBIETTIVO:
# Semplificare la ricerca di file per nome, contenuto o data.
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. CERCA PER CONTENUTO (GREP RICORSIVO)
# ------------------------------------------------------------------------------
# Cerca una stringa dentro tutti i file di una cartella.
# Uso: find_by_content "/var/log" "ERROR"

find_by_content() {
    local DIR="$1"
    local QUERY="$2"
    
    # -r = Ricorsivo
    # -n = Mostra numero riga
    # -I = Ignora file binari (Fondamentale per non stampare spazzatura)
    grep -rnI "$QUERY" "$DIR"
}

# ------------------------------------------------------------------------------
# 2. CERCA FILE RECENTI (FIND MTIME)
# ------------------------------------------------------------------------------
# Trova file modificati negli ultimi N minuti.
# Uso: find_recent "." 10 (ultimi 10 minuti)

find_recent() {
    local DIR="$1"
    local MINS="$2"
    
    # -mmin -N = Modificato meno di N minuti fa
    # -type f  = Solo file
    find "$DIR" -type f -mmin "-$MINS"
}

# ------------------------------------------------------------------------------
# 3. CERCA FILE GRANDI (FIND SIZE)
# ------------------------------------------------------------------------------
# Uso: find_big "." "100M"

find_big() {
    local DIR="$1"
    local SIZE="$2" # es. 100k, 10M, 1G
    
    # +SIZE = Più grande di SIZE
    find "$DIR" -type f -size "+$SIZE" -exec ls -lh {} \;
}

# ==============================================================================
# FUNZIONE: find_max_dir
# UTILIZZO: BEST_DIR=$(find_max_dir "/percorso/inizio")
# INPUT:    $1 = Directory radice da cui iniziare la ricerca.
# OUTPUT:   Stampa il percorso assoluto della sottocartella che contiene
#           il maggior numero di file regolari (esclusi link/dir).
# ==============================================================================
find_max_dir() {
    local ROOT="$1"
    local MAX_N=0
    local BEST_DIR=""
    
    # IFS a capo per gestire nomi con spazi nell'output di find
    local OLD_IFS="$IFS"
    IFS=$'\n'
    
    for DIR in $(find "$ROOT" -type d); do
        # Conto i file regolari nella directory corrente
        local N=$(find "$DIR" -maxdepth 1 -type f | wc -l | tr -d ' ')
        
        if [ "$N" -gt "$MAX_N" ]; then
            MAX_N="$N"
            BEST_DIR="$DIR"
        fi
    done
    
    IFS="$OLD_IFS"
    echo "$BEST_DIR"
}