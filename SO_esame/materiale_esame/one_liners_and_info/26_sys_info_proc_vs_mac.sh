#!/bin/bash

# ==============================================================================
# 26. IL FILESYSTEM VIRTUALE /proc (LINUX) E ALTERNATIVE MACOS
# ==============================================================================
# FONTE: Appunti lezioni + Adattamento per macOS (BSD/Mach Kernel)
#
# ATTENZIONE - CONCETTO FONDAMENTALE:
# - Su LINUX: Il kernel espone tutto come file dentro la cartella /proc.
# - Su MACOS: La cartella /proc NON ESISTE. Si usano comandi specifici
#   (sysctl, vm_stat, top, ps, vmmap) per chiedere info al kernel.
#
# Questo script mostra COSA CERCARE (Linux) e COME TROVARLO (macOS).
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. INFORMAZIONI HARDWARE E SISTEMA (CPU, RAM, KERNEL)
# ------------------------------------------------------------------------------

# --- A. CPU INFO ---
# Linux: /proc/cpuinfo
# Contiene: Modello, core, cache, flags.
# macOS Equivalente: sysctl
echo "--- CPU INFO (Mac vs Linux) ---"
sysctl -n machdep.cpu.brand_string  # Nome modello CPU
sysctl -a | grep machdep.cpu        # Dettagli completi (core, cache)


# --- B. MEMORIA RAM ---
# Linux: /proc/meminfo
# Contiene: Memoria totale, libera, buffer, swap.
# macOS Equivalente: vm_stat e sysctl
echo "--- MEMORY INFO ---"
sysctl hw.memsize                   # Memoria Fisica Totale (in byte)
vm_stat                             # Statistiche dettagliate (pagine libere, attive)
# Nota: Su Mac le pagine sono spesso di 4096 o 16384 byte. vm_stat le mostra in n. pagine.


# --- C. VERSIONE KERNEL ---
# Linux: /proc/version
# macOS Equivalente: uname o sw_vers
echo "--- KERNEL VERSION ---"
uname -a                            # Info kernel (Darwin Kernel Version...)
sw_vers                             # Info sistema operativo (macOS Sequoia/Sonoma...)


# --- D. UPTIME (TEMPO ATTIVITÀ) ---
# Linux: /proc/uptime (secondi totali e idle time)
# macOS Equivalente: uptime o sysctl
echo "--- UPTIME ---"
uptime                              # Leggibile (es: up 2 days)
sysctl -n kern.boottime             # Timestamp preciso dell'ultimo avvio


# --- E. LOAD AVERAGE (CARICO SISTEMA) ---
# Linux: /proc/loadavg
# 1.00 = CPU occupata al 100% (su singolo core).
# > 1.00 = Coda di processi (CPU satura).
# < 1.00 = CPU parzialmente libera.
# macOS Equivalente: sysctl o uptime
echo "--- LOAD AVERAGE ---"
sysctl -n vm.loadavg
# Output Mac: { 1.55 1.20 1.05 } (Media a 1, 5, 15 minuti)


# ------------------------------------------------------------------------------
# 2. INFORMAZIONI SUI PROCESSI (/proc/PID vs PS/LSOF)
# ------------------------------------------------------------------------------
# Su Linux, ogni processo ha una cartella /proc/1234.
# Su Mac, devi usare i tool da riga di comando per estrarre quelle info.
# Supponiamo di analizzare la shell corrente (PID $$).

PID=$$
echo "Analisi del processo corrente PID: $PID"


# --- A. COMANDO DI AVVIO (CMDLINE) ---
# Linux: /proc/PID/cmdline
# macOS Equivalente: ps
ps -p $PID -o command


# --- B. VARIABILI D'AMBIENTE (ENVIRON) ---
# Linux: /proc/PID/environ
# macOS Equivalente: ps con flag 'E' (Environment)
ps -p $PID -wwE


# --- C. FILE DESCRIPTORS APERTI (FD) ---
# Linux: /proc/PID/fd/ (contiene 0, 1, 2 e altri link)
# macOS Equivalente: lsof (List Open Files) - FONDAMENTALE
lsof -p $PID
# Cerca le righe:
# FD 0 = Standard Input
# FD 1 = Standard Output
# FD 2 = Standard Error


# --- D. DIRECTORY CORRENTE (CWD) ---
# Linux: /proc/PID/cwd
# macOS Equivalente: lsof filtrato
lsof -p $PID | grep "cwd"


# --- E. ESEGUIBILE (EXE) ---
# Linux: /proc/PID/exe (link al file binario)
# macOS Equivalente: lsof filtrato per testo (txt)
lsof -p $PID | grep "txt" | grep -v "dylib"


