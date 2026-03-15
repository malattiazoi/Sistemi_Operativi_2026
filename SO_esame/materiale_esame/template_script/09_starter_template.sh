#!/bin/bash

# ==============================================================================
# NOME SCRIPT: NOME_ESAME.sh
# AUTORE: Mario Rossi (Matricola: 123456)
# DATA: $(date +%Y-%m-%d)
# DESCRIZIONE: Soluzione Esame X.
# ==============================================================================

# 1. CONFIGURAZIONE E SICUREZZA
set -e          # Esci se un comando fallisce (Safety)
set -u          # Errore se usi variabili non definite
set -o pipefail # Errore se una pipe fallisce a metà

# 2. VARIABILI GLOBALI
SCRIPT_NAME=$(basename "$0")
TEMP_FILE=""

# 3. FUNZIONE DI PULIZIA (TRAP)
# Eseguita SEMPRE all'uscita dello script (successo o errore)
cleanup() {
    # Rimuovi file temporanei se esistono
    if [ -n "$TEMP_FILE" ] && [ -f "$TEMP_FILE" ]; then
        rm -f "$TEMP_FILE"
    fi
}
trap cleanup EXIT

# 4. FUNZIONE HELP / USAGE
usage() {
    echo "Utilizzo: ./$SCRIPT_NAME [ARGOMENTO]"
    echo "Esempio: ./$SCRIPT_NAME file.txt"
    exit 1
}

# 5. CONTROLLO ARGOMENTI
if [ $# -lt 1 ]; then
    usage
fi

ARG_1="$1"

# ==============================================================================
# 6. LOGICA PRINCIPALE (MAIN)
# ==============================================================================

echo "[START] Avvio elaborazione di $ARG_1..."

# --- INCOLLA QUI LE TUE FUNZIONI UTILS SE SERVONO ---

# Esempio logica
if [ -f "$ARG_1" ]; then
    echo "Il file esiste. Procedo..."
    # ... codice esame ...
else
    echo "Errore: File non trovato."
    exit 1
fi

echo "[END] Completato."