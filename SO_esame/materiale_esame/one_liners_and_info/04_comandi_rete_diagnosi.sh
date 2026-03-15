#!/bin/bash

# ==============================================================================
# 03. RETE E DIAGNOSI: IP, PORTE, DNS E CONNETTIVITÀ (MACOS EDITION)
# ==============================================================================
# OBIETTIVO:
# Capire perché la rete non va, qual è il mio IP, quali porte sono aperte
# e se un server remoto è raggiungibile.
#
# DIFFERENZE CRITICHE LINUX vs MACOS:
# 1. IP: Linux usa 'ip addr'. macOS usa 'ifconfig' (BSD).
# 2. Porte: Linux usa 'ss -tulpn'. macOS usa 'lsof -i' o 'netstat' (BSD).
# 3. DNS: macOS usa 'scutil --dns' per vedere i resolver reali.
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. IDENTIFICARE LE INTERFACCE E L'INDIRIZZO IP
# ------------------------------------------------------------------------------
# Su Mac, le interfacce principali sono solitamente:
# - lo0 : Localhost (127.0.0.1)
# - en0 : Wi-Fi (spesso) o Ethernet
# - en1 : Ethernet (spesso) o Wi-Fi

echo "--- 1. INFO INTERFACCE (IFCONFIG) ---"

# 1.1 Mostra tutto (Verboso e difficile da leggere)
# ifconfig

# 1.2 Trovare solo il proprio IP (IPv4)
# "inet " indica l'indirizzo IPv4. "inet6" l'IPv6.
# grep -v 127.0.0.1 esclude localhost.
echo "Il mio indirizzo IP (IPv4):"
ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}'

# 1.3 Metodo Semplificato Apple (ipconfig)
# Comando specifico macOS per ottenere l'IP di un'interfaccia specifica.
echo "IP Interfaccia Wi-Fi (en0):"
ipconfig getifaddr en0

# 1.4 Vedere il MAC ADDRESS (Ether)
echo "MAC Address (en0):"
ifconfig en0 | grep "ether" | awk '{print $2}'


# ------------------------------------------------------------------------------
# 2. VERIFICARE LA CONNETTIVITÀ (PING)
# ------------------------------------------------------------------------------
# Fondamentale per capire se "internet funziona" o se un server è giù.

echo "----------------------------------------------------------------"
echo "--- 2. CONNETTIVITÀ (PING) ---"

TARGET="8.8.8.8" # Google DNS

# 2.1 Ping Base
# Su Mac/Linux il ping è INFINITO di default. Devi fermarlo con Ctrl+C.
# All'esame usa SEMPRE il flag -c (Count) per fermarlo dopo N pacchetti.

echo "Pingo $TARGET per 3 volte..."
if ping -c 3 "$TARGET" > /dev/null; then
    echo "SUCCESS: $TARGET è raggiungibile."
else
    echo "FAIL: $TARGET non risponde."
fi

# 2.2 Ping con Timeout (-W)
# Utile negli script: se non risponde entro 1 secondo, fallisce subito.
# Su Mac il flag è -W (millisecondi) o -t (secondi) a seconda della versione.
# Versione sicura BSD: -t timeout_in_secondi
# ping -c 1 -t 2 10.0.0.99


# ------------------------------------------------------------------------------
# 3. DIAGNOSTICA PORTE APERTE (LSOF e NETSTAT)
# ------------------------------------------------------------------------------
# Scenario: "Ho lanciato il server web ma non riesco a connettermi".
# Domanda: Il server sta ascoltando? Su quale porta?

echo "----------------------------------------------------------------"
echo "--- 3. PORTE E SERVIZI IN ASCOLTO ---"

# 3.1 LSOF (List Open Files) - IL MIGLIORE SU MACOS
# -i : File di rete (Internet)
# -P : Non risolvere i nomi delle porte (mostra 80 invece di http)
# -n : Non risolvere i nomi degli host (mostra IP invece di nomi)
# grep LISTEN : Mostra solo le porte in ascolto (server).

echo "Servizi in ascolto (LSOF):"
sudo lsof -i -P -n | grep LISTEN
# Nota: sudo serve per vedere i processi di tutti gli utenti.

# 3.2 NETSTAT (Metodo Classico BSD)
# -a : All sockets
# -n : Numeric (IP e Porte)
# -p tcp : Solo protocollo TCP
# grep LISTEN
echo "Servizi in ascolto (NETSTAT):"
netstat -anp tcp | grep LISTEN


