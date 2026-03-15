#!/bin/bash

# ------------------------------------------------------------------------------
# TRACCIA:
# Scrivere uno script bash che visiti periodicamente una certa pagina html via 
# http e stampi a terminale un messaggio quando trova una certa stringa nella 
# pagina. Intervallo, indirizzo e stringa passati come parametri.
# ------------------------------------------------------------------------------

# 1. Controllo Argomenti
if [ $# -lt 3 ]; then
    echo "Uso: $0 <intervallo_sec> <url> <stringa>"
    exit 1
fi

INTERVAL="$1"
URL="$2"
SEARCH_STR="$3"

echo "Monitoraggio di '$URL' ogni $INTERVAL secondi."
echo "In attesa della stringa: '$SEARCH_STR'..."

# 2. Loop Infinito
while true; do
    # Scarico la pagina
    # curl -s: silent mode (non mostra la barra progresso)
    # -L: segue eventuali redirect
    CONTENT=$(curl -s -L "$URL")
    
    # Cerco la stringa nel contenuto scaricato
    # grep -q: quiet mode (esce con 0 se trova, 1 se non trova, senza stampare nulla)
    if echo "$CONTENT" | grep -q "$SEARCH_STR"; then
        echo "------------------------------------------------"
        echo "[TROVATO!] La stringa '$SEARCH_STR' è apparsa!"
        echo "Timestamp: $(date)"
        echo "------------------------------------------------"
        # Decommenta 'break' se vuoi che lo script termini quando trova la stringa
        # break 
    fi
    
    # Attesa
    sleep "$INTERVAL"
done
