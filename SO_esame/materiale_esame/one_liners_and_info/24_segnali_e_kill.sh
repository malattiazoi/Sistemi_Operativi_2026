#!/bin/bash

# ==============================================================================
# 24. GUIDA COMPLETA AI SEGNALI (KILL, SIGINT, SIGTERM) - MACOS EDITION
# ==============================================================================
# DESCRIZIONE:
# I "Segnali" sono messaggi inviati ai processi per dire loro di fermarsi, 
# riavviarsi, o andare in pausa.
# Il comando `kill` non serve solo a "uccidere", ma a inviare uno qualsiasi 
# di questi segnali.
#
# AMBIENTE: macOS (BSD Userland).
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. SINTASSI FONDAMENTALE DI 'kill'
# ------------------------------------------------------------------------------
# kill [OPZIONI] PID

# Inviare il segnale di default (SIGTERM - 15) al processo con PID 1234
# È una richiesta gentile: "Per favore, chiuditi e salva i dati".
kill 1234

# Inviare un segnale specifico usando il NUMERO
kill -9 1234

# Inviare un segnale specifico usando il NOME (Consigliato su Mac!)
kill -s KILL 1234


# ------------------------------------------------------------------------------
# 2. I SEGNALI PIÙ IMPORTANTI (DA SAPERE A MEMORIA)
# ------------------------------------------------------------------------------

# SIGINT (Signal 2) - INTERRUPT
# --------------------------------------------------------
# Equivalente: Premere Ctrl+C nel terminale.
# Effetto: Interrompe il processo in primo piano.
# Gestibile: SÌ (Il programma può decidere di ignorarlo o chiedere conferma).
kill -s INT 1234


# SIGTERM (Signal 15) - TERMINATE (Default)
# --------------------------------------------------------
# Equivalente: Comando 'kill' senza opzioni.
# Effetto: Chiede al processo di terminare. Gli dà tempo di chiudere file e connessioni.
# Gestibile: SÌ (Il programma può pulire prima di uscire).
kill -s TERM 1234


# SIGKILL (Signal 9) - KILL (L'Arma Finale)
# --------------------------------------------------------
# Equivalente: "Staccare la spina".
# Effetto: Il Kernel rimuove istantaneamente il processo dalla memoria.
# Gestibile: NO (Il processo muore subito, senza salvare nulla e senza eseguire cleanup).
# DA USARE SOLO SE SIGTERM NON FUNZIONA.
kill -9 1234


# SIGHUP (Signal 1) - HANGUP
# --------------------------------------------------------
# Equivalente: Chiudere la finestra del terminale.
# Effetto: Di solito termina il processo.
# Uso avanzato: Molti servizi (es. Apache, Nginx) lo usano per "Ricaricare la configurazione"
# senza spegnersi (Soft Restart).
kill -s HUP 1234


# SIGQUIT (Signal 3) - QUIT
# --------------------------------------------------------
# Equivalente: Premere Ctrl+\ nel terminale.
# Effetto: Termina il processo e crea un "Core Dump" (file di debug della memoria).
# Utile se il prof chiede di analizzare perché un programma si è bloccato.
kill -s QUIT 1234


# ------------------------------------------------------------------------------
# 3. METTERE IN PAUSA E RIPRENDERE (STOP & CONT)
# ------------------------------------------------------------------------------
# Utile se un processo sta consumando troppa CPU e vuoi "congelarlo" un attimo
# senza chiuderlo.

# SIGSTOP (Signal 17, 19 o 23 a seconda dell'architettura Mac)
# --------------------------------------------------------
# Effetto: Congela il processo. Non usa più CPU, ma rimane in RAM.
# Gestibile: NO (Non può essere ignorato).
kill -s STOP 1234

# SIGTSTP (Signal 18 o 20) - TERMINAL STOP
# --------------------------------------------------------
# Equivalente: Premere Ctrl+Z nel terminale.
# Effetto: Manda il processo in background (pausa).
# Gestibile: SÌ.
kill -s TSTP 1234

# SIGCONT (Signal 19, 18 o 25) - CONTINUE
# --------------------------------------------------------
# Effetto: "Scongela" un processo fermato con STOP o TSTP. Riprende a girare.
kill -s CONT 1234


# ------------------------------------------------------------------------------
# 4. KILLALL e PKILL (Uccidere per NOME invece che PID)
# ------------------------------------------------------------------------------
# Su macOS, `killall` è nativo e molto potente.

# Chiude TUTTI i processi che si chiamano "Safari"
killall Safari

# Chiude forzatamente (-9) tutti i processi "python3"
killall -9 python3

# Chiude tutti i processi dell'utente "mlazoi814" (Attenzione!)
killall -u mlazoi814

# PKILL (Pattern Kill)
# Più flessibile di killall, cerca nel nome del comando.
# Esempio: 'pkill fire' chiuderà 'firefox', 'firewall', etc.
pkill -9 fire


# ==============================================================================
# 📊 TABELLA RIEPILOGATIVA SEGNALI (SPECIFICA MACOS/BSD)
# ==============================================================================
# | NOME    | NUMERO (Mac) | EFFETTO                                        |
# |---------|--------------|------------------------------------------------|
# | SIGHUP  | 1            | Ricarica config / Hangup terminale             |
# | SIGINT  | 2            | Interruzione da tastiera (Ctrl+C)              |
# | SIGQUIT | 3            | Uscita con Core Dump (Ctrl+\)                  |
# | SIGKILL | 9            | Uccisione forzata (immediata)                  |
# | SIGTERM | 15           | Terminazione gentile (Default)                 |
# | SIGSTOP | 17/19/23* | Pausa forzata (non intercettabile)             |
# | SIGTSTP | 18/20* | Pausa da terminale (Ctrl+Z)                    |
# | SIGCONT | 19/18/25* | Ripresa dopo pausa                             |
# 
# *NOTA SUI NUMERI: Su MacOS i numeri per STOP/CONT variano tra architetture 
# (x86 vs ARM/Apple Silicon). USA SEMPRE I NOMI (-s STOP) PER SICUREZZA!

# ==============================================================================
# 💡 SUGGERIMENTI E SCENARI D'ESAME
# ==============================================================================

# --- SCENARIO 1: "Il server web si è bloccato, riavvialo senza chiuderlo" ---
# Non usare kill -9! Usa HUP per fargli rileggere la configurazione.
# kill -s HUP $(pgrep nginx)

# --- SCENARIO 2: "Non riesco a chiudere uno script zombie" ---
# Se vedi una 'Z' in 'ps' o 'top', il processo è Zombie.
# NON PUOI uccidere uno zombie (è già morto). Devi uccidere il PADRE (PPID).
# 1. Trova il PPID: ps -o ppid,comm -p PID_ZOMBIE
# 2. Uccidi il padre: kill -9 PPID_TROVATO

# --- SCENARIO 3: "Simulare un freeze per testare script di monitoraggio" ---
# Lancia uno sleep, poi fermalo con STOP.
# sleep 1000 &
# PID=$!
# kill -s STOP $PID
# (Ora verifica se il tuo script di controllo si accorge che è bloccato)

# --- TRUCCO MACOS: Visualizzare tutti i segnali disponibili ---
# /bin/kill -l
# (Ti mostrerà la lista esatta dei numeri validi per il tuo Mac corrente)