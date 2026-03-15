#!/bin/bash

# ==============================================================================
# 10. NETWORK PORTS DISCOVERY: ASCOLTO, SCANSIONE E PROCESSI (MACOS)
# ==============================================================================
# OBIETTIVO:
# Capire quali porte sono aperte sulla TUA macchina (Listening) e quali sono
# aperte su macchine REMOTE (Scanning).
#
# DIFFERENZE CRITICHE MACOS vs LINUX:
# 1. Linux usa 'ss -tulpn' o 'netstat -tulpn'. Su macOS NON ESISTONO o non mostrano i PID.
# 2. Su macOS, lo strumento RE per le porte locali è 'lsof'.
# 3. Per le porte remote, 'nc' (Netcat) su Mac ha flag diversi (-G per timeout).
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. PORTE LOCALI IN ASCOLTO (CHI STA ASCOLTANDO SUL MIO MAC?)
# ------------------------------------------------------------------------------
# Domanda d'esame: "Verifica quali servizi sono attivi e su quali porte."

echo "--- 1. PORTE LOCALI (LISTENING) ---"

# METODO A: LSOF (IL MIGLIORE SU MACOS)
# Sintassi: sudo lsof -i -P -n | grep LISTEN
# -i : Internet (file di rete)
# -P : Port Numbers (mostra 80 invece di http, 22 invece di ssh). FONDAMENTALE.
# -n : No Hostname (mostra IP invece di nomi). VELOCIZZA di 10x l'esecuzione.
# grep LISTEN : Filtra solo le porte che stanno aspettando connessioni.
# sudo : Necessario per vedere i processi non tuoi (es. servizi di sistema).

echo "Scansione porte locali (lsof)..."
sudo lsof -i -P -n | grep LISTEN

# METODO B: NETSTAT (ALTERNATIVO BSD)
# Sintassi: netstat -an | grep LISTEN
# -a : All sockets
# -n : Numeric (IP e Porte)
# -p tcp : (Opzionale) Mostra solo TCP
# Nota: Su macOS, netstat NON ti dice il PID del processo. È meno utile di lsof.

echo "Scansione porte locali (netstat -an)..."
netstat -anp tcp | grep LISTEN


# ------------------------------------------------------------------------------
# 2. PORTE REMOTE (SCANSIONE E CONNETTIVITÀ)
# ------------------------------------------------------------------------------
# Domanda d'esame: "Controlla se il server X ha la porta 80 aperta."
# Non possiamo usare lsof (lavora solo sul locale). Usiamo NC (Netcat).

echo "----------------------------------------------------------------"
echo "--- 2. PORTE REMOTE (NETCAT) ---"

TARGET="google.com"
PORTA=443

# METODO: NC (NETCAT) SCAN MODE
# Flag macOS (BSD Netcat):
# -z : Zero-I/O mode. Non manda dati, controlla solo se la connessione si apre.
# -v : Verbose. Ti dice "succeeded" o "failed".
# -G 2 : Timeout di connessione in secondi (Linux usa -w). CRITICO PER SCRIPT.

echo "Testo connessione verso $TARGET:$PORTA..."
# Redirezioniamo stderr su stdout (2>&1) perché nc su Mac scrive i messaggi su stderr.
nc -z -v -G 2 "$TARGET" "$PORTA" 2>&1

# ESEMPIO SCRIPTING (CHECK SILENZIOSO)
# In uno script non vuoi output a video, vuoi solo sapere se va (Exit Code 0).
if nc -z -G 2 "$TARGET" "$PORTA"; then
    echo "[SCRIPT] Porta $PORTA su $TARGET: APERTA (OK)"
else
    echo "[SCRIPT] Porta $PORTA su $TARGET: CHIUSA/TIMEOUT (FAIL)"
fi


# ------------------------------------------------------------------------------
# 3. DAL PROCESSO ALLA PORTA (E VICEVERSA)
# ------------------------------------------------------------------------------
# Domanda d'esame: "Quale PID sta occupando la porta 8080? Uccidilo."

echo "----------------------------------------------------------------"
echo "--- 3. MAPPING PROCESSO <-> PORTA ---"

# Simuliamo un processo che ascolta su una porta locale
# Netcat in ascolto (-l) sulla porta 9999 in background (&)
nc -l 9999 &
PID_SIMULATO=$!
echo "Ho avviato un processo finto (PID $PID_SIMULATO) sulla porta 9999."
sleep 1 # Diamo tempo di avviarsi

# 3.1 TROVARE IL PID DALLA PORTA
# Usiamo lsof -i :PORTA
# Aggiungiamo -t (Terse) per avere SOLO il numero PID (perfetto per script).

echo "Cerco chi usa la porta 9999..."
PID_TROVATO=$(lsof -t -i :9999)

echo "PID Trovato da lsof: $PID_TROVATO"

# 3.2 UCCIDERE IL PROCESSO CHE OCCUPA LA PORTA
if [ -n "$PID_TROVATO" ]; then
    echo "Killando il processo $PID_TROVATO..."
    kill "$PID_TROVATO"
else
    echo "Nessun processo trovato sulla porta 9999."
fi


# ------------------------------------------------------------------------------
# 4. SCANSIONE RANGE DI PORTE (PORT SCANNING)
# ------------------------------------------------------------------------------
# Domanda d'esame: "Controlla quali porte tra 80 e 85 sono aperte su localhost."
# Netcat può prendere un range.

echo "----------------------------------------------------------------"
echo "--- 4. PORT SCANNING (RANGE) ---"

# Scansiona localhost (127.0.0.1) porte 20-25
# 2>&1 | grep succeeded serve per vedere solo quelle aperte
nc -z -v -G 1 127.0.0.1 20-25 2>&1 | grep "succeeded" || echo "Nessuna porta aperta nel range 20-25."


