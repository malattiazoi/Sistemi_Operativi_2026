#!/bin/bash

# ==============================================================================
# UTILS: CONTROLLI PRELIMINARI (CHECKS)
# ==============================================================================
# OBIETTIVO:
# Verificare che l'ambiente sia pronto prima di eseguire la logica pesante.
# Controllare permessi di Root, numero di argomenti e presenza di programmi.
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. CONTROLLO UTENTE ROOT
# ------------------------------------------------------------------------------
# Molti esami chiedono di installare cose o modificare file di sistema.
# Questa funzione assicura che lo script sia lanciato con 'sudo'.

check_root() {
    # id -u ritorna l'ID utente. 0 è sempre root.
    if [ "$(id -u)" -ne 0 ]; then
        echo "[ERRORE] Questo script deve essere eseguito come root (usa sudo)." >&2
        exit 1
    fi
    echo "[CHECK] Permessi di root confermati."
}

# ------------------------------------------------------------------------------
# 2. CONTROLLO NUMERO ARGOMENTI
# ------------------------------------------------------------------------------
# Uso: check_args $# 2 "Uso: script.sh <file1> <file2>"
# $1 = Numero argomenti passati ($#)
# $2 = Numero argomenti richiesti
# $3 = Messaggio di utilizzo (Usage message)

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

# ------------------------------------------------------------------------------
# 3. CONTROLLO DIPENDENZE SOFTWARE
# ------------------------------------------------------------------------------
# Verifica se un comando è installato nel sistema.
# Uso: check_cmd "nmap" || exit 1

check_cmd() {
    local CMD="$1"
    # command -v è il modo standard POSIX per verificare l'esistenza di un programma
    if ! command -v "$CMD" > /dev/null 2>&1; then
        echo "[ERRORE] Il comando '$CMD' non è installato o non è nel PATH." >&2
        return 1 # Ritorna errore (false)
    fi
    return 0 # Ritorna successo (true)
}

# ------------------------------------------------------------------------------
# 4. CONTROLLO FILE E DIRECTORY
# ------------------------------------------------------------------------------
# Verifica che un input sia un file valido e leggibile.

check_file_readable() {
    local FILE="$1"
    if [ ! -f "$FILE" ]; then
        echo "[ERRORE] '$FILE' non esiste o non è un file regolare." >&2
        exit 1
    fi
    if [ ! -r "$FILE" ]; then
        echo "[ERRORE] '$FILE' esiste ma NON ho i permessi di lettura." >&2
        exit 1
    fi
}

# Funzione per calcolare hash (Compatibile Mac/Linux)
get_md5() {
    if command -v md5sum >/dev/null 2>&1; then
        # Linux
        echo -n "$1" | md5sum | awk '{print $1}'
    else
        # Mac
        md5 -q -s "$1"
    fi
}

# 1. Rilevamento OS e Funzione Tempo
# Su Linux 'date +%s%3N' dà millisecondi. Su Mac 'date +%s' dà secondi (coreutils non garantite).
OS_TYPE=$(uname)

get_current_time() {
    if [ "$OS_TYPE" == "Linux" ]; then
        # Millisecondi
        date +%s%3N
    else
        # Secondi (Mac)
        date +%s
    fi
}
