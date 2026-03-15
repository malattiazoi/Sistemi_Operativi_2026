#!/bin/bash

# ------------------------------------------------------------------------------
# [cite_start]TRACCIA[cite: 86, 87, 88, 89, 90]:
# Script interattivo per generalità.
# a) Richiede password "sesamo" (invisibile) per ogni inserimento.
# b) Non interrompibile (no CTRL+C).
# c) Scrive su file leggibile solo al proprietario.
# d) Termina se password è "omases" (invisibile).
# e) Non deve svelare le password a chi legge il codice sorgente.
# ------------------------------------------------------------------------------

OUTPUT_FILE="generalita_segrete.txt"

# 1. Configurazione Permessi File (Punto c)
touch "$OUTPUT_FILE"
chmod 600 "$OUTPUT_FILE"

# 2. Disabilita interruzione (Punto b)
# SIGINT = CTRL+C, SIGTSTP = CTRL+Z
trap '' SIGINT SIGTSTP

# 3. Hashing delle password (Punto e - Sicurezza)
# Non scriviamo "sesamo" in chiaro nel codice per confronto diretto, usiamo i loro Hash MD5.
# Hash calcolati preventivamente (echo -n "sesamo" | md5sum)
HASH_SESAMO="1844156d4166d94387f1a4ad031ca5fa"
HASH_OMASES="34305dca77eb2d0a0bd67a7b8df48bf5"

# Funzione per calcolare hash compatibile Mac/Linux
get_input_hash() {
    local INPUT="$1"
    if command -v md5sum >/dev/null 2>&1; then
        echo -n "$INPUT" | md5sum | awk '{print $1}'
    else
        md5 -q -s "$INPUT"
    fi
}

echo "Avvio sistema di raccolta dati."

while true; do
    # 4. Richiesta Password (Punto a)
    # -s nasconde l'input
    echo ""
    read -s -p "Inserisci password per procedere: " PASS_INPUT
    echo ""

    # Calcolo hash dell'input
    CURRENT_HASH=$(get_input_hash "$PASS_INPUT")

    # 5. Verifica "omases" per uscita (Punto d)
    if [ "$CURRENT_HASH" == "$HASH_OMASES" ]; then
        echo "Procedura di terminazione attivata. Arrivederci."
        break
    fi

    # 6. Verifica "sesamo" per inserimento
    if [ "$CURRENT_HASH" == "$HASH_SESAMO" ]; then
        echo "Accesso consentito."
        read -p "Inserisci Nome e Cognome: " DATI
        
        # Scrittura su file
        echo "$DATI" >> "$OUTPUT_FILE"
        echo "Dati salvati in sicurezza."
    else
        echo "Password errata."
    fi
done