# ------------------------------------------------------------------------------
# 5. AUTOMAZIONE: ATTENDERE UN SERVIZIO (WAIT FOR IT)
# ------------------------------------------------------------------------------
# Scenario classico: Lanci un database o un server web e devi aspettare
# che sia pronto prima di lanciare lo script di test.
# Soluzione: Loop "While ! nc..."

echo "----------------------------------------------------------------"
echo "--- 5. SCRIPT: ATTESA SERVIZIO ---"

# Funzione simulata
wait_for_port() {
    HOST=$1
    PORT=$2
    TIMEOUT=5 # Secondi massimi di attesa
    COUNT=0
    
    echo "Attendo che $HOST:$PORT sia disponibile..."
    
    # Finché nc FALLISCE (! nc ...), dormi e riprova
    while ! nc -z -G 1 "$HOST" "$PORT"; do
        echo "Porta ancora chiusa..."
        sleep 1
        ((COUNT++))
        
        if [ "$COUNT" -ge "$TIMEOUT" ]; then
            echo "Timeout! Il servizio non è partito."
            return 1
        fi
    done
    
    echo "Servizio DISPONIBILE su $HOST:$PORT!"
    return 0
}

# Testiamo con una porta chiusa (fallirà dopo 5 secondi)
wait_for_port "localhost" 9999


# ------------------------------------------------------------------------------
# 6. IDENTIFICARE IL TIPO DI PROTOCOLLO (TCP/UDP)
# ------------------------------------------------------------------------------
# lsof di default mostra TCP. Se cerchi UDP devi specificarlo.

echo "----------------------------------------------------------------"
echo "--- 6. PROTOCOLLI UDP ---"

# Trovare servizi UDP (es. DNS, mDNS, Syslog)
# sudo lsof -i UDP -P -n


# ==============================================================================
# 🧩 RIASSUNTO COMANDI PER ESAME
# ==============================================================================

# SCENARIO A: "Il server web non parte, porta occupata."
# 1. Trova il colpevole: sudo lsof -i :80
# 2. Prendi il PID:      sudo lsof -t -i :80
# 3. Uccidi:             sudo kill -9 $(sudo lsof -t -i :80)

# SCENARIO B: "Verifica se il firewall blocca la porta 443 verso google.com"
# nc -z -v -G 2 google.com 443
# Se dice "Connection refused" o "Operation timed out", è bloccato o giù.

# SCENARIO C: "Elenca tutte le connessioni ESTABILISHED (attive)"
# sudo lsof -i -P -n | grep ESTABLISHED


# ==============================================================================
# ⚠️ TABELLA FLAG VITALI (MACOS NETWORK)
# ==============================================================================
# | COMANDO | FLAG     | SIGNIFICATO                                         |
# |---------|----------|-----------------------------------------------------|
# | lsof    | -i       | Seleziona file internet (Rete).                     |
# | lsof    | -i :80   | Seleziona porta specifica.                          |
# | lsof    | -P       | Porte numeriche (VELOCE).                           |
# | lsof    | -n       | IP numerici (VELOCE).                               |
# | lsof    | -t       | Terse mode (Solo PID output).                       |
# | nc      | -z       | Zero-IO (Scan mode).                                |
# | nc      | -v       | Verbose (Dettagli successo/fallimento).             |
# | nc      | -G N     | Timeout connessione N secondi (BSD/Mac).            |
# | nc      | -l       | Listen mode (Crea un server in ascolto).            |

echo "----------------------------------------------------------------"
echo "Tutorial Porte Network Completato."

# ==============================================================================
# COME TROVARE LE PORTE (NETWORK ANALYSIS) - KIT ESAME
# ==============================================================================

# --- 1. IL METODO UNIVERSALE (lsof) ---
# Trova quale processo sta usando una porta specifica (es: 8080)
lsof -i :8080

# Elenca tutte le porte TCP in ascolto (LISTEN)
lsof -nP -iTCP -sTCP:LISTEN
# -n : Non risolve i nomi degli host (più veloce)
# -P : Non risolve i nomi delle porte (mostra 80 invece di http)

# --- 2. IL METODO LINUX (netstat / ss) ---
# Se l'esame è sul server Linux e lsof non è installato:
netstat -tulnp | grep LISTEN
# -t (tcp), -u (udp), -l (listen), -n (numeric), -p (program/PID)

# --- 3. CONTROLLARE SE UNA PORTA È LIBERA (Semplice) ---
# Se non ricevi output, la porta è libera:
lsof -i :4444 || echo "Porta 4444 libera"


# ==============================================================================
# 💡 SUGGERIMENTI PER L'ESAME (SCENARI PRATICI)
# ==============================================================================

# --- SCENARIO 1: "Non riesco ad avviare il mio server" ---
# Se ricevi l'errore "Address already in use", devi trovare chi occupa la porta
# e terminarlo.
# Comando rapido per killare il processo sulla porta 8080:
# kill -9 $(lsof -t -i :8080)
# (L'opzione -t di lsof estrae solo il numero del PID)

# --- SCENARIO 2: "Su quale porta gira il mio processo?" ---
# Se conosci il nome del programma (es: 'nc' o 'python'):
# lsof -i -a -c python

# --- SCENARIO 3: "Vedere porte UDP vs TCP" ---
# Ricorda che la stessa porta (es: 53) può essere usata sia in TCP che in UDP.
# lsof -iUDP :53
# lsof -iTCP :53

# --- NOTA PER MACOS ---
# Su Mac, i comandi netstat e lsof sono leggermente diversi da Linux.
# lsof è identico, mentre netstat su Mac non supporta l'opzione -p.
# CONSIGLIO: Usa sempre LSOF per essere sicuro che funzioni ovunque.