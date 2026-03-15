#!/bin/bash

# ==============================================================================
# 06. GUIDA COMPLETA A CURL E HTTP (MACOS EDITION)
# ==============================================================================
# OBIETTIVO:
# Interagire con server web, scaricare file, compilare form e monitorare siti.
#
# UTILIZZO ESAME (Esame 17):
# "Scrivere uno script che visiti periodicamente una pagina e avvisi se trova una stringa."
#
# PERCHÉ CURL SU MACOS?
# macOS include 'curl' di default. Non include 'wget'.
# Usare 'wget' all'esame su un Mac potrebbe darti "Command not found".
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. SCARICAMENTO BASE (GET REQUEST)
# ------------------------------------------------------------------------------
# Sintassi: curl [OPZIONI] URL

echo "--- 1. SCARICAMENTO BASE ---"

# 1.1 Scaricare a video (STDOUT)
# Utile se devi passare l'output a 'grep' o 'wc' immediatamente.
# curl https://www.example.com

# 1.2 Scaricare su file specifico (-o)
# Flag -o (output): Decidi tu il nome del file locale.
curl -o pagina_prova.html https://www.example.com

# 1.3 Scaricare con nome originale (-O)
# Flag -O (O maiuscola): Usa il nome del file remoto (es. archivio.tar.gz).
# curl -O https://www.example.com/archivio.tar.gz

# ------------------------------------------------------------------------------
# 2. SILENZIARE E GESTIRE I REDIRECT (CRITICO PER SCRIPT)
# ------------------------------------------------------------------------------
# Di default curl mostra una barra di progresso e statistiche.
# Negli script automatici questo "sporca" l'output.

echo "--- 2. OPZIONI PER SCRIPTING ---"

# 2.1 Modalità Silent (-s)
# Nasconde la barra di caricamento e gli errori.
curl -s https://www.example.com > /dev/null

# 2.2 Seguire i Redirect (-L) - FONDAMENTALE
# Molti siti (es. google.com) ti reindirizzano da HTTP a HTTPS (Codice 301/302).
# Senza -L, curl scarica solo una pagina vuota che dice "Moved Permanently".
# Con -L, curl segue il link fino alla destinazione finale.
curl -s -L -o google.html http://www.google.com

# 2.3 Combinazione Classica Scripting (-sL)
# Scarica silenziosamente seguendo i redirect.
curl -sL https://www.example.com > /dev/null


# ------------------------------------------------------------------------------
# 3. HEADER CHECK E STATUS CODE (-I, -w)
# ------------------------------------------------------------------------------
# A volte vuoi sapere solo SE una pagina esiste, senza scaricare MB di dati.

echo "--- 3. HEADER E STATUS ---"

# 3.1 Scaricare solo gli Header (-I / --head)
# Mostra: HTTP/2 200 OK, Content-Type, Last-Modified, ecc.
curl -I https://www.example.com

