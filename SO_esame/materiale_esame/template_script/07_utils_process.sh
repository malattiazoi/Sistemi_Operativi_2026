#!/bin/bash

# ==============================================================================
# UTILS: GESTIONE PROCESSI E PID
# ==============================================================================
# OBIETTIVO:
# Trovare processi, verificare se girano e ucciderli in modo sicuro.
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. OTTENERE PID (PGREP)
# ------------------------------------------------------------------------------
# Trova il PID di un processo dal nome.
# Uso: PID=$(get_pid "firefox")

get_pid() {
    local NAME="$1"
    # pgrep ritorna i PID. -x match esatto (opzionale).
    pgrep "$NAME" | head -n 1
}

# ------------------------------------------------------------------------------
# 2. VERIFICA SE IN ESECUZIONE
# ------------------------------------------------------------------------------
# Controlla se un PID esiste ed è vivo.
# Uso: if is_running 1234; then ...

is_running() {
    local PID="$1"
    # kill -0 non uccide, controlla solo se si può inviare segnali (quindi se esiste)
    kill -0 "$PID" 2>/dev/null
}

# ------------------------------------------------------------------------------
# 3. KILL CON TIMEOUT (LOGICA ESAME 49)
# ------------------------------------------------------------------------------
# Monitora un processo e lo uccide se supera il tempo limite.
# Uso: kill_timeout "1234" "60" (Pid 1234, Max 60 secondi)

kill_timeout() {
    local PID="$1"
    local MAX_SEC="$2"
    local ELAPSED=0
    
    echo "Monitoraggio PID $PID per $MAX_SEC secondi..."
    
    while is_running "$PID"; do
        sleep 1
        ((ELAPSED++))
        
        if [ "$ELAPSED" -ge "$MAX_SEC" ]; then
            echo "[TIMEOUT] Il processo $PID ha superato il limite. KILL."
            kill -9 "$PID"
            return 0
        fi
    done
    
    echo "Il processo $PID è terminato da solo prima del timeout."
}