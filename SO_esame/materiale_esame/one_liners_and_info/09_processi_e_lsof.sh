#!/bin/bash

# ==============================================================================
# 09. LSOF MASTER CLASS: DIAGNOSTICA TOTALE (MACOS EDITION)
# ==============================================================================
# OBIETTIVO:
# Capire ESATTAMENTE quale processo sta tenendo aperto un file, una cartella o 
# una connessione di rete.
#
# PERCHÉ È FONDAMENTALE SU MACOS:
# 1. È l'unico modo affidabile per vedere quale PID sta usando una Porta TCP.
# 2. Risolve problemi di "File in use" o "Cannot unmount disk".
# 3. Permette di uccidere processi in base a cosa stanno toccando.
#
# REGOLA D'ORO:
# Su macOS, lancia SEMPRE lsof con 'sudo' se vuoi vedere i processi di tutti gli utenti
# (inclusi quelli di sistema) e le connessioni di rete complete.
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. BASI: CHI STA USANDO QUESTO FILE?
# ------------------------------------------------------------------------------
# Sintassi: lsof /percorso/file
# Risponde a: "Voglio cancellare un file ma il Finder dice che è in uso."

echo "--- 1. ANALISI FILE SINGOLO ---"

# Creiamo un file dummy e un processo che lo tiene occupato in background
touch file_bloccato.txt
# 'tail -f' tiene aperto il file in lettura. Lo lanciamo in background (&)
tail -f file_bloccato.txt > /dev/null &
PID_TAIL=$!  # Salviamo il PID per dopo

echo "Ho lanciato un processo (PID $PID_TAIL) che blocca 'file_bloccato.txt'."
echo "Analisi con lsof:"

# ESECUZIONE LSOF
# Output tipico: COMMAND  PID  USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
lsof file_bloccato.txt

# Spiegazione Colonne Vitali:
# COMMAND: Il nome del programma (es. tail)
# PID:     Il Process ID (utile per killarlo)
# USER:    Chi lo ha lanciato
# FD:      File Descriptor (cwd=current dir, txt=codice, 1r=lettura, 2w=scrittura)


# ------------------------------------------------------------------------------
# 2. DIAGNOSTICA RETE (RETE E PORTE) - CRITICO PER ESAME
# ------------------------------------------------------------------------------
# Su macOS, 'netstat -p' non ti dice il PID. 'lsof -i' è la soluzione.
# Flag: -i (Internet)

echo "----------------------------------------------------------------"
echo "--- 2. DIAGNOSTICA RETE (-i) ---"

# 2.1 LISTA DI TUTTE LE CONNESSIONI DI RETE
# Attenzione: Senza filtri è una lista enorme.
# sudo lsof -i

# 2.2 FILTRARE PER PORTA SPECIFICA (:porta)
# "Chi sta ascoltando sulla porta 80?" o "Chi usa la 22 (SSH)?"
echo "Controllo porta 22 (SSH):"
sudo lsof -i :22

# 2.3 FILTRARE PER PROTOCOLLO (TCP/UDP)
echo "Controllo solo connessioni UDP:"
sudo lsof -i UDP

# 2.4 FLAG VITALI PER VELOCITÀ E LEGGIBILITÀ (-n, -P)
# Di default lsof cerca di risolvere i nomi DNS (lento) e i nomi dei servizi (es. 22->ssh).
# -n : No Hostname (mostra IP numerici). VELOCISSIMO.
# -P : No Port Names (mostra numeri porta).
echo "Controllo Porta 443 (Veloce -n -P):"
sudo lsof -n -P -i :443


# ------------------------------------------------------------------------------
# 3. FILTRARE PER UTENTE (-u)
# ------------------------------------------------------------------------------
# "Cosa sta facendo l'utente 'mario'?" o "Cosa NON sta facendo root?"

echo "----------------------------------------------------------------"
echo "--- 3. FILTRI UTENTE (-u) ---"

CURRENT_USER=$(whoami)

# 3.1 Tutto ciò che è aperto dal tuo utente
# lsof -u "$CURRENT_USER" | head -n 5

