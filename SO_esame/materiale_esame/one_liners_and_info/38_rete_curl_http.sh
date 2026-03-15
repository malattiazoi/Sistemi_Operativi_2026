#!/bin/bash

# ==============================================================================
# 38. RETE E HTTP: CURL, PING, NC (MACOS NETWORKING)
# ==============================================================================
# OBIETTIVO:
# Interagire con il web e la rete da riga di comando.
# Fondamentale per:
# 1. Esame 17: "Monitora una pagina web e avvisa se cambia/trova stringa".
# 2. Scaricare file o script da internet.
# 3. Verificare se un server è raggiungibile.
#
# AMBIENTE: macOS (Curl è nativo, Wget spesso assente)
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. CURL - IL COLTELLINO SVIZZERO DEL WEB
# ------------------------------------------------------------------------------
# Sintassi base: curl [OPZIONI] URL

echo "--- 1. CURL BASE ---"

# 1.1 Scaricare una pagina a video (STDOUT)
# Utile per pipe con grep.
# curl https://www.google.com

# 1.2 Scaricare e salvare su file (-o)
# -o (output): Specifica il nome del file salvato.
echo "Scarico esempio.html..."
curl -o esempio.html https://www.example.com

# 1.3 Modalità Silenziosa (-s / --silent) - CRITICO PER SCRIPT
# Di default curl mostra una barra di progresso e statistiche.
# In uno script (come nell'Esame 17) NON vuoi vedere queste info, vuoi solo i dati.
echo "Scarico silenziosamente..."
curl -s https://www.example.com > /dev/null

# 1.4 Seguire i Redirect (-L / --location)
# Se vai su http://google.com, il server ti risponde "301 Moved to HTTPS".
# Senza -L, curl si ferma e scarica una pagina vuota o di errore.
# Con -L, curl segue il reindirizzamento fino alla pagina vera.
curl -L -s -o google.html http://www.google.com


# ------------------------------------------------------------------------------
# 2. CONTROLLO HEADER E STATO HTTP (-I)
# ------------------------------------------------------------------------------
# A volte vuoi sapere solo SE la pagina esiste (200 OK) o se è stata modificata,
# senza scaricare tutto il contenuto (che potrebbe essere enorme).

echo "--- 2. HEADER CHECK (-I) ---"

# -I (Head): Scarica solo le intestazioni HTTP.
curl -I https://www.example.com

# Output tipico:
# HTTP/2 200 
# content-type: text/html
# last-modified: Thu, 17 Oct 2019 07:18:26 GMT