# ------------------------------------------------------------------------------
# 4. TESTARE PORTE REMOTE (NC / NETCAT)
# ------------------------------------------------------------------------------
# Scenario: "Il server risponde al ping, ma il sito non carica".
# Probabile causa: Firewall o servizio spento sulla porta 80.

echo "----------------------------------------------------------------"
echo "--- 4. TEST PORTE REMOTE (NETCAT) ---"

SERVER="google.com"
PORTA=80

# Sintassi Mac (BSD Netcat): nc -z -v -G <timeout> host porta
# -z : Scan mode (non invia dati, controlla solo se apre la connessione)
# -v : Verbose (ti dice "Succeeded!" o "Refused")
# -G 2 : Timeout di 2 secondi (Linux usa -w)

echo "Testo connessione a $SERVER:$PORTA..."
# Redirigo stderr su stdout (2>&1) per poter usare grep
nc -z -v -G 2 "$SERVER" "$PORTA" 2>&1 | grep "succeeded" && echo "Porta APERTA" || echo "Porta CHIUSA"


# ------------------------------------------------------------------------------
# 5. DNS E RISOLUZIONE NOMI (NSLOOKUP, DIG, SCUTIL)
# ------------------------------------------------------------------------------
# Scenario: "Ping 8.8.8.8 funziona, ma ping google.com no".
# Problema: DNS rotto.

echo "----------------------------------------------------------------"
echo "--- 5. DIAGNOSTICA DNS ---"

# 5.1 NSLOOKUP (Semplice)
echo "Risoluzione google.com:"
nslookup google.com | grep "Address:"

# 5.2 DIG (Dettagliato - Per Esperti)
# Ti dice ESATTAMENTE quale server DNS sta rispondendo e quanto ci mette.
# dig google.com +short

# 5.3 SCUTIL (Specifico macOS)
# Mostra la configurazione DNS reale del sistema (quella usata dal WiFi).
echo "Configurazione DNS macOS:"
scutil --dns | grep "nameserver" | head -n 2


# ------------------------------------------------------------------------------
# 6. ROUTING E GATEWAY (NETSTAT -R)
# ------------------------------------------------------------------------------
# Scenario: "Non esco su internet".
# Problema: Manca il Gateway Default.

echo "----------------------------------------------------------------"
echo "--- 6. ROUTING TABLE ---"

# Su Linux: ip route
# Su macOS: netstat -rn
# Cerca la destinazione "default" o "0.0.0.0"

echo "Gateway di Default:"
netstat -rn | grep "default" | awk '{print $2}'


# ------------------------------------------------------------------------------
# 7. MACOS SPECIALS: NETWORKSETUP
# ------------------------------------------------------------------------------
# Comando potentissimo per configurare la rete da terminale su Mac.

echo "----------------------------------------------------------------"
echo "--- 7. NETWORKSETUP (SOLO MAC) ---"

# Elenca tutti i servizi di rete (Wi-Fi, Ethernet, Thunderbolt...)
# networksetup -listallnetworkservices

# Ottenere info su un servizio specifico
# networksetup -getinfo "Wi-Fi"

# Spegnere/Accendere il Wi-Fi da riga di comando (Utile per reset)
# networksetup -setairportpower en0 off
# networksetup -setairportpower en0 on


# ==============================================================================
# 🧩 ESEMPIO SCRIPT ESAME: CHECK CONNESSIONE TOTALE
# ==============================================================================
# "Scrivi uno script che verifica se sei connesso a internet e se il DNS funziona"

echo "----------------------------------------------------------------"
echo "--- ESECUZIONE DIAGNOSTICA AUTOMATICA ---"

# 1. Check Gateway (Ping 8.8.8.8)
if ping -c 1 -t 2 8.8.8.8 > /dev/null; then
    echo "[OK] Connessione IP esterna funzionante."
    
    # 2. Check DNS (Ping google.com)
    if ping -c 1 -t 2 google.com > /dev/null; then
        echo "[OK] Risoluzione DNS funzionante."
    else
        echo "[ERR] Problema DNS! Riesco a raggiungere IP ma non nomi."
        echo "Suggerimento: Controlla /etc/resolv.conf o scutil --dns"
    fi
else
    echo "[ERR] Nessuna connessione internet (Gateway irraggiungibile)."
    echo "Suggerimento: Controlla il Wi-Fi (ifconfig en0) o il router."
fi