# 3.2 NEGAZIONE (ESCLUDERE UN UTENTE) - TRUCCO ESAME
# "Mostrami i file aperti, ma NON quelli di root (voglio vedere solo utenti reali)"
# Il carattere '^' significa NOT.
echo "File aperti da utenti NON root (primi 5):"
lsof -u ^root | head -n 5


# ------------------------------------------------------------------------------
# 4. FILTRARE PER PROCESSO (-c, -p)
# ------------------------------------------------------------------------------
# "Quali file sta toccando Chrome?" oppure "Quali librerie usa il PID 1234?"

echo "----------------------------------------------------------------"
echo "--- 4. FILTRI PROCESSO (-c, -p) ---"

# 4.1 Per NOME comando (-c)
# Nota: -c prende l'inizio del nome. "-c bash" trova "bash", "bashrc", ecc.
echo "File aperti dal processo 'bash':"
lsof -c bash | head -n 5

# 4.2 Per PID (-p)
# Se conosci il PID (es. dal comando ps o top), usa -p.
echo "File aperti dal PID $PID_TAIL (il nostro tail di prima):"
lsof -p "$PID_TAIL"


# ------------------------------------------------------------------------------
# 5. CARTELLE E FILESYSTEM (+D)
# ------------------------------------------------------------------------------
# Scenario: "Non riesco a smontare /Volumes/Chiavetta".
# Devi trovare chi sta usando un file QUALSIASI dentro quella cartella.

echo "----------------------------------------------------------------"
echo "--- 5. ANALISI DIRECTORY (+D) ---"

# Creiamo una directory e accediamoci
mkdir -p test_dir
cd test_dir
# Lanciamo una subshell che rimane in questa cartella
(sleep 10) &
PID_SUBSHELL=$!
cd ..

# +D (Directory Recursive): Cerca chiunque stia usando la cartella o i suoi figli.
echo "Chi sta usando 'test_dir'?"
lsof +D ./test_dir

# Nota: Se provassi a fare 'rm -rf test_dir' ora, potrebbe fallire o dare problemi.


# ------------------------------------------------------------------------------
# 6. SCRIPTING AVANZATO: OUTPUT TERSE (-t) E AUTOMAZIONE
# ------------------------------------------------------------------------------
# Scenario Esame: "Scrivi uno script che killa tutti i processi che usano la porta 8080".
# Non puoi parsare l'output standard di lsof facilmente con awk perché ha intestazioni e spazi variabili.
# SOLUZIONE: Flag -t (Terse).
# -t : Stampa SOLO i PID, nient'altro. Perfetto per 'xargs kill'.

echo "----------------------------------------------------------------"
echo "--- 6. AUTOMAZIONE (KILL BY FILE) ---"

echo "Il PID da uccidere è: $PID_TAIL"

# 1. Ottenere solo il PID tramite file
PID_TROVATO=$(lsof -t file_bloccato.txt)
echo "Lsof -t ha trovato: $PID_TROVATO"

# 2. Killare direttamente
if [ -n "$PID_TROVATO" ]; then
    echo "Uccido il processo che blocca il file..."
    kill "$PID_TROVATO"
    # Oppure in una riga: lsof -t file_bloccato.txt | xargs kill
fi

# Verifica
if lsof file_bloccato.txt; then
    echo "Il file è ancora bloccato."
else
    echo "File liberato con successo!"
fi


# ------------------------------------------------------------------------------
# 7. LOGICA OPERATORI (AND / OR) - AVANZATO
# ------------------------------------------------------------------------------
# Di default, i flag di lsof sono in OR.
# lsof -u mario -c bash -> (Utente mario) OR (Comando bash).
#
# Se vuoi l'AND (Utente mario CHE STA USANDO bash), serve il flag -a.

echo "----------------------------------------------------------------"
echo "--- 7. OPERATORE AND (-a) ---"

echo "Cerco processi che sono MIEI (-u) E che sono BASH (-c):"
lsof -a -u "$CURRENT_USER" -c bash


# ==============================================================================
# 🧩 RIASSUNTO SCENARI D'ESAME
# ==============================================================================

