#!/bin/bash

# TEMPLATE PER INPUT INTERATTIVO
# Obiettivo: Chiedere password e poi loop di input

echo "--- BENVENUTO NEL SISTEMA SEGRETO ---"

# 1. Input Password Nascosto (-s)
# Loop finché la password è giusta
while true; do
    read -s -p "Inserisci Parola Chiave: " PASSWORD
    echo "" # Newline dopo input nascosto
    
    if [ "$PASSWORD" == "segreto" ]; then
        echo "Accesso Consentito."
        break
    else
        echo "Password Errata. Riprova."
        # exit 1 # Se vuoi uscire subito
    fi
done

# 2. Loop di Inserimento Dati
OUTPUT_FILE="segreto.txt"
echo "Inserisci righe di testo (scrivi 'fine' per uscire):"

while true; do
    read -p "> " LINEA
    
    if [ "$LINEA" == "fine" ]; then
        echo "Salvataggio e chiusura."
        break
    fi
    
    # Appendi al file
    echo "$LINEA" >> "$OUTPUT_FILE"
done

# 3. Protezione File finale (chmod 600 - solo proprietario rw)
chmod 600 "$OUTPUT_FILE"
echo "File salvato in $OUTPUT_FILE con permessi sicuri."