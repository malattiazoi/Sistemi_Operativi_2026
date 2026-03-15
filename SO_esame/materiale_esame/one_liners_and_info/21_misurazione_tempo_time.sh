#!/bin/bash

# ==============================================================================
# 21. TIME MASTER CLASS: PROFILING E BENCHMARK (MACOS / BSD)
# ==============================================================================
# OBIETTIVO:
# Misurare quanto tempo impiega un comando, quanta CPU usa e quanta RAM consuma.
#
# LA TRAPPOLA DI BASH (SHELL KEYWORD vs BINARY):
# Esistono DUE comandi 'time':
# 1. 'time' (Bash Builtin): Semplice, mostra solo Real/User/Sys.
# 2. '/usr/bin/time' (System Binary): Potente, supporta flag come -l (RAM).
#
# DIFFERENZE CRITICHE MACOS (BSD) vs LINUX (GNU):
# - Linux: Usa '/usr/bin/time -v' (Verbose) per vedere la RAM.
# - macOS: Usa '/usr/bin/time -l' (Long). Il flag -v NON ESISTE.
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. TIME BASE (BASH BUILTIN)
# ------------------------------------------------------------------------------
# Questo è quello che succede se scrivi solo 'time'.
# È veloce, ma povero di dettagli.

echo "--- 1. BASH BUILTIN TIME ---"

# Misuriamo un comando che dorme per 1 secondo
echo "Eseguo: time sleep 1"
time sleep 1

# Output tipico:
# real    0m1.005s  <-- Tempo totale passato (Orologio a muro)
# user    0m0.001s  <-- Tempo CPU speso nel codice del programma
# sys     0m0.002s  <-- Tempo CPU speso dal Kernel (chiamate di sistema)


# ------------------------------------------------------------------------------
# 2. INTERPRETAZIONE: REAL vs USER vs SYS
# ------------------------------------------------------------------------------
# Capire dove sta il collo di bottiglia.

echo "----------------------------------------------------------------"
echo "--- 2. ANALISI COLLI DI BOTTIGLIA ---"

# CASO A: I/O BOUND (Lento per colpa del disco/attesa)
# Real è alto, ma User e Sys sono bassi.
# Significa che la CPU non ha lavorato, ha solo aspettato.
echo "Simulazione I/O Bound (Sleep):"
time sleep 2

# CASO B: CPU BOUND (Lento per calcoli intensivi)
# User è quasi uguale a Real.
# La CPU ha lavorato tutto il tempo.
echo "Simulazione CPU Bound (Calcolo matematico):"
# Calcoliamo somma numeri fino a 500000
time awk 'BEGIN { for(i=0;i<500000;i++) sum+=i; print sum }' > /dev/null

# CASO C: SYS BOUND (Chiamate di sistema pesanti)
# Sys è alto. Tante letture disco, allocazioni memoria, fork.
echo "Simulazione Sys Bound (Listing ricorsivo pesante):"
# ls -R su /usr/bin genera tante chiamate al filesystem
time ls -R /usr/bin > /dev/null 2>&1


# ------------------------------------------------------------------------------
# 3. IL VERO POTERE: /usr/bin/time -l (SOLO MACOS)
# ------------------------------------------------------------------------------
# Se l'esame chiede: "Quanta memoria RAM (Resident Set Size) ha usato il processo?"
# DEVI usare il binario di sistema con il flag -l (elle minuscola).

echo "----------------------------------------------------------------"
echo "--- 3. DETTAGLI RISORSE (-l) ---"

# Creiamo un carico che usa memoria (sort di un file grande)
# Generiamo 500k numeri casuali
seq 1 500000 > numeri.txt

echo "Analisi memoria comando 'sort':"
/usr/bin/time -l sort numeri.txt > /dev/null

# SPIEGAZIONE OUTPUT CRITICO (-l):
# maximum resident set size:  La RAM massima occupata (in Byte).
# voluntary context switches: Quante volte il processo ha ceduto la CPU (attesa IO).
# involuntary context switches: Quante volte il sistema ha tolto la CPU (multitasking).
# page reclaims / faults:     Attività della memoria virtuale.


# ------------------------------------------------------------------------------
# 4. FORMATO POSIX (-p)
# ------------------------------------------------------------------------------
# Se devi parsare l'output di time con uno script, usa -p.
# Garantisce un formato standard:
# real 1.00
# user 0.00
# sys  0.00

echo "----------------------------------------------------------------"
echo "--- 4. FORMATO PORTABILE (-p) ---"
/usr/bin/time -p sleep 1