# SCENARIO A: "Trova quale porta sta usando un programma Java"
# sudo lsof -i -a -c java
# (-i = rete, -c = java, -a = unisci condizioni)

# SCENARIO B: "Il server web non parte perché la porta 80 è occupata. Liberala."
# PID=$(sudo lsof -t -i :80)
# if [ -n "$PID" ]; then kill -9 $PID; fi

# SCENARIO C: "Controlla file aperti cancellati (Deleted but still open)"
# A volte lo spazio disco non si libera perché un processo tiene aperto un file cancellato.
# lsof | grep "deleted"


# ==============================================================================
# ⚠️ TABELLA FLAG VITALI (MACOS)
# ==============================================================================
# | FLAG           | DESCRIZIONE                                          |
# |----------------|------------------------------------------------------|
# | -i             | Mostra connessioni di rete.                          |
# | -i :80         | Filtra porta 80.                                     |
# | -i TCP         | Filtra protocollo TCP.                               |
# | -n             | Non risolvere Hostname (IP numerici, veloce).        |
# | -P             | Non risolvere Porte (Porte numeriche, veloce).       |
# | -u user        | Filtra per utente.                                   |
# | -u ^user       | Esclude utente.                                      |
# | -c comm        | Filtra per nome comando (es. -c chrome).             |
# | -p PID         | Filtra per Process ID.                               |
# | +D /path       | Filtra file aperti dentro una directory (ricorsivo). |
# | -t             | Terse mode (Solo PID). Vitale per scripting/kill.    |
# | -a             | AND logico (unisce le condizioni).                   |

# Pulizia
rm -f file_bloccato.txt
rmdir test_dir
echo "----------------------------------------------------------------"
echo "Tutorial LSOF Completato."

# ==============================================================================
# GUIDA AL COMANDO 'lsof' (LIST OPEN FILES)
# ==============================================================================

# 1. UTILIZZO PER PORTE DI RETE (Il più comune in esame)
# ------------------------------------------------------------------------------
# Trova quale processo sta occupando una porta specifica (es: 8080)
lsof -i :8080

# Mostra tutte le connessioni Internet attive (TCP e UDP)
lsof -i

# Mostra solo le connessioni TCP in stato 'LISTEN' (porte aperte in attesa)
lsof -i -sTCP:LISTEN


# 2. FILTRI PER UTENTE E PROCESSO
# ------------------------------------------------------------------------------
# Elenca tutti i file aperti dall'utente 'mlazoi814'
lsof -u mlazoi814

# Elenca i file aperti da un processo specifico tramite il suo PID
lsof -p 1234

# Elenca i file aperti da un comando specifico (es: tutti i file aperti da 'bash')
lsof -c bash


# 3. RICERCA PER FILE O DIRECTORY
# ------------------------------------------------------------------------------
# Chi sta usando questo file specifico?
lsof /Users/test/documento.txt

# Elenca i file aperti all'interno di una directory (+D è ricorsivo)
lsof +D /var/log


# ==============================================================================
# 💡 SUGGERIMENTI PER L'ESAME (SCENARI PRATICI)
# ==============================================================================

# --- SCENARIO 1: "Uccidi il processo che occupa la porta 80" ---
# Spesso un server non parte perché la porta è occupata.
# Step 1: lsof -t -i :80  (l'opzione -t restituisce SOLO il PID, utilissimo!)
# Step 2: kill -9 $(lsof -t -i :80)

# --- SCENARIO 2: "Trova file cancellati ma ancora aperti" ---
# Se il disco è pieno (df) ma non trovi file grossi (du), un processo potrebbe
# tenere aperto un file che hai già cancellato col comando 'rm'.
# grep "deleted" cercandolo nell'output di lsof:
# lsof | grep "(deleted)"

# --- SCENARIO 3: "Vedere dove punta una Pipe o un Socket" ---
# Se stai analizzando la comunicazione tra processi (IPC):
# lsof -E 
# (L'opzione -E mostra le informazioni sugli endpoint, come le pipe tra processi).

# --- NOTA MACOS vs LINUX ---
# Su MacOS lsof è pre