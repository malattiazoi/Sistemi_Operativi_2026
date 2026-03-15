#!/bin/bash

# ------------------------------------------------------------------------------
# TRACCIA:
# Scrivere uno script bash di nome "pscmd" che prenda come argomento il nome
# di un comando e che restituisca la somma delle percentuali di CPU 
# utilizzate da tutte le istanze di tale comando in esecuzione 
# nel sistema da parte di qualsiasi utente al momento del lancio dello script.
# ------------------------------------------------------------------------------

CMD_NAME="$1"

# 1. Controllo Argomenti
if [ -z "$CMD_NAME" ]; then
    echo "Errore: Inserire il nome del comando da analizzare."
    echo "Uso: $0 <nome_comando>"
    exit 1
fi

# 2. Estrazione dati processi
# 'ps -e' seleziona tutti i processi di tutti gli utenti.
# '-o pcpu,comm' formatta l'output mostrando solo: %CPU e NOME COMANDO.
# --no-headers toglie l'intestazione (PID, %CPU...) per facilitare il calcolo.
DATI=$(ps -e -o pcpu,comm --no-headers)

# 3. Filtraggio e Somma (tutto in una pipe)
# grep: cerca le righe che contengono il nome del comando.
# awk: somma la prima colonna (CPU) per ogni riga trovata.
SOMMA_CPU=$(echo "$DATI" | grep "$CMD_NAME" | awk '{sum+=$1} END {print sum+0}')
# Nota: "sum+0" nel print finale serve a stampare 0 invece di stringa vuota 
# se grep non trova nulla.

echo "Somma CPU per '$CMD_NAME': $SOMMA_CPU%"