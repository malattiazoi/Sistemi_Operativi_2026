#!/bin/bash

# ==============================================================================
# 23. GUIDA COMPLETA A 'ulimit' (GESTIONE RISORSE DI SISTEMA)
# ==============================================================================
# FONTE: Appunti lezioni + Integrazioni Exam Kit (Specifiche MacOS)
# DESCRIZIONE:
# `ulimit` è un comando built-in della shell che controlla le risorse disponibili
# per la shell corrente e per i processi da essa avviati.
# Serve a prevenire che un singolo processo saturi la CPU, la RAM o i descrittori
# dei file, bloccando l'intero sistema.
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. CONCETTI BASE: SOFT LIMIT vs HARD LIMIT
# ------------------------------------------------------------------------------
# Ogni risorsa ha due limiti associati. Capire la differenza è domanda d'esame.

# SOFT LIMIT (-S):
# È il limite "attuale" che il kernel impone al processo.
# L'utente può ALZARE il soft limit fino al valore dell'Hard Limit.
# L'utente può ABBASSARE il soft limit a piacimento.

# HARD LIMIT (-H):
# È il tetto massimo invalicabile.
# L'utente normale può solo ABBASSARE il proprio Hard Limit (irreversibile).
# Solo l'utente ROOT può alzare un Hard Limit.

# Visualizzare TUTTI i limiti correnti (Soft)
ulimit -a

# Visualizzare TUTTI i limiti massimi (Hard)
ulimit -H -a


# ------------------------------------------------------------------------------
# 2. LIMITARE I FILE APERTI (FLAG -n) - CRITICO SU MACOS
# ------------------------------------------------------------------------------
# L'errore "Too many open files" è classico quando si lavora con server o socket.
# Su MacOS, il valore di default è spesso basso (es. 256 o 4864).

# Mostra il limite attuale di file descriptor
ulimit -n

# Prova a impostare il limite a 1024 (Soft Limit)
ulimit -n 1024

# Impostare Hard Limit (Se sei root o se il sistema lo permette)
ulimit -H -n 4096


# ------------------------------------------------------------------------------
# 3. PROTEZIONE DA PROCESSI INFINTI (FLAG -u)
# ------------------------------------------------------------------------------
# Controlla il numero massimo di processi/thread che l'utente può creare.
# Utile per proteggersi dalle "Fork Bomb" (processi che si clonano all'infinito).

# Mostra il limite processi utente
ulimit -u

# Imposta un limite di sicurezza (es. 100 processi max per questa shell)
ulimit -u 100


# ------------------------------------------------------------------------------
# 4. DIMENSIONE FILE E MEMORIA (FLAG -f, -v)
# ------------------------------------------------------------------------------
# Impedire a uno script di riempire il disco con log giganti o mangiare tutta la RAM.

# -f : Dimensione massima file creati (in blocchi da 1KB)
# Se uno script prova a scrivere oltre questo limite, riceverà errore "File too large".
ulimit -f 10240

# -v : Memoria virtuale massima (in KB)
# Se un processo chiede più RAM (malloc), il sistema risponderà picche.
ulimit -v 1048576


# ------------------------------------------------------------------------------
# 5. CORE DUMPS (FLAG -c) - DEBUGGING
# ------------------------------------------------------------------------------
# Un "core dump" è un file che contiene la memoria di un programma quando crasha.
# Di default è spesso 0 (disabilitato) per risparmiare spazio.

# Abilitare i core dump (dimensione illimitata) per analizzare crash con GDB/LLDB
ulimit -c unlimited


# ==============================================================================
# ⚠️ ATTENZIONE: PERSISTENZA SU MACOS vs LINUX
# ==============================================================================
# Le modifiche fatte con `ulimit` valgono SOLO per la shell corrente.
# Se chiudi il terminale, i limiti tornano quelli di default.

# SU LINUX (Metodo Classico citato nel file):
# Si modifica /etc/security/limits.conf aggiungendo:
# username soft nofile 4096
# username hard nofile 65535

# SU MACOS (Metodo Esame):
# MacOS NON usa limits.conf (o lo ignora).
# Per rendere una modifica persistente per il tuo utente, devi aggiungere
# il comando al tuo file di configurazione della shell.

# Aggiungi questo alla fine di ~/.zshrc (se usi Zsh) o ~/.bash_profile (se usi Bash):
# echo "ulimit -n 4096" >> ~/.zshrc

# Se devi modificare i limiti di SISTEMA (quelli massimi globali), su Mac si usa 'sysctl'
# o si creano file .plist in /Library/LaunchDaemons (Argomento avanzato).


# ==============================================================================
# 📊 TABELLA OPZIONI (FLAG)
# ==============================================================================
# | FLAG | RISORSA (RESOURCE)                  | UNITÀ DI MISURA             |
# |------|-------------------------------------|-----------------------------|
# | -a   | All (Mostra tutto)                  | N/A                         |
# | -H   | Hard Limit (Modifica il tetto max)  | N/A                         |
# | -S   | Soft Limit (Modifica il lim. curr)  | N/A                         |
# | -n   | File Descriptors (File Aperti)      | Numero intero (es. 1024)    |
# | -u   | User Processes (Max Processi)       | Numero intero               |
# | -f   | File Size (Max dim. file scrittura) | Blocchi da 1024 byte (KB)   |
# | -v   | Virtual Memory (Max RAM virtuale)   | KB                          |
# | -c   | Core Dump Size                      | Blocchi (0 = disabilitato)  |
# | -t   | CPU Time (Tempo CPU max in sec)     | Secondi                     |
# | -s   | Stack Size (Dimensione Stack)       | KB                          |
# | -l   | Locked Memory (Mem. bloccata RAM)   | KB                          |


# ==============================================================================
# 💡 SUGGERIMENTI E SCENARI D'ESAME
# ==============================================================================

# --- SCENARIO 1: "Simula un crash per memoria esaurita" ---
# Se devi testare come il tuo script gestisce gli errori di memoria:
# ulimit -v 5000  (Limita a 5MB circa)
# ./mio_script_pesante.sh
# Lo script dovrebbe fallire con "Out of memory" o segfault.

# --- SCENARIO 2: "Il server web non parte: Too many open files" ---
# Diagnosi:
# 1. Controlla il limite attuale: ulimit -n
# 2. Controlla quanti file ha aperti il processo: lsof -p PID | wc -l
# 3. Se file aperti > ulimit, devi alzare il limite: ulimit -n 4096

# --- SCENARIO 3: "Fork Bomb Protection" ---
# Una fork bomb è un comando che si replica esponenzialmente: :(){ :|:& };:
# Se la lanci senza limiti, il Mac si blocca e devi forzare lo spegnimento.
# Difesa preventiva in esame:
# ulimit -u 200
# (Così al massimo crei 200 processi e il sistema rimane reattivo per killarli).

# --- TRUCCO MACOS: "ulimit: invalid argument" ---
# Se provi a impostare "ulimit -n 999999" su Mac, otterrai errore.
# Non puoi superare il limite imposto dal kernel (kern.maxfiles).
# Controlla il massimo assoluto del sistema con:
# sysctl kern.maxfiles