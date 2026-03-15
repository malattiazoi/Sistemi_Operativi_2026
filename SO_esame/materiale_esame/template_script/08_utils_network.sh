#!/bin/bash

# ==============================================================================
# UTILS: NETWORK & CONNECTIVITY (MACOS OPTIMIZED)
# ==============================================================================
# OBIETTIVO:
# Funzioni per controllare porte aperte, ottenere IP e verificare siti web.
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. CONTROLLO PORTA (NETCAT)
# ------------------------------------------------------------------------------
# Verifica se un host remoto ha una porta aperta.
# Ritorna 0 (True) se aperta, 1 (False) se chiusa/timeout.
#
# Uso: if check_port "google.com" "80"; then ...

check_port() {
    local HOST="$1"
    local PORT="$2"
    
    # OPZIONI NETCAT (NC):
    # -z = Scan mode (Zero-I/O), controlla solo se è aperta senza inviare dati.
    # -G 2 = Timeout di 2 secondi (SPECIFICO PER MACOS/BSD).
    #        (Su Linux si userebbe -w 2).
    # 2>/dev/null = Nasconde errori tipo "Connection refused".
    
    nc -z -G 2 "$HOST" "$PORT" > /dev/null 2>&1
}

# ------------------------------------------------------------------------------
# 2. TROVA IL MIO IP (IFCONFIG PARSING)
# ------------------------------------------------------------------------------
# Estrae l'IP locale (LAN) della macchina. Ignora il localhost (127.0.0.1).
# Uso: MY_IP=$(get_my_ip)

get_my_ip() {
    # 1. ifconfig elenca le interfacce
    # 2. grep "inet " prende le righe IPv4
    # 3. grep -v esclude l'indirizzo di loopback
    # 4. awk stampa la seconda colonna (l'IP)
    # 5. head prende solo il primo risultato (di solito en0 o eth0)
    ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | head -n 1
}

# ------------------------------------------------------------------------------
# 3. CHECK STATUS HTTP (CURL)
# ------------------------------------------------------------------------------
# Ottiene il codice di risposta HTTP (es. 200, 404, 500) di un sito.
# Uso: STATUS=$(get_http_status "http://google.com")

get_http_status() {
    local URL="$1"
    
    # -I = Head only (scarica solo intestazione, veloce)
    # -s = Silent (niente barra progresso)
    # -o /dev/null = Butta via l'output testuale
    # -w "%{http_code}" = Scrivi in output SOLO il codice di stato
    curl -I -s -o /dev/null -w "%{http_code}" "$URL"
}

# ------------------------------------------------------------------------------
# 4. CHECK DNS (NSLOOKUP)
# ------------------------------------------------------------------------------
# Verifica se un dominio viene risolto in un IP.
# Uso: if resolve_host "google.com"; then ...

resolve_host() {
    local HOST="$1"
    nslookup "$HOST" > /dev/null 2>&1
}