# ------------------------------------------------------------------------------
# 5. SALVARE L'OUTPUT DI TIME SU FILE (REDIREZIONE)
# ------------------------------------------------------------------------------
# TRAPPOLA: 'time' scrive su STDERR (canale 2), non su STDOUT (canale 1).
# Sbagliato: time cmd > log.txt (Salva l'output del comando, ma il tempo va a video).
# Corretto: (time cmd) 2> log.txt

echo "----------------------------------------------------------------"
echo "--- 5. REDIREZIONE SU LOG ---"

LOG_FILE="benchmark.log"

echo "Eseguo benchmark salvando su $LOG_FILE..."
# Le parentesi servono a raggruppare time e il comando, per redirigere tutto lo stderr
(time sort numeri.txt > /dev/null) 2> "$LOG_FILE"

echo "Contenuto del log:"
cat "$LOG_FILE"


# ------------------------------------------------------------------------------
# 6. BENCHMARKING INTERNO (DATE vs TIME)
# ------------------------------------------------------------------------------
# Se devi misurare solo una PARTE dello script, 'time' è scomodo.
# Meglio usare la differenza tra due 'date +%s' (visto nel File 07).

echo "----------------------------------------------------------------"
echo "--- 6. BENCHMARKING INTERNO ---"

START=$(date +%s)
sleep 1
END=$(date +%s)
DIFF=$((END - START))
echo "Tempo misurato internamente: $DIFF secondi."


# ==============================================================================
# 🧩 SCENARI D'ESAME REALI
# ==============================================================================

echo "----------------------------------------------------------------"
echo "--- SCENARI D'ESAME ---"

# SCENARIO A: MISURARE UTILIZZO RAM
# "Trova quanta RAM massima usa lo script my_script.sh"
# Soluzione:
# /usr/bin/time -l ./my_script.sh 2>&1 | grep "maximum resident set size"

# SCENARIO B: ORDINARE COMANDI PER VELOCITÀ
# "Verifica se è più veloce grep o awk per cercare una stringa"
echo "Test Grep:"
time grep "999" numeri.txt > /dev/null
echo "Test Awk:"
time awk '/999/' numeri.txt > /dev/null

# SCENARIO C: CAPIRE PERCHÉ È LENTO
# Se Real >> (User + Sys), il problema è esterno (Rete lenta, Disco lento, Sleep).
# Se Real ~= (User + Sys), il problema è il codice (CPU al 100%).


# ==============================================================================
# ⚠️ TABELLA DIFFERENZE (TIME)
# ==============================================================================
# | COMANDO       | FUNZIONE                                              |
# |---------------|-------------------------------------------------------|
# | time          | Bash Builtin. Output semplice (Real/User/Sys).        |
# | /usr/bin/time | System Binary. Output standard BSD.                   |
# | ... -l        | (Solo Binary) Mostra RAM, IO, Context Switches.       |
# | ... -p        | (Solo Binary) Output POSIX standard per parsing.      |
# | ... -v        | (GNU Linux) Verbose. SU MACOS NON ESISTE (USA -l).    |

# Pulizia
rm -f numbers.txt benchmark.log numeri.txt
echo "----------------------------------------------------------------"
echo "Tutorial Time Completato."

# ==============================================================================
# 21. GUIDA COMPLETA AL COMANDO 'time' - PERFORMANCE E BENCHMARK
# ==============================================================================
# FONTE: Appunti lezioni + Integrazioni Exam Kit (Specifiche MacOS)
# DESCRIZIONE:
# Il comando `time` misura la durata dell'esecuzione di un comando e l'utilizzo
# delle risorse di sistema. È fondamentale per capire se un processo è lento
# perché calcola troppo (CPU bound) o perché aspetta il disco/rete (I/O bound).
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. I TRE VALORI FONDAMENTALI (Dal file originale)
# ------------------------------------------------------------------------------
# Quando lanci `time comando`, ottieni tre metriche. Capirle è domanda d'esame.

time sleep 2

# Output tipico:
# real    0m2.005s  (Tempo di Orologio / Wall-Clock)
# user    0m0.001s  (Tempo CPU Utente)
# sys     0m0.002s  (Tempo CPU Kernel)

# --- DETTAGLIO ---
# 1. REAL ("Wall-Clock Time")
#    - È il tempo che passa realmente sul tuo orologio da polso.
#    - Include TUTTO: calcoli, attesa del disco, attesa della rete, sleep.
#    - È ciò che percepisce l'utente finale.

# 2. USER (CPU Time - User Mode)
#    - È il tempo che la CPU ha passato eseguendo ESPLICITAMENTE il codice
#      del tuo programma (calcoli matematici, cicli, stringhe).
#    - Se il programma fa `sleep 10`, questo valore NON sale.

# 3. SYS (CPU Time - Kernel Mode)
#    - È il tempo che la CPU ha passato a servire le richieste del tuo programma
#      (System Calls): leggere file, allocare RAM, gestire la rete.

