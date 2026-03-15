#!/bin/bash

# ==============================================================================
# 13. GESTIONE PROCESSI: PS, KILL, TOP, JOBS (MACOS BSD)
# ==============================================================================
# OBIETTIVO:
# Monitorare, gestire e terminare i processi.
# Capire come ottenere il PID (Process ID) per manipolare programmi in esecuzione.
#
# CONCETTI CHIAVE:
# - PID (Process ID): Numero univoco che identifica un processo.
# - PPID (Parent PID): Il processo "genitore" che ha lanciato questo.
# - $$ : Variabile speciale che contiene il PID dello script corrente.
# - $! : Variabile speciale che contiene il PID dell'ultimo processo in background.
#
# AMBIENTE: macOS (BSD ps / BSD top)
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. PS (PROCESS STATUS) - FOTOGRAFIA ISTANTANEA
# ------------------------------------------------------------------------------
# 'ps' mostra cosa sta girando in QUESTO momento.

echo "--- 1. MONITORAGGIO BASE (PS) ---"

# 1.1 Sintassi BSD (Standard Mac)
# a = All users (tutti gli utenti)
# u = User oriented (mostra utente, cpu, mem...)
# x = No terminal (anche processi di sistema/background)
echo "Elenco processi completo (ps aux - prime 3 righe):"
ps aux | head -n 3

# 1.2 Sintassi Personalizzata (-o) - VITALE PER SCRIPT
# Se devi estrarre solo PID e CPU per fare calcoli (come nell'Esame 13),
# NON usare 'ps aux' e poi 'cut'. Usa '-o'.
# Keywords: pid, ppid, user, %cpu, %mem, comm (comando), etime (tempo esecuzione)

echo "Output pulito per scripting (PID, %CPU, COMMAND):"
ps -A -o pid,%cpu,comm | head -n 5

# 1.3 Ordinamento (su Mac)
# Su Linux si usa --sort. Su Mac BSD non c'è.
# Si usa 'ps -m' (per memoria) o 'ps -r' (per CPU).
echo "Top 3 processi per utilizzo CPU (ps -Ar):"
ps -Ar -o pid,%cpu,comm | head -n 4


# ------------------------------------------------------------------------------
# 2. TOP (MONITORAGGIO REAL-TIME E BATCH)
# ------------------------------------------------------------------------------
# 'top' è interattivo, ma negli script serve la modalità "Batch" (esegui una volta e esci).

echo "----------------------------------------------------------------"
echo "--- 2. TOP (SCRIPTING MODE) ---"

# DIFFERENZA CRITICA MACOS:
# Linux: top -b -n 1
# macOS: top -l 1
# Se usi -b su Mac, dà errore.

echo "Eseguo top una volta sola (-l 1):"
# -l 1 : 1 Campione (Sample)
# -n 5 : Mostra solo 5 processi
# -o cpu : Ordina per CPU (o -o mem per memoria)
top -l 1 -n 5 -o cpu | grep "PhysMem"  # Esempio: Estrarre info memoria globale


# ------------------------------------------------------------------------------
# 3. BACKGROUND (&) E VARIABILI SPECIALI ($$, $!)
# ------------------------------------------------------------------------------
# Fondamentale per l'Esame 10 ("Lanciare due script indipendentemente").

echo "----------------------------------------------------------------"
echo "--- 3. BACKGROUND E PID SPECIALI ---"

echo "Il PID di questo script è: $$"

# Lanciamo un processo che dorme per 100 secondi in background (&)
sleep 100 &

# $! contiene il PID dell'ultimo comando lanciato con &
PID_SLEEP=$!
echo "Ho lanciato 'sleep' in background. Il suo PID è: $PID_SLEEP"

# Verifica che esista
ps -p "$PID_SLEEP"


# ------------------------------------------------------------------------------
# 4. KILL E SEGNALI (TERMINARE PROCESSI)
# ------------------------------------------------------------------------------
# I segnali dicono al processo cosa fare.
# 15 (SIGTERM) = Per favore, chiuditi (Default). Il processo può salvare i dati.
# 9  (SIGKILL) = Muori ORA. Nessun salvataggio. Brutale.
# 2  (SIGINT)  = Equivalente a Ctrl+C.
# 1  (SIGHUP)  = Rileggi la configurazione (Reload).

