#!/bin/bash

# Traccia: Scrivere uno script che prenda in input un nome di file.

# Verificare che l'utente abbia passato un argomento.

# Verificare che il file esista.

# Creare una copia di backup sicura (usando la funzione backup_file).

# Stampare a video il contenuto del file convertito tutto in MAIUSCOLO 
# (usando la funzione to_upper compatibile con Mac).

# Stampare un messaggio di successo colorato finale.


check_args() {
    local NUM_ARGS_CURRENT="$1"
    local NUM_ARGS_NEEDED="$2"
    local USAGE_MSG="$3"

    if [ "$NUM_ARGS_CURRENT" -lt "$NUM_ARGS_NEEDED" ]; then
        echo "[ERRORE] Argomenti insufficienti." >&2
        echo "Richiesti: $NUM_ARGS_NEEDED, Forniti: $NUM_ARGS_CURRENT" >&2
        echo "$USAGE_MSG" >&2
        exit 1
    fi
}

backup_file() {
    local FILE="$1"
    local BAK="${FILE}.bak"
    
    if [ -f "$FILE" ]; then
        cp "$FILE" "$BAK"
        echo "[BACKUP] Creato $BAK"
    else
        echo "[WARN] File $FILE non trovato, niente backup."
    fi
}

to_upper() {
    echo "$1" | tr '[:lower:]' '[:upper:]'
}

log_success() {
    local MSG="$1"
    printf "${GREEN}[OK]${RESET}   %s\n" "$MSG"
}

check_args $# 1 "inserire il nome del file da analizzare"

NAME_FILE="$1"



if [ -f "$NAME_FILE" ]; then
    backup_file "$NAME_FILE"
    echo "---contenuto convertito---"
    while IFS= read -r RIGA || [ -n "$RIGA" ]; do
        to_upper "$RIGA"
    done <"$NAME_FILE"
    #potevo anche non usare il file e fare:
    #cat "$NAME_FILE" | to_upper
    log_success "Modifica effettuata"
else
    echo "file non esistente o non trovato"
    exit 1
fi