# ------------------------------------------------------------------------------
# 3. STATISTICHE PROCESSO E MEMORIA (MAPS/STAT)
# ------------------------------------------------------------------------------

# --- A. MAPPA MEMORIA (MAPS / SMAPS) ---
# Linux: /proc/PID/maps (librerie, stack, heap) e /proc/PID/smaps (dettaglio paginazione)
# macOS Equivalente: vmmap (Tool potentissimo specifico di Mac!)
# vmmap $PID
# (Nota: vmmap richiede privilegi o di essere proprietario del processo)

# I campi di SMAPS (Linux) spiegati per l'esame:
# - Rss (Resident Set Size): Quanta RAM fisica sta usando davvero.
# - Pss (Proportional Set Size): Rss diviso tra i processi che condividono le librerie.
# - Shared_Clean: Pagine condivise (es. librerie C) non modificate.
# - Private_Dirty: Pagine scritte solo da questo processo (es. dati utente).
#   *IMPORTANTE*: Se Private_Dirty cresce sempre, hai un Memory Leak!
# - Swap: Pagine spostate su disco perché la RAM è piena.


# --- B. STATO E STATISTICHE (STAT) ---
# Linux: /proc/PID/stat (sequenza di numeri illeggibili senza legenda)
# macOS Equivalente: ps con output formattato
# Legenda stati (comune a Linux/Mac):
# R = Running (in esecuzione)
# S = Sleeping (in attesa di un evento, meno di 20 secondi)
# I = Idle (Sleeping da più di 20 secondi - Tipico di Mac/BSD)
# Z = Zombie (Terminato ma padre non ha letto exit code)
# T = Stopped (Fermato da segnale, es. Ctrl+Z)
# D = Uninterruptible Sleep (Attesa disco - Pericoloso se bloccato qui)

echo "--- STATO PROCESSO ---"
ps -p $PID -o pid,state,ppid,comm,ucomm,lstart,rss,vsz

# Spiegazione Colonne Output Mac:
# PID   : ID Processo
# STATE : R, S, I, Z, T...
# PPID  : Parent PID (chi l'ha lanciato)
# COMM  : Percorso completo comando
# UCOMM : Nome breve comando
# LSTART: Data/Ora avvio preciso
# RSS   : Memoria Fisica (Real Memory) in KB
# VSZ   : Memoria Virtuale in KB


# ------------------------------------------------------------------------------
# 4. TABELLA DI CONVERSIONE RAPIDA (DA IMPARARE A MEMORIA)
# ------------------------------------------------------------------------------
# Se il prof chiede "Dove trovi X?", rispondi: "Su Linux in /proc/X, su Mac uso Y".

# | OBIETTIVO                  | LINUX (/proc)        | MACOS (Comando)     |
# |----------------------------|----------------------|---------------------|
# | Info CPU                   | /proc/cpuinfo        | sysctl machdep.cpu  |
# | Info RAM                   | /proc/meminfo        | vm_stat             |
# | Info Kernel                | /proc/version        | uname -a            |
# | Carico Sistema             | /proc/loadavg        | uptime / sysctl     |
# | Linea di Comando Processo  | /proc/PID/cmdline    | ps -p PID -o command|
# | Variabili Ambiente         | /proc/PID/environ    | ps -p PID -wwE      |
# | File Aperti                | /proc/PID/fd/        | lsof -p PID         |
# | Mappa Memoria              | /proc/PID/maps       | vmmap PID           |
# | Eseguibile                 | /proc/PID/exe        | lsof -p PID         |
# | Cartella di lavoro         | /proc/PID/cwd        | lsof -p PID         |


# ==============================================================================
# 💡 SUGGERIMENTI E SCENARI D'ESAME
# ==============================================================================

# --- SCENARIO 1: "Trova il processo che consuma più memoria reale (RSS)" ---
# Su Linux guarderesti /proc, su Mac usa ps:
# ps -A -o pid,rss,comm | sort -n -k2 | tail -n 5
# (Mostra i top 5 processi per consumo RAM fisica)

# --- SCENARIO 2: "Analisi Zombie" ---
# Cerca processi con stato 'Z' o 'Z+'
# ps -A -o pid,state,ppid,command | grep "Z"

# --- SCENARIO 3: "Capire i limiti di un processo" ---
# Su Linux guarderesti /proc/PID/limits.
# Su Mac non c'è un file diretto, ma puoi dedurlo dai limiti della shell corrente
# (ulimit -a) che vengono ereditati dai figli.

# --- DETTAGLIO: THREADS ---
# Linux: /proc/PID/task/ (ogni thread è una cartella).
# Mac: ps -M -p PID (mostra i thread del processo).