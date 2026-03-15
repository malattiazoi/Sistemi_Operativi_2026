#!/bin/bash

# 1. Definizione della funzione di risposta
stampa_valore() {
    echo " [A] Ricevuto segnale! Il contatore è: $COUNT"
}

# 2. TRAPPOLE (Il cuore dell'esame)
# Quando ricevi SIGUSR1, esegui 'stampa_valore'
trap stampa_valore SIGUSR1

echo "Script A avviato. Il mio PID è: $$"
COUNT=0

# 3. Loop infinito (simulazione lavoro)
while true; do
    ((COUNT++))
    # Sleep riduce il carico CPU, importante nei loop infiniti
    sleep 1
done