# ------------------------------------------------------------------------------
# 2. INTERPRETAZIONE DEI DATI (Scenario Esame)
# ------------------------------------------------------------------------------

# CASO A: REAL è molto più grande di USER + SYS
# (real >> user + sys)
# Significato: Il programma è "I/O Bound" o sta dormendo.
# La CPU non sta lavorando, il programma sta aspettando qualcosa (scaricamento file,
# lettura disco lento, input utente).
# Esempio: `time sleep 5` -> real 5s, user 0s, sys 0s.

# CASO B: USER + SYS è circa uguale a REAL
# (real ≈ user + sys)
# Significato: Il programma è "CPU Bound".
# Sta usando la CPU al 100% per tutto il tempo (es. compressione video, calcolo hash).

# CASO C: USER + SYS è maggiore di REAL (Solo Multi-Core!)
# (user + sys > real)
# Significato: Il programma lavora in PARALLELO su più core.
# Se hai 4 core e lavorano tutti insieme per 1 secondo:
# Real = 1s, User = 4s.

# ------------------------------------------------------------------------------
# 3. SHELL KEYWORD vs BINARIO (CRITICO SU MACOS!)
# ------------------------------------------------------------------------------
# ATTENZIONE: Quando scrivi `time` nel terminale, stai usando il comando integrato
# nella shell (Bash o Zsh). È semplice e veloce, ma ha poche opzioni.

# Per usare il VERO comando time (che su MacOS è BSD time), devi scrivere:
# /usr/bin/time [opzioni] comando

# Esempio pratico su MacOS per vedere l'uso della memoria (Flag -l):
# /usr/bin/time -l ls -R /etc > /dev/null

# L'opzione -l (elle) su MacOS mostra dettagli preziosi come:
# - maximum resident set size (Memoria RAM massima usata)
# - page faults (Errori di pagina / accesso memoria)
# - voluntary context switches (Quante volte ha ceduto la CPU)

# ------------------------------------------------------------------------------
# 4. SALVARE L'OUTPUT DI TIME SU FILE (Trick d'esame)
# ------------------------------------------------------------------------------
# `time` stampa il risultato sullo "Standard Error" (stderr), non su stdout.
# Una pipe normale non lo cattura!

# SBAGLIATO (Il file sarà vuoto o conterrà solo l'output di ls):
# time ls > log_tempo.txt

# GIUSTO (Raggruppa il comando e ridirigi stderr):
# (time ls) 2> log_tempo.txt

# GIUSTO CON FORMATO POSIX (Opzione -p):
# (time -p ls) 2> log_tempo.txt
# (Crea un output più facile da leggere per gli script automatici).


# ==============================================================================
# 📊 TABELLA OPZIONI (FLAG) - MACOS / BSD
# ==============================================================================
# Nota: Le opzioni valgono per `/usr/bin/time`, NON per il `time` della shell.

# | FLAG | DESCRIZIONE DETTAGLIATA                                         |
# |------|-----------------------------------------------------------------|
# | -p   | POSIX mode. Output standard su 3 righe (real, user, sys).       |
# | -l   | (SOLO MACOS/BSD) Long format. Mostra memoria, I/O e page fault. |
# | -a   | Append. Se usato con -o, aggiunge al file invece di sovrascrivere.|
# | -o F | Output file. Scrive le statistiche nel file F invece che stderr.|

# NOTA DIFFERENZA LINUX (GNU):
# Su Linux GNU, esiste l'opzione `-v` (verbose) che fa quello che `-l` fa su Mac.
# Su Linux GNU, esiste `-f` per formattare la stringa. Su Mac NO.

# ==============================================================================
# 💡 SUGGERIMENTI E SCENARI PRATICI
# ==============================================================================

# --- SCENARIO 1: Benchmark di due comandi ---
# "Quale metodo è più veloce per trovare un file?"
# time find . -name "*.txt"
# time ls -R | grep ".txt"
# (Confronta il valore 'real').

# --- SCENARIO 2: Debugging script lento ---
# Se 'real' è alto ma 'user' è basso, controlla la rete o il disco.
# Se 'user' è alto, il codice è inefficiente nei calcoli.

# --- SCENARIO 3: Vedere quanta RAM usa uno script (Su Mac) ---
# /usr/bin/time -l ./mio_script_pesante.sh
# Cerca la riga "maximum resident set size".
# Nota: Il valore è solitamente in Byte.

# --- CURIOSITÀ ---
# Il comando `time` integrato in ZSH (shell di default su Mac moderni)
# dà un output diverso da quello di BASH.
# ZSH:  "0.00s user 0.00s system 85% cpu 0.005 total"
# BASH: "real 0m0.005s ..."
# Non spaventarti se vedi formati diversi, i numeri significano la stessa cosa.