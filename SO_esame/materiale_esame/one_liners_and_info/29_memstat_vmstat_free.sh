#!/bin/bash

# ==============================================================================
# 29. MONITORAGGIO MEMORIA: VMSTAT (LINUX) vs VM_STAT (MACOS) E FREE
# ==============================================================================
# FONTE: Appunti lezioni + Adattamento macOS
#
# CONCETTI CHIAVE:
# 1. LINUX usa 'free' e 'vmstat -s'.
# 2. MACOS usa 'vm_stat' e 'sysctl'.
#
# PROBLEMA ESAME SU MAC:
# Se il prof chiede "Lancia il comando free", su Mac riceverai "command not found".
# Questo script ti insegna come ottenere gli stessi dati.
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. VM_STAT (LA VERSIONE MACOS DI VMSTAT)
# ------------------------------------------------------------------------------
# Sintassi: vm_stat [intervallo]
# DIFFERENZA CRITICA:
# - Linux: Mostra i valori in KILOBYTE (KB).
# - macOS: Mostra i valori in PAGINE (Pages).
#
# Per leggere vm_stat su Mac, devi sapere la dimensione della pagina (solitamente 4096 byte).
# Formula: (Numero Pagine * 4096) / 1024 / 1024 = Megabyte (MB).

echo "--- 1. STATISTICHE MEMORIA VIRTUALE (vm_stat) ---"
vm_stat

# Esempio di monitoraggio continuo (aggiorna ogni 1 secondo, ferma con Ctrl+C)
# vm_stat 1


# ------------------------------------------------------------------------------
# 2. SIMULARE IL COMANDO 'free' SU MACOS
# ------------------------------------------------------------------------------
# Il comando 'free' di Linux mostra una tabella con Total, Used, Free, Buff/Cache.
# Su Mac non esiste, ma possiamo calcolarlo usando 'sysctl' e 'vm_stat'.

echo "--- 2. SIMULAZIONE 'free' (RAM FISICA E SWAP) ---"

# Memoria Fisica Totale (RAM Installata)
echo "RAM Totale Installata (Bytes):"
sysctl hw.memsize

# Swap Usato (Spazio su disco usato come RAM)
echo "Swap Usato (Bytes):"
sysctl vm.swapusage

# Pagine Libere (Free) vs Attive
# Nota: Su Mac, "Pages free" sembra basso perché macOS usa quasi tutta la RAM
# per la cache dei file (File-backed pages). È normale.
vm_stat | grep "Pages free"
vm_stat | grep "Pages active"


# ------------------------------------------------------------------------------
# 3. SPIEGAZIONE DETTAGLIATA DELL'OUTPUT (CONCETTI TEORICI)
# ------------------------------------------------------------------------------
# Le seguenti definizioni provengono dal tuo file sorgente (Linux `vmstat -s`),
# qui tradotte e spiegate nel contesto di un esame.

# --- MEMORIA RAM ---
# Total Memory: Tutta la RAM fisica installata.
# Used Memory: RAM occupata da processi + sistema.
# Free Memory: RAM completamente vuota (spesso poca, ed è un bene!).
# Active Memory: Dati usati recentemente, non possono essere rimossi.
# Inactive Memory: Dati non usati da un po'. Se serve spazio, il sistema li cancella e usa questa RAM.
# Buffer/Cache: RAM usata per velocizzare il disco. Se apri un file, finisce qui.

# --- SWAP (MEMORIA VIRTUALE SU DISCO) ---
# Total Swap: Spazio su disco riservato per le emergenze.
# Used Swap: Quanto ne stiamo usando. Se > 0, la RAM è piena e il PC rallenta.
# Swap Cache: Dati che sono sia in RAM che in Swap (ottimizzazione).

# --- CPU TICKS (TEMPO PROCESSORE) ---
# Un "Tick" è un'unità di tempo minima del processore.
# User CPU: Tempo speso per i tuoi programmi (Browser, VSCode).
# System CPU: Tempo speso per il Kernel (Gestione dischi, rete).
# Idle CPU: Tempo in cui la CPU non fa nulla (se alto, il PC è scarico).
# Nice CPU: Tempo speso per processi a bassa priorità.
# IO-Wait: Tempo speso ASPETTANDO il disco. Se alto, il disco è il collo di bottiglia.
# Steal Time: Tempo rubato dall'Hypervisor (solo su Macchine Virtuali).

# --- PAGING vs SWAPPING (DOMANDA CLASSICA) ---
# Paged In: Dati letti dal disco alla RAM (Normale quando apri programmi).
# Paged Out: Dati scritti dalla RAM al disco (Normale salvataggio file).
# Swapped In: Dati recuperati dallo Swap (RAM piena -> Rallentamento).
# Swapped Out: Dati buttati fuori dalla RAM nello Swap (RAM piena -> Rallentamento).
# SU MACOS: vm_stat mostra "Pageouts". Se sono alti, stai usando lo swap o salvando file.

# --- EVENTI DI SISTEMA ---
# Interrupts: Segnali hardware (es. muovi il mouse, arriva pacchetto rete).
# Context Switches: La CPU passa da un processo all'altro (Multitasking).
# Forks: Nuovi processi creati (ogni comando che lanci è una fork).


# ------------------------------------------------------------------------------
# 4. TRUCCO PER L'ESAME: LEGGERE VM_STAT IN MEGABYTE
# ------------------------------------------------------------------------------
# vm_stat di default è illeggibile (numeri enormi di pagine).
# Questo comando (usando perl o awk) lo converte in MB al volo. Copialo se serve.

echo "--- VM_STAT LEGGIBILE (MB) ---"
vm_stat | perl -ne '/page size of (\d+)/; $s=$1; print "$1 " if /(\D+):\s+(\d+)/ && printf("%-20s %10.0f MB\n", $1, $2*$s/1048576);'


# ==============================================================================
# 💡 SUGGERIMENTI E SCENARI D'ESAME
# ==============================================================================

# --- SCENARIO 1: "Il sistema è lento, controlla se sta swappando" ---
# 1. Lancia: sysctl vm.swapusage
# 2. Guarda "used". Se è 0.00M, tutto ok. Se è alto (es. 2048M), manca RAM.
# 3. Alternativa: vm_stat 1 (guarda se la colonna "pageout" continua a salire).

# --- SCENARIO 2: "Quanta memoria libera ho DAVVERO?" ---
# Su Linux: Guarderesti la colonna "available" di `free`.
# Su Mac: Somma "Pages free" + "Pages inactive" + "File-backed pages".
# La memoria "Inactive" è considerata libera perché il sistema può riprenderla subito.

# --- SCENARIO 3: "Analizza i Context Switches" ---
# Se il numero di Context Switches (in vmstat o top) è altissimo (>100.000/sec),
# un processo sta impazzendo o ci sono troppi thread attivi.
# Su Mac usa: top -l 1 | grep "Context switches"

# --- SCENARIO 4: "Differenza Buffer vs Cache" ---
# Buffers: Metadati del filesystem (dove sono i file, permessi).
# Cache: Il contenuto vero e proprio dei file.
# Su Mac sono spesso raggruppati in "File-backed pages".