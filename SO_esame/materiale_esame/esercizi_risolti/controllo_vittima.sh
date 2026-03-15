#!/bin/bash

# Uno script A svolge delle operazioni (es.incrementa un contatore).
# Costruire uno script B che costringa ad intervalli regolari 
# lo script A a stampare allo standard output il risultato dell'operazione.
# Lo script A può essere modificato per ottenere lo scopo prefisso.
# Non è permesso usare file temporanei per lo svolgimento dell'esercizio.
# I due script devono essere lanciati indipendentemente.

# Prendo il PID di A come argomento
PID_A="$1"

if [ -z "$PID_A" ]; then
    echo "Errore: Devi dirmi il PID di Script A."
    echo "Uso: $0 <PID>"
    exit 1
fi

echo "Script B avviato. Controllero' il processo $PID_A ogni 5 secondi."

while true; do
    sleep 5
    
    # Controllo se A è ancora vivo
    if ! kill -0 "$PID_A" 2>/dev/null; then
        echo "Script A è terminato. Esco."
        break
    fi
    
    echo " [B] Invio segnale SIGUSR1 a $PID_A..."
    # kill invia il segnale
    kill -SIGUSR1 "$PID_A"
done

#con funzioni 

#!/bin/bash

# ==============================================================================
# FUNZIONI
# ==============================================================================

get_pid_by_name() {
    # Cerca il PID di un processo dal nome, escludendo se stesso e grep
    # pgrep -f cerca nella riga di comando completa
    pgrep -f "$1" | head -n 1
}

send_signal() {
    local PID="$1"
    # kill -0 controlla esistenza
    if kill -0 "$PID" 2>/dev/null; then
        kill -SIGUSR1 "$PID"
        echo "[B] Segnale inviato a PID $PID"
        return 0
    else
        echo "[B] Errore: Processo $PID non trovato."
        return 1
    fi
}

# ==============================================================================
# MAIN
# ==============================================================================

TARGET_NAME="script_A.sh"
echo "Cerco il processo '$TARGET_NAME'..."

TARGET_PID=$(get_pid_by_name "$TARGET_NAME")

if [ -z "$TARGET_PID" ]; then
    echo "Processo non trovato automaticamente."
    read -p "Inserisci manualmente il PID di Script A: " TARGET_PID
fi

if [ -z "$TARGET_PID" ]; then
    echo "Nessun PID fornito. Esco."
    exit 1
fi

echo "Monitoraggio PID $TARGET_PID attivo. Invio richiesta ogni 3 secondi."

while true; do
    sleep 3
    send_signal "$TARGET_PID" || break
done