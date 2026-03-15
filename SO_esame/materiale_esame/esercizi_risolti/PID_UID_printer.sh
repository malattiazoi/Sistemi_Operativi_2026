#!/bin/bash

# Scrivere uno script bash di sinossi:
# chi_usa_file.sh <FILE> 
# verifichi se <FILE> esiste e che, in caso affermativo mostri PID, utente
# e comando dei processi che stanno usando quel file.
# Se nessun processo usa il file lo script scriva al terminale "LIBERO".

FILE="$1"

# 1. Controllo Argomenti
if [ -z "$FILE" ]; then
    echo "Uso: $0 <file>"
    exit 1
fi

# 2. Controllo Esistenza
if [ ! -e "$FILE" ]; then
    echo "Errore: Il file '$FILE' non esiste."
    exit 1
fi

# 3. Controllo Processi (lsof)
# Salviamo l'output in una variabile per non stampare subito
# 2>/dev/null nasconde eventuali errori di permessi
OUTPUT=$(lsof "$FILE" 2>/dev/null)

if [ -n "$OUTPUT" ]; then
    # Se la variabile NON è vuota, qualcuno sta usando il file.
    # Stampiamo un'intestazione personalizzata e poi i dati.
    echo "Il file è in uso da:"
    echo "PID     UTENTE   COMANDO"
    echo "------------------------"
    
    # Uso awk per estrarre solo PID ($2), USER ($3) e COMMAND ($1) dall'output di lsof
    # NR>1 salta l'intestazione originale di lsof
    echo "$OUTPUT" | awk 'NR>1 {print $2, $3, $1}' | column -t
else
    # Se la variabile è vuota
    echo "LIBERO"
fi