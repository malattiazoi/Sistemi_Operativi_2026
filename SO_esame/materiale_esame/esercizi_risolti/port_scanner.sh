#!/bin/bash

# Scrivere uno script che prenda in input un Host (IP o dominio) e una Porta.

# Verificare che ci siano entrambi gli argomenti.

# Controllare se la porta su quell'host è aperta (timeout massimo 2 secondi).

# Se è aperta: Stampa "Servizio ATTIVO".

# Se è chiusa o non raggiungibile: Stampa "Servizio NON RAGGIUNGIBILE".

# Extra: Se la porta è la 80 (HTTP), usa curl per stampare il codice di 
# risposta del server (es. "200").

if [ $# -lt 2 ]; then
    echo "ERRORE: argomenti mancanti."
    echo "UTILIZZO: $0 <host> <porta>"
    exit 1
fi

HOST="$1"
PORTA="$2"

echo "Controllo connettività $HOST:$PORTA..."
# nc -z scan mode check apertura
# -G 2 imposto un timeout di 2 secondi
# 2>/dev/null nascondo gli errori
if nc -z -G 2 "$HOST" "$PORTA" 2>/dev/null; then
    echo "[OK] Service ON"
    if [ "$PORTA" == 80 ]; then
        echo "Trying to reach HTTP..."
# curl -i (head only) -s (silent)
# -o /dev/null (output in null) -w (writeout format)
        HTTP_CODE=$(curl -i -s -o /dev/null -w "%{http_code}" "http://$HOST")
        echo "Server respnse: $HTTP_CODE"
    fi
else
    echo "[ERR] Service OFF"
    exit 1
fi

#se avessi usato le funzioni salvate nei log

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

check_port() {
    local HOST="$1"
    local PORT="$2"
    
    # nc -z = Scan mode (niente dati)
    # -G 2  = Timeout 2 secondi (Specifico Mac, su Linux è -w 2)
    nc -z -G 2 "$HOST" "$PORT" > /dev/null 2>&1
}

get_http_status() {
    local URL="$1"
    
    # -I = Head only (scarica solo intestazione, veloce)
    # -s = Silent (niente barra progresso)
    # -o /dev/null = Butta via l'output testuale
    # -w "%{http_code}" = Scrivi in output SOLO il codice di stato
    curl -I -s -o /dev/null -w "%{http_code}" "$URL"
}

#codice
check_args $# 2 "USO: ./port_scanner.sh <host> <porta>"
TARGET=$1
PORT=$2

echo "scan..."

if check_port "$TARGET" "$PORT"; then
    echo "ok"
    if [ "$PORT" -eq 80 ]; then
        code=$(get_http_status "$TARGET")
        echo "Status: $code"
    fi
else
    echo "no ok"
    exit 1
fi