# 3.2 Estrarre SOLO il Codice HTTP (es. 200, 404, 500)
# -o /dev/null : Butta via il contenuto della pagina.
# -s : Zitto.
# -w "%{http_code}" : Scrivi (Write) solo il codice di stato alla fine.
CODICE=$(curl -s -o /dev/null -w "%{http_code}" https://www.example.com)

echo "Il codice di stato è: $CODICE"

if [ "$CODICE" == "200" ]; then
    echo "Sito ONLINE e raggiungibile."
else
    echo "Sito OFFLINE o Errore (Codice: $CODICE)."
fi


# ------------------------------------------------------------------------------
# 4. MONITORAGGIO PAGINA WEB (SOLUZIONE ESAME 17)
# ------------------------------------------------------------------------------
# TRACCIA: "Script che visita periodicamente URL e stampa messaggio se trova STRINGA."

echo "--- 4. SIMULAZIONE ESAME 17 (MONITOR) ---"

# Parametri (Simulati, in script reale usaresti $1, $2...)
URL_TARGET="https://www.example.com"
STRINGA_CERCA="Domain"
INTERVALLO=2

echo "Avvio monitoraggio di $URL_TARGET ogni $INTERVALLO secondi..."
echo "Cerco la parola: $STRINGA_CERCA"

# Loop di monitoraggio (limitato a 3 giri per la demo)
for i in {1..3}; do
    echo "Controllo #$i..."
    
    # 1. Scarica contenuto in variabile
    HTML=$(curl -sL "$URL_TARGET")
    
    # 2. Cerca stringa con grep
    # grep -q (quiet) ritorna 0 (vero) se trova, 1 (falso) se non trova.
    if echo "$HTML" | grep -q "$STRINGA_CERCA"; then
        echo "[$(date +%H:%M:%S)] TROVATA! La stringa '$STRINGA_CERCA' è presente."
    else
        echo "[$(date +%H:%M:%S)] Non trovata."
    fi
    
    sleep "$INTERVALLO"
done


# ------------------------------------------------------------------------------
# 5. USER AGENT SPOOFING (-A)
# ------------------------------------------------------------------------------
# Alcuni siti bloccano "curl" per evitare bot.
# Puoi fingere di essere un browser (Chrome/Safari) cambiando lo User Agent.

echo "--- 5. USER AGENT SPOOFING ---"

FAKE_UA="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.114 Safari/537.36"

# Esempio di richiesta "mascherata"
curl -s -A "$FAKE_UA" -I https://www.google.com | grep "200"


# ------------------------------------------------------------------------------
# 6. INVIARE DATI (POST) E FORM (-d, -X)
# ------------------------------------------------------------------------------
# Se devi compilare un form o chiamare un'API.

echo "--- 6. POST REQUESTS ---"

# -d "chiave=valore" invia i dati come POST.
# Esempio fittizio (non funzionerà davvero senza un server API):
# curl -X POST -d "username=mario&pass=12345" https://api.sito.com/login


# ------------------------------------------------------------------------------
# 7. DIAGNOSTICA AVANZATA (-v)
# ------------------------------------------------------------------------------
# Se qualcosa non va, usa -v (Verbose).
# Mostra handshake SSL, richiesta inviata e risposta ricevuta.

echo "--- 7. DEBUG VERBOSE (-v) ---"
# curl -v https://www.example.com


# ==============================================================================
# 🧩 RIASSUNTO SCRIPT ESAME (DA COPIARE/INCOLLARE)
# ==============================================================================
# Ecco lo scheletro perfetto per l'esercizio di monitoraggio.

cat << 'EOF' > monitor_web.sh
#!/bin/bash

# Controllo argomenti
if [ $# -ne 3 ]; then
    echo "Uso: $0 <intervallo> <url> <stringa>"
    exit 1
fi

SEC=$1
URL=$2
STR=$3

echo "Monitoraggio $URL per '$STR' ogni $SEC secondi. (Ctrl+C per uscire)"

while true; do
    # Scarica silenziosamente (-s) seguendo i redirect (-L)
    # Se curl fallisce (es. no internet), HTML sarà vuoto
    HTML=$(curl -sL "$URL")
    
    if [ -z "$HTML" ]; then
        echo "Errore: Impossibile scaricare la pagina."
    else
        # Cerca la stringa
        if echo "$HTML" | grep -q "$STR"; then
            echo "[$(date)] TROVATO MATCH!"
        fi
    fi
    
    sleep "$SEC"
done
EOF

chmod +x monitor_web.sh
echo "Script 'monitor_web.sh' generato."


# ==============================================================================
# ⚠️ TABELLA FLAG VITALI (CURL MACOS)
# ==============================================================================
# | FLAG           | NOME ESTESO       | DESCRIZIONE                             |
# |----------------|-------------------|-----------------------------------------|
# | -s             | --silent          | Nasconde progress bar ed errori.        |
# | -L             | --location        | Segue i redirect (301/302).             |
# | -o file        | --output          | Scrive l'output su un file locale.      |
# | -O             | --remote-name     | Usa il nome del file remoto.            |
# | -I             | --head            | Scarica solo gli header HTTP.           |
# | -A "..."       | --user-agent      | Imposta lo User Agent (finge browser).  |
# | -w "..."       | --write-out       | Stampa formattata (es. status code).    |
# | -d "..."       | --data            | Invia dati POST (form/API).             |
# | -k             | --insecure        | Ignora errori certificati SSL (HTTPS).  |

# Pulizia
rm -f pagina_prova.html google.html
echo "----------------------------------------------------------------"
echo "Tutorial Curl Completato."

# ==============================================================================
# GUIDA AL COMANDO 'curl' (Client URL) - KIT ESAME
# ==============================================================================

# ------------------------------------------------------------------------------
# COS'È cURL?
# È uno strumento per trasferire dati da o verso un server (HTTP, HTTPS, FTP...).
# A differenza di un browser, mostra il "dietro le quinte" della comunicazione.
# ------------------------------------------------------------------------------

# 1. SCARICARE E SALVARE (Le basi)
# ------------------------------------------------------------------------------
# Scarica la pagina e la stampa a video (STDOUT):
# curl https://www.google.it

# Scarica e salva in un file specifico (-o minuscolo):
# curl https://esempio.com/dati.csv -o locale.csv

# Scarica e salva usando il nome originale del file remoto (-O maiuscolo):
# curl -O https://esempio.com/archivio.zip


# 2. ISPEZIONE E DEBUG (Molto probabile in esame)
# ------------------------------------------------------------------------------
# Vedere solo l'HEADER (la risposta del server senza il contenuto):
# Utile per controllare codici di errore (200 OK, 404 Not Found, 301 Redirect).
# curl -I https://www.google.it

# Modalità Verbose (-v): Mostra tutto (connessione, certificati, header inviati).
# curl -v https://www.google.it


# 3. INVIO DATI E API (POST/JSON)
# ------------------------------------------------------------------------------
# Inviare dati di un form (POST):
# curl -X POST -d "utente=admin&pass=secret" https://api.test.com/login

# Inviare dati in formato JSON (richiede l'header Content-Type):
# curl -H "Content-Type: application/json" -d '{"id": 1, "status": "ok"}' https://api.test.com/update


# 4. ALTRE OPZIONI "SALVAVITA"
# ------------------------------------------------------------------------------
# -L : Segue i redirect (fondamentale se l'URL è abbreviato o cambiato).
# -u : Autenticazione base (es. -u username:password).
# -k : Ignora errori dei certificati SSL (utile se il server d'esame è locale/privato).


# ==============================================================================
# 💡 LINEE DI COMANDO UTILI E CONSIGLI PER L'ESAME
# ==============================================================================

# --- TRUCCO 1: Scaricare e processare al volo ---
# Spesso l'esame chiede: "Scarica un file e conta quante righe contengono 'Error'".
# Non serve salvare il file! Usa le pipe:
# curl -s https://server.com/log.txt | grep "Error" | wc -l
# (L'opzione -s sta per 'silent', toglie la barra di caricamento di curl).

# --- TRUCCO 2: Verificare se un sito è online in uno script ---
# if curl -I -s -f https://server.com > /dev/null; then
#     echo "Il server è raggiungibile"
# else
#     echo "Server DOWN o URL errato"
# fi
# (-f sta per 'fail silently', restituisce un errore se il codice HTTP è >= 400).

# --- DIFFERENZA CURL vs SCP ---
# cURL: Si usa per protocolli WEB (HTTP/S) o pubblici. Non richiede SSH.
# SCP: Si usa per copiare file tra computer tramite SSH (richiede accesso di sistema).
# In esame: se ti danno un link "http://...", usa curl. Se ti danno "utente@ip", usa scp.

# --- ATTENZIONE SU MACOS ---
# Il curl su MacOS è già molto aggiornato, ma ricorda che se devi scaricare 
# molti file in serie, Bash può farlo così:
# curl -O "https://sito.com/file_[1-10].jpg"