echo "----------------------------------------------------------------"
echo "--- 4. KILL (TERMINAZIONE) ---"

echo "Invio segnale di terminazione gentile (15) al PID $PID_SLEEP..."
kill -15 "$PID_SLEEP"

# Verifica se è morto
sleep 1
if ps -p "$PID_SLEEP" > /dev/null; then
    echo "È ancora vivo. Uso la forza bruta (SIGKILL 9)..."
    kill -9 "$PID_SLEEP"
else
    echo "Il processo è terminato correttamente."
fi


# ------------------------------------------------------------------------------
# 5. KILLALL E PKILL (UCCIDERE PER NOME)
# ------------------------------------------------------------------------------
# Se non sai il PID ma sai il nome (es. "chrome"), usa questi.

echo "----------------------------------------------------------------"
echo "--- 5. KILLALL E PGREP ---"

# Lanciamo due processi con lo stesso nome
sleep 500 &
sleep 500 &

# pgrep: Trova i PID dato un nome (Process Grep)
# -l : Mostra anche il nome
echo "Tutti i processi 'sleep' attivi:"
pgrep -l sleep

# killall: Uccide TUTTI i processi con quel nome
echo "Uccido tutti i processi 'sleep'..."
killall sleep
# Nota: Su script importanti, 'killall' è pericoloso. Meglio trovare il PID preciso.


# ------------------------------------------------------------------------------
# 6. JOB CONTROL (FG, BG, JOBS)
# ------------------------------------------------------------------------------
# Gestire i processi nella sessione corrente del terminale.
# Ctrl+Z : Sospende un processo (Stop).
# bg : Lo riprende in background.
# fg : Lo riporta in primo piano.

echo "----------------------------------------------------------------"
echo "--- 6. JOB CONTROL ---"

# Lanciamo un job
sleep 200 &

# jobs: Elenca i lavori attivi nella shell corrente
echo "Lista Jobs:"
jobs

# %1 indica il "Job numero 1" (non il PID)
echo "Porto il job %1 in primo piano (fg) per 1 secondo..."
# fg %1  <-- Questo bloccherebbe lo script finché sleep finisce.
# Lo killiamo per pulizia
kill %1


# ------------------------------------------------------------------------------
# 7. WAIT (SINCRONIZZAZIONE)
# ------------------------------------------------------------------------------
# CRITICO PER ESAME: "Lancia 3 processi e attendi che finiscano prima di uscire".

echo "----------------------------------------------------------------"
echo "--- 7. WAIT ---"

echo "Lancio processo A..."
sleep 2 &
PID_A=$!

echo "Lancio processo B..."
sleep 4 &
PID_B=$!

echo "Attendo che finiscano TUTTI..."
wait
# Oppure wait $PID_A per aspettarne uno specifico.

echo "Tutti i processi finiti. Script concluso."


# ==============================================================================
# 🧩 ESEMPIO PRATICO: SOLUZIONE ESAME 10 (COMUNICAZIONE)
# ==============================================================================
# Traccia: "Script A fa operazioni. Script B costringe A a stampare output."
# Soluzione: Si usano i SEGNALI (TRAP).
#
# Script A (Vittima):
# trap "echo Il contatore è $COUNT" SIGUSR1
# while true; do ((COUNT++)); sleep 1; done
#
# Script B (Controllore):
# kill -SIGUSR1 $PID_DI_A

echo "----------------------------------------------------------------"
echo "--- SIMULAZIONE TRAP (ESAME 10) ---"

# Creiamo lo script A al volo
cat << 'EOF' > script_A.sh
#!/bin/bash
COUNT=0
# Definizione TRAP: Quando ricevo segnale USR1, stampo info
trap "echo [Script A] Ricevuto segnale! Contatore attule: $COUNT" SIGUSR1

echo "[Script A] Avviato con PID $$ (In attesa di segnali...)"
while true; do
    ((COUNT++))
    sleep 1
done
EOF

chmod +x script_A.sh

# Avviamo Script A in background
./script_A.sh &
PID_A=$!
echo "Script A lanciato con PID $PID_A"

sleep 2
echo "[Script B] Invio segnale SIGUSR1 a $PID_A..."
kill -SIGUSR1 "$PID_A"