# Esempio Scripting: Estrarre lo Status Code
STATUS=$(curl -s -o /dev/null -I -w "%{http_code}" https://www.example.com)
echo "Lo stato del sito è: $STATUS"

if [ "$STATUS" == "200" ]; then
    echo "Sito Online!"
else
    echo "Sito Offline o Errore ($STATUS)"
fi


# ------------------------------------------------------------------------------
# 🚀 SIMULAZIONE ESAME 17: MONITORAGGIO PAGINA WEB
# ------------------------------------------------------------------------------
# Traccia:
# "Scrivere uno script che visiti periodicamente una pagina e stampi un messaggio
#  quando trova una certa stringa. Parametri: Intervallo, URL, Stringa."

echo "--- 3. SOLUZIONE ESAME 17 (MONITOR) ---"

# Funzione simulata (in un file reale toglieresti la funzione e useresti $1 $2 $3)
monitor_sito() {
    INTERVALLO=$1
    URL=$2
    STRINGA_CERCA=$3
    
    echo "Avvio monitoraggio di $URL ogni $INTERVALLO secondi..."
    echo "Cerco la stringa: '$STRINGA_CERCA'"
    
    # Loop infinito (interrompere con Ctrl+C)
    # Nel test mettiamo un contatore per non bloccare lo script dimostrativo
    COUNT=0
    while [ $COUNT -lt 3 ]; do 
        
        # 1. Scarica la pagina in memoria (variabile) o file temporaneo
        # Usiamo -s (silent) e -L (follow redirects)
        CONTENUTO=$(curl -s -L "$URL")
        
        # 2. Cerca la stringa dentro il contenuto
        # grep -q (quiet): esce con 0 se trova, 1 se non trova
        if echo "$CONTENUTO" | grep -q "$STRINGA_CERCA"; then
            echo "[$(date)] TROVATO! La stringa '$STRINGA_CERCA' è presente."
            # Qui potresti mettere un 'exit 0' se vuoi che si fermi quando trova
        else
            echo "[$(date)] Non trovata..."
        fi
        
        sleep "$INTERVALLO"
        ((COUNT++))
    done
    echo "Fine simulazione monitoraggio."
}

# Testiamo la funzione con example.com (che contiene "Domain")
monitor_sito 2 "https://www.example.com" "Domain"


# ------------------------------------------------------------------------------
# 4. SCARICAMENTO FILE (BACKUP REMOTO)
# ------------------------------------------------------------------------------
# Utile se l'esame chiede di scaricare un dataset o un archivio.
# -O (O maiuscola): Salva il file con lo stesso nome che ha sul server.

# curl -O https://path.to/file/archive.tar.gz


# ------------------------------------------------------------------------------
# 5. DIAGNOSTICA DI RETE: PING E NC (NETCAT)
# ------------------------------------------------------------------------------
# Se curl fallisce, dobbiamo capire se è colpa del DNS, del server o della porta.

echo "--- 5. DIAGNOSTICA RETE ---"

HOST="www.google.com"

# 5.1 PING (Raggiungibilità Base)
# -c 3 : Manda solo 3 pacchetti (altrimenti su Mac/Linux va all'infinito)
echo "Test Ping verso $HOST:"
ping -c 3 "$HOST" > /dev/null && echo "Host Raggiungibile (Ping OK)" || echo "Host Irraggiungibile"

# 5.2 NC (NETCAT) - CONTROLLO PORTE
# curl usa la porta 80 (HTTP) o 443 (HTTPS).
# Se ping funziona ma curl no, forse la porta è chiusa (Firewall).
# nc -z (scan mode, non invia dati)
# nc -v (verbose)
# -G 2 (Timeout 2 secondi - flag specifico macOS, Linux usa -w)

PORTA=80
echo "Test Porta $PORTA su $HOST:"
# Nota: nc su Mac scrive su stderr, usiamo 2>&1
nc -z -v -G 2 "$HOST" "$PORTA" 2>&1 | grep "succeeded" && echo "Porta $PORTA aperta."


# ------------------------------------------------------------------------------
# 6. USER AGENT E TRUCCHI ANTI-BLOCCO
# ------------------------------------------------------------------------------
# Alcuni siti bloccano "curl" perché è un bot.
# Possiamo fingere di essere un browser reale con il flag -A (User Agent).

echo "--- 6. User Agent Spoofing ---"
FAKE_AGENT="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)"
curl -s -A "$FAKE_AGENT" -I https://www.google.com | grep "200"


# ==============================================================================
# 🧩 RIASSUNTO SCRIPT ESAME 17 (VERSIONE PULITA)
# ==============================================================================
# Ecco come scrivere lo script "monitor.sh" per l'esame, pronto per la consegna.

cat << 'EOF' > monitor_esame17.sh
#!/bin/bash

# Controllo Argomenti
if [ $# -ne 3 ]; then
    echo "Uso: $0 <intervallo_secondi> <url> <stringa>"
    exit 1
fi

INTERVALLO=$1
URL=$2
STRINGA=$3

# Loop Infinito
while true; do
    # Scarica pagina
    # 2>/dev/null nasconde errori di curl (es. host non trovato)
    HTML=$(curl -s -L "$URL" 2>/dev/null)
    
    # Verifica esistenza output (se curl fallisce HTML è vuoto)
    if [ -z "$HTML" ]; then
        echo "Errore: Impossibile contattare $URL"
    else
        # Cerca stringa
        if echo "$HTML" | grep -q "$STRINGA"; then
            echo "Stringa '$STRINGA' TROVATA su $URL!"
            # Opzionale: break per uscire dopo aver trovato
        else
            # Opzionale: echo "Non trovata..."
            : # Comando nullo (do nothing)
        fi
    fi
    
    # Attesa
    sleep "$INTERVALLO"
done
EOF

chmod +x monitor_esame17.sh
echo "Script 'monitor_esame17.sh' creato come riferimento."


# ==============================================================================
# ⚠️ TABELLA FLAG VITALI (CURL SU MACOS)
# ==============================================================================
# | FLAG           | DESCRIZIONE                                          |
# |----------------|------------------------------------------------------|
# | -s (--silent)  | Non mostrare progress bar o errori.                  |
# | -L (--location)| Segui i redirect (301/302). FONDAMENTALE.            |
# | -o file        | Salva output su file invece che a schermo.           |
# | -O             | Salva usando il nome remoto del file.                |
# | -I (--head)    | Scarica solo gli header (veloce check esistenza).    |
# | -A "Agent"     | Cambia lo User-Agent (fingersi un browser).          |
# | -d "data"      | Invia dati POST (es. compilare form).                |

echo "----------------------------------------------------------------"
echo "Test completato."
# Pulizia
rm -f esempio.html google.html