# ==============================================================================
# ⚠️ TABELLA FLAG VITALI (RETE MACOS)
# ==============================================================================
# | COMANDO   | FLAG | SIGNIFICATO                                     |
# |-----------|------|-------------------------------------------------|
# | ifconfig  | -a   | Mostra tutte le interfacce (anche down)         |
# | ping      | -c N | Conta N pacchetti e poi fermati (OBBLIGATORIO)  |
# | ping      | -t S | Timeout in secondi (specifico Mac)              |
# | lsof      | -i   | Mostra file Internet (connessioni/porte)        |
# | lsof      | -P   | Porte numeriche (non tradurre 80 in http)       |
# | nc        | -z   | Zero-I/O (Scanning mode, non invia dati)        |
# | nc        | -G S | Timeout in secondi (Linux usa -w)               |
# | netstat   | -rn  | Mostra tabella di routing (n = numeric)         |

echo "----------------------------------------------------------------"
echo "Test Rete Completato."
# ==============================================================================
# GUIDA AI COMANDI DI RETE (DIAGNOSI E CONFIGURAZIONE)
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. PING (Verifica connettività)
# A cosa serve: Controlla se un computer remoto risponde. Usa il protocollo ICMP.
# ------------------------------------------------------------------------------
# ping -c 4 google.com
#   -c 4 : Invia solo 4 pacchetti (fondamentale, altrimenti su Mac continua all'infinito)
#   -i 0.5 : Aspetta mezzo secondo tra un pacchetto e l'altro (più veloce)

# ------------------------------------------------------------------------------
# 2. IFCONFIG vs IP (Identificazione della macchina)
# IMPORTANTE: Su MacOS si usa 'ifconfig'. Il comando 'ip' è solo per Linux.
# ------------------------------------------------------------------------------
# ifconfig
#   Mostra tutte le interfacce. Cerca 'en0' (solitamente il Wi-Fi su Mac).
#   L'indirizzo IP è quello dopo la parola 'inet'.

# ifconfig en0 up/down 
#   Attiva o disattiva l'interfaccia (richiede sudo).

# ------------------------------------------------------------------------------
# 3. DIG (Diagnosi DNS)
# A cosa serve: Sapere a quale indirizzo IP corrisponde un nome (o viceversa).
# ------------------------------------------------------------------------------
# dig google.com
#   Mostra la risposta completa del server DNS.
# dig +short google.com
#   Restituisce SOLO l'indirizzo IP (utilissimo negli script per salvare l'IP in una variabile).
# dig -x 8.8.8.8
#   Reverse lookup: dall'IP risale al nome del dominio.

# ------------------------------------------------------------------------------
# 4. TRACEROUTE (Analisi del percorso)
# A cosa serve: Vedere tutti i "salti" (router) che un pacchetto fa per arrivare a destinazione.
# ------------------------------------------------------------------------------
# traceroute -n google.com
#   -n : Non risolve i nomi dei nodi (molto più veloce, mostra solo gli IP).

# ------------------------------------------------------------------------------
# 5. ARP (Address Resolution Protocol)
# A cosa serve: Associa gli indirizzi IP agli indirizzi fisici (MAC Address) della rete locale.
# ------------------------------------------------------------------------------
# arp -a
#   Mostra la tabella dei dispositivi vicini a te nella stessa rete.

# ------------------------------------------------------------------------------
# 6. NETSTAT / LSOF (Connessioni attive e porte) - Spesso chiesto!
# A cosa serve: Vedere quali programmi stanno usando la rete e su quali porte.
# ------------------------------------------------------------------------------
# netstat -an | grep LISTEN
#   Mostra tutte le porte "aperte" in attesa di connessione.
# lsof -i :80
#   Mostra quale processo sta usando la porta 80 (HTTP).

# ==============================================================================
# TABELLA DI CONVERSIONE (ESAME: LINUX vs MACOS)
# ==============================================================================
# Se l'esame è su Linux (Ubuntu/Debian), il professore vorrà 'ip'. 
# Se è sul tuo Mac, userai i comandi legacy.
#
# AZIONE                | COMANDO MACOS (BSD) | COMANDO LINUX (Moderno)
# ----------------------|----------------------|-------------------------
# Vedere IP/Interfacce  | ifconfig             | ip addr
# Vedere Tabella Routing| netstat -nr          | ip route
# Vedere Tabella ARP    | arp -a               | ip neigh
# Attivare interfaccia  | ifconfig en0 up      | ip link set eth0 up