sleep 2
echo "[Script B] Invio segnale SIGUSR1 a $PID_A..."
kill -SIGUSR1 "$PID_A"

# Pulizia
echo "Test finito, uccido Script A."
kill -9 "$PID_A"
rm script_A.sh


# ==============================================================================
# ⚠️ TABELLA FLAG VITALI (MACOS PROCESSES)
# ==============================================================================
# | COMANDO | FLAG        | SIGNIFICATO                                   |
# |---------|-------------|-----------------------------------------------|
# | ps      | -A (o ax)   | Tutti i processi (All).                       |
# | ps      | -o ...      | Output personalizzato (pid,%cpu,comm).        |
# | ps      | -r          | Ordina per CPU (Specifico Mac).               |
# | top     | -l 1        | Logging mode (Batch). 1 Campione.             |
# | top     | -o cpu      | Ordina per CPU.                               |
# | kill    | -9          | Force Kill (SigKill).                         |
# | kill    | -15         | Terminate (SigTerm - Default).                |
# | $$      | Var         | PID dello script corrente.                    |
# | $!      | Var         | PID dell'ultimo processo background.          |

echo "----------------------------------------------------------------"
echo "Tutorial Processi Completato."

# ==============================================================================
# GESTIONE PID, PPID E IDENTIFICATIVI PROCESSI
# ==============================================================================

# 1. TROVARE I PID (Process ID)
# ------------------------------------------------------------------------------
# Mostra tutti i processi del sistema con dettagli (standard)
ps aux

# Mostra i processi dell'utente corrente
ps -u $USER

# Trovare il PID di un processo conoscendo il nome (es: 'bash')
pgrep bash

# Trovare PID e mostrare anche il nome del comando
pidof bash

# Mostra la gerarchia (chi ha generato chi): PID e PPID (Parent PID)
ps -efj


# 2. IDENTIFICATIVI SPECIALI ($$, $!, $PPID)
# ------------------------------------------------------------------------------
# Il PID dello script stesso che sta girando
echo "Il mio PID è: $$"

# Il PID dell'ultimo processo lanciato in background (&)
sleep 10 &
echo "Il PID del processo in background è: $!"

# Il PID del processo padre (la shell che ha lanciato lo script)
echo "Il PID di mio padre è: $PPID"


# 3. TERMINARE I PROCESSI (kill)
# ------------------------------------------------------------------------------
# Invia il segnale di default (SIGTERM - 15): Chiede gentilmente di chiudere
kill 1234

# Invia il segnale di chiusura forzata (SIGKILL - 9): Chiude istantaneamente
kill -9 1234

# Chiudi tutti i processi che hanno un certo nome
pkill -9 chrome


# 4. MONITORAGGIO DINAMICO
# ------------------------------------------------------------------------------
# Visualizzazione interattiva (NI=nice, PRI=priorità, RES=memoria reale)
top

# Monitora un PID specifico e aggiorna ogni secondo
top -p 1234


# ==============================================================================
# 💡 SUGGERIMENTI PER L'ESAME (SCENARI PRATICI)
# ==============================================================================

# --- SCENARIO 1: "Uccidi il processo più vecchio di un certo utente" ---
# ps -u $USER -o pid,start_time,comm --sort=start_time | head -n 2

# --- SCENARIO 2: "Verifica se un processo è ancora attivo nello script" ---
# if ps -p $PID > /dev/null; then
#    echo "Il processo $PID è ancora in esecuzione"
# fi

# --- SCENARIO 3: "Trovare processi 'Zombie' (defunti)" ---
# Un processo zombie ha lo stato 'Z'. Non può essere killato (è già morto), 
# bisogna killare il suo PADRE.
# ps js | grep 'Z'

# --- SCENARIO 4: "Relazione tra PID e File Descriptors" ---
# Se vuoi vedere quali file sta usando un PID:
# ls -l /proc/$PID/fd   (Solo su Linux)
# lsof -p $PID           (Su MacOS e Linux)

# --- NOTA SUI SEGNALI ---
# 1  (SIGHUP): Riavvia/Rilegge configurazione
# 2  (SIGINT): CTRL+C (Interrompe da tastiera)
# 9  (SIGKILL): Forza la chiusura (da usare come ultima spiaggia)
# 15 (SIGTERM): Chiusura pulita (permette al programma di salvare i dati)